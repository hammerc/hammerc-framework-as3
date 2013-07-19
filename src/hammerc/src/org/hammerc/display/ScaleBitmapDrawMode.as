/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.display
{
	/**
	 * <code>ScaleBitmapDrawMode</code> 枚举了 <code>ScaleBitmap</code> 类的绘制方式.
	 * @author wizardc
	 */
	public class ScaleBitmapDrawMode
	{
		/**
		 * 不根据尺寸拉伸该位图.
		 */
		public static const NONE:int = 0;
		
		/**
		 * 根据尺寸拉伸该位图.
		 */
		public static const NORMAL:int = 1;
		
		/**
		 * 平铺该位图.
		 */
		public static const TILE:int = 2;
		
		/**
		 * 九切片模式, 除四个顶点外的区域按拉伸处理.
		 */
		public static const SCALE_9_GRID:int = 3;
		
		/**
		 * 九切片模式, 除四个顶点外的区域按平铺处理.
		 */
		public static const TILE_SCALE_9_GRID:int = 4;
	}
}
