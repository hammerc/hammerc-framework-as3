/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.geom.Rectangle;
	
	import org.hammerc.components.Button;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>HScrollBarSkin</code> 类定义了水平滚动条控件的皮肤.
	 * @author wizardc
	 */
	public class HScrollBarSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 减小滚动条值的按钮.
		 */
		public var decrementButton:Button;
		
		/**
		 * 皮肤子件, 增大滚动条值的按钮.
		 */
		public var incrementButton:Button;
		
		/**
		 * 皮肤子件, 实体滑块组件.
		 */
		public var thumb:Button;
		
		/**
		 * 皮肤子件, 实体轨道组件.
		 */
		public var track:Button;
		
		/**
		 * 创建一个 <code>HScrollBarSkin</code> 对象.
		 */
		public function HScrollBarSkin()
		{
			super();
			this.minWidth = 50;
			this.minHeight = 16;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			track = new Button();
			track.left = 16;
			track.right = 16;
			track.width = 10;
			track.createLabelIfNeed = false;
			track.skinName = NoLabelButtonSkin;
			track.setStyle("upSkin", ScrollBar_horizotalBGSkin_c);
			track.setStyle("overSkin", null);
			track.setStyle("downSkin", null);
			track.setStyle("disabledSkin", null);
			track.setStyle("useTextFilter", false);
			track.setStyle("scale9Grid", new Rectangle(5, 5, 151, 5));
			this.addElement(track);
			decrementButton = new Button();
			decrementButton.left = 0;
			decrementButton.width = 16;
			decrementButton.createLabelIfNeed = false;
			decrementButton.skinName = NoLabelButtonSkin;
			decrementButton.setStyle("upSkin", ScrollBar_arrowLeft_upSkin_c);
			decrementButton.setStyle("overSkin", ScrollBar_arrowLeft_overSkin_c);
			decrementButton.setStyle("downSkin", ScrollBar_arrowLeft_downSkin_c);
			decrementButton.setStyle("disabledSkin", ScrollBar_arrowLeft_disabledSkin_c);
			decrementButton.setStyle("useTextFilter", false);
			decrementButton.setStyle("scale9Grid", new Rectangle(3, 3, 10, 9));
			this.addElement(decrementButton);
			incrementButton = new Button();
			incrementButton.right = 0;
			incrementButton.width = 16;
			incrementButton.createLabelIfNeed = false;
			incrementButton.skinName = NoLabelButtonSkin;
			incrementButton.setStyle("upSkin", ScrollBar_arrowRight_upSkin_c);
			incrementButton.setStyle("overSkin", ScrollBar_arrowRight_overSkin_c);
			incrementButton.setStyle("downSkin", ScrollBar_arrowRight_downSkin_c);
			incrementButton.setStyle("disabledSkin", ScrollBar_arrowRight_disabledSkin_c);
			incrementButton.setStyle("useTextFilter", false);
			incrementButton.setStyle("scale9Grid", new Rectangle(3, 3, 10, 9));
			this.addElement(incrementButton);
			thumb = new Button();
			thumb.createLabelIfNeed = false;
			thumb.skinName = NoLabelButtonSkin;
			thumb.setStyle("upSkin", ScrollBar_thumbHorizontal_upSkin_c);
			thumb.setStyle("overSkin", ScrollBar_thumbHorizontal_overSkin_c);
			thumb.setStyle("downSkin", ScrollBar_thumbHorizontal_downSkin_c);
			thumb.setStyle("disabledSkin", ScrollBar_thumbHorizontal_disabledSkin_c);
			thumb.setStyle("useTextFilter", false);
			thumb.setStyle("scale9Grid", new Rectangle(3, 3, 24, 9));
			this.addElement(thumb);
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
			decrementButton.height = h;
			incrementButton.height = h;
			thumb.height = h;
			track.height = h;
		}
	}
}
