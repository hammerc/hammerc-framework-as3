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
	import org.hammerc.components.Label;
	import org.hammerc.components.UIAsset;
	import org.hammerc.themes.hi.HiSkin;
	
	/**
	 * <code>ProgressBarSkin</code> 类定义了进度条控件的皮肤.
	 * @author wizardc
	 */
	public class ProgressBarSkin extends HiSkin
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
			this.minHeight = 24;
			this.minWidth = 30;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			track = new UIAsset();
			track.skinName = ProgressBarTrackSkin;
			track.left = 0;
			track.right = 0;
			track.top = 0;
			track.bottom = 0;
			this.addElement(track);
			thumb = new UIAsset();
			thumb.skinName = ProgressBarThumbSkin;
			thumb.top = 0;
			thumb.bottom = 0;
			this.addElement(thumb);
			labelDisplay = new Label();
			labelDisplay.horizontalCenter = 0;
			labelDisplay.verticalCenter = 0;
			this.addElement(labelDisplay);
		}
	}
}
