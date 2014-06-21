/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ItemRendererSkin</code> 类定义了简单的项呈示器控件的皮肤.
	 * @author wizardc
	 */
	public class ItemRendererSkin extends HiSkin
	{
		/**
		 * 皮肤子件, 按钮上的文本标签.
		 */
		public var labelDisplay:Label;
		
		/**
		 * 创建一个 <code>ItemRendererSkin</code> 对象.
		 */
		public function ItemRendererSkin()
		{
			super();
			this.states = ["up", "over", "down"];
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
			var g:Graphics = this.graphics;
			g.clear();
			var textColor:uint;
			switch(this.currentState)
			{			
				case "up":
				case "disabled":
					this.drawRoundRect(0, 0, w, h, 0, _themeColors[1], 1, this.verticalGradientMatrix(0, 0, w, h)); 
					textColor = _themeColors[0];
					break;
				case "over":
				case "down":
					this.drawRoundRect(0, 0, w, h, 0, _borderColors[0], 1, this.verticalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:0, y:0, w:w, h:h - 1, r:0});
					this.drawRoundRect(0, 0, w, h - 1, 0, _fillColors[3], 1, this.verticalGradientMatrix(0, 0, w, h - 1)); 
					textColor = _themeColors[1];
					break;
			}
			if(labelDisplay != null)
			{
				labelDisplay.textColor = textColor;
				labelDisplay.applyTextFormatNow();
				labelDisplay.filters = (this.currentState == "over" || this.currentState == "down") ? _textOverFilter : null;
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
