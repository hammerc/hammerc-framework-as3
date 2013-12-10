/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.hammerc.events.UIEvent;
	
	/**
	 * @eventType org.hammerc.events.UIEvent.VALUE_COMMIT
	 */
	[Event(name="valueCommit", type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>NumericStepper</code> 类实现了从有序集中选择或编辑值的组件.
	 * @author wizardc
	 */
	public class NumericStepper extends Spinner
	{
		/**
		 * 皮肤子件, 编辑文本.
		 */
		public var textDisplay:EditableText;
		
		private var _maxChanged:Boolean = false;
		private var _stepSizeChanged:Boolean = false;
		
		private var _maxChars:int = 0;
		private var _maxCharsChanged:Boolean = false;
		
		private var _valueParseFunction:Function;
		private var _valueParseFunctionChanged:Boolean = false;
		
		private var _valueFormatFunction:Function;
		private var _valueFormatFunctionChanged:Boolean = false;
		
		/**
		 * 创建一个 <code>NumericStepper</code> 对象.
		 */
		public function NumericStepper()
		{
			super();
			this.maximum = 10;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return NumericStepper;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "NumericStepper";
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set maximum(value:Number):void
		{
			_maxChanged = true;
			super.maximum = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set stepSize(value:Number):void
		{
			_stepSizeChanged = true;
			super.stepSize = value;
		}
		
		/**
		 * 设置或获取字段中最多可输入的字符数.
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
		 * 设置或获取从字段中显示的值提取数值的函数.
		 * <p>示例: <code>function valueParseFunc(text:String):Number</code>.</p>
		 */
		public function set valueParseFunction(value:Function):void
		{
			_valueParseFunction = value;
			_valueParseFunctionChanged = true;
			this.invalidateProperties();
		}
		public function get valueParseFunction():Function
		{
			return _valueParseFunction;
		}
		
		/**
		 * 设置或获取对字段中显示的值设置格式的函数.
		 * <p>示例: <code>function valueFormatFunc(number:Number):String</code>.</p>
		 */
		public function set valueFormatFunction(value:Function):void
		{
			_valueFormatFunction = value;
			_valueFormatFunctionChanged = true;
			this.invalidateProperties();
		}
		public function get valueFormatFunction():Function
		{
			return _valueFormatFunction;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_maxChanged || _stepSizeChanged || _valueFormatFunctionChanged)
			{
				textDisplay.widthInChars = calculateWidestValue();
				_maxChanged = false;
				_stepSizeChanged = false;
				if(_valueFormatFunctionChanged)
				{
					applyDisplayFormatFunction();
					_valueFormatFunctionChanged = false;
				}
			}
			if(_valueParseFunctionChanged)
			{
				commitTextInput(false);
				_valueParseFunctionChanged = false;
			}
			if(_maxCharsChanged)
			{
				textDisplay.maxChars = _maxChars;
				_maxCharsChanged = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setValue(newValue:Number):void
		{
			super.setValue(newValue);
			applyDisplayFormatFunction();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function changeValueByStep(increase:Boolean = true):void
		{
			commitTextInput();
			super.changeValueByStep(increase);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setFocus():void
		{
			if(this.stage != null)
			{
				this.stage.focus = textDisplay;
				if(textDisplay != null && (textDisplay.editable || textDisplay.selectable))
				{
					textDisplay.selectAll();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == textDisplay)
			{
				textDisplay.addEventListener(KeyboardEvent.KEY_UP, textDisplay_keyUpHandler);
				textDisplay.addEventListener(FocusEvent.FOCUS_OUT, textDisplay_focusOutHandler); 
				textDisplay.focusEnabled = false;
				textDisplay.maxChars = _maxChars;
				textDisplay.restrict = "0-9\\-\\.\\,";
				textDisplay.text = value.toString();
				textDisplay.widthInChars = calculateWidestValue();
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
				textDisplay.removeEventListener(KeyboardEvent.KEY_UP, textDisplay_keyUpHandler);
			}
		}
		
		private function commitTextInput(dispatchChange:Boolean = false):void
		{
			var inputValue:Number;
			var prevValue:Number = value;
			if(this.valueParseFunction != null)
			{
				inputValue = this.valueParseFunction.call(textDisplay.text);
			}
			else
			{
				inputValue = parseFloat(textDisplay.text);
				if(isNaN(inputValue))
				{
					inputValue = this.minimum;
				}
			}
			if((textDisplay.text != null && textDisplay.text.length != this.value.toString().length) || textDisplay.text == "" || (inputValue != this.value && (Math.abs(inputValue - this.value) >= 0.000001 || isNaN(inputValue))))
			{
				this.setValue(this.nearestValidValue(inputValue, this.snapInterval));
				if(this.value == prevValue && inputValue != prevValue)
				{
					this.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
				}
			}
			if(dispatchChange)
			{
				if(this.value != prevValue)
				{
					this.dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		private function calculateWidestValue():Number
		{
			var widestNumber:Number = this.minimum.toString().length > this.maximum.toString().length ? this.minimum : this.maximum;
			widestNumber += this.stepSize;
			if(this.valueFormatFunction != null)
			{
				return this.valueFormatFunction.call(widestNumber).length;
			}
			else
			{
				return widestNumber.toString().length;
			}
		}
		
		private function applyDisplayFormatFunction():void
		{
			if(this.valueFormatFunction != null)
			{
				textDisplay.text = this.valueFormatFunction.call(this.value);
			}
			else
			{
				textDisplay.text = this.value.toString();
			}
		}
		
		private function textDisplay_keyUpHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				commitTextInput(true);
			}
		}
		
		private function textDisplay_focusOutHandler(event:Event):void
		{
			commitTextInput(true);
		}
	}
}
