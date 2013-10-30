/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.Graphics;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ComboBoxButtonSkin</code> 类定义了下拉框按钮控件的皮肤.
	 * @author wizardc
	 */
	public class ComboBoxButtonSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>ComboBoxButtonSkin</code> 对象.
		 */
		public function ComboBoxButtonSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.minHeight = 23;
			this.minWidth = 20;
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
			var radius:Object = {tl:0, tr:_cornerRadius, bl:0, br:_cornerRadius};
			switch(this.currentState)
			{
				case "up":
				case "disabled":
					this.drawCurrentState(0, 0, w, h, _borderColors[0], _bottomLineColors[0], [_fillColors[0], _fillColors[1]], radius);
					arrowColor = _themeColors[0];
					break;
				case "over":
					this.drawCurrentState(0, 0, w, h, _borderColors[1], _bottomLineColors[1], [_fillColors[2], _fillColors[3]], radius);
					arrowColor = _themeColors[1];
					break;
				case "down":
					this.drawCurrentState(0, 0, w, h, _borderColors[2], _bottomLineColors[2], [_fillColors[4], _fillColors[5]], radius);
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
