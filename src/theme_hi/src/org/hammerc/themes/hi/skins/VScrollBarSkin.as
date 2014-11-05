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
	 * <code>VScrollBarSkin</code> 类定义了垂直滚动条控件的皮肤.
	 * @author wizardc
	 */
	public class VScrollBarSkin extends HiSkin
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
			this.minWidth = 15;
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
			track.height = 54;
			track.skinName = VScrollBarTrackSkin;
			this.addElement(track);
			decrementButton = new Button();
			decrementButton.top = 0;
			decrementButton.skinName = ScrollBarUpButtonSkin;
			this.addElement(decrementButton);
			incrementButton = new Button();
			incrementButton.bottom = 0;
			incrementButton.skinName = ScrollBarDownButtonSkin;
			this.addElement(incrementButton);
			thumb = new Button();
			thumb.skinName = VScrollBarThumbSkin;
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
