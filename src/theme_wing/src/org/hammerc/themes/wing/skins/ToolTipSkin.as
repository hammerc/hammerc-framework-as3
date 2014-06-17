/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.hammerc.components.TextToolTip;
	import org.hammerc.core.IToolTip;
	import org.hammerc.core.UIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.display.GraphicsScaleBitmap;
	import org.hammerc.display.ScaleBitmapDrawMode;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	import org.hammerc.utils.WeakReference;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ToolTipSkin</code> 类定义了文本工具提示的皮肤.
	 * @author wizardc
	 */
	public class ToolTipSkin extends UIComponent implements IToolTip
	{
		/**
		 * 组件最大宽度.
		 */
		public static var maxWidth:Number = 300;
		
		/**
		 * 背景皮肤引用.
		 */
		hammerc_internal static const backgroundSkin:WeakReference = new WeakReference();
		
		private var _toolTipData:Object;
		private var _toolTipDataChanged:Boolean;
		
		private var _textField:TextField;
		private var _background:GraphicsScaleBitmap;
		
		/**
		 * 创建一个 <code>ToolTipSkin</code> 对象.
		 */
		public function ToolTipSkin()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.minWidth = 10;
			this.minHeight = 10;
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
			createBackground();
			createTextField();
		}
		
		private function createBackground():void
		{
			var bitmapData:BitmapData = backgroundSkin.target as BitmapData;
			if(bitmapData == null)
			{
				bitmapData = new ToolTip_bgSkin() as BitmapData;
				backgroundSkin.target = bitmapData;
			}
			_background = new GraphicsScaleBitmap(bitmapData, new Rectangle(5, 5, 32, 9), ScaleBitmapDrawMode.SCALE_9_GRID, WingSkin.smoothing, false);
			this.addChild(_background);
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
			tf.font = "Verdana";
			tf.color = 0xffffff;
			_textField.defaultTextFormat = tf;
			WingEffectUtil.setTextGlow(_textField);
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
				_textField.htmlText = _toolTipData as String;
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
			_background.width = unscaledWidth;
			_background.height = unscaledHeight;
			_background.drawBitmap();
		}
	}
}
