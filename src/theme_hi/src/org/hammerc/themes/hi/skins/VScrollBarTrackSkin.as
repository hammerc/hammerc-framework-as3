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
	import flash.display.GradientType;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>VScrollBarTrackSkin</code> 类为垂直滚动条轨道的皮肤.
	 * @author wizardc
	 */
	public class VScrollBarTrackSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>VScrollBarTrackSkin</code> 对象.
		 */
		public function VScrollBarTrackSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.currentState = "up";
			this.minHeight = 15;
			this.minWidth = 15;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.graphics.clear();
			//绘制边框
			this.drawRoundRect(0, 0, w, h, 0, _borderColors[0], 1, horizontalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:1, y:1, w:w - 2, h:h - 2, r:0}); 
			//绘制填充
			this.drawRoundRect(1, 1, w - 2, h - 2, 0, 0xdddbdb, 1, horizontalGradientMatrix(1, 2, w - 2, h - 3));
			//绘制底线
			this.drawLine(1, 1, 1, h - 1, 0xbcbcbc);
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
