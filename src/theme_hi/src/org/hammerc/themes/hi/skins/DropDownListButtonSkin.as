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
	import flash.display.Graphics;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>DropDownListButtonSkin</code> 类定义了下拉框按钮控件的皮肤.
	 * @author wizardc
	 */
	public class DropDownListButtonSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>DropDownListButtonSkin</code> 对象.
		 */
		public function DropDownListButtonSkin()
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
			switch(this.currentState)
			{
				case "up":
				case "disabled":
					this.drawCurrentState(0, 0, w, h, _borderColors[0], _bottomLineColors[0], [_fillColors[0], _fillColors[1]], _cornerRadius);
					if(w > 21 && h > 2)
					{
						this.drawLine(w - 21, 1, w - 21, h - 1, _otherColors[0]);
						this.drawLine(w - 20, 1, w - 20, h - 1, _otherColors[1]);
					}
					arrowColor = _themeColors[0];
					break;
				case "over":
					this.drawCurrentState(0, 0, w, h, _borderColors[1], _bottomLineColors[1], [_fillColors[2], _fillColors[3]], _cornerRadius);
					if(w > 21 && h > 2)
					{
						this.drawLine(w - 21, 1, w - 21, h - 1, _fillColors[2]);
						this.drawLine(w - 20, 1, w - 20, h - 1, _fillColors[3]);
					}
					arrowColor = _themeColors[1];
					break;
				case "down":
					this.drawCurrentState(0, 0, w, h, _borderColors[2], _bottomLineColors[2], [_fillColors[4], _fillColors[5]], _cornerRadius);
					if(w > 21 && h > 2)
					{
						this.drawLine(w - 21, 1, w - 21, h - 1, _otherColors[2]);
						this.drawLine(w - 20, 1, w - 20, h - 1, _otherColors[3]);
					}
					arrowColor = _themeColors[1];
					break;
			}
			if(w > 21)
			{
				g.lineStyle(0, 0, 0);
				g.beginFill(arrowColor);
				g.moveTo(w - 10, h * 0.5 + 3);
				g.lineTo(w - 13.5, h * 0.5 - 2);
				g.lineTo(w - 6.5, h * 0.5 - 2);
				g.lineTo(w - 10, h * 0.5 + 3);
				g.endFill();
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
