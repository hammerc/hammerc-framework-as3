/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import org.hammerc.components.DataGroup;
	import org.hammerc.components.Scroller;
	import org.hammerc.layouts.HorizontalAlign;
	import org.hammerc.layouts.VerticalLayout;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>ListSkin</code> 类定义了列表控件的皮肤.
	 * @author wizardc
	 */
	public class ListSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 内容容器.
		 */
		public var dataGroup:DataGroup;
		
		/**
		 * 创建一个 <code>ListSkin</code> 对象.
		 */
		public function ListSkin()
		{
			super();
			this.minWidth = 70;
			this.minHeight = 70;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			dataGroup = new DataGroup();
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
			dataGroup.layout = layout;
			var scroller:Scroller = new Scroller();
			scroller.left = 0;
			scroller.top = 0;
			scroller.right = 0;
			scroller.bottom = 0;
			scroller.minViewportInset = 0;
			scroller.viewport = dataGroup;
			this.addElement(scroller);
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
