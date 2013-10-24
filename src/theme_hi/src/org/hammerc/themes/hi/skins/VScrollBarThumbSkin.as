/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.GradientType;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>VScrollBarThumbSkin</code> 类为垂直滚动条滑块的皮肤.
	 * @author wizardc
	 */
	public class VScrollBarThumbSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>VScrollBarThumbSkin</code> 对象.
		 */
		public function VScrollBarThumbSkin()
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
			switch(this.currentState)
			{
				case "up":
				case "disabled":
					this.drawRoundRect(0, 0, w, h, 0, _borderColors[0], 1, this.horizontalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:1, y:1, w:w - 2, h:h - 2, r:0}); 
					this.drawRoundRect(1, 1, w - 2, h - 2, 0, [_fillColors[0], _fillColors[1]], 1, this.horizontalGradientMatrix(1, 1, w - 2, h - 2), GradientType.LINEAR); 
					this.drawLine(w-1, 0, w-1, h, _bottomLineColors[0]);
					break;
				case "over":
					this.drawRoundRect(0, 0, w, h, 0, _borderColors[1], 1, this.horizontalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:1, y:1, w:w - 2, h:h - 2, r:0}); 
					this.drawRoundRect(1, 1, w - 2, h - 2, 0, [_fillColors[2], _fillColors[3]], 1, this.horizontalGradientMatrix(1, 1, w - 2, h - 2), GradientType.LINEAR); 
					this.drawLine(w-1, 0, w-1, h, _bottomLineColors[1]);
					break;
				case "down":
					this.drawRoundRect(0, 0, w, h, 0, _borderColors[2], 1, this.horizontalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:1, y:1, w:w - 2, h:h - 2, r:0}); 
					this.drawRoundRect(1, 1, w - 2, h - 2, 0, [_fillColors[4], _fillColors[5]], 1, this.horizontalGradientMatrix(1, 1, w - 2, h - 2), GradientType.LINEAR); 
					this.drawLine(w - 1, 0, w - 1, h, _bottomLineColors[2]);
					break;
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
