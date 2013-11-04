/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.geom.Point;
	
	import org.hammerc.components.supportClasses.SliderBase;
	
	/**
	 * <code>HSlider</code> 类实现了水平滑块组件.
	 * @author wizardc
	 */
	public class HSlider extends SliderBase
	{
		/**
		 * 创建一个 <code>HSlider</code> 对象.
		 */
		public function HSlider()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return HSlider;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "HSlider";
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function pointToValue(x:Number, y:Number):Number
		{
			if(thumb == null || track == null)
			{
				return 0;
			}
			var range:Number = this.maximum - this.minimum;
			var thumbRange:Number = track.layoutBoundsWidth - thumb.layoutBoundsWidth;
			return this.minimum + ((thumbRange != 0) ? (x / thumbRange) * range : 0);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateSkinDisplayList():void
		{
			if(thumb == null || track == null)
			{
				return;
			}
			var thumbRange:Number = track.layoutBoundsWidth - thumb.layoutBoundsWidth;
			var range:Number = this.maximum - this.minimum;
			var thumbPosTrackX:Number = (range > 0) ? ((this.pendingValue - this.minimum) / range) * thumbRange : 0;
			var thumbPos:Point = track.localToGlobal(new Point(thumbPosTrackX, 0));
			var thumbPosParentX:Number = thumb.parent.globalToLocal(thumbPos).x;
			thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX), thumb.layoutBoundsY);
			if(showTrackHighlight && trackHighlight != null && trackHighlight.parent != null)
			{
				var trackHighlightX:Number = trackHighlight.parent.globalToLocal(thumbPos).x - thumbPosTrackX;
				trackHighlight.x = Math.round(trackHighlightX);
				trackHighlight.width = Math.round(thumbPosTrackX);
			}
		}
	}
}
