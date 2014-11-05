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
	import org.hammerc.components.EditableText;
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ComboBoxTextInputSkin</code> 类定义了下拉框输入文本控件的皮肤.
	 * @author wizardc
	 */
	public class ComboBoxTextInputSkin extends HiSkin
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
		 * 创建一个 <code>ComboBoxTextInputSkin</code> 对象.
		 */
		public function ComboBoxTextInputSkin()
		{
			super();
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
			textDisplay.heightInLines = 1;
			textDisplay.multiline = false;
			textDisplay.left = 1;
			textDisplay.right = 1;
			textDisplay.verticalCenter = 0;
			this.addElement(textDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
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
			else if(promptDisplay && this.contains(promptDisplay))
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
			var radius:Object = {tl:_cornerRadius, tr:0, bl:_cornerRadius, br:0};
			this.drawCurrentState(0, 0, w, h, _borderColors[0], _bottomLineColors[0], 0xFFFFFF, radius);
		}
	}
}
