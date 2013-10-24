/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.TrackBaseEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>SliderBase</code> 类为滑块控件基类.
	 * @author wizardc
	 */
	public class SliderBase extends TrackBase
	{
		/**
		 * 皮肤子件, 轨道高亮显示对象.
		 */
		public var trackHighlight:InteractiveObject;
		
		private var _showTrackHighlight:Boolean = true;
		
		private var _pendingValue:Number = 0;
		
		private var _liveDragging:Boolean = true;
		
		/**
		 * 创建一个 <code>SliderBase</code> 对象.
		 */
		public function SliderBase()
		{
			super();
			this.maximum = 10;
		}
		
		/**
		 * 设置或获取是否启用轨道高亮效果.
		 */
		public function set showTrackHighlight(value:Boolean):void
		{
			if(_showTrackHighlight == value)
			{
				return;
			}
			_showTrackHighlight = value;
			if(trackHighlight != null)
			{
				trackHighlight.visible = value;
			}
			this.invalidateDisplayList();
		}
		public function get showTrackHighlight():Boolean
		{
			return _showTrackHighlight;
		}
		
		/**
		 * 设置或获取释放鼠标按键时滑块将具有的值.
		 * 无论 <code>liveDragging</code> 是否为 true, 在滑块拖动期间始终更新此属性.
		 * 而 <code>value</code> 属性在当 <code>liveDragging</code> 为 false 时, 只在鼠标释放时更新一次.
		 */
		protected function set pendingValue(value:Number):void
		{
			if(value == _pendingValue)
			{
				return;
			}
			_pendingValue = value;
			this.invalidateDisplayList();
		}
		protected function get pendingValue():Number
		{
			return _pendingValue;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setValue(value:Number):void
		{
			_pendingValue = value;
			super.setValue(value);
		}
		
		/**
		 * 设置或获取在沿着轨道拖动滑块时, 是否在释放滑块按钮时, 提交此滑块的值.
		 */
		public function set liveDragging(value:Boolean):void
		{
			_liveDragging = value;
		}
		public function get liveDragging():Boolean
		{
			return _liveDragging;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateWhenMouseMove():void
		{      
			if(track == null)
			{
				return;
			}
			var pos:Point = track.globalToLocal(new Point(HammercGlobals.stage.mouseX, HammercGlobals.stage.mouseY));
			var newValue:Number = this.pointToValue(pos.x - _clickOffset.x,pos.y - _clickOffset.y);
			newValue = this.nearestValidValue(newValue, this.snapInterval);
			if(newValue != this.pendingValue)
			{
				this.dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
				if(this.liveDragging == true)
				{
					this.setValue(newValue);
					this.dispatchEvent(new Event(Event.CHANGE));
				}
				else
				{
					this.pendingValue = newValue;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function stage_mouseUpHandler(event:Event):void
		{
			super.stage_mouseUpHandler(event);
			if((this.liveDragging == false) && (this.value != this.pendingValue))
			{
				this.setValue(this.pendingValue);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
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
			var thumbW:Number = (thumb) ? thumb.width : 0;
			var thumbH:Number = (thumb) ? thumb.height : 0;
			var offsetX:Number = event.stageX - (thumbW / 2);
			var offsetY:Number = event.stageY - (thumbH / 2);
			var p:Point = track.globalToLocal(new Point(offsetX, offsetY));
			var newValue:Number = this.pointToValue(p.x, p.y);
			newValue = this.nearestValidValue(newValue, this.snapInterval);
			if(newValue != this.pendingValue)
			{
				this.setValue(newValue);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == trackHighlight)
			{
				trackHighlight.mouseEnabled = false;
				if(trackHighlight is DisplayObjectContainer)
				{
					(trackHighlight as DisplayObjectContainer).mouseChildren = false;
				}
				trackHighlight.visible = _showTrackHighlight;
			}
		}
	}
}
