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
	import flash.display.DisplayObject;
	import flash.text.TextFormatAlign;
	
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.skins.supportClasses.ButtonBaseSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>CheckBoxSkin</code> 类定义了复选框控件的皮肤.
	 * @author wizardc
	 */
	public class CheckBoxSkin extends ButtonBaseSkin
	{
		/**
		 * 创建一个 <code>CheckBoxSkin</code> 对象.
		 */
		public function CheckBoxSkin()
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
			labelDisplay.left = 0;
			labelDisplay.right = 0;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			labelDisplay.verticalCenter = 0;
			this.addElement(labelDisplay);
			_container.verticalCenter = 1;
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
			if(styleProperty == "upSkin" && _skinMap["up"] != null)
			{
				var skin:DisplayObject = _skinMap["up"] as DisplayObject;
				labelDisplay.left = skin.width;
				_container.width = skin.width;
				_container.height = skin.height;
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
				this.drawScaleBitmap(_currentSkin);
			}
		}
	}
}
