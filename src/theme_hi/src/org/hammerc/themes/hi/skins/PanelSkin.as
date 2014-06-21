/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Group;
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>PanelSkin</code> 类定义了带有标题和内容区域的面板控件的皮肤.
	 * @author wizardc
	 */
	public class PanelSkin extends HiSkin
	{
		/**
		 * 皮肤子件, 内容容器.
		 */
		public var contentGroup:Group;
		
		/**
		 * 皮肤子件, 标题显示对象.
		 */
		public var titleDisplay:Label;
		
		/**
		 * 创建一个 <code>PanelSkin</code> 对象.
		 */
		public function PanelSkin()
		{
			super();
			this.minHeight = 60;
			this.minWidth = 80;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			contentGroup = new Group();
			contentGroup.top = 30;
			contentGroup.left = 1;
			contentGroup.right = 1;
			contentGroup.bottom = 1;
			contentGroup.clipAndEnableScrolling = true;
			this.addElement(contentGroup);
			titleDisplay = new Label();
			titleDisplay.maxDisplayedLines = 1;
			titleDisplay.left = 5;
			titleDisplay.right = 5;
			titleDisplay.top = 1;
			titleDisplay.minHeight = 28;
			titleDisplay.verticalAlign = VerticalAlign.MIDDLE;
			titleDisplay.textAlign = TextFormatAlign.CENTER;
			this.addElement(titleDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.graphics.clear();
			var g:Graphics = this.graphics;
			g.lineStyle(1, _borderColors[0]);
			g.beginFill(_themeColors[1]);
			g.drawRoundRect(0, 0, w, h, _cornerRadius + 2, _cornerRadius + 2);
			g.endFill();
			g.lineStyle();
			this.drawRoundRect(1, 1, w - 1, 28, {tl:_cornerRadius - 1, tr:_cornerRadius - 1, bl:0, br:0}, [_otherColors[4], _otherColors[5]], 1, this.verticalGradientMatrix(1, 1, w - 1, 28)); 
			this.drawLine(1, 29, w, 29, _otherColors[6]);
			this.drawLine(1, 30, w, 30, _otherColors[7]);
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
