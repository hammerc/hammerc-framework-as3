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
	import org.hammerc.components.HScrollBar;
	import org.hammerc.components.VScrollBar;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>ScrollerSkin</code> 类定义了滚动条控件的皮肤.
	 * @author wizardc
	 */
	public class ScrollerSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 水平滚动条.
		 */
		public var horizontalScrollBar:HScrollBar;
		
		/**
		 * 皮肤子件, 垂直滚动条.
		 */
		public var verticalScrollBar:VScrollBar;
		
		/**
		 * 创建一个 <code>ScrollerSkin</code> 对象.
		 */
		public function ScrollerSkin()
		{
			super();
			this.minWidth = 10;
			this.minHeight = 10;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			horizontalScrollBar = new HScrollBar();
			horizontalScrollBar.height = 16;
			horizontalScrollBar.visible = false;
			this.addElement(horizontalScrollBar);
			verticalScrollBar = new VScrollBar();
			verticalScrollBar.width = 16;
			verticalScrollBar.visible = false;
			this.addElement(verticalScrollBar);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			if(this.currentState == "disabled")
			{
				WingEffectUtil.setGray(this);
			}
			else
			{
				WingEffectUtil.clearGray(this);
			}
		}
	}
}
