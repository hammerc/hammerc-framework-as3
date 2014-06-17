/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.display.DisplayObject;
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.skins.supportClasses.ButtonBaseSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ToggleButtonSkin</code> 类定义了切换按钮控件的皮肤.
	 * @author wizardc
	 */
	public class ToggleButtonSkin extends ButtonBaseSkin
	{
		/**
		 * 创建一个 <code>ToggleButtonSkin</code> 对象.
		 */
		public function ToggleButtonSkin()
		{
			super();
			this.states = this.states.concat(["upAndSelected", "overAndSelected", "downAndSelected", "disabledAndSelected"]);
			this.styleProperties = this.styleProperties.concat(["overFontColor", "downFontColor", "disabledFontColor", "textAlign", "upAndSelectedFontColor", "overAndSelectedFontColor", "downAndSelectedFontColor", "disabledAndSelectedFontColor", "upAndSelectedSkin", "overAndSelectedSkin", "downAndSelectedSkin", "disabledAndSelectedSkin"]);
			this.minWidth = 10;
			this.minHeight = 10;
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
			labelDisplay.left = 7;
			labelDisplay.right = 7;
			labelDisplay.top = 4;
			labelDisplay.bottom = 4;
			this.addElement(labelDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			var textColor:uint = this.hostComponent.getStyle("fontColor");
			if(this.currentState != "up" && this.hostComponent.getStyle(this.currentState + "FontColor") != null)
			{
				textColor = this.hostComponent.getStyle(this.currentState + "FontColor");
			}
			if(labelDisplay != null)
			{
				labelDisplay.textColor = textColor;
				labelDisplay.applyTextFormatNow();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentStyle(styleProperty:String, hasSet:Boolean, value:* = null):void
		{
			super.commitCurrentStyle(styleProperty, hasSet, value);
			switch(styleProperty)
			{
				case "upAndSelectedSkin":
				case "overAndSelectedSkin":
				case "downAndSelectedSkin":
				case "disabledAndSelectedSkin":
					var key:String = styleProperty.replace("Skin", "");
					_skinMap[key] = this.getSkinObject(value);
					if(_skinMap[key] != null)
					{
						DisplayObject(_skinMap[key]).scale9Grid = _scale9Grid;
					}
					break;
				case "fontFamily":
					labelDisplay.fontFamily = value;
					labelDisplay.applyTextFormatNow();
					break;
				case "fontSize":
					labelDisplay.size = value;
					labelDisplay.applyTextFormatNow();
					break;
				case "fontItalic":
					labelDisplay.italic = value;
					labelDisplay.applyTextFormatNow();
					break;
				case "fontBold":
					labelDisplay.bold = value;
					labelDisplay.applyTextFormatNow();
					break;
				case "useTextFilter":
					_useTextFilter = value;
					this.textFilterColorChanged();
					break;
				case "textFilterColor":
					_textFilterColor = value;
					this.textFilterColorChanged();
					break;
				case "textAlign":
					labelDisplay.textAlign = value;
					break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function textFilterColorChanged():void
		{
			if(_useTextFilter)
			{
				WingEffectUtil.setTextGlow(labelDisplay, _textFilterColor);
			}
			else
			{
				WingEffectUtil.clearTextGlow(labelDisplay);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			if(_currentSkin != null)
			{
				_currentSkin.width = w;
				_currentSkin.height = h;
				this.drawScaleBitmap(_currentSkin);
			}
		}
	}
}
