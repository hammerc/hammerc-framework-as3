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
	 * <code>VSliderTrackSkin</code> 类垂直滑块轨道的皮肤.
	 * @author wizardc
	 */
	public class VSliderTrackSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>VSliderTrackSkin</code> 对象.
		 */
		public function VSliderTrackSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.currentState = "up";
			this.minHeight = 15;
			this.minWidth = 4;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var offsetX:Number = Math.round(w * 0.5 - 2);
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF, 0);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
			w = 4;
			this.graphics.lineStyle();
			this.drawRoundRect(offsetX, 0, w, h, 1, 0xdddbdb, 1, this.verticalGradientMatrix(offsetX, 0, w, h)); 
			if(h > 4)
			{
				this.drawLine(offsetX, 1, offsetX, h - 1, 0xbcbcbc);
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
