/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.GradientType;
	
	import org.hammerc.components.EditableText;
	import org.hammerc.components.Label;
	import org.hammerc.components.Scroller;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TextAreaSkin</code> 类定义了可设置外观的多行文本输入控件的皮肤.
	 * @author wizardc
	 */
	public class TextAreaSkin extends HiSkin
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
		 * 皮肤子件, 实体滚动条组件.
		 */
		public var scroller:Scroller;
		
		/**
		 * 创建一个 <code>TextAreaSkin</code> 对象.
		 */
		public function TextAreaSkin()
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
			textDisplay.widthInChars = 15;
			textDisplay.heightInLines = 10;
			scroller = new Scroller();
			scroller.left = 0;
			scroller.top = 0;
			scroller.right = 0;
			scroller.bottom = 0;
			scroller.minViewportInset = 1;
			scroller.measuredSizeIncludesScrollBars = false;
			scroller.viewport = textDisplay;
			this.addElement(scroller);
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
			promptDisplay.x = 1;
			promptDisplay.y = 1;
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
			graphics.clear();
			//绘制边框
			drawRoundRect(0, 0, w, h, 0, _borderColors[0], 1, verticalGradientMatrix(0, 0, w, h), GradientType.LINEAR, null, {x:1, y:2, w:w - 2, h:h - 3, r:0}); 
			//绘制填充
			drawRoundRect(1, 2, w - 2, h - 3, 0, 0xFFFFFF, 1, verticalGradientMatrix(1, 2, w - 2, h - 3)); 
			//绘制底线
			drawLine(1, 0, w, 0, _bottomLineColors[0]);
		}
	}
}
