/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.geom.Rectangle;
	
	import org.hammerc.components.UIAsset;
	import org.hammerc.core.UIComponent;
	import org.hammerc.display.GraphicsScaleBitmap;
	
	/**
	 * <code>ProgressBarThumbSkin</code> 类定义了水平进度条轨道的皮肤.
	 * @author wizardc
	 */
	public class ProgressBarThumbSkin extends UIComponent
	{
		private var _track:UIAsset;
		private var _bitmap:GraphicsScaleBitmap;
		
		/**
		 * 创建一个 <code>ProgressBarThumbSkin</code> 对象.
		 * @param track 轨迹对象.
		 */
		public function ProgressBarThumbSkin(track:UIAsset)
		{
			super();
			_track = track;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			_bitmap = new GraphicsScaleBitmap();
			_bitmap.x = 2;
			_bitmap.y = 2;
			_bitmap.bitmapData = new ProgressBar_horizotalFGSkin_c();
			_bitmap.scale9Grid = new Rectangle(1, 1, 5, 9);
			_bitmap.useDelay = false;
			this.addChild(_bitmap);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			_bitmap.width = Math.round((_track.width - 3) * (w / _track.width));
			_bitmap.height = h - 4;
			_bitmap.drawBitmap();
		}
	}
}
