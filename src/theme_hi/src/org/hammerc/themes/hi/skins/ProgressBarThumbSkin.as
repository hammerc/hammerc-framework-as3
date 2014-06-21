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
	 * <code>ProgressBarThumbSkin</code> 类定义了进度条轨道的皮肤.
	 * @author wizardc
	 */
	public class ProgressBarThumbSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>ProgressBarThumbSkin</code> 对象.
		 */
		public function ProgressBarThumbSkin()
		{
			super();
			this.minHeight = 10;
			this.minWidth = 5;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF, 0);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
			this.graphics.lineStyle();
			this.drawRoundRect(0, 0, w, h, 0, _fillColors[2], 1, this.verticalGradientMatrix(0, 0, w, h)); 
			if(w > 5)
			{
				this.drawLine(1, 0, w - 1, 0, _fillColors[3]);
			}
		}
	}
}
