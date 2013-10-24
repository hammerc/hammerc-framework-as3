/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.hammerc.components.Button;
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IViewport;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.PropertyChangeEvent;
	import org.hammerc.events.ResizeEvent;
	import org.hammerc.events.UIEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ScrollBarBase</code> 类为滚动条基类.
	 * @author wizardc
	 */
	public class ScrollBarBase extends TrackBase
	{
		/**
		 * 皮肤子件, 减小滚动条值的按钮.
		 */
		public var decrementButton:Button;
		
		/**
		 * 皮肤子件, 增大滚动条值的按钮.
		 */
		public var incrementButton:Button;
		
		/**
		 * 正在步进增大值的标志.
		 */
		private var _steppingDown:Boolean;
		
		/**
		 * 正在步进减小值的标志.
		 */
		private var _steppingUp:Boolean;
		
		/**
		 * 正在步进改变值的标志.
		 */
		private var _isStepping:Boolean;
		
		/**
		 * 记录当前滚动方向的标志.
		 */
		private var _trackScrollDown:Boolean;
		
		/**
		 * 当鼠标按住轨道时用于循环滚动的计时器.
		 */
		private var _trackScrollTimer:Timer;
		
		/**
		 * 在鼠标按住轨道的滚动过程中记录滚动的位置.
		 */
		private var _trackPosition:Point = new Point();
		
		/**
		 * 正在进行鼠标按住轨道滚动过程的标志.
		 */
		private var _trackScrolling:Boolean = false;
		
		private var _pageSize:Number = 20;
		private var _pageSizeChanged:Boolean = false;
		
		private var _repeatInterval:Number = 35;
		private var _repeatDelay:Number = 500;
		
		private var _fixedThumbSize:Boolean = false;
		
		private var _autoThumbVisibility:Boolean = true;
		
		private var _viewport:IViewport;
		
		/**
		 * 创建一个 <code>ScrollBarBase</code> 对象.
		 */
		public function ScrollBarBase()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set minimum(value:Number):void
		{
			if(value == super.minimum)
			{
				return;
			}
			super.minimum = value;
			this.invalidateSkinState();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set maximum(value:Number):void
		{
			if(value == super.maximum)
			{
				return;
			}
			super.maximum = value;
			this.invalidateSkinState();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set snapInterval(value:Number):void
		{
			super.snapInterval = value;
			_pageSizeChanged = true;
		}
		
		/**
		 * 设置或获取翻页大小.
		 */
		public function set pageSize(value:Number):void
		{
			if(value == _pageSize)
			{
				return;
			}
			_pageSize = value;
			_pageSizeChanged = true;
			this.invalidateProperties();
			this.invalidateDisplayList();
		}
		public function get pageSize():Number
		{
			return _pageSize;
		}
		
		/**
		 * 设置或获取用户在轨道上按住鼠标时 page 事件之间相隔的毫秒数.
		 */
		public function set repeatInterval(value:Number):void
		{
			_repeatInterval = value;
		}
		public function get repeatInterval():Number
		{
			return _repeatInterval;
		}
		
		/**
		 * 设置或获取是否调整滑块的大小.
		 */
		public function set fixedThumbSize(value:Boolean):void
		{
			if(_fixedThumbSize == value)
			{
				return;
			}
			_fixedThumbSize = value;
			this.invalidateDisplayList();
		}
		public function get fixedThumbSize():Boolean
		{
			return _fixedThumbSize;
		}
		
		/**
		 * 设置或获取在第一个 page 事件之后直到后续的 page 事件发生之间相隔的毫秒数.
		 */
		public function set repeatDelay(value:Number):void
		{
			_repeatDelay = value;
		}
		public function get repeatDelay():Number
		{
			return _repeatDelay;
		}
		
		/**
		 * 设置或获取是否无论何时更新滑块的大小, 都将重置滑块的可见性.
		 */
		public function set autoThumbVisibility(value:Boolean):void
		{
			if(_autoThumbVisibility == value)
			{
				return;
			}
			_autoThumbVisibility = value;
			this.invalidateDisplayList();
		}
		public function get autoThumbVisibility():Boolean
		{
			return _autoThumbVisibility;
		}
		
		/**
		 * 设置或获取由此滚动条控制的可滚动组件.
		 */
		public function set viewport(value:IViewport):void
		{
			if(value == _viewport)
			{
				return;
			}
			if(_viewport != null)
			{
				_viewport.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
				_viewport.removeEventListener(ResizeEvent.RESIZE, viewport_resizeHandler);
				_viewport.clipAndEnableScrolling = false;
			}
			_viewport = value;
			if(_viewport != null)
			{
				_viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
				_viewport.addEventListener(ResizeEvent.RESIZE, viewport_resizeHandler);
				_viewport.clipAndEnableScrolling = true;
			}
		}
		public function get viewport():IViewport
		{
			return _viewport;
		}
		
		/**
		 * 根据指定数值返回最接近 snapInterval 的整数倍的数值.
		 */
		private function nearestValidSize(size:Number):Number
		{
			var interval:Number = snapInterval;
			if(interval == 0)
			{
				return size;
			}
			var validSize:Number = Math.round(size / interval) * interval;
			return (Math.abs(validSize) < interval) ? interval : validSize;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_pageSizeChanged)
			{
				_pageSize = nearestValidSize(_pageSize);
				_pageSizeChanged = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			if(maximum <= minimum)
			{
				return "inactive";
			}
			return super.getCurrentSkinState();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == decrementButton)
			{
				decrementButton.addEventListener(UIEvent.BUTTON_DOWN, button_buttonDownHandler);
				decrementButton.autoRepeat = true;
			}
			else if(instance == incrementButton)
			{
				incrementButton.addEventListener(UIEvent.BUTTON_DOWN, button_buttonDownHandler);
				incrementButton.autoRepeat = true;
			}
			else if(instance == track)
			{
				track.addEventListener(MouseEvent.ROLL_OVER, track_rollOverHandler);
				track.addEventListener(MouseEvent.ROLL_OUT, track_rollOutHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == decrementButton)
			{
				decrementButton.removeEventListener(UIEvent.BUTTON_DOWN, button_buttonDownHandler);
			}
			else if(instance == incrementButton)
			{
				incrementButton.removeEventListener(UIEvent.BUTTON_DOWN, button_buttonDownHandler);
			}
			else if(instance == track)
			{
				track.removeEventListener(MouseEvent.ROLL_OVER, track_rollOverHandler);
				track.removeEventListener(MouseEvent.ROLL_OUT, track_rollOutHandler);
			}
		}
		
		/**
		 * 从 <code>value</code> 增加或减去 <code>pageSize</code>.
		 * <p>每次增加后, 新的 <code>value</code> 是大于当前 <code>value</code> 的 <code>pageSize</code> 的最接近倍数.<br/>
		 * 每次减去后, 新的 <code>value</code> 是小于当前 <code>value</code> 的 <code>pageSize</code> 的最接近倍数. <code>value</code> 的最小值是 <code>pageSize</code>.</p>
		 * @param increase 翻页操作是增加 (true) 还是减少 (false) <code>value</code>.
		 */
		public function changeValueByPage(increase:Boolean = true):void
		{
			var val:Number;
			if(increase)
			{
				val = Math.min(value + pageSize, maximum);
			}
			else
			{
				val = Math.max(value - pageSize, minimum);
			}
			this.setValue(val);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 目标视域组件属性发生改变.
		 */
		private function viewport_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			switch(event.property) 
			{
				case "contentWidth": 
					viewport_contentWidthChangeHandler(event);
					break;
				case "contentHeight": 
					viewport_contentHeightChangeHandler(event);
					break;
				case "horizontalScrollPosition":
					viewport_horizontalScrollPositionChangeHandler(event);
					break;
				case "verticalScrollPosition":
					viewport_verticalScrollPositionChangeHandler(event);
					break;
			}
		}
		
		/**
		 * 目标视域组件尺寸发生改变.
		 */
		hammerc_internal function viewport_resizeHandler(event:ResizeEvent):void
		{
		}
		
		/**
		 * 目标视域组件的内容宽度发生改变.
		 */
		hammerc_internal function viewport_contentWidthChangeHandler(event:PropertyChangeEvent):void
		{
		}
		
		/**
		 * 目标视域组件的内容高度发生改变.
		 */
		hammerc_internal function viewport_contentHeightChangeHandler(event:PropertyChangeEvent):void
		{
		}
		
		/**
		 * 目标视域组件的水平方向滚动条位置发生改变.
		 */
		hammerc_internal function viewport_horizontalScrollPositionChangeHandler(event:PropertyChangeEvent):void
		{
		}
		
		/**
		 * 目标视域组件的垂直方向滚动条位置发生改变.
		 */
		hammerc_internal function viewport_verticalScrollPositionChangeHandler(event:PropertyChangeEvent):void
		{
		}
		
		/**
		 * 鼠标在两端按钮上按住不放的事件.
		 */
		protected function button_buttonDownHandler(event:Event):void
		{
			var increment:Boolean = (event.target == incrementButton);
			if(!_isStepping && ((increment && this.value < this.maximum) || (!increment && this.value > this.minimum)))
			{
				this.dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
				_isStepping = true;
				HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, button_buttonUpHandler, false, 0, true);
				HammercGlobals.stage.addEventListener(Event.MOUSE_LEAVE, button_buttonUpHandler, false, 0, true);
			}
			if(!_steppingDown && !_steppingUp)
			{
				this.changeValueByStep(increment);
				return;
			}
		}
		
		/**
		 * 鼠标在两端按钮上弹起的事件.
		 */
		protected function button_buttonUpHandler(event:Event):void
		{
			if(_steppingDown || _steppingUp)
			{
				this.dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
				_steppingUp = _steppingDown = false;
				_isStepping = false;
			}
			else if(_isStepping)
			{
				this.dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
				_isStepping = false;
			}
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, button_buttonUpHandler);
			HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, button_buttonUpHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function track_mouseDownHandler(event:MouseEvent):void
		{
			if(!this.enabled)
			{
				return;
			}
			_trackPosition = track.globalToLocal(new Point(event.stageX, event.stageY));
			if(event.shiftKey)
			{
				var thumbW:Number = (thumb) ? thumb.layoutBoundsWidth : 0;
				var thumbH:Number = (thumb) ? thumb.layoutBoundsHeight : 0;
				_trackPosition.x -= (thumbW / 2);
				_trackPosition.y -= (thumbH / 2);
			}
			var newScrollValue:Number = this.pointToValue(_trackPosition.x, _trackPosition.y);
			_trackScrollDown = (newScrollValue > this.value);
			if(event.shiftKey)
			{
				var adjustedValue:Number = this.nearestValidValue(newScrollValue, this.snapInterval);
				this.setValue(adjustedValue);
				this.dispatchEvent(new Event(Event.CHANGE));
				return;
			}
			this.dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
			this.changeValueByPage(_trackScrollDown);
			_trackScrolling = true;
			HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, track_mouseMoveHandler, false, 0, true);      
			HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, track_mouseUpHandler, false, 0, true);
			HammercGlobals.stage.addEventListener(Event.MOUSE_LEAVE, track_mouseUpHandler, false, 0, true);
			if(_trackScrollTimer == null)
			{
				_trackScrollTimer = new Timer(_repeatDelay, 1);
				_trackScrollTimer.addEventListener(TimerEvent.TIMER, trackScrollTimerHandler);
			}
			else
			{
				_trackScrollTimer.delay = _repeatDelay;
				_trackScrollTimer.repeatCount = 1;
			}
			_trackScrollTimer.start();
		}
		
		/**
		 * 在轨道上按住 shift 并按下鼠标后, 滑块滑动到按下点的计时器触发函数.
		 */
		private function trackScrollTimerHandler(event:Event):void
		{
			var newScrollValue:Number = this.pointToValue(_trackPosition.x, _trackPosition.y);
			if(newScrollValue == value)
			{
				return;
			}
			var fixedThumbSize:Boolean = _fixedThumbSize !== false;
			if(_trackScrollDown)
			{
				var range:Number = this.maximum - this.minimum;
				if(range == 0)
				{
					return;
				}
				if((this.value + this.pageSize) > newScrollValue && (!fixedThumbSize || this.nearestValidValue(newScrollValue, this.pageSize) != this.maximum))
				{
					return;
				}
			}
			else if(newScrollValue > this.value)
			{
				return;
			}
			var oldValue:Number = value;
			this.changeValueByPage(_trackScrollDown);
			if(_trackScrollTimer && _trackScrollTimer.repeatCount == 1)
			{
				_trackScrollTimer.delay = _repeatInterval;
				_trackScrollTimer.repeatCount = 0;
			}
		}
		
		/**
		 * 轨道上鼠标移动事件.
		 */
		private function track_mouseMoveHandler(event:MouseEvent):void
		{
			if(_trackScrolling)
			{
				var pt:Point = new Point(event.stageX, event.stageY);
				_trackPosition = track.globalToLocal(pt);
			}
		}
		
		/**
		 * 轨道上鼠标弹起事件.
		 */
		private function track_mouseUpHandler(event:Event):void
		{
			_trackScrolling = false;
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, track_mouseMoveHandler);      
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, track_mouseUpHandler);
			HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, track_mouseUpHandler);
			this.dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
			if(_trackScrollTimer != null)
			{
				_trackScrollTimer.reset();
			}
		}
		
		/**
		 * 鼠标经过轨道触发函数.
		 */
		private function track_rollOverHandler(event:MouseEvent):void
		{
			if(_trackScrolling && _trackScrollTimer != null)
			{
				_trackScrollTimer.start();
			}
		}
		
		/**
		 * 鼠标移出轨道时触发的函数.
		 */
		private function track_rollOutHandler(event:MouseEvent):void
		{
			if(_trackScrolling && _trackScrollTimer != null)
			{
				_trackScrollTimer.stop();
			}
		}
	}
}
