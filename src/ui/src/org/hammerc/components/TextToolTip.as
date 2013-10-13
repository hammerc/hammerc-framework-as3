/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.hammerc.core.IToolTip;
	import org.hammerc.core.UIComponent;
	
	/**
	 * <code>TextToolTip</code> 类实现了文本工具提示.
	 * @author wizardc
	 */
	public class TextToolTip extends UIComponent implements IToolTip
	{
		/**
		 * 组件最大宽度.
		 */
		public static var maxWidth:Number = 300;
		
		private var _toolTipData:Object;
		private var _toolTipDataChanged:Boolean;
		
		private var _textField:TextField;
		
		/**
		 * 创建一个 <code>TextToolTip</code> 对象.
		 */
		public function TextToolTip()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTipData(value:Object):void
		{
			if(_toolTipData != value)
			{
				_toolTipData = value;
				_toolTipDataChanged = true;
				this.invalidateProperties();
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		public function get toolTipData():Object
		{
			return _toolTipData;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			createTextField();
			this.filters = [new DropShadowFilter(1, 45, 0, 0.7, 2, 2, 1, 1)];
		}
		
		private function drawBackground():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.7);
			this.graphics.drawRoundRect(0, 0, this.width, this.height, 5, 5);
			this.graphics.endFill();
		}
		
		private function createTextField():void
		{
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.mouseEnabled = false;
			_textField.multiline = true;
			_textField.selectable = false;
			_textField.wordWrap = false;
			var tf:TextFormat = _textField.getTextFormat();
			tf.font = "SimSun";
			tf.color = 0xffffff;
			_textField.defaultTextFormat = tf;
			this.addChild(_textField);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_toolTipDataChanged)
			{
				_textField.text = _toolTipData as String;
				_toolTipDataChanged = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			var widthSlop:Number = 10;
			var heightSlop:Number = 10;
			_textField.wordWrap = false;
			if(_textField.textWidth + 5 + widthSlop > TextToolTip.maxWidth)
			{
				_textField.width = TextToolTip.maxWidth - widthSlop;
				_textField.wordWrap = true;
			}
			this.measuredWidth = _textField.width + widthSlop;
			this.measuredHeight = _textField.height + heightSlop;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var widthSlop:Number = 10;
			var heightSlop:Number = 10;
			_textField.x = 5;
			_textField.y = 5;
			_textField.width = unscaledWidth - widthSlop;
			_textField.height = unscaledHeight - heightSlop;
			drawBackground();
		}
	}
}
