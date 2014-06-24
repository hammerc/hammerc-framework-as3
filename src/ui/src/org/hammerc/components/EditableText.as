/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	
	import org.hammerc.components.supportClasses.TextBase;
	import org.hammerc.core.IEditableText;
	import org.hammerc.core.IViewport;
	import org.hammerc.core.NavigationUnit;
	
	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.TextEvent.TEXT_INPUT
	 */
	[Event(name="textInput", type="flash.events.TextEvent")]
	
	/**
	 * <code>EditableText</code> 类实现了可编辑文本组件.
	 * @author wizardc
	 */
	public class EditableText extends TextBase implements IEditableText, IViewport
	{
		private var _displayAsPassword:Boolean = false;
		private var _displayAsPasswordChanged:Boolean = true;
		
		private var _pendingEditable:Boolean = true;
		
		private var _editable:Boolean = true;
		private var _editableChanged:Boolean = false;
		
		private var _maxChars:int = 0;
		private var _maxCharsChanged:Boolean = false;
		
		private var _multiline:Boolean = true;
		private var _multilineChanged:Boolean = false;
		
		private var _restrict:String = null;
		private var _restrictChanged:Boolean = false;
		
		private var _heightInLines:Number = NaN;
		private var _heightInLinesChanged:Boolean = false;
		
		private var _widthInChars:Number = NaN;
		private var _widthInCharsChanged:Boolean = false;
		
		private var _contentWidth:Number = 0;
		private var _contentHeight:Number = 0;
		
		private var _horizontalScrollPosition:Number = 0;
		private var _verticalScrollPosition:Number = 0;
		
		private var _clipAndEnableScrolling:Boolean = false;
		
		/**
		 * heightInLines 计算出来的默认高度.
		 */
		private var _defaultHeight:Number = NaN;
		
		/**
		 * widthInChars 计算出来的默认宽度.
		 */
		private var _defaultWidth:Number = NaN;
		
		private var _isValidating:Boolean = false;
		
		/**
		 * 创建一个 <code>EditableText</code> 对象.
		 */
		public function EditableText()
		{
			super();
			this.selectable = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set displayAsPassword(value:Boolean):void
		{
			if(value != _displayAsPassword)
			{
				_displayAsPassword = value;
				_displayAsPasswordChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set editable(value:Boolean):void
		{
			if(_editable == value)
			{
				return;
			}
			if(this.enabled)
			{
				_editable = value;
				_editableChanged = true;
				this.invalidateProperties();
			}
			else
			{
				_pendingEditable = value;
			}
		}
		public function get editable():Boolean
		{
			if(this.enabled)
			{
				return _editable;
			}
			return _pendingEditable;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void
		{
			if(value == super.enabled)
			{
				return;
			}
			super.enabled = value;
			if(enabled)
			{
				if(_editable != _pendingEditable)
				{
					_editableChanged = true;
				}
				_editable = _pendingEditable;
			}
			else
			{
				if(editable)
				{
					_editableChanged = true;
				}
				_pendingEditable = _editable;
				_editable = false;
			}
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		public function set maxChars(value:int):void
		{
			if(value != _maxChars)
			{
				_maxChars = value;
				_maxCharsChanged = true;
				this.invalidateProperties();
			}
		}
		public function get maxChars():int
		{
			return _maxChars;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set multiline(value:Boolean):void
		{
			if(value != multiline)
			{
				_multiline = value;
				_multilineChanged = true;
				this.invalidateProperties();
			}
		}
		public function get multiline():Boolean
		{
			return _multiline;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set restrict(value:String):void
		{
			if(value != _restrict)
			{
				_restrict = value;
				_restrictChanged = true;
				this.invalidateProperties();
			}
		}
		public function get restrict():String
		{
			return _restrict;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set size(value:uint):void
		{
			if(size != value)
			{
				super.size = value;
				_heightInLinesChanged = true;
				_widthInCharsChanged = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set leading(value:int):void
		{
			if(leading != value)
			{
				super.leading = value;
				_heightInLinesChanged = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set heightInLines(value:Number):void
		{
			if(_heightInLines != value)
			{
				_heightInLines = value;
				_heightInLinesChanged = true;
				this.invalidateProperties();
			}
		}
		public function get heightInLines():Number
		{
			return _heightInLines;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set widthInChars(value:Number):void
		{
			if(_widthInChars != value)
			{
				_widthInChars = value;
				_widthInCharsChanged = true;
				this.invalidateProperties();
			}
		}
		public function get widthInChars():Number
		{
			return _widthInChars;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		
		private function setContentWidth(value:Number):void
		{
			if(value != _contentWidth)
			{
				var oldValue:Number = _contentWidth;
				_contentWidth = value;
				this.dispatchPropertyChangeEvent("contentWidth", oldValue, value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		
		private function setContentHeight(value:Number):void
		{
			if(value != _contentHeight)
			{
				var oldValue:Number = _contentHeight;
				_contentHeight = value;
				this.dispatchPropertyChangeEvent("contentHeight", oldValue, value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(_horizontalScrollPosition == value)
			{
				return;
			}
			value = Math.round(value);
			var oldValue:Number = _horizontalScrollPosition;
			_horizontalScrollPosition = value;
			if(_clipAndEnableScrolling)
			{
				if(_textField != null)
				{
					_textField.scrollH = value;
				}
				this.dispatchPropertyChangeEvent("horizontalScrollPosition", oldValue, value);
			}
		}
		public function get horizontalScrollPosition():Number
		{
			return _horizontalScrollPosition;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if(_verticalScrollPosition == value)
			{
				return;
			}
			value = Math.round(value);
			var oldValue:Number = _verticalScrollPosition;
			_verticalScrollPosition = value;
			if(_clipAndEnableScrolling)
			{
				if(_textField != null)
				{
					_textField.scrollV = getScrollVByVertitcalPos(value);
				}
				this.dispatchPropertyChangeEvent("verticalScrollPosition", oldValue, value);
			}
		}
		public function get verticalScrollPosition():Number
		{
			return _verticalScrollPosition;
		}
		
		/**
		 * 根据垂直像素位置获取对应的垂直滚动位置.
		 */
		private function getScrollVByVertitcalPos(value:Number):int
		{
			if(_textField.numLines == 0)
			{
				return 1;
			}
			var lineHeight:Number = _textField.getLineMetrics(0).height;
			return int(value / lineHeight) + 1;
		}
		
		/**
		 * 根据垂直滚动位置获取对应的垂直像位置.
		 */
		private function getVerticalPosByScrollV(scrollV:int):Number
		{
			if(scrollV == 1 || _textField.numLines == 0)
			{
				return 0;
			}
			var lineHeight:Number = _textField.getLineMetrics(0).height;
			if(scrollV == _textField.maxScrollV)
			{
				return lineHeight * _textField.maxScrollV;
			}
			if(scrollV == _textField.maxScrollV)
			{
				var offsetHeight:Number = this.height % lineHeight;
				return _textField.textHeight + offsetHeight - this.height;
			}
			return lineHeight * (scrollV - 1) + 2;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
		{
			var delta:Number = 0;
			var maxDelta:Number = _contentWidth - _horizontalScrollPosition - width;
			var minDelta:Number = -_horizontalScrollPosition;
			switch(navigationUnit)
			{
				case NavigationUnit.LEFT:
					delta = _horizontalScrollPosition <= 0 ? 0 : Math.max(minDelta, -size);
					break;
				case NavigationUnit.RIGHT:
					delta = (_horizontalScrollPosition + width >= contentWidth) ? 0 : Math.min(maxDelta, size);
					break;
				case NavigationUnit.PAGE_LEFT:
					delta = Math.max(minDelta, -width);
					break;
				case NavigationUnit.PAGE_RIGHT:
					delta = Math.min(maxDelta, width);
					break;
				case NavigationUnit.HOME:
					delta = minDelta;
					break;
				case NavigationUnit.END:
					delta = maxDelta;
					break;
			}
			return delta;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			var delta:Number = 0;
			var maxDelta:Number = _contentHeight - _verticalScrollPosition - height;
			var minDelta:Number = -_verticalScrollPosition;
			switch(navigationUnit)
			{
				case NavigationUnit.UP:
					delta = getVScrollDelta(-1);
					break;
				case NavigationUnit.DOWN:
					delta = getVScrollDelta(1);
					break;
				case NavigationUnit.PAGE_UP:
					delta = Math.max(minDelta, -width);
					break;
				case NavigationUnit.PAGE_DOWN:
					delta = Math.min(maxDelta, width);
					break;
				case NavigationUnit.HOME:
					delta = minDelta;
					break;
				case NavigationUnit.END:
					delta = maxDelta;
					break;
			}
			return delta;
		}
		
		/**
		 * 返回指定偏移行数的滚动条偏移量.
		 */
		private function getVScrollDelta(offsetLine:int):Number
		{
			if(_textField == null)
			{
				return 0;
			}
			var currentScrollV:int = getScrollVByVertitcalPos(_verticalScrollPosition);
			var scrollV:int = currentScrollV + offsetLine;
			scrollV = Math.max(1, Math.min(_textField.maxScrollV, scrollV));
			var startPos:Number = getVerticalPosByScrollV(scrollV);
			var delta:int = startPos - _verticalScrollPosition;
			return delta;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set clipAndEnableScrolling(value:Boolean):void
		{
			if(_clipAndEnableScrolling == value)
			{
				return;
			}
			_clipAndEnableScrolling = value;
			if(_textField != null)
			{
				if(value)
				{
					_textField.scrollH = _horizontalScrollPosition;
					_textField.scrollV = getScrollVByVertitcalPos(_verticalScrollPosition);
					updateContentSize();
				}
				else
				{
					_textField.scrollH = 0;
					_textField.scrollV = 1;
				}
			}
		}
		public function get clipAndEnableScrolling():Boolean
		{
			return _clipAndEnableScrolling;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createTextField():void
		{   
			super.createTextField();
			_textField.type = _editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			_textField.multiline = _multiline;
			_textField.wordWrap = _multiline;
			_textField.addEventListener(Event.CHANGE, textField_changeHandler);
			_textField.addEventListener(Event.SCROLL, textField_scrollHandler);
			_textField.addEventListener(TextEvent.TEXT_INPUT, textField_textInputHandler);
			if(_clipAndEnableScrolling)
			{
				_textField.scrollH = _horizontalScrollPosition;
				_textField.scrollV = getScrollVByVertitcalPos(_verticalScrollPosition);
			}
		}
		
		private function textField_changeHandler(event:Event):void
		{
			this.textFieldChanged(false);
			event.stopImmediatePropagation();
			this.dispatchEvent(new Event(Event.CHANGE));
			this.invalidateSize();
			this.invalidateDisplayList();
			updateContentSize();
		}
		
		private function textField_scrollHandler(event:Event):void
		{
			if(_isValidating)
			{
				return;
			}
			horizontalScrollPosition = _textField.scrollH;
			verticalScrollPosition = getVerticalPosByScrollV(_textField.scrollV);
		}
		
		private function textField_textInputHandler(event:TextEvent):void
		{
			event.stopImmediatePropagation();
			var newEvent:TextEvent = new TextEvent(TextEvent.TEXT_INPUT, false, true);
			newEvent.text = event.text;
			this.dispatchEvent(newEvent);
			if(newEvent.isDefaultPrevented())
			{
				event.preventDefault();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if(_textField == null)
			{
				_editableChanged = true;
				_displayAsPasswordChanged = true;
				_maxCharsChanged = true;
				_multilineChanged = true;
				_restrictChanged = true;
			}
			super.commitProperties();
			if(_editableChanged)
			{
				_textField.type = _editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
				_editableChanged = false;
			}
			if(_displayAsPasswordChanged)
			{
				_textField.displayAsPassword = _displayAsPassword;
				_displayAsPasswordChanged = false;
			}
			if(_maxCharsChanged)
			{
				_textField.maxChars = _maxChars;
				_maxCharsChanged = false;
			}
			if(_multilineChanged)
			{
				_textField.multiline = _multiline;
				_textField.wordWrap = _multiline;
				_multilineChanged = false;
			}
			if(_restrictChanged)
			{
				_textField.restrict = _restrict;
				_restrictChanged = false;
			}
			if(_heightInLinesChanged)
			{
				_heightInLinesChanged = false;
				if(isNaN(_heightInLines))
				{
					_defaultHeight = NaN;
				}
				else
				{
					var hInLine:int = int(heightInLines);
					var lineHeight:Number = 22;
					if(_textField.length > 0)
					{
						lineHeight = _textField.getLineMetrics(0).height;
					}
					else
					{
						_textField.text = "M";
						lineHeight = _textField.getLineMetrics(0).height;
						_textField.text = "";
					}
					_defaultHeight = hInLine * lineHeight + 4;
				}
			}
			if(_widthInCharsChanged)
			{
				_widthInCharsChanged = false;
				if(isNaN(_widthInChars))
				{
					_defaultWidth = NaN;
				}
				else
				{
					var wInChars:int = int(_widthInChars);
					_defaultWidth = size * wInChars + 5;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			measuredWidth = isNaN(_defaultWidth) ? DEFAULT_MEASURED_WIDTH : _defaultWidth;
			if(_maxChars != 0)
			{
				measuredWidth = Math.min(measuredWidth, _textField.textWidth + 5);
			}
			if(_multiline)
			{
				measuredHeight = isNaN(_defaultHeight) ? DEFAULT_MEASURED_HEIGHT * 2 : _defaultHeight;
			}
			else
			{
				measuredHeight = _textField.textHeight + 4;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			_isValidating = true;
			var oldScrollH:int = _textField.scrollH;
			var oldScrollV:int = _textField.scrollV;
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			updateContentSize();
			_textField.scrollH = oldScrollH;
			_textField.scrollV = oldScrollV;
			_isValidating = false;
		}
		
		/**
		 * 更新内容尺寸大小.
		 */
		private function updateContentSize():void
		{
			if(!this.clipAndEnableScrolling)
			{
				return;
			}
			setContentWidth(_textField.textWidth + 5);
			var contentHeight:Number = 0;
			var numLines:int = _textField.numLines;
			if(numLines == 0)
			{
				contentHeight = 4;
			}
			else
			{
				var lineHeight:Number = _textField.textHeight / numLines;
				var offsetHeight:Number = (this.height - 4) % lineHeight;
				contentHeight = _textField.textHeight + 4 + offsetHeight;
			}
			setContentHeight(contentHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectionBeginIndex():int
		{
			this.invalidateProperties();
			if(_textField != null)
			{
				return _textField.selectionBeginIndex;
			}
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get selectionEndIndex():int
		{
			this.invalidateProperties();
			if(_textField != null)
			{
				return _textField.selectionEndIndex;
			}
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get caretIndex():int
		{
			this.invalidateProperties();
			if(_textField != null)
			{
				return _textField.caretIndex;
			}
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSelection(beginIndex:int, endIndex:int):void
		{
			this.invalidateProperties();
			if(_textField != null)
			{
				_textField.setSelection(beginIndex, endIndex);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectAll():void
		{
			this.invalidateProperties();
			if(_textField != null)
			{
				_textField.setSelection(0, _textField.length - 1);
			}
		}
	}
}
