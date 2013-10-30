/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.GradientType;
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TabBarButtonSkin</code> 类定义了选项卡组件的按钮条目控件的皮肤.
	 * @author wizardc
	 */
	public class TabBarButtonSkin extends HiSkin
	{
		/**
		 * 皮肤子件, 按钮上的文本标签.
		 */
		public var labelDisplay:Label;
		
		/**
		 * 创建一个 <code>TabBarButtonSkin</code> 对象.
		 */
		public function TabBarButtonSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled", "upAndSelected", "overAndSelected" , "downAndSelected", "disabledAndSelected"];
			this.currentState = "up";
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.textAlign = TextFormatAlign.CENTER;
			labelDisplay.verticalAlign = VerticalAlign.MIDDLE;
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.left = 5;
			labelDisplay.right = 5;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			this.addElement(labelDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.graphics.clear();
			var textColor:uint;
			var radius:Object = {tl:_cornerRadius, tr:_cornerRadius, bl:0, br:0};
			var crr1:Object = {tl:_cornerRadius-1, tr:_cornerRadius-1, bl:0, br:0};
			switch (currentState)
			{
				case "up":
				case "disabled":
					this.drawCurrentState(0, 0, w, h, _borderColors[0], _bottomLineColors[0], [_fillColors[0], _fillColors[1]], radius);
					textColor = _themeColors[0];
					break;
				case "over":
					this.drawCurrentState(0, 0, w, h, _borderColors[0], _bottomLineColors[0], [_fillColors[2], _fillColors[3]], radius);
					textColor = _themeColors[1];
					break;
				case "down":
				case "overAndSelected":
				case "upAndSelected":
				case "downAndSelected":
				case "disabledAndSelected":
					this.drawRoundRect(x, y, w, h, radius, _borderColors[0], 1, this.verticalGradientMatrix(x, y, w, h), GradientType.LINEAR, null, {x:x + 1, y:y + 1, w:w - 2, h:h - 1, r:crr1}); 
					this.drawRoundRect(x + 1, y + 1, w - 2, h - 1, crr1, 0xFFFFFF, 1, this.verticalGradientMatrix(x + 1, y + 1, w - 2, h - 1)); 
					textColor = _themeColors[0];
					break;
			}
			if(labelDisplay != null)
			{
				labelDisplay.textColor = textColor;
				labelDisplay.applyTextFormatNow();
				labelDisplay.filters = this.currentState == "over" ? _textOverFilter : null;
			}
			this.alpha = this.currentState == "disabled" || this.currentState == "disabledAndSelected" ? 0.5 : 1;
		}
	}
}
