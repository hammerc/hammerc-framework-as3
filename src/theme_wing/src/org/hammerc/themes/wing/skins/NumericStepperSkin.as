// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.themes.wing.skins
{
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Button;
	import org.hammerc.components.EditableText;
	import org.hammerc.components.Group;
	import org.hammerc.components.UIAsset;
	import org.hammerc.layouts.HorizontalLayout;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>NumericStepperSkin</code> 类定义了选择获取编辑值组件的皮肤.
	 * @author wizardc
	 */
	public class NumericStepperSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 减小按钮.
		 */
		public var decrementButton:Button;
		
		/**
		 * 皮肤子件, 增大按钮.
		 */
		public var incrementButton:Button;
		
		/**
		 * 皮肤子件, 编辑文本.
		 */
		public var textDisplay:EditableText;
		
		private var _textBG:UIAsset;
		
		/**
		 * 创建一个 <code>NumericStepperSkin</code> 对象.
		 */
		public function NumericStepperSkin()
		{
			super();
			this.minWidth = 10;
			this.minHeight = 10;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			_textBG = new UIAsset();
			_textBG.percentWidth = 100;
			_textBG.percentHeight = 100;
			_textBG.skinName = this.getScaleBitmap(TextArea_normalSkin_c, 5, 5, 132, 11);
			this.addElement(_textBG);
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 0;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			var group:Group = new Group();
			group.layout = layout;
			group.top = 0;
			group.bottom = 0;
			group.left = 2;
			group.right = 2;
			this.addElement(group);
			decrementButton = new Button();
			decrementButton.width = 16;
			decrementButton.height = 16;
			decrementButton.createLabelIfNeed = false;
			decrementButton.skinName = NoLabelButtonSkin;
			decrementButton.setStyle("upSkin", ScrollBar_arrowLeft_upSkin_c);
			decrementButton.setStyle("overSkin", ScrollBar_arrowLeft_overSkin_c);
			decrementButton.setStyle("downSkin", ScrollBar_arrowLeft_downSkin_c);
			decrementButton.setStyle("disabledSkin", ScrollBar_arrowLeft_disabledSkin_c);
			decrementButton.setStyle("useTextFilter", false);
			decrementButton.setStyle("scale9Grid", new Rectangle(3, 3, 10, 9));
			group.addElement(decrementButton);
			textDisplay = new EditableText();
			textDisplay.minWidth = 50;
			textDisplay.percentWidth = 100;
			textDisplay.height = 16;
			textDisplay.textAlign = TextFormatAlign.CENTER;
			group.addElement(textDisplay);
			incrementButton = new Button();
			incrementButton.width = 16;
			incrementButton.height = 16;
			incrementButton.createLabelIfNeed = false;
			incrementButton.skinName = NoLabelButtonSkin;
			incrementButton.setStyle("upSkin", ScrollBar_arrowRight_upSkin_c);
			incrementButton.setStyle("overSkin", ScrollBar_arrowRight_overSkin_c);
			incrementButton.setStyle("downSkin", ScrollBar_arrowRight_downSkin_c);
			incrementButton.setStyle("disabledSkin", ScrollBar_arrowRight_disabledSkin_c);
			incrementButton.setStyle("useTextFilter", false);
			incrementButton.setStyle("scale9Grid", new Rectangle(3, 3, 10, 9));
			group.addElement(incrementButton);
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
			this.drawScaleBitmap(_textBG.skin);
		}
	}
}
