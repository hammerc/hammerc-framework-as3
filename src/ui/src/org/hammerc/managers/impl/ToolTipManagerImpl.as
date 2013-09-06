/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import org.hammerc.collections.WeakHashMap;
	import org.hammerc.components.TextToolTip;
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IInvalidating;
	import org.hammerc.core.IToolTip;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.PopUpPosition;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.ToolTipEvent;
	import org.hammerc.managers.ILayoutManagerClient;
	import org.hammerc.managers.ISystemManager;
	import org.hammerc.managers.IToolTipManager;
	import org.hammerc.managers.IToolTipManagerClient;
	
	use namespace hammerc_internal;
	
	[ExcludeClass]
	
	/**
	 * <code>ToolTipManagerImpl</code> 类实现了工具提示管理器的功能.
	 * @author wizardc
	 */
	public class ToolTipManagerImpl implements IToolTipManager
	{
		private var _initialized:Boolean = false;
		
		private var _showTimer:Timer;
		private var _hideTimer:Timer;
		private var _scrubTimer:Timer;
		
		private var _currentTipData:Object;
		
		private var _previousTarget:IToolTipManagerClient;
		private var _currentTarget:IToolTipManagerClient;
		private var _currentToolTip:DisplayObject;
		
		private var _enabled:Boolean = true;
		
		private var _hideDelay:Number = 10000;
		private var _scrubDelay:Number = 100;
		private var _showDelay:Number = 200;
		
		private var _toolTipClass:Class = TextToolTip;
		
		private var _showImmediatelyFlag:Boolean = false;
		
		private var _toolTipCacheMap:WeakHashMap = new WeakHashMap();
		
		/**
		 * 创建一个 <code>ToolTipManagerImpl</code> 对象.
		 */
		public function ToolTipManagerImpl()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function set currentTarget(value:IToolTipManagerClient):void
		{
			_currentTarget = value;
		}
		public function get currentTarget():IToolTipManagerClient
		{
			return _currentTarget;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set currentToolTip(value:IToolTip):void
		{
			_currentToolTip = value as DisplayObject;
		}
		public function get currentToolTip():IToolTip
		{
			return _currentToolTip as IToolTip;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			if(_enabled == value)
			{
				return;
			}
			_enabled = value;
			if(!_enabled && this.currentTarget != null)
			{
				this.currentTarget = null;
				targetChanged();
				_previousTarget = this.currentTarget;
			}
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set showDelay(value:Number):void
		{
			_showDelay = value;
		}
		public function get showDelay():Number
		{
			return _showDelay;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scrubDelay(value:Number):void
		{
			_scrubDelay = value;
		}
		public function get scrubDelay():Number
		{
			return _scrubDelay;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set hideDelay(value:Number):void
		{
			_hideDelay = value;
		}
		public function get hideDelay():Number
		{
			return _hideDelay;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTipRenderer(value:Class):void
		{
			_toolTipClass = value;
		}
		public function get toolTipRenderer():Class 
		{
			return _toolTipClass;
		}
		
		private function initialize():void
		{
			if(_showTimer == null)
			{
				_showTimer = new Timer(0, 1);
				_showTimer.addEventListener(TimerEvent.TIMER, showTimer_timerHandler);
			}
			if(_hideTimer == null)
			{
				_hideTimer = new Timer(0, 1);
				_hideTimer.addEventListener(TimerEvent.TIMER, hideTimer_timerHandler);
			}
			if(_scrubTimer == null)
			{
				_scrubTimer = new Timer(0, 1);
			}
			_initialized = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerToolTip(target:DisplayObject, oldToolTip:Object, newToolTip:Object):void
		{
			var hasOld:Boolean = oldToolTip != null && oldToolTip != "";
			var hasNew:Boolean = newToolTip != null && newToolTip != "";
			if(!hasOld && hasNew)
			{
				target.addEventListener(MouseEvent.MOUSE_OVER, toolTipMouseOverHandler);
				target.addEventListener(MouseEvent.MOUSE_OUT, toolTipMouseOutHandler);
				if(mouseIsOver(target))
				{
					showImmediately(target);
				}
			}
			else if(hasOld && !hasNew)
			{
				target.removeEventListener(MouseEvent.MOUSE_OVER, toolTipMouseOverHandler);
				target.removeEventListener(MouseEvent.MOUSE_OUT, toolTipMouseOutHandler);
				if(mouseIsOver(target))
				{
					hideImmediately(target);
				}
			}
		}
		
		/**
		 * 判断指定的显示对象是否位于鼠标的下方.
		 * @param target 需要判断的显示对象.
		 * @return 指定的显示对象是否位于鼠标的下方.
		 */
		private function mouseIsOver(target:DisplayObject):Boolean
		{
			if(target == null || target.stage == null)
			{
				return false;
			}
			if(target.stage.mouseX == 0 && target.stage.mouseY == 0)
			{
				return false;
			}
			if(target is ILayoutManagerClient && !ILayoutManagerClient(target).initialized)
			{
				return false;
			}
			return target.hitTestPoint(target.stage.mouseX, target.stage.mouseY, true);
		}
		
		/**
		 * 立即显示目标组件的工具提示.
		 */
		private function showImmediately(target:DisplayObject):void
		{
			_showImmediatelyFlag = true;
			checkIfTargetChanged(target);
			_showImmediatelyFlag = false;
		}
		
		/**
		 * 立即隐藏目标组件的工具提示.
		 */
		private function hideImmediately(target:DisplayObject):void
		{
			checkIfTargetChanged(null);
		}
		
		/**
		 * 当目标对象改变时进行检测.
		 * @param target 当前的目标对象.
		 */
		private function checkIfTargetChanged(displayObject:DisplayObject):void
		{
			if(!enabled)
			{
				return;
			}
			findTarget(displayObject);
			if(this.currentTarget != _previousTarget)
			{
				targetChanged();
				_previousTarget = this.currentTarget;
			}
		}
		
		/**
		 * 遍历本对象及其父层对象, 直到找到需要显示工具提示的对象为止, 该对象即为真正的目标对象.
		 * @param target 当前的目标对象.
		 */
		private function findTarget(displayObject:DisplayObject):void
		{
			while(displayObject)
			{
				if(displayObject is IToolTipManagerClient)
				{
					_currentTipData = IToolTipManagerClient(displayObject).toolTip;
					if(_currentTipData != null)
					{
						this.currentTarget = displayObject as IToolTipManagerClient;
						return;
					}
				}
				displayObject = displayObject.parent;
			}
			_currentTipData = null;
			this.currentTarget = null;
		}
		
		/**
		 * 目标对象改变后调用该方法处理.
		 */
		private function targetChanged():void
		{
			if(!_initialized)
			{
				initialize();
			}
			var event:ToolTipEvent;
			if(_previousTarget && this.currentToolTip)
			{
				event = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE, this.currentToolTip);
				_previousTarget.dispatchEvent(event);
			}
			reset();
			if(this.currentTarget)
			{
				if(!_currentTipData)
				{
					return;
				}
				if(_showDelay == 0 || _showImmediatelyFlag || _scrubTimer.running)
				{
					createTip();
					initializeTip();
					positionTip();
					showTip();
				}
				else
				{
					_showTimer.delay = _showDelay;
					_showTimer.start();
				}
			}
		}
		
		/**
		 * 创建用于显示的工具提示对象.
		 */
		private function createTip():void
		{
			var tipRenderer:Class = this.currentTarget.toolTipRenderer;
			if(tipRenderer == null)
			{
				tipRenderer = toolTipRenderer;
			}
			var key:String = getQualifiedClassName(tipRenderer);
			this.currentToolTip = _toolTipCacheMap.get(key);
			if(this.currentToolTip == null)
			{
				this.currentToolTip = new tipRenderer();
				_toolTipCacheMap.put(key, this.currentToolTip);
				if(this.currentToolTip is InteractiveObject)
				{
					InteractiveObject(this.currentToolTip).mouseEnabled = false;
				}
				if(this.currentToolTip is DisplayObjectContainer)
				{
					DisplayObjectContainer(this.currentToolTip).mouseChildren = false;
				}
			}
			toolTipContainer.addElement(this.currentToolTip);
		}
		
		/**
		 * 获取工具提示弹出层.
		 */
		private function get toolTipContainer():IUIContainer
		{
			var sm:ISystemManager;
			if(_currentTarget is IUIComponent)
			{
				sm = IUIComponent(_currentTarget).systemManager;
			}
			if(sm == null)
			{
				sm = HammercGlobals.systemManager;
			}
			return sm.toolTipContainer;
		}
		
		/**
		 * 初始化工具提示对象.
		 */
		private function initializeTip():void
		{
			this.currentToolTip.toolTipData = _currentTipData;
			if(this.currentToolTip is IInvalidating)
			{
				IInvalidating(this.currentToolTip).validateNow();
			}
		}
		
		/**
		 * 设置工具提示对象的位置.
		 */
		private function positionTip():void
		{
			var x:Number;
			var y:Number;
			var sm:DisplayObjectContainer = this.currentToolTip.parent;
			var toolTipWidth:Number = this.currentToolTip.layoutBoundsWidth;
			var toolTipHeight:Number = this.currentToolTip.layoutBoundsHeight;
			var rect:Rectangle = DisplayObject(this.currentTarget).getRect(sm);
			var centerX:Number = rect.left + (rect.width - toolTipWidth) * 0.5;
			var centetY:Number = rect.top + (rect.height - toolTipHeight) * 0.5;
			switch(this.currentTarget.toolTipPosition)
			{
				case PopUpPosition.BELOW:
					x = centerX;
					y = rect.bottom;
					break;
				case PopUpPosition.ABOVE:
					x = centerX;
					y = rect.top - toolTipHeight;
					break;
				case PopUpPosition.LEFT:
					x = rect.left - toolTipWidth;
					y = centetY;
					break;
				case PopUpPosition.RIGHT:
					x = rect.right;
					y = centetY;
					break;
				case PopUpPosition.CENTER:
					x = centerX;
					y = centetY;
					break;
				case PopUpPosition.TOP_LEFT:
					x = rect.left;
					y = rect.top;
					break;
				default:
					x = sm.mouseX + 10;
					y = sm.mouseY + 20;
					break;
			}
			var offset:Point = this.currentTarget.toolTipOffset;
			if(offset)
			{
				x += offset.x;
				y = offset.y;
			}
			var screenWidth:Number = sm.width;
			var screenHeight:Number = sm.height;
			if(x + toolTipWidth > screenWidth)
			{
				x = screenWidth - toolTipWidth;
			}
			if(y + toolTipHeight > screenHeight)
			{
				y = screenHeight - toolTipHeight;
			}
			if(x < 0)
			{
				x = 0;
			}
			if(y < 0)
			{
				y = 0;
			}
			this.currentToolTip.x = x;
			this.currentToolTip.y = y;
		}
		
		/**
		 * 显示工具提示对象.
		 */
		private function showTip():void
		{
			var event:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW, this.currentToolTip);
			this.currentTarget.dispatchEvent(event);
			HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
			if(_hideDelay == 0)
			{
				hideTip();
			}
			else if(_hideDelay < Infinity)
			{
				_hideTimer.delay = _hideDelay;
				_hideTimer.start();
			}
		}
		
		/**
		 * 隐藏工具提示对象.
		 */
		private function hideTip():void
		{
			if(_previousTarget && this.currentToolTip)
			{
				var event:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE, this.currentToolTip);
				_previousTarget.dispatchEvent(event);
			}
			if(_previousTarget)
			{
				HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
			}
			reset();
		}
		
		/**
		 * 移除当前显示的工具提示并重置所有的数据.
		 */
		private function reset():void
		{
			_showTimer.reset();
			_hideTimer.reset();
			if(this.currentToolTip != null)
			{
				var tipParent:DisplayObjectContainer = this.currentToolTip.parent;
				if(tipParent is IUIContainer)
				{
					IUIContainer(tipParent).removeElement(this.currentToolTip);
				}
				else if(tipParent != null)
				{
					tipParent.removeChild(_currentToolTip);
				}
				this.currentToolTip = null;
				_scrubTimer.delay = this.scrubDelay;
				_scrubTimer.reset();
				if(scrubDelay > 0)
				{
					_scrubTimer.delay = this.scrubDelay;
					_scrubTimer.start();
				}
			}
		}
		
		private function toolTipMouseOverHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(DisplayObject(event.target));
		}
		
		private function toolTipMouseOutHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(event.relatedObject);
		}
		
		private function showTimer_timerHandler(event:TimerEvent):void
		{
			if(this.currentTarget != null)
			{
				createTip();
				initializeTip();
				positionTip();
				showTip();
			}
		}
		
		private function hideTimer_timerHandler(event:TimerEvent):void
		{
			hideTip();
		}
		
		private function stage_mouseDownHandler(event:MouseEvent):void
		{
			reset();
		}
		
		/**
		 * @inheritDoc
		 */
		public function createToolTip(toolTipData:Object, x:Number = 0, y:Number = 0, toolTipRenderer:Class = null):IToolTip
		{
			var toolTip:IToolTip = new toolTipRenderer() as IToolTip;
			toolTipContainer.addElement(toolTip);
			toolTip.toolTipData = toolTipData;
			if(currentToolTip is IInvalidating)
			{
				IInvalidating(currentToolTip).validateNow();
			}
			var pos:Point = toolTip.parent.globalToLocal(new Point(x, y));
			toolTip.x = pos.x;
			toolTip.y = pos.y;
			return toolTip;
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroyToolTip(toolTip:IToolTip):void
		{
			var tipParent:DisplayObjectContainer = toolTip.parent;
			if(tipParent is IUIContainer)
			{
				IUIContainer(tipParent).removeElement(toolTip);
			}
			else if(tipParent&&toolTip is DisplayObject)
			{
				tipParent.removeChild(toolTip as DisplayObject);
			}
		}
	}
}
