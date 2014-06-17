/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import org.hammerc.components.DataGroup;
	import org.hammerc.layouts.HorizontalAlign;
	import org.hammerc.layouts.HorizontalLayout;
	import org.hammerc.layouts.VerticalAlign;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>TabBarSkin</code> 类定义了选项卡控件的皮肤.
	 * @author wizardc
	 */
	public class TabBarSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 内容容器.
		 */
		public var dataGroup:DataGroup;
		
		/**
		 * 创建一个 <code>TabBarSkin</code> 对象.
		 */
		public function TabBarSkin()
		{
			super();
			this.minWidth = 60;
			this.minHeight = 20;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			dataGroup = new DataGroup();
			dataGroup.percentWidth = 100;
			dataGroup.percentHeight = 100;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = -1;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.CONTENT_JUSTIFY;
			dataGroup.layout = layout;
			this.addElement(dataGroup);
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
