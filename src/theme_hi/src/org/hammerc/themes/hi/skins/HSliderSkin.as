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
	import org.hammerc.components.UIAsset;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>HSliderSkin</code> 类定义了水平滑块控件的皮肤.
	 * @author wizardc
	 */
	public class HSliderSkin extends HiSkin
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
			this.minHeight = 11;
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
			track.minWidth = 33;
			track.width = 100;
			track.tabEnabled = false;
			track.skinName = HSliderTrackSkin;
			this.addElement(track);
			trackHighlight = new UIAsset();
			trackHighlight.top = 0;
			trackHighlight.bottom = 0;
			trackHighlight.minWidth = 33;
			trackHighlight.width = 100;
			trackHighlight.tabEnabled = false;
			trackHighlight.skinName = HSliderTrackHighlightSkin;
			this.addElement(trackHighlight);
			thumb = new Button();
			thumb.top = 0;
			thumb.bottom = 0;
			thumb.width = 11;
			thumb.height = 11;
			thumb.tabEnabled = false;
			thumb.skinName = SliderThumbSkin;
			this.addElement(thumb);
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
