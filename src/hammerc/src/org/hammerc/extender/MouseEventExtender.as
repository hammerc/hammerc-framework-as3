/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.extender
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.hammerc.events.ExtendMouseEvent;
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.MOUSE_DOWN_OUTSIDE
	 */
	[Event(name="mouseDownOutside",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.MOUSE_UP_OUTSIDE
	 */
	[Event(name="mouseUpOutside",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.CLICK_OUTSIDE
	 */
	[Event(name="clickOutside",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.RELEASE_INSIDE
	 */
	[Event(name="releaseInside",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.RELEASE_OUTSIDE
	 */
	[Event(name="hammerc_releaseOutside",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.DOUBLE_CLICK_IN_INTERVAL
	 */
	[Event(name="doubleClickInInterval",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.ALWAYS_PRESS
	 */
	[Event(name="alwaysPress",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.PRESS_MOVE
	 */
	[Event(name="pressMove",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.DRAG_OVER
	 */
	[Event(name="dragOver",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.DRAG_OUT
	 */
	[Event(name="dragOut",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.ROLL_DRAG_OVER
	 */
	[Event(name="rollDragOver",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendMouseEvent.ROLL_DRAG_OUT
	 */
	[Event(name="rollDragOut",type="org.hammerc.events.ExtendMouseEvent")]
	
	/**
	 * <code>MouseEventExtender</code> 类可以为指定的交互对象扩展出丰富的鼠标交互事件.
	 * @author wizardc
	 */
	public class MouseEventExtender
	{
		/**
		 * 记录需要扩展事件的交互对象.
		 */
		protected var _interactiveObject:InteractiveObject;
		
		/**
		 * 记录双击的间隔时间, 单位毫秒.
		 */
		protected var _doubleClickInterval:int;
		
		/**
		 * 记录是否启用长按功能.
		 */
		protected var _alwaysPressable:Boolean;
		
		/**
		 * 记录长按的延迟时间, 单位毫秒.
		 */
		protected var _alwaysPressDelay:int;
		
		/**
		 * 记录长按的间隔时间, 单位毫秒.
		 */
		protected var _alwaysPressInterval:int;
		
		private var _hasFocus:Boolean = false;
		
		private var _waitDoubleClick:Boolean = false;
		private var _previousClickTime:int;
		
		private var _pressTimeout:uint;
		private var _pressInterval:uint;
		
		/**
		 * 创建一个 <code>MouseEventExtender</code> 对象.
		 * @param interactiveObject 设置需要扩展事件的交互对象.
		 * @param doubleClickInterval 设置双击的间隔时间, 单位毫秒.
		 * @param alwaysPressable 设置是否启用长按功能.
		 * @param alwaysPressDelay 设置长按的延迟时间, 单位毫秒.
		 * @param alwaysPressInterval 设置长按的间隔时间, 单位毫秒.
		 */
		public function MouseEventExtender(interactiveObject:InteractiveObject = null, doubleClickInterval:int = 500, alwaysPressable:Boolean = false, alwaysPressDelay:int = 500, alwaysPressInterval:int = 100)
		{
			this.interactiveObject = interactiveObject;
			this.doubleClickInterval = doubleClickInterval;
			this.alwaysPressable = alwaysPressable;
			this.alwaysPressDelay = alwaysPressDelay;
			this.alwaysPressInterval = alwaysPressInterval;
		}
		
		/**
		 * 设置或获取需要扩展事件的交互对象.
		 */
		public function set interactiveObject(value:InteractiveObject):void
		{
			if(_interactiveObject == value)
			{
				return;
			}
			if(_interactiveObject != null)
			{
				if(_interactiveObject.stage != null)
				{
					unregisteEvents();
				}
				_interactiveObject.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
				_interactiveObject.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
				clearTimeout(_pressTimeout);
				clearInterval(_pressInterval);
			}
			_interactiveObject = value;
			if(_interactiveObject != null)
			{
				if(_interactiveObject.stage != null)
				{
					registeEvents();
				}
				_interactiveObject.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
				_interactiveObject.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			}
		}
		public function get interactiveObject():InteractiveObject
		{
			return _interactiveObject;
		}
		
		/**
		 * 设置或获取双击的间隔时间, 单位毫秒.
		 */
		public function set doubleClickInterval(value:int):void
		{
			_doubleClickInterval = Math.max(0, value);
		}
		public function get doubleClickInterval():int
		{
			return _doubleClickInterval;
		}
		
		/**
		 * 设置或获取是否启用长按功能.
		 */
		public function set alwaysPressable(value:Boolean):void
		{
			_alwaysPressable = value;
			if(!_alwaysPressable)
			{
				clearTimeout(_pressTimeout);
				clearInterval(_pressInterval);
			}
		}
		public function get alwaysPressable():Boolean
		{
			return _alwaysPressable;
		}
		
		/**
		 * 设置或获取长按的延迟时间, 单位毫秒.
		 */
		public function set alwaysPressDelay(value:int):void
		{
			_alwaysPressDelay = Math.max(0, value);
		}
		public function get alwaysPressDelay():int
		{
			return _alwaysPressDelay;
		}
		
		/**
		 * 设置或获取长按的间隔时间, 单位毫秒.
		 */
		public function set alwaysPressInterval(value:int):void
		{
			_alwaysPressInterval = Math.max(0, value);
		}
		public function get alwaysPressInterval():int
		{
			return _alwaysPressInterval;
		}
		
		private function addedToStageHandler(event:Event):void
		{
			registeEvents();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			unregisteEvents();
		}
		
		private function registeEvents():void
		{
			_interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventsHandler);
			_interactiveObject.addEventListener(MouseEvent.MOUSE_UP, mouseEventsHandler);
			_interactiveObject.addEventListener(MouseEvent.MOUSE_OVER, mouseEventsHandler);
			_interactiveObject.addEventListener(MouseEvent.MOUSE_OUT, mouseEventsHandler);
			_interactiveObject.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventsHandler);
			_interactiveObject.addEventListener(MouseEvent.ROLL_OVER, mouseEventsHandler);
			_interactiveObject.addEventListener(MouseEvent.ROLL_OUT, mouseEventsHandler);
			_interactiveObject.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventsHandler);
			_interactiveObject.stage.addEventListener(MouseEvent.MOUSE_UP, mouseEventsHandler);
			_interactiveObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventsHandler);
		}
		
		private function unregisteEvents():void
		{
			_interactiveObject.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventsHandler);
			_interactiveObject.removeEventListener(MouseEvent.MOUSE_UP, mouseEventsHandler);
			_interactiveObject.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventsHandler);
			_interactiveObject.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventsHandler);
			_interactiveObject.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventsHandler);
			_interactiveObject.removeEventListener(MouseEvent.ROLL_OVER, mouseEventsHandler);
			_interactiveObject.removeEventListener(MouseEvent.ROLL_OUT, mouseEventsHandler);
			_interactiveObject.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventsHandler);
			_interactiveObject.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEventsHandler);
			_interactiveObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventsHandler);
		}
		
		private function mouseEventsHandler(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					if(event.currentTarget == _interactiveObject)
					{
						_hasFocus = true;
						if(_waitDoubleClick)
						{
							if(getTimer() - _previousClickTime <= _doubleClickInterval)
							{
								this.dispatchMouseEvent(ExtendMouseEvent.DOUBLE_CLICK_IN_INTERVAL, event);
							}
							_waitDoubleClick = false;
							_previousClickTime = 0;
						}
						else
						{
							_waitDoubleClick = true;
							_previousClickTime = getTimer();
						}
						if(_alwaysPressable)
						{
							_pressTimeout = setTimeout(alwaysPressStart, _alwaysPressDelay);
						}
					}
					else
					{
						this.dispatchMouseEvent(ExtendMouseEvent.MOUSE_DOWN_OUTSIDE, event);
					}
					break;
				case MouseEvent.MOUSE_UP:
					if(_hasFocus)
					{
						_hasFocus = false;
						if(event.currentTarget != _interactiveObject)
						{
							this.dispatchMouseEvent(ExtendMouseEvent.RELEASE_OUTSIDE, event);
						}
						clearTimeout(_pressTimeout);
						clearInterval(_pressInterval);
					}
					else
					{
						if(event.currentTarget == _interactiveObject)
						{
							this.dispatchMouseEvent(ExtendMouseEvent.RELEASE_INSIDE, event);
						}
						if(event.target != _interactiveObject)
						{
							this.dispatchMouseEvent(ExtendMouseEvent.CLICK_OUTSIDE, event);
						}
					}
					break;
				case MouseEvent.MOUSE_OVER:
					if(event.buttonDown)
					{
						this.dispatchMouseEvent(ExtendMouseEvent.DRAG_OVER, event);
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if(_hasFocus && event.buttonDown)
					{
						this.dispatchMouseEvent(ExtendMouseEvent.DRAG_OUT, event);
					}
					clearTimeout(_pressTimeout);
					clearInterval(_pressInterval);
					break;
				case MouseEvent.MOUSE_MOVE:
					if(_hasFocus && event.buttonDown)
					{
						this.dispatchMouseEvent(ExtendMouseEvent.PRESS_MOVE, event);
					}
					break;
				case MouseEvent.ROLL_OVER:
					if(event.buttonDown)
					{
						this.dispatchMouseEvent(ExtendMouseEvent.ROLL_DRAG_OVER, event);
					}
					break;
				case MouseEvent.ROLL_OUT:
					if(_hasFocus && event.buttonDown)
					{
						this.dispatchMouseEvent(ExtendMouseEvent.ROLL_DRAG_OUT, event);
					}
					clearTimeout(_pressTimeout);
					clearInterval(_pressInterval);
					break;
			}
		}
		
		/**
		 * 播放鼠标扩展事件.
		 */
		protected function dispatchMouseEvent(type:String, mouseEvent:MouseEvent):void
		{
			_interactiveObject.dispatchEvent(new ExtendMouseEvent(type, mouseEvent.localX, mouseEvent.localY, mouseEvent.relatedObject, mouseEvent.ctrlKey, mouseEvent.altKey, mouseEvent.shiftKey, mouseEvent.buttonDown, mouseEvent.delta));
		}
		
		private function alwaysPressStart():void
		{
			this.dispatchMouseEvent(ExtendMouseEvent.ALWAYS_PRESS, new MouseEvent("", false, false, _interactiveObject.mouseX, _interactiveObject.mouseY, _interactiveObject));
			_pressInterval = setInterval(dispatchAlwaysPressEvent, _alwaysPressInterval);
		}
		
		private function dispatchAlwaysPressEvent():void
		{
			this.dispatchMouseEvent(ExtendMouseEvent.ALWAYS_PRESS, new MouseEvent("", false, false, _interactiveObject.mouseX, _interactiveObject.mouseY, _interactiveObject));
		}
		
		/**
		 * 销毁鼠标扩展对象.
		 */
		public function destroy():void
		{
			this.interactiveObject = null;
			this.doubleClickInterval = 500;
			this.alwaysPressable = false;
			this.alwaysPressDelay = 500;
			this.alwaysPressInterval = 100;
		}
	}
}
