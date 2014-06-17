/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.geom.Rectangle;
	
	import org.hammerc.components.Button;
	import org.hammerc.components.Group;
	import org.hammerc.layouts.HorizontalLayout;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>SpinnerSkin</code> 类定义了选择值组件的皮肤.
	 * @author wizardc
	 */
	public class SpinnerSkin extends WingSkin
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
			this.minWidth = 32;
			this.minHeight = 16;
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
			decrementButton.width = 16;
			decrementButton.percentHeight = 100;
			decrementButton.createLabelIfNeed = false;
			decrementButton.skinName = NoLabelButtonSkin;
			decrementButton.setStyle("upSkin", ScrollBar_arrowLeft_upSkin_c);
			decrementButton.setStyle("overSkin", ScrollBar_arrowLeft_overSkin_c);
			decrementButton.setStyle("downSkin", ScrollBar_arrowLeft_downSkin_c);
			decrementButton.setStyle("disabledSkin", ScrollBar_arrowLeft_disabledSkin_c);
			decrementButton.setStyle("useTextFilter", false);
			decrementButton.setStyle("scale9Grid", new Rectangle(3, 3, 10, 9));
			group.addElement(decrementButton);
			incrementButton = new Button();
			incrementButton.width = 16;
			incrementButton.percentHeight = 100;
			incrementButton.createLabelIfNeed = false;
			incrementButton.skinName = NoLabelButtonSkin;
			incrementButton.setStyle("upSkin", ScrollBar_arrowRight_upSkin_c);
			incrementButton.setStyle("overSkin", ScrollBar_arrowRight_overSkin_c);
			incrementButton.setStyle("downSkin", ScrollBar_arrowRight_downSkin_c);
			incrementButton.setStyle("disabledSkin", ScrollBar_arrowRight_disabledSkin_c);
			incrementButton.setStyle("useTextFilter", false);
			incrementButton.setStyle("scale9Grid", new Rectangle(3, 3, 10, 9));
			group.addElement(incrementButton);
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
