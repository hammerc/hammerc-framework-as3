/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.GradientType;
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Button;
	import org.hammerc.components.EditableText;
	import org.hammerc.components.Group;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.HorizontalLayout;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>NumericStepperSkin</code> 类定义了选择获取编辑值组件的皮肤.
	 * @author wizardc
	 */
	public class NumericStepperSkin extends HiSkin
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
		
		/**
		 * 创建一个 <code>NumericStepperSkin</code> 对象.
		 */
		public function NumericStepperSkin()
		{
			super();
			this.minHeight = 22;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 0;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			var group:Group = new Group();
			group.layout = layout;
			group.percentWidth = 100;
			group.percentHeight = 100;
			this.addElement(group);
			decrementButton = new Button();
			decrementButton.skinName = ScrollBarLeftButtonSkin;
			decrementButton.width = 15;
			decrementButton.percentHeight = 100;
			group.addElement(decrementButton);
			textDisplay = new EditableText();
			textDisplay.minWidth = 50;
			textDisplay.percentWidth = 100;
			textDisplay.height = 16;
			textDisplay.textAlign = TextFormatAlign.CENTER;
			group.addElement(textDisplay);
			incrementButton = new Button();
			incrementButton.skinName = ScrollBarRightButtonSkin;
			incrementButton.width = 15;
			incrementButton.percentHeight = 100;
			group.addElement(incrementButton);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.graphics.clear();
			//绘制边框
			this.drawRoundRect(0, 0, w, h, 0, _borderColors[0], 1, this.verticalGradientMatrix(0, 0, w, h ), GradientType.LINEAR, null, {x:1, y:2, w:w - 2, h:h - 3, r:0}); 
			//绘制填充
			this.drawRoundRect(1, 2, w - 2, h - 3, 0, 0xFFFFFF, 1, this.verticalGradientMatrix(1, 2, w - 2, h - 3)); 
			//绘制底线
			this.drawLine(1, 0, w, 0, _bottomLineColors[0]);
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
