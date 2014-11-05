// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	
	import org.hammerc.components.EditableText;
	import org.hammerc.components.SkinnableComponent;
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IEditableText;
	import org.hammerc.core.IText;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.skins.IStateClient;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.TextEvent.TEXT_INPUT
	 */
	[Event(name="textInput", type="flash.events.TextEvent")]
	
	/**
	 * <code>SkinnableTextBase</code> 类为可设置外观的文本输入控件基类.
	 * @author wizardc
	 */
	public class SkinnableTextBase extends SkinnableComponent
	{
		/**
		 * 皮肤子件, 实体文本输入组件.
		 */
		public var textDisplay:IEditableText;
		
		/**
		 * 皮肤子件, 当 <code>text</code> 属性为空字符串时要显示的文本.
		 */
		public var promptDisplay:IText;
		
		/**
		 * textDisplay 改变时传递的参数.
		 */
		private var _textDisplayProperties:Object = {};
		
		private var _prompt:String;
		
		/**
		 * 创建一个 <code>SkinnableTextBase</code> 对象.
		 */
		public function SkinnableTextBase()
		{
			super();
			this.focusEnabled = true;
			this.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			this.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
		}
		
		/**
		 * 焦点移入.
		 */
		private function focusInHandler(event:FocusEvent):void
		{
			if(event.target == this)
			{
				this.setFocus();
				return;
			}
			this.invalidateSkinState();
		}
		
		/**
		 * 焦点移出.
		 */
		private function focusOutHandler(event:FocusEvent):void
		{
			if(event.target == this)
			{
				return;
			}
			this.invalidateSkinState();
		}
		
		/**
		 * 设置或获取当 <code>text</code> 属性为空字符串时要显示的文本内容.
		 */
		public function set prompt(value:String):void
		{
			if(_prompt == value)
			{
				return;
			}
			_prompt = value;
			if(promptDisplay != null)
			{
				promptDisplay.text = value;
			}
			this.invalidateProperties();
			this.invalidateSkinState();
		}
		public function get prompt():String
		{
			return _prompt;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set maxWidth(value:Number):void
		{
			if(textDisplay != null)
			{
				textDisplay.maxWidth = value;
				_textDisplayProperties.maxWidth = true;
			}
			else
			{
				_textDisplayProperties.maxWidth = value;
			}
			this.invalidateProperties();
		}
		override public function get maxWidth():Number
		{
			if(textDisplay != null)
			{
				return textDisplay.maxWidth;
			}
			var v:* = _textDisplayProperties.maxWidth;
			return (v === undefined) ? super.maxWidth : v;
		}
		
		/**
		 * 设置或获取文本颜色.
		 */
		public function set textColor(value:uint):void
		{
			if(textDisplay != null)
			{
				textDisplay.textColor = value;
				_textDisplayProperties.textColor = true;
			}
			else
			{
				_textDisplayProperties.textColor = value;
			}
			this.invalidateProperties();
		}
		public function get textColor():uint
		{
			if(textDisplay != null)
			{
				return textDisplay.textColor;
			}
			var v:* = _textDisplayProperties.textColor;
			return (v === undefined) ? 0 : v;
		}
		
		/**
		 * 设置或获取指定文本字段是否是密码文本字段.
		 */
		public function set displayAsPassword(value:Boolean):void
		{
			if(textDisplay != null)
			{
				textDisplay.displayAsPassword = value;
				_textDisplayProperties.displayAsPassword = true;
			}
			else
			{
				_textDisplayProperties.displayAsPassword = value;
			}
			this.invalidateProperties();
		}
		public function get displayAsPassword():Boolean
		{
			if(textDisplay != null)
			{
				return textDisplay.displayAsPassword;
			}
			var v:* = _textDisplayProperties.displayAsPassword;
			return (v === undefined) ? false : v;
		}
		
		/**
		 * 设置或获取文本是否可编辑的标志.
		 */
		public function set editable(value:Boolean):void
		{
			if(textDisplay != null)
			{
				textDisplay.editable = value;
				_textDisplayProperties.editable = true;
			}
			else
			{
				_textDisplayProperties.editable = value;
			}
			this.invalidateProperties();
		}
		public function get editable():Boolean
		{
			if(textDisplay != null)
			{
				return textDisplay.editable;
			}
			var v:* = _textDisplayProperties.editable;
			return (v === undefined) ? true : v;
		}
		
		/**
		 * 设置或获取文本字段中最多可包含的字符数.
		 */
		public function set maxChars(value:int):void
		{
			if(textDisplay != null)
			{
				textDisplay.maxChars = value;
				_textDisplayProperties.maxChars = true;
			}
			else
			{
				_textDisplayProperties.maxChars = value;
			}
			this.invalidateProperties();
		}
		public function get maxChars():int
		{
			if(textDisplay != null)
			{
				return textDisplay.maxChars;
			}
			var v:* = _textDisplayProperties.maxChars;
			return (v === undefined) ? 0 : v;
		}
		
		/**
		 * 设置或获取用户可输入到文本字段中的字符集.
		 */
		public function set restrict(value:String):void
		{
			if(textDisplay != null)
			{
				textDisplay.restrict = value;
				_textDisplayProperties.restrict = true;
			}
			else
			{
				_textDisplayProperties.restrict = value;
			}
			this.invalidateProperties();
		}
		public function get restrict():String
		{
			if(textDisplay != null)
			{
				return textDisplay.restrict;
			}
			var v:* = _textDisplayProperties.restrict;
			return (v === undefined) ? null : v;
		}
		
		/**
		 * 设置或获取文本字段是否可选.
		 */
		public function set selectable(value:Boolean):void
		{
			if(textDisplay != null)
			{
				textDisplay.selectable = value;
				_textDisplayProperties.selectable = true;
			}
			else
			{
				_textDisplayProperties.selectable = value;
			}
			this.invalidateProperties();
		}
		public function get selectable():Boolean
		{
			if(textDisplay != null)
			{
				return textDisplay.selectable;
			}
			var v:* = _textDisplayProperties.selectable;
			return (v === undefined) ? true : v;
		}
		
		/**
		 * 获取当前所选内容中第一个字符从零开始的字符索引值. 如果未选定任何文本, 此属性为 <code>caretIndex</code> 的值.
		 */
		public function get selectionBeginIndex():int
		{
			if(textDisplay != null)
			{
				return textDisplay.selectionBeginIndex;
			}
			if(_textDisplayProperties.selectionBeginIndex === undefined)
			{
				return -1;
			}
			return _textDisplayProperties.selectionBeginIndex;
		}
		
		/**
		 * 设置或获取当前所选内容中最后一个字符从零开始的字符索引值. 如果未选定任何文本, 此属性为 <code>caretIndex</code> 的值.
		 */
		public function get selectionEndIndex():int
		{
			if(textDisplay != null)
			{
				return textDisplay.selectionEndIndex;
			}
			if(_textDisplayProperties.selectionEndIndex === undefined)
			{
				return -1;
			}
			return _textDisplayProperties.selectionEndIndex;
		}
		
		/**
		 * 获取插入点位置的索引.
		 */
		public function get caretIndex():int
		{
			return textDisplay != null ? textDisplay.caretIndex : 0;
		}
		
		/**
		 * 将第一个字符和最后一个字符的索引值指定的文本设置为所选内容.
		 * @param beginIndex 所选内容中第一个字符从零开始的索引值.
		 * @param endIndex 所选内容中最后一个字符从零开始的索引值.
		 */
		public function setSelection(beginIndex:int, endIndex:int):void
		{
			if(textDisplay != null)
			{
				textDisplay.setSelection(beginIndex, endIndex);
			}
			else
			{
				_textDisplayProperties.selectionBeginIndex = beginIndex;
				_textDisplayProperties.selectionEndIndex = endIndex;
			}
		}
		
		/**
		 * 选中所有文本.
		 */
		public function selectAll():void
		{
			if(textDisplay != null)
			{
				textDisplay.selectAll();
			}
			else if(_textDisplayProperties.text !== undefined)
			{
				setSelection(0, _textDisplayProperties.text.length);
			}
		}
		
		/**
		 * 设置或获取文本.
		 */
		public function set text(value:String):void
		{
			textDisplay.htmlText = null;
			_textDisplayProperties.htmlText = undefined;
			if(textDisplay != null)
			{
				textDisplay.text = value;
				_textDisplayProperties.text = true;
			}
			else
			{
				_textDisplayProperties.text = value;
				_textDisplayProperties.selectionBeginIndex = 0;
				_textDisplayProperties.selectionEndIndex = 0;
			}
			this.invalidateProperties();
			this.invalidateSkinState();
		}
		public function get text():String
		{
			if(textDisplay != null)
			{
				return textDisplay.text;
			}
			var v:* = _textDisplayProperties.text;
			return (v === undefined) ? "" : v;
		}
		
		/**
		 * 设置或获取 HTML 文本.
		 */
		public function set htmlText(value:String):void
		{
			textDisplay.text = null;
			_textDisplayProperties.text = undefined;
			if(textDisplay != null)
			{
				textDisplay.htmlText = value;
				_textDisplayProperties.htmlText = true;
			}
			else
			{
				_textDisplayProperties.htmlText = value;
				_textDisplayProperties.selectionBeginIndex = 0;
				_textDisplayProperties.selectionEndIndex = 0;
			}
			this.invalidateProperties();
			this.invalidateSkinState();
		}
		public function get htmlText():String
		{
			if(textDisplay != null)
			{
				return textDisplay.htmlText;
			}
			var v:* = _textDisplayProperties.htmlText;
			return (v === undefined) ? "" : v;
		}
		
		hammerc_internal function getWidthInChars():Number
		{
			var richEditableText:EditableText = textDisplay as EditableText;
			if(richEditableText != null)
			{
				return richEditableText.widthInChars;
			}
			var v:* = textDisplay != null ? undefined : _textDisplayProperties.widthInChars;
			return (v === undefined) ? NaN : v;
		}
		
		hammerc_internal function setWidthInChars(value:Number):void
		{
			if(textDisplay != null)
			{
				var richEditableText:EditableText = textDisplay as EditableText;
				if(richEditableText != null)
				{
					richEditableText.widthInChars = value;
				}
				_textDisplayProperties.widthInChars = true;
			}
			else
			{
				_textDisplayProperties.widthInChars = value;
			}
			this.invalidateProperties();
		}
		
		hammerc_internal function getHeightInLines():Number
		{
			var richEditableText:EditableText = textDisplay as EditableText;
			if(richEditableText != null)
			{
				return richEditableText.heightInLines;
			}
			var v:* = textDisplay ? undefined : _textDisplayProperties.heightInLines;        
			return (v === undefined) ? NaN : v;
		}
		
		hammerc_internal function setHeightInLines(value:Number):void
		{
			if(textDisplay != null)
			{
				var richEditableText:EditableText = textDisplay as EditableText;
				if(richEditableText != null)
				{
					richEditableText.heightInLines = value;
				}
				_textDisplayProperties.heightInLines = true;
			}
			else
			{
				_textDisplayProperties.heightInLines = value;
			}
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			var focus:InteractiveObject = HammercGlobals.stage.focus;
			if(_prompt != null && skin is IStateClient && (focus == null || !this.contains(focus)) && text == "")
			{
				if(this.enabled && IStateClient(skin).hasState("normalWithPrompt"))
				{
					return "normalWithPrompt";
				}
				if(!this.enabled && IStateClient(skin).hasState("disabledWithPrompt"))
				{
					return "disabledWithPrompt";
				}
			}
			return super.getCurrentSkinState();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == textDisplay)
			{
				textDisplayAdded();
				textDisplay.addEventListener(TextEvent.TEXT_INPUT, textDisplay_changingHandler);
				textDisplay.addEventListener(Event.CHANGE, textDisplay_changeHandler);
			}
			else if(instance == promptDisplay)
			{
				promptDisplay.text = _prompt;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == textDisplay)
			{
				textDisplayRemoved();
				textDisplay.removeEventListener(TextEvent.TEXT_INPUT, textDisplay_changingHandler);
				textDisplay.removeEventListener(Event.CHANGE, textDisplay_changeHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setFocus():void
		{
			if(textDisplay != null)
			{
				textDisplay.setFocus();
			}
			else
			{
				super.setFocus();
			}
		}
		
		/**
		 * 当皮肤不为 ISkin 时, 创建 TextDisplay 显示对象.
		 */
		hammerc_internal function createTextDisplay():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function removeSkinParts():void
		{
			if(textDisplay == null)
			{
				return;
			}
			this.partRemoved("textDisplay", textDisplay);
			this.removeFromDisplayList(textDisplay as DisplayObject);
			textDisplay = null;
		}
		
		/**
		 * textDisplay 附加.
		 */
		private function textDisplayAdded():void
		{
			var newTextDisplayProperties:Object = {};
			var richEditableText:EditableText = textDisplay as EditableText;
			if(_textDisplayProperties.displayAsPassword !== undefined)
			{
				textDisplay.displayAsPassword = _textDisplayProperties.displayAsPassword;
				newTextDisplayProperties.displayAsPassword = true;
			}
			if(_textDisplayProperties.textColor !== undefined)
			{
				textDisplay.textColor = _textDisplayProperties.textColor;
				newTextDisplayProperties.textColor = true;
			}
			if(_textDisplayProperties.editable !== undefined)
			{
				textDisplay.editable = _textDisplayProperties.editable;
				newTextDisplayProperties.editable = true;
			}
			if(_textDisplayProperties.maxChars !== undefined)
			{
				textDisplay.maxChars = _textDisplayProperties.maxChars;
				newTextDisplayProperties.maxChars = true;
			}
			if(_textDisplayProperties.maxHeight !== undefined)
			{
				textDisplay.maxHeight = _textDisplayProperties.maxHeight;
				newTextDisplayProperties.maxHeight = true;
			}
			if(_textDisplayProperties.maxWidth !== undefined)
			{
				textDisplay.maxWidth = _textDisplayProperties.maxWidth;
				newTextDisplayProperties.maxWidth = true;
			}
			if(_textDisplayProperties.restrict !== undefined)
			{
				textDisplay.restrict = _textDisplayProperties.restrict;
				newTextDisplayProperties.restrict = true;
			}
			if(_textDisplayProperties.selectable !== undefined)
			{
				textDisplay.selectable = _textDisplayProperties.selectable;
				newTextDisplayProperties.selectable = true;
			}
			if(_textDisplayProperties.text !== undefined)
			{
				textDisplay.text = _textDisplayProperties.text;
				newTextDisplayProperties.text = true;
			}
			if(_textDisplayProperties.htmlText !== undefined)
			{
				textDisplay.htmlText = _textDisplayProperties.htmlText;
				newTextDisplayProperties.htmlText = true;
			}
			if(_textDisplayProperties.selectionBeginIndex !== undefined)
			{
				textDisplay.setSelection(_textDisplayProperties.selectionBeginIndex, _textDisplayProperties.selectionEndIndex);
			}
			if(_textDisplayProperties.widthInChars !== undefined && richEditableText)
			{
				richEditableText.widthInChars = _textDisplayProperties.widthInChars;
				newTextDisplayProperties.widthInChars = true;
			}
			if(_textDisplayProperties.heightInLines !== undefined && richEditableText)
			{
				richEditableText.heightInLines = _textDisplayProperties.heightInLines;
				newTextDisplayProperties.heightInLines = true;
			}
			_textDisplayProperties = newTextDisplayProperties;
		}
		
		/**
		 * textDisplay 移除.
		 */
		private function textDisplayRemoved():void
		{
			var newTextDisplayProperties:Object = {};
			var richEditableText:EditableText = textDisplay as EditableText;
			if(_textDisplayProperties.displayAsPassword)
			{
				newTextDisplayProperties.displayAsPassword = textDisplay.displayAsPassword;
			}
			if(_textDisplayProperties.textColor)
			{
				newTextDisplayProperties.textColor = textDisplay.textColor;
			}
			if(_textDisplayProperties.editable)
			{
				newTextDisplayProperties.editable = textDisplay.editable;
			}
			if(_textDisplayProperties.maxChars)
			{
				newTextDisplayProperties.maxChars = textDisplay.maxChars;
			}
			if(_textDisplayProperties.maxHeight)
			{
				newTextDisplayProperties.maxHeight = textDisplay.maxHeight;
			}
			if(_textDisplayProperties.maxWidth)
			{
				newTextDisplayProperties.maxWidth = textDisplay.maxWidth;
			}
			if(_textDisplayProperties.restrict)
			{
				newTextDisplayProperties.restrict = textDisplay.restrict;
			}
			if(_textDisplayProperties.selectable)
			{
				newTextDisplayProperties.selectable = textDisplay.selectable;
			}
			if(_textDisplayProperties.text)
			{
				newTextDisplayProperties.text = textDisplay.text;
			}
			if(_textDisplayProperties.htmlText)
			{
				newTextDisplayProperties.htmlText = textDisplay.htmlText;
			}
			if(_textDisplayProperties.heightInLines&& richEditableText)
			{
				newTextDisplayProperties.heightInLines = richEditableText.heightInLines;
			}
			if(_textDisplayProperties.widthInChars && richEditableText)
			{
				newTextDisplayProperties.widthInChars = richEditableText.widthInChars;
			}
			_textDisplayProperties = newTextDisplayProperties;
		}
		
		/**
		 * textDisplay 文字改变事件.
		 */
		private function textDisplay_changeHandler(event:Event):void
		{
			this.invalidateDisplayList();
			this.dispatchEvent(event);
		}
		
		/**
		 * textDisplay 文字即将改变事件.
		 */
		private function textDisplay_changingHandler(event:TextEvent):void
		{
			var newEvent:Event = event.clone();
			this.dispatchEvent(newEvent);
			if(newEvent.isDefaultPrevented())
			{
				event.preventDefault();
			}
		}
	}
}
