/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>HSliderTrackHighlightSkin</code> 类水平滑块高亮轨道的皮肤.
	 * @author wizardc
	 */
	public class HSliderTrackHighlightSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>HSliderTrackHighlightSkin</code> 对象.
		 */
		public function HSliderTrackHighlightSkin()
		{
			super();
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
			this.drawRoundRect(0, offsetY, w, h, 1, _fillColors[2], 1, this.verticalGradientMatrix(0, offsetY, w, h)); 
			if(w > 5)
			{
				this.drawLine(1, offsetY, w - 1, offsetY, _fillColors[3]);
			}
		}
	}
}
