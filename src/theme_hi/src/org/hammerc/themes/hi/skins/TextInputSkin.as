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
	import flash.display.GradientType;
	
	import org.hammerc.components.EditableText;
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TextInputSkin</code> 类定义了可设置外观的单行文本输入控件的皮肤.
	 * @author wizardc
	 */
	public class TextInputSkin extends HiSkin
	{
		/**
		 * 皮肤子件, 实体文本输入组件.
		 */
		public var textDisplay:EditableText;
		
		/**
		 * 皮肤子件, 当 <code>text</code> 属性为空字符串时要显示的文本.
		 */
		public var promptDisplay:Label;
		
		/**
		 * 创建一个 <code>TextInputSkin</code> 对象.
		 */
		public function TextInputSkin()
		{
			super();
			this.minHeight = 22;
			this.states = ["normal", "disabled", "normalWithPrompt", "disabledWithPrompt"];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			textDisplay = new EditableText();
			textDisplay.widthInChars = 10;
			textDisplay.multiline = false;
			textDisplay.left = 1;
			textDisplay.right = 1;
			textDisplay.verticalCenter = 0;
			this.addElement(textDisplay);
		}
		
		override protected function commitCurrentState():void
		{
			this.alpha = this.currentState == "disabled" || this.currentState == "disabledWithPrompt" ? 0.5 : 1;
			if(this.currentState == "disabledWithPrompt" || this.currentState == "normalWithPrompt")
			{
				if(promptDisplay == null)
				{
					createPromptDisplay();
				}
				if(!this.contains(promptDisplay))
				{
					this.addElement(promptDisplay);
				}
			}
			else if(promptDisplay != null && this.contains(promptDisplay))
			{
				this.removeElement(promptDisplay);
			}
		}
		
		private function createPromptDisplay():void
		{
			promptDisplay = new Label();
			promptDisplay.maxDisplayedLines = 1;
			promptDisplay.verticalCenter = 0;
			promptDisplay.x = 1;
			promptDisplay.textColor = 0xa9a9a9;
			promptDisplay.mouseChildren = false;
			promptDisplay.mouseEnabled = false;
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
			this.drawRoundRect(1, 2, w - 2, h - 3, 0, _themeColors[1], 1, this.verticalGradientMatrix(1, 2, w - 2, h - 3)); 
			//绘制底线
			this.drawLine(1, 0, w, 0, _bottomLineColors[0]);
		}
	}
}
