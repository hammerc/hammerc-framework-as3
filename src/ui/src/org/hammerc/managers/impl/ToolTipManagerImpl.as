/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers.impl
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.hammerc.collections.WeakHashMap;
	import org.hammerc.core.IToolTip;
	import org.hammerc.events.ToolTipEvent;
	import org.hammerc.managers.IToolTipManager;
	import org.hammerc.managers.IToolTipManagerClient;
	
	/**
	 * <code>ToolTipManagerImpl</code> 
	 * @author wizardc
	 */
	public class ToolTipManagerImpl implements IToolTipManager
	{
		private var _previousTarget:IToolTipManagerClient;
		private var _currentTarget:IToolTipManagerClient;
		private var _currentToolTip:IToolTip;
		private var _enabled:Boolean = true;
		private var _showDelay:Number = 500;
		private var _scrubDelay:Number = 100;
		private var _hideDelay:Number = 10000;
		private var _toolTipClass:Class;
		
		private var _initialized:Boolean = false;
		private var _showTimer:Timer;
		private var _scrubTimer:Timer;
		private var _hideTimer:Timer;
		
		private var _toolTipMap:WeakHashMap;
		
		/**
		 * 
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
			_currentToolTip = value;
		}
		public function get currentToolTip():IToolTip
		{
			return _currentToolTip;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			if(_enabled != value)
			{
				_enabled = value;
				if(!_enabled && _currentTarget != null)
				{
					_currentTarget = null;
					targetChanged();
					_previousTarget = _currentTarget;
				}
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
		public function set toolTipClass(value:Class):void
		{
			_toolTipClass = value;
		}
		public function get toolTipClass():Class
		{
			return _toolTipClass;
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerToolTip(target:DisplayObject, oldToolTip:Object, newToolTip:Object):void
		{
			var hasOld:Boolean = oldToolTip != null;
			var hasNew:Boolean = newToolTip != null;
			if(!hasOld && hasNew)
			{
				target.addEventListener(MouseEvent.ROLL_OVER, toolTipRollOverHandler);
				target.addEventListener(MouseEvent.ROLL_OUT, toolTipRollOutHandler);
				if(mouseIsOver(target))
				{
					checkIfTargetChanged(target);
				}
			}
			if(hasOld && !hasNew)
			{
				target.removeEventListener(MouseEvent.ROLL_OVER, toolTipRollOverHandler);
				target.removeEventListener(MouseEvent.ROLL_OUT, toolTipRollOutHandler);
				if(mouseIsOver(target))
				{
					checkIfTargetChanged(target);
				}
			}
		}
		
		private function toolTipRollOverHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(event.currentTarget as DisplayObject);
		}
		
		private function toolTipRollOutHandler(event:MouseEvent):void
		{
			checkIfTargetChanged(event.relatedObject);
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
			return target.hitTestPoint(target.stage.mouseX, target.stage.mouseY, true);
		}
		
		/**
		 * 当目标对象改变时进行检测.
		 * @param target 当前的目标对象.
		 */
		private function checkIfTargetChanged(target:DisplayObject):void
		{
			if(!_enabled)
			{
				return;
			}
			findTarget(target);
			if(_currentTarget != _previousTarget)
			{
				targetChanged();
				_previousTarget = _currentTarget;
			}
		}
		
		/**
		 * 遍历本对象及其父层对象, 直到找到需要显示工具提示的对象为止, 该对象即为真正的目标对象.
		 * @param target 当前的目标对象.
		 */
		private function findTarget(target:DisplayObject):void
		{
			while(target != null)
			{
				if(target is IToolTip && (target as IToolTip).toolTipData != null)
				{
					_currentTarget = target as IToolTipManagerClient;
					return;
				}
				target = target.parent;
			}
			_currentTarget = null;
		}
		
		/**
		 * 目标对象改变后调用该方法处理.
		 */
		private function targetChanged():void
		{
			if(!_initialized)
			{
				initialize();
				_initialized = true;
			}
			if(_previousTarget != null)
			{
				_previousTarget.dispatchEvent(new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE, _currentToolTip));
			}
			reset();
			if(_currentTarget != null && _currentTarget.toolTip != null)
			{
				if(_showDelay <= 0 || _scrubTimer.running)
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
		
		private function initialize():void
		{
			_showTimer = new Timer(0, 1);
			_showTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showTimerCompleteHandler);
			_scrubTimer = new Timer(0, 1);
			_hideTimer = new Timer(0, 1);
			_hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideTimerCompleteHandler);
		}
		
		private function showTimerCompleteHandler(event:TimerEvent):void
		{
			if(_currentTarget != null)
			{
				createTip();
				initializeTip();
				positionTip();
				showTip();
			}
		}
		
		private function hideTimerCompleteHandler(event:TimerEvent):void
		{
			hideTip();
		}
		
		/**
		 * 移除当前显示的工具提示并重置所有的数据.
		 */
		private function reset():void
		{
			_showTimer.reset();
			_hideTimer.reset();
			if(_currentToolTip != null)
			{
				//移除当前显示的工具提示对象
				if((_currentToolTip as DisplayObject).visible)
				{
					_currentToolTip.hide();
				}
				LayerManager.getInstance().toolTipLayer.removeChild(_currentToolTip as DisplayObject);
				_currentToolTip = null;
				//设置 scrub 延时
				_scrubTimer.reset();
				if(_scrubDelay > 0)
				{
					_scrubTimer.delay = _scrubDelay;
					_scrubTimer.start();
				}
			}
		}
		
		/**
		 * 创建用于显示的工具提示对象.
		 */
		private function createTip():void
		{
			var toolTipRenderer:Class = _currentTarget.toolTipRenderer;
			if(toolTipRenderer == null)
			{
				toolTipRenderer = _toolTipClass;
			}
			_currentToolTip = _toolTipMap.get(toolTipRenderer);
			if(_currentToolTip == null)
			{
				_currentToolTip = new toolTipRenderer() as IToolTipManagerClient;
				_toolTipMap.put(toolTipRenderer, _currentToolTip);
			}
			else
			{
				_currentToolTip.reset();
			}
			if(_currentToolTip is InteractiveObject)
			{
				(_currentToolTip as InteractiveObject).mouseEnabled = false;
			}
			if(_currentToolTip is DisplayObjectContainer)
			{
				(_currentToolTip as DisplayObjectContainer).mouseChildren = false;
			}
			(_currentToolTip as DisplayObject).visible = false;
			LayerManager.getInstance().toolTipLayer.addChild(_currentToolTip as DisplayObject);
		}
		
		/**
		 * 初始化工具提示对象.
		 */
		private function initializeTip():void
		{
			_currentToolTip.data = _currentTarget.toolTip;
			if(_currentToolTip is IInvalidating)
			{
				(_currentToolTip as IInvalidating).validateLayoutNow();
				(_currentToolTip as IInvalidating).validateShowNow();
			}
		}
		
		/**
		 * 设置工具提示对象的位置.
		 */
		private function positionTip():void
		{
			var component:DisplayObject = _currentTarget as DisplayObject;
			var toolTip:DisplayObject = _currentToolTip as DisplayObject;
			//获取组件相对于父层坐标的区域
			var layerRect:Rectangle = component.getBounds(LayerManager.getInstance().toolTipLayer);
			//获取工具提示相对于本身坐标的区域, 因为需要处理工具提示并非对其到自身原点的情况
			var toolTipRect:Rectangle = toolTip.getBounds(toolTip);
			//复用工具提示时取出的区域是上一次的大小, 需要进行调整
			toolTipRect.width = toolTip.width;
			toolTipRect.height = toolTip.height;
			//获取工具提示的中心位置
			var centerX:Number = layerRect.left + (layerRect.width - toolTipRect.width) / 2;
			var centerY:Number = layerRect.top + (layerRect.height - toolTipRect.height) / 2;
			//设置位置
			var x:Number, y:Number;
			var position:String = _currentTarget.toolTipPosition;
			switch(position)
			{
				case ToolTipPosition.ABOVE:
					x = centerX;
					y = layerRect.top - toolTipRect.height;
					break;
				case ToolTipPosition.BELOW:
					x = centerX;
					y = layerRect.bottom;
					break;
				case ToolTipPosition.LEFT:
					x = layerRect.left - toolTipRect.width;
					y = centerY;
					break;
				case ToolTipPosition.RIGHT:
					x = layerRect.right;
					y = centerY;
					break;
				default:
					x = LayerManager.getInstance().toolTipLayer.mouseX + 15;
					y = LayerManager.getInstance().toolTipLayer.mouseY + 15;
					break;
			}
			//校正位置
			x -= toolTipRect.left;
			y -= toolTipRect.top;
			//设定偏移量
			var offset:Point = _currentTarget.toolTipOffset;
			if(offset != null)
			{
				x += offset.x;
				y += offset.y;
			}
			//对超出显示区域的工具提示进行调整
			var screenWidth:Number = Global.stage.stageWidth;
			var screenHeight:Number = Global.stage.stageHeight;
			if(y + toolTipRect.height > screenHeight)
			{
				y = screenHeight - toolTipRect.height;
			}
			if(y < 0)
			{
				y = 0;
			}
			if(x + toolTipRect.width > screenWidth)
			{
				x = screenWidth - toolTipRect.width;
			}
			if(x < 0)
			{
				x = 0;
			}
			//应用坐标
			(_currentToolTip as DisplayObject).x = x;
			(_currentToolTip as DisplayObject).y = y;
		}
		
		/**
		 * 显示工具提示对象.
		 */
		private function showTip():void
		{
			_currentTarget.dispatchEvent(new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW, _currentToolTip));
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_currentToolTip.show();
			(_currentToolTip as DisplayObject).visible = true;
			if(_hideDelay > 0)
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
			if(_previousTarget != null)
			{
				_previousTarget.dispatchEvent(new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE, _currentToolTip));
				Global.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
			if(_currentToolTip != null)
			{
				_currentToolTip.hide();
				(_currentToolTip as DisplayObject).visible = false;
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			reset();
		}
		
		/**
		 * 创建指定的工具提示对象到舞台中.
		 * @param toolTip 工具提示的内容.
		 * @param x 舞台 x 轴坐标.
		 * @param y 舞台 y 轴坐标.
		 * @param toolTipRenderer 工具提示渲染类.
		 * @return 创建后的工具提示对象.
		 */
		public function createToolTip(toolTip:Object, x:Number = 0, y:Number = 0, toolTipRenderer:Class = null):IToolTipManagerClient
		{
			if(toolTipRenderer == null)
			{
				toolTipRenderer = _toolTipClass;
			}
			var toolTipRender:IToolTipManagerClient = new toolTipRenderer() as IToolTipManagerClient;
			(toolTipRender as DisplayObject).x = x;
			(toolTipRender as DisplayObject).y = y;
			toolTipRender.data = toolTip;
			LayerManager.getInstance().toolTipLayer.addChild(toolTipRender as DisplayObject);
			return toolTipRender;
		}
		
		/**
		 * 销毁指定的工具提示对象.
		 * @param toolTipRenderer 要销毁的工具提示对象.
		 */
		public function destroyToolTip(toolTipRender:IToolTipManagerClient):void
		{
			LayerManager.getInstance().toolTipLayer.removeChild(toolTipRender as DisplayObject);
		}
	}
}
