// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.themes.hi.skins
{
	import org.hammerc.components.HScrollBar;
	import org.hammerc.components.VScrollBar;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ScrollerSkin</code> 类定义了滚动条控件的皮肤.
	 * @author wizardc
	 */
	public class ScrollerSkin extends HiSkin
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
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			horizontalScrollBar = new HScrollBar();
			horizontalScrollBar.visible = false;
			this.addElement(horizontalScrollBar);
			verticalScrollBar = new VScrollBar();
			verticalScrollBar.visible = false;
			this.addElement(verticalScrollBar);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
