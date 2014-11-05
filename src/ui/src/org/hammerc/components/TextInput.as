// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.hammerc.components.supportClasses.SkinnableTextBase;
	import org.hammerc.core.IViewport;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TextInput</code> 类实现了可设置外观的单行文本输入控件.
	 * @author wizardc
	 */
	public class TextInput extends SkinnableTextBase
	{
		/**
		 * 创建一个 <code>TextInput</code> 对象.
		 */
		public function TextInput()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TextInput;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "TextInput";
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
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == textDisplay)
			{
				textDisplay.multiline = false;
				if(textDisplay is IViewport)
				{
					(textDisplay as IViewport).clipAndEnableScrolling = false;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function createSkinParts():void
		{
			textDisplay = new EditableText();
			textDisplay.widthInChars = 10;
			textDisplay.left = 1;
			textDisplay.right = 1;
			textDisplay.top = 1;
			textDisplay.bottom = 1;
			this.addToDisplayList(DisplayObject(textDisplay));
			this.partAdded("textDisplay", textDisplay);
		}
	}
}
