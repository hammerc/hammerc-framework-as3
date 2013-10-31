/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import org.hammerc.components.Group;
	import org.hammerc.components.ToggleButton;
	import org.hammerc.components.UIAsset;
	import org.hammerc.layouts.HorizontalLayout;
	import org.hammerc.layouts.VerticalAlign;
	
	/**
	 * <code>TreeItemRendererSkin</code> 类定义了树形组件的项呈示器的皮肤.
	 * @author wizardc
	 */
	public class TreeItemRendererSkin extends ItemRendererSkin
	{
		/**
		 * 皮肤子件, 图标显示对象.
		 */
		public var iconDisplay:UIAsset;
		
		/**
		 * 皮肤子件, 子节点开启按钮.
		 */
		public var disclosureButton:ToggleButton;
		
		/**
		 * 皮肤子件, 用于调整缩进值的容器对象.
		 */
		public var contentGroup:Group;
		
		/**
		 * 创建一个 <code>TreeItemRendererSkin</code> 对象.
		 */
		public function TreeItemRendererSkin()
		{
			super();
			this.minHeight = 22;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			contentGroup = new Group();
			contentGroup.top = 0;
			contentGroup.bottom = 0;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 1;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			contentGroup.layout = layout;
			this.addElement(contentGroup);
			disclosureButton = new ToggleButton();
			disclosureButton.skinName = TreeDisclosureButtonSkin;
			this.contentGroup.addElement(disclosureButton);
			iconDisplay = new UIAsset();
			this.contentGroup.addElement(iconDisplay);
			this.contentGroup.addElement(labelDisplay);
		}
	}
}
