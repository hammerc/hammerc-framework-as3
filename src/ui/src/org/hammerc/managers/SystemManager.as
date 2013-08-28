/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import org.hammerc.components.Group;
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.BasicLayout;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>SystemManager</code> 类定义了系统管理器, 它应为应用程序的顶级容器.
	 * <p>通常情况下, 一个程序应该只含有唯一的系统管理器, 并且所有的组件都包含在它内部. 它负责管理弹窗, 鼠标样式, 工具提示的显示层级, 监听舞台尺寸改变事件, 以及过滤鼠标和键盘事件为可以取消的.</p>
	 * @author wizardc
	 */
	public class SystemManager extends Group implements ISystemManager
	{
		private var _autoResize:Boolean = true;
		
		private var _noTopMostIndex:int = 0;
		private var _topMostIndex:int = 0;
		private var _toolTipIndex:int = 0;
		private var _cursorIndex:int = 0;
		
		private var _popUpContainer:SystemContainer;
		private var _toolTipContainer:SystemContainer;
		private var _cursorContainer:SystemContainer;
		
		/**
		 * 创建一个 <code>SystemManager</code> 对象.
		 */
		public function SystemManager()
		{
			super();
			this.mouseEnabledWhereTransparent = false;
			if(this.stage != null)
			{
				addToStageHandler();
			}
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true, int.MAX_VALUE);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, mouseEventHandler, true, int.MAX_VALUE);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler, true, int.MAX_VALUE);
		}
		
		private function addToStageHandler(event:Event = null):void
		{
			if(HammercGlobals._systemManagers.length == 0)
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
				this.stage.stageFocusRect = false;
			}
			var index:int = HammercGlobals._systemManagers.indexOf(this);
			if(index == -1)
			{
				HammercGlobals._systemManagers.push(this);
			}
			if(_autoResize)
			{
				this.stage.addEventListener(Event.RESIZE, onResize);
				this.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onResize);
				onResize();
			}
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			var index:int = HammercGlobals._systemManagers.indexOf(this);
			if(index != -1)
			{
				HammercGlobals._systemManagers.splice(index, 1);
			}
			if(_autoResize)
			{
				this.stage.removeEventListener(Event.RESIZE, onResize);
				this.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onResize);
			}
		}
		
		private function onResize(event:Event = null):void
		{
			super.width = stage.stageWidth;
			super.height = stage.stageHeight;
		}
		
		private function mouseEventHandler(event:MouseEvent):void
		{
			if(!event.cancelable && event.eventPhase != EventPhase.BUBBLING_PHASE)
			{
				event.stopImmediatePropagation();
				var cancelableEvent:MouseEvent = null;
				if("clickCount" in event)
				{
					var mouseEventClass:Class = MouseEvent;
					cancelableEvent = new mouseEventClass(event.type, event.bubbles, true, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta, event["commandKey"], event["controlKey"], event["clickCount"]);
				}
				else
				{
					cancelableEvent = new MouseEvent(event.type, event.bubbles, true, event.localX, event.localY, event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta);
				}
				event.target.dispatchEvent(cancelableEvent);
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			if(!event.cancelable)
			{
				switch(event.keyCode)
				{
					case Keyboard.UP:
					case Keyboard.DOWN:
					case Keyboard.PAGE_UP:
					case Keyboard.PAGE_DOWN:
					case Keyboard.HOME:
					case Keyboard.END:
					case Keyboard.LEFT:
					case Keyboard.RIGHT:
					case Keyboard.ENTER:
						event.stopImmediatePropagation();
						var cancelableEvent:KeyboardEvent = new KeyboardEvent(event.type, event.bubbles, true, event.charCode, event.keyCode, event.keyLocation, event.ctrlKey, event.altKey, event.shiftKey);
						event.target.dispatchEvent(cancelableEvent);
				}
			}
		}
		
		/**
		 * 设置或获取是否自动跟随舞台缩放.
		 * <p>当此属性为 true 时, 将强制让 <code>SystemManager</code> 始终与舞台保持相同大小. 反之需要外部手动同步大小. 默认值为 true.</p>
		 */
		public function set autoResize(value:Boolean):void
		{
			if(_autoResize == value)
			{
				return;
			}
			_autoResize = value;
			if(this.stage == null)
			{
				return;
			}
			if(_autoResize)
			{
				this.stage.addEventListener(Event.RESIZE, onResize);
				this.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onResize);
			}
			else
			{
				this.stage.removeEventListener(Event.RESIZE, onResize);
				this.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onResize);
			}
		}
		public function get autoResize():Boolean
		{
			return _autoResize;
		}
		
		/**
		 * 设置或获取弹出窗口层的起始索引 (包括).
		 */
		hammerc_internal function set noTopMostIndex(value:int):void
		{
			var delta:int = value - _noTopMostIndex;
			_noTopMostIndex = value;
			topMostIndex += delta;
		}
		hammerc_internal function get noTopMostIndex():int
		{
			return _noTopMostIndex;
		}
		
		/**
		 * 设置或获取弹出窗口层结束索引 (不包括).
		 */
		hammerc_internal function set topMostIndex(value:int):void
		{
			var delta:int = value - _topMostIndex;
			_topMostIndex = value;
			toolTipIndex += delta;
		}
		hammerc_internal function get topMostIndex():int
		{
			return _topMostIndex;
		}
		
		/**
		 * 设置或获取工具提示层结束索引 (不包括).
		 */
		hammerc_internal function set toolTipIndex(value:int):void
		{
			var delta:int = value - _toolTipIndex;
			_toolTipIndex = value;
			cursorIndex += delta;
		}
		hammerc_internal function get toolTipIndex():int
		{
			return _toolTipIndex;
		}
		
		/**
		 * 设置或获取鼠标样式层结束索引 (不包括).
		 */
		hammerc_internal function set cursorIndex(value:int):void
		{
			var delta:int = value - _cursorIndex;
			_cursorIndex = value;
		}
		hammerc_internal function get cursorIndex():int
		{
			return _cursorIndex;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get popUpContainer():IUIContainer
		{
			if(_popUpContainer == null)
			{
				_popUpContainer = new SystemContainer(this, new QName(hammerc_internal, "noTopMostIndex"), new QName(hammerc_internal, "topMostIndex"));
			}
			return _popUpContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get toolTipContainer():IUIContainer
		{
			if(_toolTipContainer == null)
			{
				_toolTipContainer = new SystemContainer(this, new QName(hammerc_internal, "topMostIndex"), new QName(hammerc_internal, "toolTipIndex"));
			}
			return _toolTipContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get cursorContainer():IUIContainer
		{
			if(_cursorContainer == null)
			{
				_cursorContainer = new SystemContainer(this, new QName(hammerc_internal, "toolTipIndex"), new QName(hammerc_internal, "cursorIndex"));
			}
			return _cursorContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set x(value:Number):void
		{
			if(!_autoResize)
			{
				super.x = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set y(value:Number):void
		{
			if(!_autoResize)
			{
				super.y = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if(!_autoResize)
			{
				super.width = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if(!_autoResize)
			{
				super.height = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleX(value:Number):void
		{
			if(!_autoResize)
			{
				super.scaleX = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleY(value:Number):void
		{
			if(!_autoResize)
			{
				super.scaleY = value;
			}
		}
		
		/**
		 * 设置或获取布局对象. <code>SystemManager</code> 只接受 <code>BasicLayout</code> 对象.
		 */
		override public function set layout(value:LayoutBase):void
		{
			if(value is BasicLayout)
			{
				super.layout = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setActualSize(width:Number, height:Number):void
		{
			if(!_autoResize)
			{
				super.setActualSize(width, height);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setLayoutBoundsPosition(x:Number, y:Number):void
		{
			if(!_autoResize)
			{
				super.setLayoutBoundsPosition(x, y);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setLayoutBoundsSize(layoutWidth:Number, layoutHeight:Number):void
		{
			if(!_autoResize)
			{
				super.setLayoutBoundsSize(layoutWidth, layoutHeight);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addElement(element:IUIComponent):IUIComponent
		{
			var addIndex:int = _noTopMostIndex;
			if(element.parent == this)
			{
				addIndex--;
			}
			return this.addElementAt(element, addIndex);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addElementAt(element:IUIComponent, index:int):IUIComponent
		{
			if(element.parent == this)
			{
				var oldIndex:int = this.getElementIndex(element);
				if(oldIndex < _noTopMostIndex)
				{
					this.noTopMostIndex--;
				}
				else if(oldIndex >= _noTopMostIndex && oldIndex < _topMostIndex)
				{
					this.topMostIndex--;
				}
				else if(oldIndex >= _topMostIndex && oldIndex < _toolTipIndex)
				{
					this.toolTipIndex--;
				}
				else
				{
					this.cursorIndex--;
				}
			}
			if(index <= _noTopMostIndex)
			{
				this.noTopMostIndex++;
			}
			else if(index > _noTopMostIndex && index <= _topMostIndex)
			{
				this.topMostIndex++;
			}
			else if(index > _topMostIndex && index <= _toolTipIndex)
			{
				this.toolTipIndex++;
			}
			else
			{
				this.cursorIndex++;
			}
			return super.addElementAt(element, index);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeElement(element:IUIComponent):IUIComponent
		{
			return this.removeElementAt(super.getElementIndex(element));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeElementAt(index:int):IUIComponent
		{
			var element:IUIComponent = super.removeElementAt(index);
			if(index < _noTopMostIndex)
			{
				this.noTopMostIndex--;
			}
			else if(index >= _noTopMostIndex && index < _topMostIndex)
			{
				this.topMostIndex--;
			}
			else if(index >= _topMostIndex && index < _toolTipIndex)
			{
				this.toolTipIndex--;
			}
			else
			{
				this.cursorIndex--;
			}
			return element;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeAllElements():void
		{
			while(_noTopMostIndex > 0)
			{
				super.removeElementAt(0);
				this.noTopMostIndex--;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function containsElement(element:IUIComponent):Boolean
		{
			if(super.containsElement(element))
			{
				if(element.parent == this)
				{
					var elementIndex:int = super.getElementIndex(element);
					if(elementIndex < _noTopMostIndex)
					{
						return true;
					}
				}
				else
				{
					for(var i:int = 0; i < _noTopMostIndex; i++)
					{
						var myChild:IUIComponent = super.getElementAt(i);
						if(myChild is IUIContainer)
						{
							if(IUIContainer(myChild).containsElement(element))
							{
								return true;
							}
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function elementRemoved(element:IUIComponent, index:int, notifyListeners:Boolean = true):void
		{
			//PopUpManager 需要监听这个事件
			if(notifyListeners)
			{
				element.dispatchEvent(new Event("removeFromSystemManager"));
			}
			super.elementRemoved(element, index, notifyListeners);
		}
		
		hammerc_internal function get raw_numElements():int
		{
			return super.numElements;
		}
		
		hammerc_internal function raw_getElementAt(index:int):IUIComponent
		{
			return super.getElementAt(index);
		}
		
		hammerc_internal function raw_addElement(element:IUIComponent):IUIComponent
		{
			var index:int = super.numElements;
			if(element.parent == this)
			{
				index--;
			}
			return this.raw_addElementAt(element, index);
		}
		
		hammerc_internal function raw_addElementAt(element:IUIComponent, index:int):IUIComponent
		{
			if(element.parent == this)
			{
				var oldIndex:int = this.getElementIndex(element);
				if(oldIndex < _noTopMostIndex)
				{
					noTopMostIndex--;
				}
				else if(oldIndex >= _noTopMostIndex && oldIndex < _topMostIndex)
				{
					topMostIndex--;
				}
				else if(oldIndex >= _topMostIndex && oldIndex < _toolTipIndex)
				{
					toolTipIndex--;
				}
				else
				{
					cursorIndex--;
				}
			}
			return super.addElementAt(element,index);
		}
		
		hammerc_internal function raw_removeElement(element:IUIComponent):IUIComponent
		{
			return super.removeElementAt(super.getElementIndex(element));
		}
		
		hammerc_internal function raw_removeElementAt(index:int):IUIComponent
		{
			return super.removeElementAt(index);
		}
		
		hammerc_internal function raw_getElementIndex(element:IUIComponent):int
		{
			return super.getElementIndex(element);
		}
		
		hammerc_internal function raw_setElementIndex(element:IUIComponent, index:int):void
		{
			super.setElementIndex(element,index);
		}
		
		hammerc_internal function raw_containsElement(element:IUIComponent):void
		{
			super.containsElement(element);
		}
	}
}
