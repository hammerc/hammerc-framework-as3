/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.hammerc.components.supportClasses.SkinnableTextBase;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TextArea</code> 类实现了可设置外观的多行文本输入控件.
	 * @author wizardc
	 */
	public class TextArea extends SkinnableTextBase
	{
		/**
		 * 皮肤子件, 实体滚动条组件.
		 */
		public var scroller:Scroller;
		
		private var _horizontalScrollPolicy:String;
		private var _horizontalScrollPolicyChanged:Boolean = false;
		
		private var _verticalScrollPolicy:String;
		private var _verticalScrollPolicyChanged:Boolean = false;
		
		/**
		 * 创建一个 <code>TextArea</code> 对象.
		 */
		public function TextArea()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TextArea;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "TextArea";
		}
		
		/**
		 * 设置或获取控件的默认宽度 (使用字号为单位测量). 若同时设置了 <code>maxChars</code> 属性, 将会根据两者测量结果的最小值作为测量宽度.
		 */
		public function set widthInChars(value:Number):void
		{
			this.setWidthInChars(value);
		}
		public function get widthInChars():Number
		{
			return this.getWidthInChars();
		}
		
		/**
		 * 设置或获取控件的默认高度 (以行为单位测量). 若设置了 <code>multiline</code> 属性为 false, 则忽略此属性.
		 */
		public function set heightInLines(value:Number):void
		{
			this.setHeightInLines(value);
		}
		public function get heightInLines():Number
		{
			return this.getHeightInLines();
		}
		
		/**
		 * 设置或获取水平滚动条显示策略.
		 */
		public function set horizontalScrollPolicy(value:String):void
		{
			if(_horizontalScrollPolicy == value)
			{
				return;
			}
			_horizontalScrollPolicy = value;
			_horizontalScrollPolicyChanged = true;
			this.invalidateProperties();
		}
		public function get horizontalScrollPolicy():String
		{
			return _horizontalScrollPolicy;
		}
		
		/**
		 * 设置或获取垂直滚动条显示策略.
		 */
		public function set verticalScrollPolicy(value:String):void
		{
			if(_verticalScrollPolicy == value)
			{
				return;
			}
			_verticalScrollPolicy = value;
			_verticalScrollPolicyChanged = true;
			this.invalidateProperties();
		}
		public function get verticalScrollPolicy():String
		{
			return _verticalScrollPolicy;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set text(value:String):void
		{
			super.text = value;
			this.dispatchEvent(new Event("textChanged"));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_horizontalScrollPolicyChanged)
			{
				if(scroller != null)
				{
					scroller.horizontalScrollPolicy = horizontalScrollPolicy;
				}
				_horizontalScrollPolicyChanged = false;
			}
			if(_verticalScrollPolicyChanged)
			{
				if(scroller != null)
				{
					scroller.verticalScrollPolicy = verticalScrollPolicy;
				}
				_verticalScrollPolicyChanged = false;
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
				textDisplay.multiline = true;
			}
			else if(instance == scroller)
			{
				if(scroller.horizontalScrollBar != null)
				{
					scroller.horizontalScrollBar.snapInterval = 0;
				}
				if(scroller.verticalScrollBar != null)
				{
					scroller.verticalScrollBar.snapInterval = 0;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function createSkinParts():void
		{
			textDisplay = new EditableText();
			textDisplay.widthInChars = 15;
			textDisplay.heightInLines = 10;
			this.addToDisplayList(DisplayObject(textDisplay));
			this.partAdded("textDisplay", textDisplay);
		}
	}
}
