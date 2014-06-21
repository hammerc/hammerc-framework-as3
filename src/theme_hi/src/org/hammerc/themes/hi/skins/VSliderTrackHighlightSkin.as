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
	 * <code>VSliderTrackHighlightSkin</code> 类垂直滑块高亮轨道的皮肤.
	 * @author wizardc
	 */
	public class VSliderTrackHighlightSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>VSliderTrackHighlightSkin</code> 对象.
		 */
		public function VSliderTrackHighlightSkin()
		{
			super();
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
			this.drawRoundRect(offsetX, 0, w, h, 1, _fillColors[2], 1, this.verticalGradientMatrix(offsetX, 0, w, h)); 
			if(h > 5)
			{
				this.drawLine(offsetX, 1, offsetX, h - 1, _fillColors[3]);
			}
		}
	}
}
