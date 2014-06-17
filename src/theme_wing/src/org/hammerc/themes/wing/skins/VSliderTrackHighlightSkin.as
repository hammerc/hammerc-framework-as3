/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.geom.Rectangle;
	
	import org.hammerc.core.UIComponent;
	import org.hammerc.display.GraphicsScaleBitmap;
	
	/**
	 * <code>VSliderTrackHighlightSkin</code> 类垂直滑块高亮轨道的皮肤.
	 * @author wizardc
	 */
	public class VSliderTrackHighlightSkin extends UIComponent
	{
		private var _bitmap:GraphicsScaleBitmap;
		
		/**
		 * 创建一个 <code>VSliderTrackHighlightSkin</code> 对象.
		 */
		public function VSliderTrackHighlightSkin()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			_bitmap = new GraphicsScaleBitmap();
			_bitmap.y = -4;
			_bitmap.bitmapData = new Slider_vertical_trackProgressSkin_c();
			_bitmap.scale9Grid = new Rectangle(5, 5, 6, 83);
			_bitmap.useDelay = false;
			this.addChild(_bitmap);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			_bitmap.width = w;
			_bitmap.height = h;
			_bitmap.drawBitmap();
		}
	}
}
