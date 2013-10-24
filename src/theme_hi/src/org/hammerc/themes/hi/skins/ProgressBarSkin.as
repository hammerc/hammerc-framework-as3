/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.DisplayObject;
	
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
		public var thumb:DisplayObject;
		
		/**
		 * 皮肤子件, 轨道显示对象, 用于确定 thumb 要覆盖的区域.
		 */
		public var track:DisplayObject;
		
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
			(track as UIAsset).skinName = ProgressBarTrackSkin;
			(track as UIAsset).left = 0;
			(track as UIAsset).right = 0;
			this.addElement((track as UIAsset));
			thumb = new UIAsset();
			(thumb as UIAsset).skinName = ProgressBarThumbSkin;
			this.addElement((thumb as UIAsset));
			labelDisplay = new Label();
			labelDisplay.y = 14;
			labelDisplay.horizontalCenter = 0;
			this.addElement(labelDisplay);
		}
	}
}
