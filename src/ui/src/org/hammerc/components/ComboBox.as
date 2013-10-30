/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import org.hammerc.components.supportClasses.DropDownListBase;
	import org.hammerc.components.supportClasses.ListBase;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.UIEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ComboBox</code> 类实现了带输入框的下拉列表控件.
	 * @author wizardc
	 */
	public class ComboBox extends DropDownListBase
	{
		/**
		 * 当用户在文本输入框中输入值且该值被提交时, 用来表示当前选中项索引的静态常量.
		 */
		private static const CUSTOM_SELECTED_ITEM:int = ListBase.CUSTOM_SELECTED_ITEM;
		
		/**
		 * 皮肤子件, 文本输入控件.
		 */
		public var textInput:TextInput;
		
		private var _actualProposedSelectedIndex:Number = NO_SELECTION;
		
		private var _userTypedIntoText:Boolean;
		
		/**
		 * 文本改变前上一次的文本内容.
		 */
		private var _previousTextInputText:String = "";
		
		private var _itemMatchingFunction:Function;
		
		private var _labelToItemFunction:Function;
		private var _labelToItemFunctionChanged:Boolean = false;
		
		private var _prompt:String;
		private var _promptChanged:Boolean = false;
		
		private var _maxChars:int = 0;
		private var _maxCharsChanged:Boolean = false;
		
		private var _restrict:String;
		private var _restrictChanged:Boolean;
		
		private var _openOnInput:Boolean = true;
		
		/**
		 * 创建一个 <code>ComboBox</code> 对象.
		 */
		public function ComboBox()
		{
			super();
			_allowCustomSelectedItem = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return ComboBox;
		}
		
		/**
		 * 设置或获取当用户在提示区域中输入字符时, 用于根据输入文字返回匹配的数据项索引列表的回调函数.
		 * <p>示例: <code>function myMatchingFunction(comboBox:ComboBox, inputText:String):Vector.&lt;int&gt;</code></p>
		 */
		public function set itemMatchingFunction(value:Function):void
		{
			_itemMatchingFunction = value;
		}
		public function get itemMatchingFunction():Function
		{
			return _itemMatchingFunction;
		}
		
		/**
		 * 设置或获取指定用于将在提示区域中输入的新值转换为与数据提供程序中的数据项具有相同数据类型的回调函数.
		 * <p>当提示区域中的文本提交且在数据提供程序中未找到时, 将调用该属性引用的函数.<br/>
		 * 示例: <code>function myLabelToItem(value:String):Object</code></p>
		 */
		public function set labelToItemFunction(value:Function):void
		{
			if(value == _labelToItemFunction)
			{
				return;
			}
			_labelToItemFunction = value;
			_labelToItemFunctionChanged = true;
			this.invalidateProperties();
		}
		public function get labelToItemFunction():Function
		{
			return _labelToItemFunction;
		}
		
		/**
		 * 设置或获取输入文本为空时要显示的文本.
		 */
		public function set prompt(value:String):void
		{
			if(_prompt == value)
			{
				return;
			}
			_prompt = value;
			_promptChanged = true;
			this.invalidateProperties();
		}
		public function get prompt():String
		{
			return _prompt;
		}
		
		/**
		 * 设置或获取文本输入框中最多可包含的字符数, 0 值为无限制.
		 */
		public function set maxChars(value:int):void
		{
			if(value == _maxChars)
			{
				return;
			}
			_maxChars = value;
			_maxCharsChanged = true;
			this.invalidateProperties();
		}
		public function get maxChars():int
		{
			return _maxChars;
		}
		
		/**
		 * 设置或获取表示用户可输入到文本字段中的字符集.
		 */
		public function set restrict(value:String):void
		{
			if(value == _restrict)
			{
				return;
			}
			_restrict = value;
			_restrictChanged = true;
			this.invalidateProperties();
		}
		public function get restrict():String
		{
			return _restrict;
		}
		
		/**
		 * 设置或获取用户在文本输入框编辑时是否会打开下拉列表.
		 */
		public function set openOnInput(value:Boolean):void
		{
			_openOnInput = value;
		}
		public function get openOnInput():Boolean
		{
			return _openOnInput;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set selectedIndex(value:int):void
		{
			super.selectedIndex = value;
			_actualProposedSelectedIndex = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function set userProposedSelectedIndex(value:Number):void
		{
			super.userProposedSelectedIndex = value;
			_actualProposedSelectedIndex = value;
		}
		
		/**
		 * 处理正在输入文本的操作, 搜索并匹配数据项.
		 */
		private function processInputField():void
		{
			var matchingItems:Vector.<int>;
			_actualProposedSelectedIndex = CUSTOM_SELECTED_ITEM;
			if(this.dataProvider == null || this.dataProvider.length <= 0)
			{
				return;
			}
			if(textInput.text != "")
			{
				if(_itemMatchingFunction != null)
				{
					matchingItems = _itemMatchingFunction(this, textInput.text);
				}
				else
				{
					matchingItems = findMatchingItems(textInput.text);
				}
				if(matchingItems.length > 0)
				{
					super.changeHighlightedSelection(matchingItems[0], true);
					var typedLength:int = textInput.text.length;
					var item:Object = this.dataProvider != null ? this.dataProvider.getItemAt(matchingItems[0]) : undefined;
					if(item != null)
					{
						var itemString:String = this.itemToLabel(item);
						_previousTextInputText = textInput.text = itemString;
						textInput.setSelection(typedLength, itemString.length);
					}
				}
				else
				{
					super.changeHighlightedSelection(CUSTOM_SELECTED_ITEM);
				}
			}
			else
			{
				super.changeHighlightedSelection(NO_SELECTION);
			}
		}
		
		/**
		 * 根据指定字符串找到匹配的数据项索引列表.
		 */
		private function findMatchingItems(input:String):Vector.<int>
		{
			var startIndex:int;
			var stopIndex:int;
			var retVal:int;
			var retVector:Vector.<int> = new Vector.<int>;
			retVal = findStringLoop(input, 0, this.dataProvider.length);
			if(retVal != -1)
			{
				retVector.push(retVal);
			}
			return retVector;
		}
		
		/**
		 * 在数据源中查询指定索引区间的数据项, 返回数据字符串与 str 开头匹配的数据项索引.
		 */
		private function findStringLoop(str:String, startIndex:int, stopIndex:int):Number
		{
			for(startIndex; startIndex != stopIndex; startIndex++)
			{
				var itmStr:String = this.itemToLabel(this.dataProvider.getItemAt(startIndex));
				itmStr = itmStr.substring(0, str.length);
				if(str == itmStr || str.toUpperCase() == itmStr.toUpperCase())
				{
					return startIndex;
				}
			}
			return -1;
		}
		
		private function getCustomSelectedItem():*
		{
			var input:String = textInput.text;
			if(input == "")
			{
				return undefined;
			}
			else if(labelToItemFunction != null)
			{
				return _labelToItemFunction(input);
			}
			else
			{
				return input;
			}
		}
		
		hammerc_internal function applySelection():void
		{
			if(_actualProposedSelectedIndex == CUSTOM_SELECTED_ITEM)
			{
				var itemFromInput:* = getCustomSelectedItem();
				if(itemFromInput != undefined)
				{
					this.setSelectedItem(itemFromInput, true);
				}
				else
				{
					this.setSelectedIndex(NO_SELECTION, true);
				}
			}
			else
			{
				setSelectedIndex(_actualProposedSelectedIndex, true);
			}
			if(textInput != null)
			{
				textInput.setSelection(-1, -1);
			}
			_userTypedIntoText = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			var selectedIndexChanged:Boolean = _proposedSelectedIndex != NO_PROPOSED_SELECTION;
			if(_proposedSelectedIndex == CUSTOM_SELECTED_ITEM && _pendingSelectedItem == undefined)
			{
				_proposedSelectedIndex = NO_PROPOSED_SELECTION;
			}
			super.commitProperties();
			if(textInput != null)
			{
				if(_promptChanged)
				{
					textInput.prompt = _prompt;
					_promptChanged = false;
				}
				if(_maxCharsChanged)
				{
					textInput.maxChars = _maxChars;
					_maxCharsChanged = false;
				}
				if(_restrictChanged)
				{
					textInput.restrict = _restrict;
					_restrictChanged = false;
				}
			}
			if(selectedIndexChanged && selectedIndex == NO_SELECTION)
			{
				_previousTextInputText = textInput.text = "";
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function updateLabelDisplay(displayItem:* = undefined):void
		{
			super.updateLabelDisplay();
			if(textInput != null)
			{
				if(displayItem == undefined)
				{
					displayItem = this.selectedItem;
				}
				if(displayItem != null && displayItem != undefined)
				{
					_previousTextInputText = textInput.text = this.itemToLabel(displayItem);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == textInput)
			{
				this.updateLabelDisplay();
				textInput.addEventListener(Event.CHANGE, this.textInput_changeHandler);
				textInput.maxChars = this.maxChars;
				textInput.restrict = this.restrict;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == textInput)
			{
				textInput.removeEventListener(Event.CHANGE, this.textInput_changeHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function changeHighlightedSelection(newIndex:int, scrollToTop:Boolean = false):void
		{
			super.changeHighlightedSelection(newIndex, scrollToTop);
			if(newIndex >= 0)
			{
				var item:Object = this.dataProvider != null ? this.dataProvider.getItemAt(newIndex) : undefined;
				if(item != null && textInput != null)
				{
					var itemString:String = this.itemToLabel(item);
					_previousTextInputText = textInput.text = itemString;
					textInput.selectAll();
					_userTypedIntoText = false;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setFocus():void
		{
			if(stage != null && textInput != null)
			{
				stage.focus = textInput.textDisplay as InteractiveObject;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function dropDownController_openHandler(event:UIEvent):void
		{
			super.dropDownController_openHandler(event);
			this.userProposedSelectedIndex = _userTypedIntoText ? NO_SELECTION : this.selectedIndex;  
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dropDownController_closeHandler(event:UIEvent):void
		{
			super.dropDownController_closeHandler(event);
			if(!event.isDefaultPrevented())
			{
				this.applySelection();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function itemRemoved(index:int):void
		{
			if(index == this.selectedIndex)
			{
				this.updateLabelDisplay("");
			}
			super.itemRemoved(index);
		}
		
		/**
		 * 文本输入改变事件处理函数.
		 */
		protected function textInput_changeHandler(event:Event):void
		{
			_userTypedIntoText = true;
			if(_previousTextInputText.length > textInput.text.length)
			{
				super.changeHighlightedSelection(CUSTOM_SELECTED_ITEM);
			}
			else if(_previousTextInputText != textInput.text)
			{
				if(_openOnInput)
				{
					if(!this.isDropDownOpen)
					{
						this.openDropDown();
						this.addEventListener(UIEvent.OPEN, editingOpenHandler);
						return;
					}
				}
				processInputField();
			}
			_previousTextInputText = textInput.text;
		}
		
		/**
		 * 第一次输入等待下拉列表打开后在处理数据匹配.
		 */
		private function editingOpenHandler(event:UIEvent):void
		{
			this.removeEventListener(UIEvent.OPEN, editingOpenHandler);
			processInputField();
		}
	}
}
