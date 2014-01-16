/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	
	import org.hammerc.components.supportClasses.TextBase;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.UIEvent;
	import org.hammerc.layouts.VerticalAlign;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>Label</code> 类实现一行或多行不可编辑的文本控件.
	 * @author wizardc
	 */
	public class Label extends TextBase
	{
		/**
		 * 是否只显示嵌入的字体. 此属性对只所有 <code>Label</code> 实例有效.
		 * true 表示如果指定的 fontFamily 没有被嵌入, 即使用户机上存在该设备字体也不显示. 而将使用默认的字体. 默认值为 false.
		 */
		public static var showEmbedFontsOnly:Boolean = false;
		
		private var _toolTipSet:Boolean = false;
		
		private var _verticalAlign:String = VerticalAlign.TOP;
		
		private var _maxDisplayedLines:int = 0;
		
		//上一次测量的宽度
		private var _lastUnscaledWidth:Number = NaN;
		
		private var _padding:Number = 0;
		private var _paddingLeft:Number = NaN;
		private var _paddingRight:Number = NaN;
		private var _paddingTop:Number = NaN;
		private var _paddingBottom:Number = NaN;
		
		//记录不同范围的格式信息
		private var _rangeFormatDic:Dictionary;
		
		//范围格式信息发送改变标志
		private var _rangeFormatChanged:Boolean = false;
		
		private var _isTruncated:Boolean = false;
		private var _truncateToFit:Boolean = true;
		
		/**
		 * 创建一个 <code>Label</code> 对象.
		 */
		public function Label()
		{
			this.addEventListener(UIEvent.UPDATE_COMPLETE, updateCompleteHandler);
		}
		
		private function updateCompleteHandler(event:UIEvent):void
		{
			_lastUnscaledWidth = NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set fontFamily(value:String):void
		{
			if(fontFamily == value)
			{
				return;
			}
			var fontList:Array = Font.enumerateFonts(false);
			_embedFonts = false;
			for each(var font:Font in fontList)
			{
				if(font.fontName == value)
				{
					_embedFonts = true;
					break;
				}
			}
			if(!_embedFonts && showEmbedFontsOnly)
			{
				return;
			}
			super.fontFamily = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set toolTip(value:Object):void
		{
			super.toolTip = value;
			_toolTipSet = (value != null);
		}
		
		/**
		 * 设置或获取垂直对齐方式.
		 */
		public function set verticalAlign(value:String):void
		{
			if(_verticalAlign != value)
			{
				_verticalAlign = value;
				_defaultStyleChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		/**
		 * 设置或获取最大显示行数, 0 或负值代表不限制.
		 */
		public function set maxDisplayedLines(value:int):void
		{
			if(_maxDisplayedLines != value)
			{
				_maxDisplayedLines = value;
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get maxDisplayedLines():int
		{
			return _maxDisplayedLines;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set text(value:String):void
		{
			if(value == null)
			{
				value = "";
			}
			if(!this.isHTML && value == _text)
			{
				return;
			}
			super.text = value;
			_rangeFormatDic = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set htmlText(value:String):void
		{
			if(value == null)
			{
				value = "";
			}
			if(this.isHTML && value == _explicitHTMLText)
			{
				return;
			}
			super.htmlText = value;
			_rangeFormatDic = null;
		}
		
		/**
		 * 设置或获取四个边缘的共同内边距. 若单独设置了任一边缘的内边距, 则该边缘的内边距以单独设置的值为准.
		 * 此属性主要用于快速设置多个边缘的相同内边距.
		 */
		public function set padding(value:Number):void
		{
			if(_padding != value)
			{
				_padding = value;
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get padding():Number
		{
			return _padding;
		}
		
		/**
		 * 设置或获取容器的左边缘与布局元素的左边缘之间的最少像素数. 若为 NaN 将使用 <code>padding</code> 的值.
		 */
		public function set paddingLeft(value:Number):void
		{
			if(_paddingLeft != value)
			{
				_paddingLeft = value;
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		/**
		 * 设置或获取容器的右边缘与布局元素的右边缘之间的最少像素数. 若为 NaN 将使用 <code>padding</code> 的值.
		 */
		public function set paddingRight(value:Number):void
		{
			if(_paddingRight != value)
			{
				_paddingRight = value;
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		/**
		 * 设置或获取容器的顶边缘与第一个布局元素的顶边缘之间的像素数. 若为 NaN 将使用 <code>padding</code> 的值.
		 */
		public function set paddingTop(value:Number):void
		{
			if(_paddingTop != value)
			{
				_paddingTop = value;
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		/**
		 * 设置或获取容器的底边缘与最后一个布局元素的底边缘之间的像素数. 若为 NaN 将使用 <code>padding</code> 的值.
		 */
		public function set paddingBottom(value:Number):void
		{
			if(_paddingBottom != value)
			{
				_paddingBottom = value;
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		/**
		 * 设置或获取是否使用"..."截断 <code>Label</code> 控件的文本.
		 * 如果此属性为true, 并且 <code>Label</code> 控件大小小于其文本大小, 则使用"..."截断 <code>Label</code> 控件的文本. 反之将直接截断文本.
		 * 注意：当使用 htmlText 显示文本时, 始终直接截断文本, 不显示"...".
		 */
		public function set truncateToFit(value:Boolean):void
		{
			if(_truncateToFit != value)
			{
				_truncateToFit = value;
				this.invalidateDisplayList();
			}
		}
		public function get truncateToFit():Boolean
		{
			return _truncateToFit;
		}
		
		/**
		 * 获取文本是否已经截断并以"..."结尾的标志.
		 * 注意：当使用 htmlText 显示文本时, 始终直接截断文本, 不显示"...".
		 */
		public function get isTruncated():Boolean
		{
			return _isTruncated;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultTextFormat():TextFormat
		{
			if(_defaultStyleChanged)
			{
				_textFormat = getDefaultTextFormat();
				//当设置了 verticalAlign 为 VerticalAlign.JUSTIFY 时将忽略行高
				if(_verticalAlign == VerticalAlign.JUSTIFY)
				{
					_textFormat.leading = 0;
				}
				_defaultStyleChanged = false;
			}
			return _textFormat;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function copyDefaultFormatFrom(textBase:TextBase):void
		{
			super.copyDefaultFormatFrom(textBase);
			if(textBase is Label)
			{
				verticalAlign = (textBase as Label).verticalAlign;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createTextField():void
		{
			super.createTextField();
			_textField.wordWrap = true;
			_textField.multiline = true;
			_textField.visible = false;
			_textField.mouseWheelEnabled = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			var needSetDefaultFormat:Boolean = _defaultStyleChanged || _textChanged || _htmlTextChanged;
			_rangeFormatChanged = needSetDefaultFormat || _rangeFormatChanged;
			if(_rangeFormatChanged)
			{
				//如果样式发生改变, 父级会执行样式刷新的过程, 这里就不用重复了
				if(!needSetDefaultFormat)
				{
					_textField.setTextFormat(defaultTextFormat);
				}
				applyRangeFormat();
				_rangeFormatChanged = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			//先提交属性, 防止样式发生改变导致的测量不准确问题
			if(_invalidatePropertiesFlag)
			{
				validateProperties();
			}
			if(isSpecialCase())
			{
				if(isNaN(_lastUnscaledWidth))
				{
					_oldPreferWidth = NaN;
					_oldPreferHeight = NaN;
				}
				else
				{
					measureUsingWidth(_lastUnscaledWidth);
					return;
				}
			}
			var availableWidth:Number;
			if(!isNaN(explicitWidth))
			{
				availableWidth = explicitWidth;
			}
			else if(maxWidth!=10000)
			{
				availableWidth = maxWidth;
			}
			measureUsingWidth(availableWidth);
		}
		
		/**
		 * 特殊情况, 组件尺寸由父级决定, 要等到父级 UpdateDisplayList 的阶段才能测量.
		 */
		private function isSpecialCase():Boolean
		{
			return _maxDisplayedLines != 1 && (!isNaN(this.percentWidth) || (!isNaN(this.left) && !isNaN(this.right))) && isNaN(this.explicitHeight) && isNaN(this.percentHeight);
		}
		
		/**
		 * 使用指定的宽度进行测量.
		 */
		private function measureUsingWidth(w:Number):void
		{
			var originalText:String = _textField.text;
			if(_isTruncated || _textChanged || _htmlTextChanged)
			{
				if(isHTML)
				{
					_textField.htmlText = _explicitHTMLText;
				}
				else
				{
					_textField.text = _text;
				}
				applyRangeFormat();
			}
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var paddingR:Number = isNaN(_paddingRight) ? padding : _paddingRight;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			if(!isNaN(w))
			{
				_textField.width = w - paddingL - paddingR;
				this.measuredWidth = Math.ceil(_textField.textWidth + 5);
				this.measuredHeight = Math.ceil(_textField.textHeight + 4);
			}
			else
			{
				var oldWordWrap:Boolean = _textField.wordWrap;
				_textField.wordWrap = false;
				this.measuredWidth = Math.ceil(_textField.textWidth + 5);
				this.measuredHeight = Math.ceil(_textField.textHeight + 4);
				_textField.wordWrap = oldWordWrap;
			}
			_textField.autoSize = TextFieldAutoSize.NONE;
			if(_maxDisplayedLines > 0 && _textField.numLines > _maxDisplayedLines)
			{
				var lineM:TextLineMetrics = _textField.getLineMetrics(0);
				this.measuredHeight = lineM.height * _maxDisplayedLines - lineM.leading + 4;
			}
			this.measuredWidth += paddingL + paddingR;
			this.measuredHeight += paddingT + paddingB;
			if(_isTruncated)
			{
				_textField.text = originalText;
				applyRangeFormat();
			}
		}
		
		/**
		 * 将指定的格式应用于指定范围中的每个字符.
		 * 注意：使用此方法应用的格式只能影响到当前的文字内容, 若改变文字内容, 所有文字将会被重置为默认格式.
		 * @param format 一个包含字符和段落格式设置信息的 <code>TextFormat</code> 对象.
		 * @param beginIndex 可选; 一个整数, 指定所需文本范围内第一个字符的从零开始的索引位置.
		 * @param endIndex 可选; 一个整数, 指定所需文本范围后面的第一个字符.
		 * 如果指定 beginIndex 和 endIndex 值, 则更新索引从 beginIndex 到 endIndex - 1 的文本.
		 */
		public function setFormatOfRange(format:TextFormat, beginIndex:int=-1, endIndex:int=-1):void
		{
			if(_rangeFormatDic == null)
			{
				_rangeFormatDic = new Dictionary();
			}
			if(_rangeFormatDic[beginIndex] == null)
			{
				_rangeFormatDic[beginIndex] = new Dictionary();
			}
			_rangeFormatDic[beginIndex][endIndex] = cloneTextFormat(format);
			_rangeFormatChanged = true;
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 * 克隆一个文本格式对象.
		 */
		private static function cloneTextFormat(tf:TextFormat):TextFormat
		{
			return new TextFormat(tf.font, tf.size, tf.color, tf.bold, tf.italic, tf.underline, tf.url, tf.target, tf.align, tf.leftMargin, tf.rightMargin, tf.indent, tf.leading);
		}
		
		/**
		 * 应用范围格式信息.
		 */
		private function applyRangeFormat(expLeading:Object = null):void
		{
			_rangeFormatChanged = false;
			if(_rangeFormatDic == null || _textField == null || _text == null)
			{
				return;
			}
			var useLeading:Boolean = expLeading != null;
			for(var beginIndex:* in _rangeFormatDic)
			{
				var endDic:Dictionary = _rangeFormatDic[beginIndex] as Dictionary;
				if(endDic != null)
				{
					for(var index:* in endDic)
					{
						if(endDic[index] == null)
						{
							continue;
						}
						var oldLeading:Object;
						if(useLeading)
						{
							oldLeading = (endDic[index] as TextFormat).leading;
							(endDic[index] as TextFormat).leading = expLeading;
						}
						var endIndex:int = index;
						if(endIndex > _textField.text.length)
						{
							endIndex = _textField.text.length;
						}
						try
						{
							_textField.setTextFormat(endDic[index], beginIndex, endIndex);
						}
						catch(e:Error)
						{
						}
						if(useLeading)
						{
							(endDic[index] as TextFormat).leading = oldLeading;
						}
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			this.$updateDisplayList(unscaledWidth, unscaledHeight);
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var paddingR:Number = isNaN(_paddingRight) ? padding : _paddingRight;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			_textField.x = paddingL;
			_textField.y = paddingT;
			if(isSpecialCase())
			{
				var firstTime:Boolean = isNaN(_lastUnscaledWidth) || _lastUnscaledWidth != unscaledWidth;
				_lastUnscaledWidth = unscaledWidth;
				if(firstTime)
				{
					_oldPreferWidth = NaN;
					_oldPreferHeight = NaN;
					this.invalidateSize();
					return;
				}
			}
			//防止在父级validateDisplayList()阶段改变的text属性值, 接下来直接调用自身的updateDisplayList()而没有经过measu(),使用的测量尺寸是上一次的错误值.
			if(_invalidateSizeFlag)
			{
				this.validateSize();
			}
			//解决初始化时文本闪烁问题
			if(!_textField.visible)
			{
				_textField.visible = true;
			}
			if(_isTruncated)
			{
				_textField.text = _text;
				applyRangeFormat();
			}
			_textField.scrollH = 0;
			_textField.scrollV = 1;
			_textField.width = unscaledWidth - paddingL - paddingR;
			var unscaledTextHeight:Number = unscaledHeight - paddingT - paddingB;
			_textField.height = unscaledTextHeight;
			if(_maxDisplayedLines == 1)
			{
				_textField.wordWrap = false;
			}
			else if(Math.floor(this.width) < Math.floor(this.measuredWidth))
			{
				_textField.wordWrap = true;
			}
			_textWidth = _textField.textWidth + 5;
			_textHeight = _textField.textHeight + 4;
			if(_maxDisplayedLines > 0 && _textField.numLines > _maxDisplayedLines)
			{
				var lineM:TextLineMetrics = _textField.getLineMetrics(0);
				var h:Number = lineM.height * _maxDisplayedLines - lineM.leading + 4;
				_textField.height = Math.min(unscaledTextHeight, h);
			}
			if(_verticalAlign == VerticalAlign.JUSTIFY)
			{
				_textField.setTextFormat(this.defaultTextFormat);
				applyRangeFormat(0);
			}
			if(_truncateToFit)
			{
				_isTruncated = truncateTextToFit();
				if(!_toolTipSet)
				{
					super.toolTip = _isTruncated ? _text : null;
				}
			}
			if(_textField.textHeight + 4 >= unscaledTextHeight)
			{
				return;
			}
			if(_verticalAlign == VerticalAlign.JUSTIFY)
			{
				if(_textField.numLines > 1)
				{
					_textField.height = unscaledTextHeight;
					var extHeight:Number = Math.max(0, unscaledTextHeight - _textField.textHeight - 4);
					this.defaultTextFormat.leading = Math.floor(extHeight/(_textField.numLines - 1));
					_textField.setTextFormat(this.defaultTextFormat);
					applyRangeFormat(this.defaultTextFormat.leading);
					this.defaultTextFormat.leading = 0;
				}
			}
			else
			{
				var valign:Number = 0;
				if(_verticalAlign == VerticalAlign.MIDDLE)
				{
					valign = 0.5;
				}
				else if(_verticalAlign == VerticalAlign.BOTTOM)
				{
					valign = 1;
				}
				_textField.y += Math.floor((unscaledTextHeight - _textField.textHeight - 4) * valign);
				_textField.height = unscaledTextHeight - _textField.y;
			}
		}
		
		/**
		 * 截断超过边界的字符串, 使用"..."结尾.
		 */
		private function truncateTextToFit():Boolean
		{
			if(this.isHTML)
			{
				return false;
			}
			var truncationIndicator:String = "...";
			var originalText:String = text;
			var expLeading:Object = verticalAlign == VerticalAlign.JUSTIFY ? 0 : null;
			try
			{
				var lineM:TextLineMetrics = _textField.getLineMetrics(0);
				var realTextHeight:Number = _textField.height;
				var lastLineIndex:int =int(realTextHeight / lineM.height);
			}
			catch(error:Error)
			{
				lastLineIndex = 1;
			}
			if(lastLineIndex < 1)
			{
				lastLineIndex = 1;
			}
			if(_textField.numLines > lastLineIndex && _textField.textHeight + 4 > _textField.height)
			{
				var offset:int = _textField.getLineOffset(lastLineIndex);
				originalText = originalText.substr(0, offset);
				_textField.text = originalText + truncationIndicator;
				applyRangeFormat(expLeading);
				while(originalText.length > 1 && _textField.numLines > lastLineIndex)
				{
					originalText = originalText.slice(0, -1);
					_textField.text = originalText + truncationIndicator;
					applyRangeFormat(expLeading);
				}
				return true;
			}
			return false;
		}
	}
}
