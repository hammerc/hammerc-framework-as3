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
	import org.hammerc.components.Button;
	import org.hammerc.components.Group;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.layouts.HorizontalLayout;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>SpinnerSkin</code> 类定义了选择值组件的皮肤.
	 * @author wizardc
	 */
	public class SpinnerSkin extends HiSkin
	{
		/**
		 * 皮肤子件, 减小按钮.
		 */
		public var decrementButton:Button;
		
		/**
		 * 皮肤子件, 增大按钮.
		 */
		public var incrementButton:Button;
		
		/**
		 * 创建一个 <code>SpinnerSkin</code> 对象.
		 */
		public function SpinnerSkin()
		{
			super();
			this.minWidth = 34;
			this.minHeight = 15;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 0;
			var group:Group = new Group();
			group.layout = layout;
			group.percentWidth = 100;
			group.percentHeight = 100;
			this.addElement(group);
			decrementButton = new Button();
			decrementButton.skinName = ScrollBarLeftButtonSkin;
			decrementButton.percentWidth = 100;
			decrementButton.percentHeight = 100;
			group.addElement(decrementButton);
			incrementButton = new Button();
			incrementButton.skinName = ScrollBarRightButtonSkin;
			incrementButton.percentWidth = 100;
			incrementButton.percentHeight = 100;
			group.addElement(incrementButton);
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
