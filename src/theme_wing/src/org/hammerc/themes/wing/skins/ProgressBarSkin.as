/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import org.hammerc.components.Label;
	import org.hammerc.components.UIAsset;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	/**
	 * <code>ProgressBarSkin</code> 类定义了水平进度条控件的皮肤.
	 * @author wizardc
	 */
	public class ProgressBarSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 进度高亮显示对象.
		 */
		public var thumb:UIAsset;
		
		/**
		 * 皮肤子件, 轨道显示对象, 用于确定 thumb 要覆盖的区域.
		 */
		public var track:UIAsset;
		
		/**
		 * 皮肤子件, 进度条文本.
		 */
		public var labelDisplay:Label;
		
		/**
		 * 创建一个 <code>ProgressBarSkin</code> 对象.
		 */
		public function ProgressBarSkin()
		{
			super();
			this.minHeight = 10;
			this.minWidth = 10;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			track = new UIAsset();
			track.left = 0;
			track.right = 0;
			track.top = 0;
			track.bottom = 0;
			track.skinName = this.getScaleBitmap(ProgressBar_horizotalBGSkin_c, 5, 5, 151, 5);
			this.addElement(track);
			thumb = new UIAsset();
			thumb.top = 0;
			thumb.bottom = 0;
			thumb.skinName = new ProgressBarThumbSkin(track);
			this.addElement(thumb);
			labelDisplay = new Label();
			labelDisplay.horizontalCenter = 0;
			labelDisplay.verticalCenter = 0;
			this.addElement(labelDisplay);
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
			this.drawScaleBitmap(track.skin);
		}
	}
}
