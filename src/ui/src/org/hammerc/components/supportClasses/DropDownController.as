/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.UIEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.UIEvent.OPEN
	 */
	[Event(name="open",type="org.hammerc.events.UIEvent")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.CLOSE
	 */
	[Event(name="close",type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>DropDownController</code> 类用于处理因用户交互而打开和关闭下拉列表的操作的控制器.
	 * @author wizardc
	 */
	public class DropDownController extends EventDispatcher
	{
		private var _mouseIsDown:Boolean;
		
		private var _openButton:ButtonBase;
		
		private var _dropDown:DisplayObject;
		
		private var _isOpen:Boolean = false;
		
		private var _closeOnResize:Boolean = true;
		
		private var _rollOverOpenDelay:Number = NaN;
		private var _rollOverOpenDelayTimer:Timer;
		
		private var _hitAreaAdditions:Vector.<DisplayObject>;
		
		/**
		 * 创建一个 <code>DropDownController</code> 对象.
		 */
		public function DropDownController()
		{
			super();
		}
		
		/**
		 * 设置或获取下拉按钮实例.
		 */
		public function set openButton(value:ButtonBase):void
		{
			if(_openButton === value)
			{
				return;
			}
			removeOpenTriggers();
			_openButton = value;
			addOpenTriggers();
		}
		public function get openButton():ButtonBase
		{
			return _openButton;
		}
		
		/**
		 * 设置或获取下拉区域显示对象.
		 */
		public function set dropDown(value:DisplayObject):void
		{
			if(_dropDown === value)
			{
				return;
			}
			_dropDown = value;
		}
		public function get dropDown():DisplayObject
		{
			return _dropDown;
		}
		
		/**
		 * 获取下拉列表是否已经打开的标志.
		 */
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		/**
		 * 设置或获取在调整舞台大小时是否会关闭下拉列表.
		 */
		public function set closeOnResize(value:Boolean):void
		{
			if(_closeOnResize == value)
			{
				return;
			}
			if(this.isOpen)
			{
				removeCloseOnResizeTrigger();
			}
			_closeOnResize = value;
			addCloseOnResizeTrigger();
		}
		public function get closeOnResize():Boolean
		{
			return _closeOnResize;
		}
		
		/**
		 * 设置或获取滑过锚点按钮时打开下拉列表要等待的延迟 (以毫秒为单位).
		 * <p>如果设置为 NaN, 则下拉列表会在单击时打开, 而不是在滑过时打开.</p>
		 */
		public function set rollOverOpenDelay(value:Number):void
		{
			if(_rollOverOpenDelay == value)
			{
				return;
			}
			removeOpenTriggers();
			_rollOverOpenDelay = value;
			addOpenTriggers();
		}
		public function get rollOverOpenDelay():Number
		{
			return _rollOverOpenDelay;
		}
		
		/**
		 * 设置或获取要考虑作为下拉列表的点击区域的一部分的显示对象列表. 在包含项列出的任何组件内进行鼠标单击不会自动关闭下拉列表.
		 */
		public function set hitAreaAdditions(value:Vector.<DisplayObject>):void
		{
			_hitAreaAdditions = value;
		}
		public function get hitAreaAdditions():Vector.<DisplayObject>
		{
			return _hitAreaAdditions;
		}
		
		/**
		 * 添加触发下拉列表打开的事件监听.
		 */
		private function addOpenTriggers():void
		{
			if(this.openButton != null)
			{
				if(isNaN(this.rollOverOpenDelay))
				{
					this.openButton.addEventListener(UIEvent.BUTTON_DOWN, this.openButton_buttonDownHandler);
				}
				else
				{
					this.openButton.addEventListener(MouseEvent.ROLL_OVER, this.openButton_rollOverHandler);
				}
			}
		}
		
		/**
		 * 移除触发下拉列表打开的事件监听.
		 */
		private function removeOpenTriggers():void
		{
			if(this.openButton != null)
			{
				if(isNaN(this.rollOverOpenDelay))
				{
					this.openButton.removeEventListener(UIEvent.BUTTON_DOWN, this.openButton_buttonDownHandler);
				}
				else
				{
					this.openButton.removeEventListener(MouseEvent.ROLL_OVER, this.openButton_rollOverHandler);
				}
			}
		}
		
		/**
		 * 添加触发下拉列表关闭的事件监听.
		 */
		private function addCloseTriggers():void
		{
			if(HammercGlobals.stage != null)
			{
				if(isNaN(this.rollOverOpenDelay))
				{
					HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
					HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler_noRollOverOpenDelay);
				}
				else
				{
					HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
				}
				addCloseOnResizeTrigger();
				if(this.openButton != null && this.openButton.stage != null)
				{
					HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.stage_mouseWheelHandler);
				}
			}
		}
		
		/**
		 * 移除触发下拉列表关闭的事件监听.
		 */
		private function removeCloseTriggers():void
		{
			if(HammercGlobals.stage != null)
			{
				if(isNaN(this.rollOverOpenDelay))
				{
					HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.stage_mouseDownHandler);
					HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler_noRollOverOpenDelay);
				}
				else
				{
					HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
					HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
					HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, this.stage_mouseUpHandler);
				}
				removeCloseOnResizeTrigger();
				if(this.openButton != null && this.openButton.stage != null)
				{
					HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.stage_mouseWheelHandler);
				}
			}
		}
		
		/**
		 * 添加舞台尺寸改变的事件监听.
		 */
		private function addCloseOnResizeTrigger():void
		{
			if(this.closeOnResize)
			{
				HammercGlobals.stage.addEventListener(Event.RESIZE, this.stage_resizeHandler, false, 0, true);
			}
		}
		
		/**
		 * 移除舞台尺寸改变的事件监听.
		 */
		private function removeCloseOnResizeTrigger():void
		{
			if(this.closeOnResize)
			{
				HammercGlobals.stage.removeEventListener(Event.RESIZE, this.stage_resizeHandler);
			}
		}
		
		/**
		 * 检查鼠标是否在 DropDown 或者 openButton 区域内.
		 */
		private function isTargetOverDropDownOrOpenButton(target:DisplayObject):Boolean
		{
			if(target != null)
			{
				if(this.openButton != null && this.openButton.contains(target))
				{
					return true;
				}
				if(_hitAreaAdditions != null)
				{
					for(var i:int = 0; i < _hitAreaAdditions.length; i++)
					{
						if(_hitAreaAdditions[i] == target || ((_hitAreaAdditions[i] is DisplayObjectContainer) && DisplayObjectContainer(_hitAreaAdditions[i]).contains(target as DisplayObject)))
						{
							return true;
						}
					}
				}
				if(this.dropDown is DisplayObjectContainer)
				{
					if(DisplayObjectContainer(this.dropDown).contains(target))
					{
						return true;
					}
				}
				else
				{
					if(target == this.dropDown)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 打开下拉列表.
		 */
		public function openDropDown():void
		{
			openDropDownHelper();
		}
		
		/**
		 * 执行打开下拉列表.
		 */
		private function openDropDownHelper():void
		{
			if(!this.isOpen)
			{
				addCloseTriggers();
				_isOpen = true;
				this.dispatchEvent(new UIEvent(UIEvent.OPEN));
			}
		}
		
		/**
		 * 关闭下拉列表.
		 */
		public function closeDropDown(commit:Boolean):void
		{
			if(this.isOpen)
			{   
				_isOpen = false;
				var dde:UIEvent = new UIEvent(UIEvent.CLOSE, false, true);
				if(!commit)
				{
					dde.preventDefault();
				}
				this.dispatchEvent(dde);
				removeCloseTriggers();
			}
		}
		
		/**
		 * openButton 上按下鼠标事件.
		 */
		hammerc_internal function openButton_buttonDownHandler(event:Event):void
		{
			if(this.isOpen)
			{
				this.closeDropDown(true);
			}
			else
			{
				_mouseIsDown = true;
				openDropDownHelper();
			}
		}
		
		/**
		 * openButton 上鼠标经过事件.
		 */
		hammerc_internal function openButton_rollOverHandler(event:MouseEvent):void
		{
			if(this.rollOverOpenDelay == 0)
			{
				openDropDownHelper();
			}
			else
			{
				openButton.addEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
				_rollOverOpenDelayTimer = new Timer(this.rollOverOpenDelay, 1);
				_rollOverOpenDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rollOverDelay_timerCompleteHandler);
				_rollOverOpenDelayTimer.start();
			}
		}
		
		/**
		 * openButton 上鼠标移出事件.
		 */
		private function openButton_rollOutHandler(event:MouseEvent):void
		{
			if(_rollOverOpenDelayTimer != null && _rollOverOpenDelayTimer.running)
			{
				_rollOverOpenDelayTimer.stop();
				_rollOverOpenDelayTimer = null;
			}
			openButton.removeEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
		}
		
		/**
		 * 到达鼠标移入等待延迟打开的时间.
		 */
		private function rollOverDelay_timerCompleteHandler(event:TimerEvent):void
		{
			openButton.removeEventListener(MouseEvent.ROLL_OUT, openButton_rollOutHandler);
			_rollOverOpenDelayTimer = null;
			openDropDownHelper();
		}
		
		/**
		 * 舞台上鼠标按下事件.
		 */
		hammerc_internal function stage_mouseDownHandler(event:Event):void
		{
			if(_mouseIsDown)
			{
				_mouseIsDown = false;
				return;
			}
			if(this.dropDown == null || (this.dropDown != null && (event.target == this.dropDown || (this.dropDown is DisplayObjectContainer && !DisplayObjectContainer(this.dropDown).contains(DisplayObject(event.target))))))
			{
				var target:DisplayObject = event.target as DisplayObject;
				if(this.openButton != null && target && this.openButton.contains(target))
				{
					return;
				}
				if(_hitAreaAdditions != null)
				{
					for(var i:int = 0; i < _hitAreaAdditions.length; i++)
					{
						if(_hitAreaAdditions[i] == event.target || ((_hitAreaAdditions[i] is DisplayObjectContainer) && DisplayObjectContainer(_hitAreaAdditions[i]).contains(event.target as DisplayObject)))
						{
							return;
						}
					}
				}
				this.closeDropDown(true);
			}
		}
		
		/**
		 * 舞台上鼠标移动事件.
		 */
		hammerc_internal function stage_mouseMoveHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var containedTarget:Boolean = isTargetOverDropDownOrOpenButton(target);
			if(containedTarget)
			{
				return;
			}
			if(event is MouseEvent && MouseEvent(event).buttonDown)
			{
				HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
				HammercGlobals.stage.addEventListener(Event.MOUSE_LEAVE, this.stage_mouseUpHandler);
				return;
			}
			this.closeDropDown(true);
		}
		
		/**
		 * 舞台上鼠标弹起事件.
		 */
		hammerc_internal function stage_mouseUpHandler_noRollOverOpenDelay(event:Event):void
		{
			if(_mouseIsDown)
			{
				_mouseIsDown = false;
				return;
			}
		}
		
		/**
		 * 舞台上鼠标弹起事件.
		 */
		hammerc_internal function stage_mouseUpHandler(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			var containedTarget:Boolean = isTargetOverDropDownOrOpenButton(target);
			if(containedTarget)
			{
				HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
				HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, this.stage_mouseUpHandler);
				return;
			}
			this.closeDropDown(true);
		}
		
		/**
		 * 舞台尺寸改变事件.
		 */
		hammerc_internal function stage_resizeHandler(event:Event):void
		{
			this.closeDropDown(true);
		}
		
		/**
		 * 舞台上鼠标滚轮事件.
		 */
		private function stage_mouseWheelHandler(event:MouseEvent):void
		{
			if(this.dropDown != null && !(DisplayObjectContainer(this.dropDown).contains(DisplayObject(event.target)) && event.isDefaultPrevented()))
			{
				this.closeDropDown(false);
			}
		}
	}
}
