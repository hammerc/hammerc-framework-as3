/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.display.DisplayObject;
	
	import org.hammerc.components.EditableText;
	import org.hammerc.components.Label;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>TextInputSkin</code> 类定义了可设置外观的单行文本输入控件的皮肤.
	 * @author wizardc
	 */
	public class TextInputSkin extends WingSkin
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
		 * 皮肤显示对象表.
		 */
		protected var _skinMap:Object;
		
		/**
		 * 当前的皮肤显示对象.
		 */
		protected var _currentSkin:DisplayObject;
		
		/**
		 * 创建一个 <code>TextInputSkin</code> 对象.
		 */
		public function TextInputSkin()
		{
			super();
			_skinMap = new Object();
			this.states = ["normal", "disabled", "normalWithPrompt", "disabledWithPrompt"];
			this.styleProperties = this.styleProperties.concat(["normalSkin", "disabledSkin", "normalWithPromptSkin", "disabledWithPromptSkin", "disabledFontColor", "normalWithPromptFontColor", "disabledWithPromptFontColor", "paddingTop", "paddingBottom", "paddingLeft", "paddingRight", "textAlign"]);
			this.minWidth = 10;
			this.minHeight = 10;
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
			this.addElement(textDisplay);
			promptDisplay = new Label();
			promptDisplay.maxDisplayedLines = 1;
			promptDisplay.mouseChildren = false;
			promptDisplay.mouseEnabled = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			if(this.currentState == "disabledWithPrompt" || this.currentState == "normalWithPrompt")
			{
				if(!this.contains(promptDisplay))
				{
					this.addElement(promptDisplay);
				}
			}
			else if(promptDisplay != null && this.contains(promptDisplay))
			{
				this.removeElement(promptDisplay);
			}
			if(_currentSkin != null && _currentSkin.parent == _container)
			{
				_container.removeChild(_currentSkin);
			}
			_currentSkin = _skinMap[this.currentState];
			if(_currentSkin == null)
			{
				_currentSkin = _skinMap["normal"];
			}
			if(_currentSkin != null)
			{
				_container.addChild(_currentSkin);
			}
			var textColor:uint = this.hostComponent.getStyle("fontColor");
			if(this.currentState != "up" && this.hostComponent.getStyle(this.currentState + "FontColor") != null)
			{
				textColor = this.hostComponent.getStyle(this.currentState + "FontColor");
			}
			if(textDisplay != null)
			{
				if(this.currentState == "disabledWithPrompt" || this.currentState == "normalWithPrompt")
				{
					promptDisplay.textColor = textColor;
				}
				else
				{
					textDisplay.textColor = textColor;
				}
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
				case "normalSkin":
				case "disabledSkin":
				case "normalWithPromptSkin":
				case "disabledWithPromptSkin":
					var key:String = styleProperty.replace("Skin", "");
					_skinMap[key] = this.getSkinObject(value);
					if(_skinMap[key] != null)
					{
						DisplayObject(_skinMap[key]).scale9Grid = _scale9Grid;
					}
					break;
				case "paddingTop":
					textDisplay.top = value;
					promptDisplay.top = value;
					break;
				case "paddingBottom":
					textDisplay.bottom = value;
					promptDisplay.bottom = value;
					break;
				case "paddingLeft":
					textDisplay.left = value;
					promptDisplay.left = value;
					break;
				case "paddingRight":
					textDisplay.right = value;
					promptDisplay.right = value;
					break;
				case "textAlign":
					textDisplay.textAlign = value;
					promptDisplay.textAlign = value;
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
				WingEffectUtil.setTextGlow(textDisplay, _textFilterColor);
			}
			else
			{
				WingEffectUtil.clearTextGlow(textDisplay);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function scale9GridChanged():void
		{
			for(var i:int = 0; i < this.states.length; i++)
			{
				if(_skinMap.hasOwnProperty(this.states[i]))
				{
					DisplayObject(_skinMap[this.states[i]]).scale9Grid = _scale9Grid;
				}
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
