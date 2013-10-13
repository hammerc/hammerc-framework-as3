/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>CheckBoxSkin</code> 类定义了复选框控件的皮肤.
	 * @author wizardc
	 */
	public class CheckBoxSkin extends HiSkin
	{
		/**
		 * 皮肤子件, 按钮上的文本标签.
		 */
		public var labelDisplay:Label;
		
		/**
		 * 创建一个 <code>CheckBoxSkin</code> 对象.
		 */
		public function CheckBoxSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled", "upAndSelected", "overAndSelected", "downAndSelected", "disabledAndSelected"];
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
			labelDisplay.left = 16;
			labelDisplay.right = 0;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			labelDisplay.verticalCenter = 0;
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
			g.beginFill(0xFFFFFF, 0);
			g.drawRect(0, 0, w, h);
			g.endFill();
			var startY:Number = Math.round((h - 14) * 0.5);
			if(startY < 0)
			{
				startY = 0;
			}
			w = 14;
			h = 14;
			var selected:Boolean = false;
			var selectedColor:uint = 0xFFFFFF;
			switch(this.currentState)
			{
				case "up":
				case "upAndSelected":
				case "disabled":
					this.drawCurrentState(0, startY, w, h, _borderColors[0], _bottomLineColors[0], [_fillColors[0], _fillColors[1]]);
					selectedColor = _fillColors[4];
					selected = (this.currentState == "upAndSelected");
					break;
				case "over":
				case "overAndSelected":
					this.drawCurrentState(0, startY, w, h, _borderColors[1], _bottomLineColors[1], [_fillColors[2], _fillColors[3]]);
					selected = (this.currentState != "over");
					break;
				case "down":
				case "downAndSelected":
				case "disabledAndSelected":
					this.drawCurrentState(0, startY, w, h, _borderColors[2], _bottomLineColors[2], [_fillColors[4], _fillColors[5]]);
					selected = (this.currentState != "down");
					break;
			}
			if(selected)
			{
				g.lineStyle(0, 0, 0);
				g.beginFill(selectedColor);
				g.moveTo(3, startY+5);
				g.lineTo(5, startY+10);
				g.lineTo(7, startY+10);
				g.lineTo(12, startY+2);
				g.lineTo(13, startY+1);
				g.lineTo(11, startY+1);
				g.lineTo(6.5, startY+7);
				g.lineTo(5, startY+5);
				g.lineTo(3, startY+5);
				g.endFill();
			}
			this.alpha = this.currentState == "disabled" || this.currentState == "disabledAndSelected" ? 0.5 : 1;
		}
	}
}
