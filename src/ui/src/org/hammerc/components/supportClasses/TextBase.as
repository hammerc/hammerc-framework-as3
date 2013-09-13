/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IText;
	import org.hammerc.core.UIComponent;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TextBase</code> 类为文本基类.
	 * @author wizardc
	 */
	public class TextBase extends UIComponent implements IText
	{
		/**
		 * 默认的文本测量宽度.
		 */
		public static const DEFAULT_MEASURED_WIDTH:Number = 160;
		
		/**
		 * 默认的文本测量高度.
		 */
		public static const DEFAULT_MEASURED_HEIGHT:Number = 22;
		
		/**
		 * 呈示此文本的文本对象.
		 */
		protected var _textField:TextField;
		
		private var _condenseWhite:Boolean = false;
		private var _condenseWhiteChanged:Boolean = false;
		
		hammerc_internal var _defaultStyleChanged:Boolean = true;
		
		hammerc_internal var _embedFonts:Boolean = false;
		
		private var _fontFamily:String = "SimSun";
		private var _size:uint = 12;
		private var _bold:Boolean = false;
		private var _italic:Boolean = false;
		private var _underline:Boolean = false;
		private var _textAlign:String = TextFormatAlign.LEFT;
		private var _leading:int = 0;
		
		//在 enabled 属性为 false 时记录的颜色值
		private var _pendingColor:uint = 0x000000;
		
		private var _textColor:uint = 0x000000;
		private var _disabledColor:uint = 0xaab3b3;
		
		private var _letterSpacing:Number = NaN;
		
		hammerc_internal var _textFormat:TextFormat;
		
		private var _htmlText:String = "";
		
		hammerc_internal var _htmlTextChanged:Boolean = false;
		
		hammerc_internal var _explicitHTMLText:String = null; 
		
		private var _pendingSelectable:Boolean = false;
		
		private var _selectable:Boolean = false;
		
		private var _selectableChanged:Boolean;
		
		hammerc_internal var _text:String = "";
		hammerc_internal var _textChanged:Boolean = false;
		
		hammerc_internal var _textHeight:Number;
		hammerc_internal var _textWidth:Number;
		
		/**
		 * 创建一个 <code>TextBase</code> 对象.
		 */
		public function TextBase()
		{
			super();
		}
		
		/**
		 * 设置或获取是否删除具有 HTML 文本的文本字段中的额外空白 (空格, 换行符等等).
		 * <p>在设置 <code>htmlText</code> 属性之前设置该属性.</p>
		 */
		public function set condenseWhite(value:Boolean):void
		{
			if(value != _condenseWhite)
			{
				return;
			}
			_condenseWhite = value;
			_condenseWhiteChanged = true;
			if(this.isHTML)
			{
				_htmlTextChanged = true;
			}
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();
			this.dispatchEvent(new Event("condenseWhiteChanged"));
		}
		public function get condenseWhite():Boolean
		{
			return _condenseWhite;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void
		{
			if(this.enabled == value)
			{
				return;
			}
			super.enabled = value;
			if(this.enabled)
			{
				if(_selectable != _pendingSelectable)
				{
					_selectableChanged = true;
				}
				if(_textColor != _pendingColor)
				{
					_defaultStyleChanged = true;
				}
				_selectable = _pendingSelectable;
				_textColor = _pendingColor;
			}
			else
			{
				if(_selectable)
				{
					_selectableChanged = true;
				}
				if(_textColor != disabledColor)
				{
					_defaultStyleChanged = true;
				}
				_pendingSelectable = _selectable;
				_pendingColor = _textColor;
				_selectable = false;
				_textColor = _disabledColor;
			}
			this.invalidateProperties();
		}
		
		/**
		 * 设置或获取字体名称.
		 */
		public function set fontFamily(value:String):void
		{
			if(_fontFamily != value)
			{
				_fontFamily = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get fontFamily():String
		{
			return _fontFamily;
		}
		
		/**
		 * 设置或获取字号大小.
		 */
		public function set size(value:uint):void
		{
			if(_size != value)
			{
				_size = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get size():uint
		{
			return _size;
		}
		
		/**
		 * 设置或获取是否为粗体.
		 */
		public function set bold(value:Boolean):void
		{
			if(_bold != value)
			{
				_bold = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get bold():Boolean
		{
			return _bold;
		}
		
		/**
		 * 设置或获取是否为斜体.
		 */
		public function set italic(value:Boolean):void
		{
			if(_italic != value)
			{
				_italic = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get italic():Boolean
		{
			return _italic;
		}
		
		/**
		 * 设置或获取是否有下划线.
		 */
		public function set underline(value:Boolean):void
		{
			if(_underline != value)
			{
				_underline = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
			}
		}
		public function get underline():Boolean
		{
			return _underline;
		}
		
		/**
		 * 设置或获取文字的水平对齐方式.
		 */
		public function set textAlign(value:String):void
		{
			if(_textAlign != value)
			{
				_textAlign = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get textAlign():String
		{
			return _textAlign;
		}
		
		/**
		 * 设置或获取行距.
		 */
		public function set leading(value:int):void
		{
			if(_leading != value)
			{
				_leading = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get leading():int
		{
			return _leading;
		}
		
		/**
		 * 设置或获取文本颜色.
		 */
		public function set textColor(value:uint):void
		{
			if(_textColor == value)
			{
				return;
			}
			if(this.enabled)
			{
				_textColor = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
			}
			else
			{
				_pendingColor = value;
			}
		}
		public function get textColor():uint
		{
			if(this.enabled)
			{
				return _textColor;
			}
			return _pendingColor;
		}
		
		/**
		 * 设置或获取被禁用时的文字颜色.
		 */
		public function set disabledColor(value:uint):void
		{
			if(_disabledColor != value)
			{
				return;
			}
			_disabledColor = value;
			if(!this.enabled)
			{
				_textColor = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
			}
		}
		public function get disabledColor():uint
		{
			return _disabledColor;
		}
		
		/**
		 * 设置或获取字符间距.
		 */
		public function set letterSpacing(value:Number):void
		{
			if(_letterSpacing != value)
			{
				_letterSpacing = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get letterSpacing():Number
		{
			return _letterSpacing;
		}
		
		/**
		 * 应用到所有文字的默认文字格式设置信息对象.
		 */
		protected function get defaultTextFormat():TextFormat
		{
			if(_defaultStyleChanged)
			{
				_textFormat = this.getDefaultTextFormat();
				_defaultStyleChanged = false;
			}
			return _textFormat;
		}
		
		/**
		 * 由于设置了默认文本格式后, 是延迟一帧才集中应用的, 若需要立即应用文本样式, 可以手动调用此方法.
		 */
		hammerc_internal function applyTextFormatNow():void
		{
			if(_defaultStyleChanged)
			{
				_textField.setTextFormat(this.defaultTextFormat);
				_textField.defaultTextFormat = this.defaultTextFormat;
			}
		}
		
		/**
		 * 从另外一个文本组件复制默认文字格式信息到自身.
		 * @param textBase 目标文本组件.
		 */
		public function copyDefaultFormatFrom(textBase:TextBase):void
		{
			this.fontFamily = textBase.fontFamily;
			this.size = textBase.size;
			this.textColor = textBase.textColor;
			this.bold = textBase.bold;
			this.italic = textBase.italic;
			this.underline = textBase.underline;
			this.textAlign = textBase.textAlign;
			this.leading = textBase.leading;
			this.letterSpacing = textBase.letterSpacing;
			this.disabledColor = textBase.disabledColor;
		}
		
		/**
		 * 获取文字的默认格式设置信息对象.
		 * @return 默认格式设置信息对象.
		 */
		public function getDefaultTextFormat():TextFormat
		{
			var textFormat:TextFormat = new TextFormat(_fontFamily, _size, _textColor, _bold, _italic, _underline, "", "", _textAlign, 0, 0, 0, _leading);
			if(!isNaN(this.letterSpacing))
			{
				textFormat.kerning = true;
				textFormat.letterSpacing = letterSpacing;
			}
			else
			{
				textFormat.kerning = false;
				textFormat.letterSpacing = null;
			}
			return textFormat;
		}
		
		/**
		 * 设置或获取是否可以选择文本.
		 */
		public function set selectable(value:Boolean):void
		{
			if(value == selectable)
			{
				return;
			}
			if(this.enabled)
			{
				_selectable = value;
				_selectableChanged = true;
				this.invalidateProperties();
			}
			else
			{
				_pendingSelectable = value;
			}
		}
		public function get selectable():Boolean
		{
			if(this.enabled)
			{
				return _selectable;
			}
			return _pendingSelectable;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set text(value:String):void
		{
			if(value == null)
			{
				value = "";
			}
			if(!this.isHTML && value == _text)
			{
				return;
			}
			_text = value;
			if(_textField != null)
			{
				_textField.text = _text;
			}
			_textChanged = true;
			_htmlText = null;
			_explicitHTMLText = null;
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * 设置或获取 HTML 文本.
		 */
		public function set htmlText(value:String):void
		{
			if(value == null)
			{
				value = "";
			}
			if(this.isHTML && value == _explicitHTMLText)
			{
				return;
			}
			_htmlText = value;
			if(_textField != null)
			{
				_textField.htmlText = _htmlText;
			}
			_htmlTextChanged = true;
			_text = null;
			_explicitHTMLText = value;
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		public function get htmlText():String
		{
			return _htmlText;
		}
		
		/**
		 * 获取当前是否为 HTML 文本.
		 */
		hammerc_internal function get isHTML():Boolean
		{
			return _explicitHTMLText != null;
		}
		
		/**
		 * 获取文本高度.
		 */
		public function get textHeight():Number
		{
			validateNowIfNeed();
			return _textHeight;
		}
		
		/**
		 * 获取文本宽度.
		 */
		public function get textWidth():Number
		{
			validateNowIfNeed();
			return _textWidth;
		}
		
		/**
		 * 由于组件是延迟应用属性的, 若需要在改变文本属性后立即获得正确的值, 要先调用 validateNow 方法.
		 */
		private function validateNowIfNeed():void
		{
			if(_invalidatePropertiesFlag || _invalidateSizeFlag || _invalidateDisplayListFlag)
			{
				this.validateNow();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if(_textField == null)
			{
				checkTextField();
			}
		}
		
		/**
		 * 检查是否创建了 textField 对象, 没有就创建一个.
		 */
		private function checkTextField():void
		{
			if(_textField == null)
			{
				this.createTextField();
				if(this.isHTML)
				{
					_textField.htmlText = _explicitHTMLText;
				}
				else
				{
					_textField.text = _text;
				}
				_condenseWhiteChanged = true;
				_selectableChanged = true;
				_textChanged = true;
				_defaultStyleChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * 创建文本显示对象.
		 */
		protected function createTextField():void
		{
			_textField = new TextField();
			_textField.selectable = this.selectable;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.mouseWheelEnabled = false;
			addChild(_textField);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_textField == null)
			{
				checkTextField();
			}
			if(_condenseWhiteChanged)
			{
				_textField.condenseWhite = _condenseWhite;
				_condenseWhiteChanged = false;
			}
			if(_selectableChanged)
			{
				_textField.selectable = _selectable;
				_selectableChanged = false;
			}
			if(_defaultStyleChanged)
			{
				_textField.setTextFormat(defaultTextFormat);
				_textField.defaultTextFormat = defaultTextFormat;
				_textField.embedFonts = _embedFonts;
				if(this.isHTML)
				{
					_textField.htmlText = _explicitHTMLText;
				}
			}
			if(_textChanged || _htmlTextChanged)
			{
				this.textFieldChanged(true);
				_textChanged = false;
				_htmlTextChanged = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setFocus():void
		{
			if(_textField && HammercGlobals.stage != null)
			{
				HammercGlobals.stage.focus = _textField;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			this.measuredWidth = DEFAULT_MEASURED_WIDTH;
			this.measuredHeight = DEFAULT_MEASURED_HEIGHT;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			_textField.x = 0;
			_textField.y = 0;
			_textField.width = unscaledWidth;
			_textField.height = unscaledHeight;
			_textWidth = _textField.textWidth;
			_textHeight = _textField.textHeight;
		}
		
		/**
		 * 更新显示列表.
		 */
		final hammerc_internal function $updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * 返回包含控件中文本位置和文本行度量值的相关信息.
		 * @param lineIndex 要获得其度量值的行的索引.
		 * @return 包含控件中文本位置和文本行度量值的相关信息.
		 */
		public function getLineMetrics(lineIndex:int):TextLineMetrics
		{
			validateNowIfNeed();
			return _textField ? _textField.getLineMetrics(lineIndex) : null;
		}
		
		/**
		 * 文本显示对象属性改变.
		 * @param styleChangeOnly 是否仅更改样式.
		 */
		protected function textFieldChanged(styleChangeOnly:Boolean):void
		{
			if(!styleChangeOnly)
			{
				_text = _textField.text;
			}
			_htmlText = _textField.htmlText;
			_textWidth = _textField.textWidth;
			_textHeight = _textField.textHeight;
		}
	}
}
