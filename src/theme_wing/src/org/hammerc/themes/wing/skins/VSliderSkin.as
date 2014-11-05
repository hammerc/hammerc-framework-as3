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
	import flash.geom.Rectangle;
	
	import org.hammerc.components.Button;
	import org.hammerc.components.UIAsset;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>VSliderSkin</code> 类定义了垂直滑块控件的皮肤.
	 * @author wizardc
	 */
	public class VSliderSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 实体滑块组件.
		 */
		public var thumb:Button;
		
		/**
		 * 皮肤子件, 实体轨道组件.
		 */
		public var track:Button;
		
		/**
		 * 皮肤子件, 轨道高亮显示对象.
		 */
		public var trackHighlight:UIAsset;
		
		/**
		 * 创建一个 <code>VSliderSkin</code> 对象.
		 */
		public function VSliderSkin()
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
			track.left = 0;
			track.right = 0;
			track.top = 0;
			track.bottom = 0;
			track.height = 100;
			track.tabEnabled = false;
			track.createLabelIfNeed = false;
			track.skinName = NoLabelButtonSkin;
			track.setStyle("upSkin", Slider_vertical_trackSkin_c);
			track.setStyle("overSkin", null);
			track.setStyle("downSkin", null);
			track.setStyle("disabledSkin", Slider_vertical_trackDisabledSkin_c);
			track.setStyle("useTextFilter", false);
			track.setStyle("scale9Grid", new Rectangle(5, 5, 6, 90));
			this.addElement(track);
			trackHighlight = new UIAsset();
			trackHighlight.left = 0;
			trackHighlight.right = 0;
			trackHighlight.height = 100;
			trackHighlight.tabEnabled = false;
			trackHighlight.skinName = VSliderTrackHighlightSkin;
			this.addElement(trackHighlight);
			thumb = new Button();
			thumb.left = 0;
			thumb.right = 0;
			thumb.height = 8;
			thumb.tabEnabled = false;
			thumb.createLabelIfNeed = false;
			thumb.skinName = NoLabelButtonSkin;
			thumb.setStyle("upSkin", Slider_thumbVertical_upSkin_c);
			thumb.setStyle("overSkin", Slider_thumbVertical_overSkin_c);
			thumb.setStyle("downSkin", Slider_thumbVertical_downSkin_c);
			thumb.setStyle("disabledSkin", Slider_thumbVertical_disabledSkin_c);
			thumb.setStyle("useTextFilter", false);
			thumb.setStyle("scale9Grid", new Rectangle(7, 0, 2, 8));
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
		}
	}
}
