/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ButtonSkin</code> 类定义了按钮控件的皮肤.
	 * @author wizardc
	 */
	public class ButtonSkin extends HiSkin
	{
		/**
		 * 皮肤子件, 按钮上的文本标签.
		 */
		public var labelDisplay:Label;
		
		/**
		 * 创建一个 <code>ButtonSkin</code> 对象.
		 */
		public function ButtonSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.minHeight = 21;
			this.minWidth = 21;
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
			switch(currentState)
			{
				case "up":
				case "disabled":
					this.drawCurrentState(0, 0, w, h, _borderColors[0], _bottomLineColors[0], [_fillColors[0], _fillColors[1]], _cornerRadius);
					textColor = _themeColors[0];
					break;
				case "over":
					this.drawCurrentState(0, 0, w, h, _borderColors[1], _bottomLineColors[1], [_fillColors[2], _fillColors[3]], _cornerRadius);
					textColor = _themeColors[1];
					break;
				case "down":
					this.drawCurrentState(0, 0, w, h, _borderColors[2], _bottomLineColors[2], [_fillColors[4], _fillColors[5]], _cornerRadius);
					textColor = _themeColors[1];
					break;
			}
			if(labelDisplay != null)
			{
				labelDisplay.textColor = textColor;
				labelDisplay.applyTextFormatNow();
				labelDisplay.filters = (currentState == "over" || currentState == "down") ? _textOverFilter : null;
			}
			this.alpha = currentState == "disabled" ? 0.5 : 1;
		}
	}
}
