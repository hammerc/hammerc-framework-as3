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
	 * <code>VScrollBarSkin</code> 类定义了垂直滚动条控件的皮肤.
	 * @author wizardc
	 */
	public class VScrollBarSkin extends WingSkin
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
		 * 创建一个 <code>VScrollBarSkin</code> 对象.
		 */
		public function VScrollBarSkin()
		{
			super();
			this.minWidth = 16;
			this.minHeight = 50;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			track = new Button();
			track.top = 16;
			track.bottom = 16;
			track.height = 10;
			track.createLabelIfNeed = false;
			track.skinName = NoLabelButtonSkin;
			track.setStyle("upSkin", ScrollBar_verticalBGSkin_c);
			track.setStyle("overSkin", null);
			track.setStyle("downSkin", null);
			track.setStyle("disabledSkin", null);
			track.setStyle("useTextFilter", false);
			track.setStyle("scale9Grid", new Rectangle(5, 5, 5, 151));
			this.addElement(track);
			decrementButton = new Button();
			decrementButton.top = 0;
			decrementButton.height = 16;
			decrementButton.createLabelIfNeed = false;
			decrementButton.skinName = NoLabelButtonSkin;
			decrementButton.setStyle("upSkin", ScrollBar_arrowUp_upSkin_c);
			decrementButton.setStyle("overSkin", ScrollBar_arrowUp_overSkin_c);
			decrementButton.setStyle("downSkin", ScrollBar_arrowUp_downSkin_c);
			decrementButton.setStyle("disabledSkin", ScrollBar_arrowUp_disabledSkin_c);
			decrementButton.setStyle("useTextFilter", false);
			decrementButton.setStyle("scale9Grid", new Rectangle(3, 3, 9, 10));
			this.addElement(decrementButton);
			incrementButton = new Button();
			incrementButton.bottom = 0;
			incrementButton.height = 16;
			incrementButton.createLabelIfNeed = false;
			incrementButton.skinName = NoLabelButtonSkin;
			incrementButton.setStyle("upSkin", ScrollBar_arrowDown_upSkin_c);
			incrementButton.setStyle("overSkin", ScrollBar_arrowDown_overSkin_c);
			incrementButton.setStyle("downSkin", ScrollBar_arrowDown_downSkin_c);
			incrementButton.setStyle("disabledSkin", ScrollBar_arrowDown_disabledSkin_c);
			incrementButton.setStyle("useTextFilter", false);
			incrementButton.setStyle("scale9Grid", new Rectangle(3, 3, 9, 10));
			this.addElement(incrementButton);
			thumb = new Button();
			thumb.createLabelIfNeed = false;
			thumb.skinName = NoLabelButtonSkin;
			thumb.setStyle("upSkin", ScrollBar_thumbVertical_upSkin_c);
			thumb.setStyle("overSkin", ScrollBar_thumbVertical_overSkin_c);
			thumb.setStyle("downSkin", ScrollBar_thumbVertical_downSkin_c);
			thumb.setStyle("disabledSkin", ScrollBar_thumbVertical_disabledSkin_c);
			thumb.setStyle("useTextFilter", false);
			thumb.setStyle("scale9Grid", new Rectangle(3, 3, 9, 24));
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
			decrementButton.width = w;
			incrementButton.width = w;
			thumb.width = w;
			track.width = w;
		}
	}
}
