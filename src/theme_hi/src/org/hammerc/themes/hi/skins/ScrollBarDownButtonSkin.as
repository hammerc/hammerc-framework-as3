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
	import flash.display.Graphics;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ScrollBarDownButtonSkin</code> 类为滚动条向下滚动按钮的皮肤.
	 * @author wizardc
	 */
	public class ScrollBarDownButtonSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>ScrollBarDownButtonSkin</code> 对象.
		 */
		public function ScrollBarDownButtonSkin()
		{
			super();
			this.states = ["up","over","down","disabled"];
			this.currentState = "up";
			this.minHeight = 17;
			this.minWidth = 15;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var g:Graphics = this.graphics;
			g.clear();
			var arrowColor:uint;
			var radius:Object = 0;
			switch(this.currentState)
			{
				case "up":
				case "disabled":
					this.drawRoundRect(0, 0, w, h, 0, _borderColors[0], 1, this.horizontalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:1, y:1, w:w - 2, h:h - 2, r:0});
					this.drawRoundRect(1, 1, w - 2, h - 2, 0, [_fillColors[0], _fillColors[1]], 1, this.horizontalGradientMatrix(1, 1, w - 2, h - 2), GradientType.LINEAR);
					this.drawLine(w - 1, 0, w - 1, h, _bottomLineColors[0]);
					arrowColor = _themeColors[0];
					break;
				case "over":
					this.drawRoundRect(0, 0, w, h, 0, _borderColors[1], 1, this.horizontalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:1, y:1, w:w - 2, h:h - 2, r:0});
					this.drawRoundRect(1, 1, w - 2, h - 2, 0, [_fillColors[2],_fillColors[3]], 1, this.horizontalGradientMatrix(1, 1, w - 2, h - 2),GradientType.LINEAR);
					this.drawLine(w - 1, 0, w - 1, h, _bottomLineColors[1]);
					arrowColor = _themeColors[1];
					break;
				case "down":
					this.drawRoundRect(0, 0, w, h, 0, _borderColors[2], 1, this.horizontalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:1, y:1, w:w - 2, h:h - 2, r:0});
					this.drawRoundRect(1, 1, w - 2, h - 2, 0, [_fillColors[4],_fillColors[5]], 1, this.horizontalGradientMatrix(1, 1, w - 2, h - 2), GradientType.LINEAR);
					this.drawLine(w - 1, 0, w - 1, h, _bottomLineColors[2]);
					arrowColor = _themeColors[1];
					break;
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
			g.lineStyle(0, 0, 0);
			g.beginFill(arrowColor);
			g.moveTo(w * 0.5, h * 0.5 + 3);
			g.lineTo(w * 0.5 - 3.5, h * 0.5 - 2);
			g.lineTo(w * 0.5 + 3.5, h * 0.5 - 2);
			g.lineTo(w * 0.5, h * 0.5 + 3);
			g.endFill();
		}
	}
}
