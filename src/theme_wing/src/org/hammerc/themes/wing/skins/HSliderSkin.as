/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.geom.Rectangle;
	
	import org.hammerc.components.Button;
	import org.hammerc.components.UIAsset;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>HSliderSkin</code> 类定义了水平滑块控件的皮肤.
	 * @author wizardc
	 */
	public class HSliderSkin extends WingSkin
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
		 * 创建一个 <code>HSliderSkin</code> 对象.
		 */
		public function HSliderSkin()
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
			track.left = 0;
			track.right = 0;
			track.top = 0;
			track.bottom = 0;
			track.width = 100;
			track.tabEnabled = false;
			track.createLabelIfNeed = false;
			track.skinName = NoLabelButtonSkin;
			track.setStyle("upSkin", Slider_horizontal_trackSkin_c);
			track.setStyle("overSkin", null);
			track.setStyle("downSkin", null);
			track.setStyle("disabledSkin", Slider_horizontal_trackDisabledSkin_c);
			track.setStyle("useTextFilter", false);
			track.setStyle("scale9Grid", new Rectangle(5, 5, 90, 6));
			this.addElement(track);
			trackHighlight = new UIAsset();
			trackHighlight.top = 0;
			trackHighlight.bottom = 0;
			trackHighlight.width = 100;
			trackHighlight.tabEnabled = false;
			trackHighlight.skinName = HSliderTrackHighlightSkin;
			this.addElement(trackHighlight);
			thumb = new Button();
			thumb.top = 0;
			thumb.bottom = 0;
			thumb.width = 8;
			thumb.tabEnabled = false;
			thumb.createLabelIfNeed = false;
			thumb.skinName = NoLabelButtonSkin;
			thumb.setStyle("upSkin", Slider_thumbHorizontal_upSkin_c);
			thumb.setStyle("overSkin", Slider_thumbHorizontal_overSkin_c);
			thumb.setStyle("downSkin", Slider_thumbHorizontal_downSkin_c);
			thumb.setStyle("disabledSkin", Slider_thumbHorizontal_disabledSkin_c);
			thumb.setStyle("useTextFilter", false);
			thumb.setStyle("scale9Grid", new Rectangle(0, 7, 8, 2));
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
