// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.themes.hi.skins
{
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>HSliderTrackSkin</code> 类水平滑块轨道的皮肤.
	 * @author wizardc
	 */
	public class HSliderTrackSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>HSliderTrackSkin</code> 对象.
		 */
		public function HSliderTrackSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.currentState = "up";
			this.minHeight = 4;
			this.minWidth = 15;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var offsetY:Number = Math.round(h * 0.5 - 2);
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF, 0);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
			h = 4;
			this.graphics.lineStyle();
			this.drawRoundRect(0, offsetY, w, h, 1, 0xdddbdb, 1, this.verticalGradientMatrix(0, offsetY, w, h)); 
			if(w > 4)
			{
				this.drawLine(1, offsetY, w - 1, offsetY, 0xbcbcbc);
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
