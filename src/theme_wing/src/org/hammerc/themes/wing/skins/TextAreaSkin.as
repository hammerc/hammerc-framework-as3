// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.themes.wing.skins
{
	import org.hammerc.components.Scroller;
	
	/**
	 * <code>TextAreaSkin</code> 类定义了可设置外观的多行文本输入控件的皮肤.
	 * @author wizardc
	 */
	public class TextAreaSkin extends TextInputSkin
	{
		/**
		 * 皮肤子件, 实体滚动条组件.
		 */
		public var scroller:Scroller;
		
		/**
		 * 创建一个 <code>TextAreaSkin</code> 对象.
		 */
		public function TextAreaSkin()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			scroller = new Scroller();
			scroller.minViewportInset = 1;
			scroller.measuredSizeIncludesScrollBars = false;
			scroller.viewport = textDisplay;
			this.addElement(scroller);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentStyle(styleProperty:String, hasSet:Boolean, value:* = null):void
		{
			super.commitCurrentStyle(styleProperty, hasSet, value);
			switch(styleProperty)
			{
				case "paddingTop":
					scroller.left = value;
					break;
				case "paddingBottom":
					scroller.top = value;
					break;
				case "paddingLeft":
					scroller.right = value;
					break;
				case "paddingRight":
					scroller.bottom = value;
					break;
			}
		}
	}
}
