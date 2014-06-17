/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Button;
	import org.hammerc.components.Group;
	import org.hammerc.components.Label;
	import org.hammerc.layouts.HorizontalAlign;
	import org.hammerc.layouts.HorizontalLayout;
	import org.hammerc.layouts.VerticalAlign;
	
	/**
	 * <code>AlertSkin</code> 类为弹出对话框的皮肤类.
	 * @author wizardc
	 */
	public class AlertSkin extends TitleWindowSkin
	{
		/**
		 * 皮肤子件, 文本内容显示对象.
		 */
		public var contentDisplay:Label;
		
		/**
		 * 皮肤子件, 是按钮.
		 */
		public var yesButton:Button;
		
		/**
		 * 皮肤子件, 否按钮.
		 */
		public var noButton:Button;
		
		/**
		 * 皮肤子件, 确定按钮.
		 */
		public var okButton:Button;
		
		/**
		 * 皮肤子件, 取消按钮.
		 */
		public var cancelButton:Button;
		
		/**
		 * 创建一个 <code>AlertSkin</code> 对象.
		 */
		public function AlertSkin()
		{
			super();
			this.minHeight = 100;
			this.minWidth = 170;
			this.maxWidth = 310;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			contentDisplay = new Label;
			contentDisplay.top = 30;
			contentDisplay.left = 1;
			contentDisplay.right = 1;
			contentDisplay.bottom = 36;
			contentDisplay.verticalAlign = VerticalAlign.MIDDLE;
			contentDisplay.textAlign = TextFormatAlign.CENTER;
			contentDisplay.padding = 10;
			contentDisplay.selectable = true;
			this.addElement(contentDisplay);
			var hGroup:Group = new Group;
			hGroup.bottom = 10;
			hGroup.horizontalCenter = 0;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.gap = 10;
			layout.paddingLeft = layout.paddingRight = 20;
			hGroup.layout = layout;
			this.addElement(hGroup);
			yesButton = new Button();
			yesButton.minWidth = 60;
			hGroup.addElement(yesButton);
			noButton = new Button();
			noButton.minWidth = 60;
			hGroup.addElement(noButton);
			okButton = new Button();
			okButton.minWidth = 60;
			hGroup.addElement(okButton);
			cancelButton = new Button();
			cancelButton.minWidth = 60;
			hGroup.addElement(cancelButton);
		}
	}
}
