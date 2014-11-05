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
	 * <code>ProgressBarTrackSkin</code> 类定义了进度条轨道的皮肤.
	 * @author wizardc
	 */
	public class ProgressBarTrackSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>ProgressBarTrackSkin</code> 对象.
		 */
		public function ProgressBarTrackSkin()
		{
			super();
			this.minHeight = 10;
			this.minWidth = 30;
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
			this.drawRoundRect(0, 0, w, h, 0, 0xdddbdb, 1, this.verticalGradientMatrix(0, 0, w, h)); 
			if(w > 4)
			{
				this.drawLine(1, 0, w-1, 0, 0xbcbcbc);
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
