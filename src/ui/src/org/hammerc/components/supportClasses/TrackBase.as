// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.components.Button;
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.ResizeEvent;
	import org.hammerc.events.TrackBaseEvent;
	import org.hammerc.events.UIEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.CHANGE_START
	 */
	[Event(name="changeStart", type="org.hammerc.events.UIEvent")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.CHANGE_END
	 */
	[Event(name="changeEnd", type="org.hammerc.events.UIEvent")]
	
	/**
	 * @eventType org.hammerc.events.TrackBaseEvent.THUMB_DRAG
	 */
	[Event(name="thumbDrag", type="org.hammerc.events.TrackBaseEvent")]
	
	/**
	 * @eventType org.hammerc.events.TrackBaseEvent.THUMB_PRESS
	 */
	[Event(name="thumbPress", type="org.hammerc.events.TrackBaseEvent")]
	
	/**
	 * @eventType org.hammerc.events.TrackBaseEvent.THUMB_RELEASE
	 */
	[Event(name="thumbRelease", type="org.hammerc.events.TrackBaseEvent")]
	
	/**
	 * <code>TrackBase</code> 类是具有一个轨道和一个或多个滑块按钮的组件基类.
	 * @author wizardc
	 */
	public class TrackBase extends Range
	{
		/**
		 * 皮肤子件, 实体滑块组件.
		 */
		public var thumb:Button;
		
		/**
		 * 皮肤子件, 实体轨道组件.
		 */
		public var track:Button;
		
		/**
		 * 记录鼠标在 thumb 上按下的位置.
		 */
		hammerc_internal var _clickOffset:Point;
		
		/**
		 * 当鼠标拖动 thumb 时, 需要更新 value 的标记.
		 */
		private var _needUpdateValue:Boolean = false;
		
		private var _mouseDownTarget:DisplayObject;
		
		/**
		 * 创建一个 <code>TrackBase</code> 对象.
		 */
		public function TrackBase()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
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
			this.invalidateDisplayList();
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
			this.invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set value(newValue:Number):void
		{
			if(newValue == super.value)
			{
				return;
			}
			super.value = newValue;
			this.invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setValue(value:Number):void
		{
			super.setValue(value);
			this.invalidateDisplayList();
		}
		
		/**
		 * 将相对于轨道的 x, y 像素位置转换为介于最小值和最大值 (包括两者) 之间的一个值.
		 * @param x 相对于轨道原点的位置的x坐标.
		 * @param y 相对于轨道原点的位置的y坐标.
		 */
		protected function pointToValue(x:Number, y:Number):Number
		{
			return minimum;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function changeValueByStep(increase:Boolean = true):void
		{
			var prevValue:Number = this.value;
			super.changeValueByStep(increase);
			if(this.value != prevValue)
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			return this.enabled ? "normal" : "disabled";
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == thumb)
			{
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, this.thumb_mouseDownHandler);
				thumb.addEventListener(ResizeEvent.RESIZE, thumb_resizeHandler);
				thumb.addEventListener(UIEvent.UPDATE_COMPLETE, thumb_updateCompleteHandler);
				thumb.stickyHighlighting = true;
			}
			else if(instance == track)
			{
				track.addEventListener(MouseEvent.MOUSE_DOWN, this.track_mouseDownHandler);
				track.addEventListener(ResizeEvent.RESIZE, track_resizeHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == thumb)
			{
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, this.thumb_mouseDownHandler);
				thumb.removeEventListener(ResizeEvent.RESIZE, thumb_resizeHandler);            
				thumb.removeEventListener(UIEvent.UPDATE_COMPLETE, thumb_updateCompleteHandler);            
			}
			else if(instance == track)
			{
				track.removeEventListener(MouseEvent.MOUSE_DOWN, this.track_mouseDownHandler);
				track.removeEventListener(ResizeEvent.RESIZE, track_resizeHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.updateSkinDisplayList();
		}
		
		/**
		 * 更新皮肤部件 (通常为滑块) 的大小和可见性.
		 * <p>子类覆盖此方法以基于 <code>minimum</code>, <code>maximum</code> 和 <code>value</code> 属性更新滑块的大小, 位置和可见性.</p> 
		 */
		protected function updateSkinDisplayList():void 
		{
		}
		
		/**
		 * 添加到舞台时.
		 */
		private function addedToStageHandler(event:Event):void
		{
			this.updateSkinDisplayList();
		}
		
		/**
		 * 轨道尺寸改变事件.
		 */
		private function track_resizeHandler(event:Event):void
		{
			this.updateSkinDisplayList();
		}
		
		/**
		 * 滑块尺寸改变事件.
		 */
		private function thumb_resizeHandler(event:Event):void
		{
			this.updateSkinDisplayList();
		}
		
		/**
		 * 滑块三个阶段的延迟布局更新完毕事件.
		 */
		private function thumb_updateCompleteHandler(event:Event):void
		{
			this.updateSkinDisplayList();
			thumb.removeEventListener(UIEvent.UPDATE_COMPLETE, thumb_updateCompleteHandler);
		}
		
		/**
		 * 滑块按下事件.
		 */
		protected function thumb_mouseDownHandler(event:MouseEvent):void
		{
			HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler, false, 0, true);
			HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler, false, 0, true);
			HammercGlobals.stage.addEventListener(Event.MOUSE_LEAVE, this.stage_mouseUpHandler, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_clickOffset = thumb.globalToLocal(new Point(event.stageX, event.stageY));
			this.dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_PRESS));
			this.dispatchEvent(new UIEvent(UIEvent.CHANGE_START));
		}
		
		/**
		 * 拖动 thumb 过程中触发的 EnterFrame 事件.
		 */
		private function onEnterFrame(event:Event):void
		{
			if(!_needUpdateValue || track == null)
			{
				return;
			}
			this.updateWhenMouseMove();
			_needUpdateValue = false;
		}
		
		/**
		 * 当 thumb 被拖动时更新值, 此方法每帧只被调用一次, 比直接在鼠标移动事件里更新性能更高.
		 */
		protected function updateWhenMouseMove():void
		{
			if(track == null)
			{
				return;
			}
			var p:Point = track.globalToLocal(new Point(HammercGlobals.stage.mouseX, HammercGlobals.stage.mouseY));
			var newValue:Number = this.pointToValue(p.x - _clickOffset.x, p.y - _clickOffset.y);
			newValue = this.nearestValidValue(newValue, this.snapInterval);
			if(newValue != this.value)
			{
				this.setValue(newValue);
				this.validateDisplayList();
				this.dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 当 value 改变后需要手动调用该方法来保证滚动区域正确.
		 */
		public function updateWhenValueChanged():void
		{
			this.value = this.nearestValidValue(this.value, this.snapInterval);
			this.setValue(this.value);
			this.validateDisplayList();
		}
		
		/**
		 * 鼠标移动事件.
		 */
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			if(_needUpdateValue)
			{
				return;
			}
			_needUpdateValue = true;
		}
		
		/**
		 * 鼠标弹起事件.
		 */
		protected function stage_mouseUpHandler(event:Event):void
		{
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
			HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, this.stage_mouseUpHandler);
			this.removeEventListener(Event.ENTER_FRAME, this.updateWhenMouseMove);
			if(_needUpdateValue)
			{
				this.updateWhenMouseMove();
				_needUpdateValue = false;
			}
			this.dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_RELEASE));
			this.dispatchEvent(new UIEvent(UIEvent.CHANGE_END));
		}
		
		/**
		 * 轨道被按下事件.
		 */
		protected function track_mouseDownHandler(event:MouseEvent):void 
		{
		}
		
		/**
		 * 当在组件上按下鼠标时记录被按下的子显示对象.
		 */
		private function mouseDownHandler(event:MouseEvent):void
		{
			HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, system_mouseUpSomewhereHandler, false, 0, true);
			HammercGlobals.stage.addEventListener(Event.MOUSE_LEAVE, system_mouseUpSomewhereHandler, false, 0, true);
			_mouseDownTarget = DisplayObject(event.target);
		}
		
		/**
		 * 当鼠标弹起时, 若不是在 mouseDownTarget 上弹起, 而是另外的子显示对象上弹起时, 额外抛出一个鼠标单击事件.
		 */
		private function system_mouseUpSomewhereHandler(event:Event):void
		{
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, system_mouseUpSomewhereHandler);
			HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, system_mouseUpSomewhereHandler);
			if(_mouseDownTarget != event.target && event is MouseEvent && contains(DisplayObject(event.target)))
			{
				var mEvent:MouseEvent = event as MouseEvent;
				var mousePoint:Point = new Point(mEvent.localX, mEvent.localY);
				mousePoint = this.globalToLocal(DisplayObject(event.target).localToGlobal(mousePoint));
				this.dispatchEvent(new MouseEvent(MouseEvent.CLICK, mEvent.bubbles, mEvent.cancelable, mousePoint.x, mousePoint.y, mEvent.relatedObject, mEvent.ctrlKey, mEvent.altKey, mEvent.shiftKey, mEvent.buttonDown, mEvent.delta));
			}
			_mouseDownTarget = null;
		}
	}
}
