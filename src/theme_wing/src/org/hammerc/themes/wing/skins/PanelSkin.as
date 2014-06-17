/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Group;
	import org.hammerc.components.Label;
	import org.hammerc.components.UIAsset;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>PanelSkin</code> 类定义了带有标题和内容区域的面板控件的皮肤.
	 * @author wizardc
	 */
	public class PanelSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 内容容器.
		 */
		public var contentGroup:Group;
		
		/**
		 * 皮肤子件, 标题显示对象.
		 */
		public var titleDisplay:Label;
		
		private var _background:UIAsset;
		
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
			_background = new UIAsset();
			_background.width = 10;
			_background.height = 10;
			_background.skinName = this.getScaleBitmap(Frame_BG_c, 30, 28, 307, 190);
			this.addElement(_background);
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
			if(this.currentState == "disabled")
			{
				WingEffectUtil.setGray(this);
			}
			else
			{
				WingEffectUtil.clearGray(this);
			}
			_background.skin.width = w;
			_background.skin.height = h;
			this.drawScaleBitmap(_background.skin);
		}
	}
}
