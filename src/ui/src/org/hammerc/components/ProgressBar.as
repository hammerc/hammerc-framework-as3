/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.hammerc.components.supportClasses.Range;
	import org.hammerc.core.UIComponent;
	import org.hammerc.events.MoveEvent;
	import org.hammerc.events.ResizeEvent;
	
	/**
	 * <code>ProgressBar</code> 类实现了进度条控件.
	 * @author wizardc
	 */
	public class ProgressBar extends Range
	{
		/**
		 * 皮肤子件, 进度高亮显示对象.
		 */
		public var thumb:DisplayObject;
		
		/**
		 * 皮肤子件, 轨道显示对象, 用于确定 thumb 要覆盖的区域.
		 */
		public var track:DisplayObject;
		
		/**
		 * 皮肤子件, 进度条文本.
		 */
		public var labelDisplay:Label;
		
		private var _labelFunction:Function;
		
		private var _direction:String = ProgressBarDirection.LEFT_TO_RIGHT;
		
		private var _trackResizedOrMoved:Boolean = false;
		
		/**
		 * 创建一个 <code>ProgressBar</code> 对象.
		 */
		public function ProgressBar()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return ProgressBar;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "ProgressBar";
		}
		
		/**
		 * 设置或获取进度条文本格式化回调函数.
		 * <p>示例：<br/>
		 * labelFunction(value:Number,maximum:Number):String;</p>
		 */
		public function set labelFunction(value:Function):void
		{
			if(_labelFunction == value)
			{
				return;
			}
			_labelFunction = value;
			this.invalidateDisplayList();
		}
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		
		/**
		 * 将当前值转换成文本.
		 */
		protected function valueToLabel(value:Number,maximum:Number):String
		{
			if(this.labelFunction != null)
			{
				return this.labelFunction.call(null, value, maximum);
			}
			return value + " / " + maximum;
		}
		
		/**
		 * 设置或获取进度条增长方向.
		 */
		public function set direction(value:String):void
		{
			if(_direction == value)
			{
				return;
			}
			_direction = value;
			this.invalidateDisplayList();
		}
		public function get direction():String
		{
			return _direction;
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
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			this.updateSkinDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(instance == track)
			{
				if(track is UIComponent)
				{
					track.addEventListener(ResizeEvent.RESIZE, onTrackResizeOrMove);
					track.addEventListener(MoveEvent.MOVE, onTrackResizeOrMove);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == track)
			{
				if(track is UIComponent)
				{
					track.removeEventListener(ResizeEvent.RESIZE, onTrackResizeOrMove);
					track.removeEventListener(MoveEvent.MOVE, onTrackResizeOrMove);
				}
			}
		}
		
		private function onTrackResizeOrMove(event:Event):void
		{
			_trackResizedOrMoved = true;
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_trackResizedOrMoved)
			{
				this.updateSkinDisplayList();
			}
		}
		
		/**
		 * 更新皮肤部件大小和可见性.
		 */
		protected function updateSkinDisplayList():void
		{
			_trackResizedOrMoved = false;
			var currentValue:Number = isNaN(this.value) ? 0 : this.value;
			var maxValue:Number = isNaN(this.maximum) ? 0 : this.maximum;
			if(thumb != null && track != null)
			{
				var trackWidth:Number = isNaN(track.width) ? 0 : track.width;
				trackWidth *= track.scaleX;
				var trackHeight:Number = isNaN(track.height) ? 0 : track.height;
				trackHeight *= track.scaleY;
				var thumbWidth:Number = Math.round((currentValue / maxValue) * trackWidth);
				if(isNaN(thumbWidth) || thumbWidth < 0 || thumbWidth === Infinity)
				{
					thumbWidth = 0;
				}
				var thumbHeight:Number = Math.round((currentValue / maxValue) * trackHeight);
				if(isNaN(thumbHeight) || thumbHeight < 0 || thumbHeight === Infinity)
				{
					thumbHeight = 0;
				}
				var thumbPos:Point = this.globalToLocal(track.localToGlobal(new Point()));
				switch(_direction)
				{
					case ProgressBarDirection.LEFT_TO_RIGHT:
						thumb.width = thumbWidth;
						thumb.x = thumbPos.x;
						break;
					case ProgressBarDirection.RIGHT_TO_LEFT:
						thumb.width = thumbWidth;
						thumb.x = thumbPos.x + trackWidth - thumbWidth;
						break;
					case ProgressBarDirection.TOP_TO_BOTTOM:
						thumb.height = thumbHeight;
						thumb.y = thumbPos.y;
						break;
					case ProgressBarDirection.BOTTOM_TO_TOP:
						thumb.height = thumbHeight;
						thumb.y = thumbPos.y + trackHeight - thumbHeight;
						break;
				}
			}
			if(labelDisplay != null)
			{
				labelDisplay.text = valueToLabel(currentValue, maxValue);
			}
		}
	}
}
