/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.geom.Point;
	
	import org.hammerc.components.supportClasses.SliderBase;
	
	/**
	 * <code>VSlider</code> 类实现了垂直滑块组件.
	 * @author wizardc
	 */
	public class VSlider extends SliderBase
	{
		/**
		 * 创建一个 <code>VSlider</code> 对象.
		 */
		public function VSlider()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return VSlider;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "VSlider";
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
			var thumbRange:Number = track.layoutBoundsHeight - thumb.layoutBoundsHeight;
			return this.minimum + ((thumbRange != 0) ? ((thumbRange - y) / thumbRange) * range : 0);
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
			var thumbHeight:Number = thumb.layoutBoundsHeight;
			var thumbRange:Number = track.layoutBoundsHeight - thumbHeight;
			var range:Number = this.maximum - this.minimum;
			var thumbPosTrackY:Number = (range > 0) ? thumbRange - (((this.pendingValue - this.minimum) / range) * thumbRange) : 0;
			var thumbPos:Point = track.localToGlobal(new Point(0, thumbPosTrackY));
			var thumbPosParentY:Number = thumb.parent.globalToLocal(thumbPos).y;
			thumb.setLayoutBoundsPosition(thumb.layoutBoundsX, Math.round(thumbPosParentY));
			if(showTrackHighlight && trackHighlight != null && trackHighlight.parent != null)
			{
				var trackHighlightY:Number = this.trackHighlight.parent.globalToLocal(thumbPos).y;
				trackHighlight.y = Math.round(trackHighlightY + thumbHeight);
				trackHighlight.height = Math.round(thumbRange - trackHighlightY);
			}
		}
	}
}
