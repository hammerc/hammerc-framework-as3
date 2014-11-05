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
	import org.hammerc.themes.hi.HiSkin;
	
	/**
	 * <code>HScrollBarSkin</code> 类定义了水平滚动条控件的皮肤.
	 * @author wizardc
	 */
	public class HScrollBarSkin extends HiSkin
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
			this.minHeight = 15;
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
			track.width = 54;
			track.skinName = HScrollBarTrackSkin;
			this.addElement(track);
			decrementButton = new Button();
			decrementButton.left = 0;
			decrementButton.skinName = ScrollBarLeftButtonSkin;
			this.addElement(decrementButton);
			incrementButton = new Button();
			incrementButton.right = 0;
			incrementButton.skinName = ScrollBarRightButtonSkin;
			this.addElement(incrementButton);
			thumb = new Button();
			thumb.skinName = HScrollBarThumbSkin;
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
