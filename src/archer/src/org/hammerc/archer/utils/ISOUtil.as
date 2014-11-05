// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.utils
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * <code>ISOUtil</code> 类提供等角坐标转换.
	 * @author wizardc
	 */
	public class ISOUtil
	{
		/**
		 * 精确的魔法数字 1.2247.
		 */
		public static const Y_CORRECT:Number = Math.cos(-Math.PI / 6) * Math.SQRT2;
		
		/**
		 * 把等角空间中的一个 3D 坐标点转换成屏幕上的 2D 坐标点.
		 * @param pos 等角空间中的一个 3D 坐标点.
		 * @return 对应的屏幕上的 2D 坐标点.
		 */
		public static function isoToScreen(pos:Vector3D):Point
		{
			var screenX:Number = pos.x - pos.z;
			var screenY:Number = pos.y * Y_CORRECT + (pos.x + pos.z) * .5;
			return new Point(screenX, screenY);
		}
		
		/**
		 * 把屏幕上的 2D 坐标点转换成等角空间中的一个 3D 坐标点, y 轴为 0.
		 * @param point 屏幕上的一个 2D 坐标点.
		 * @return 对应的等角空间中的 3D 坐标点.
		 */
		public static function screenToIso(point:Point):Vector3D
		{
			var posX:Number = point.y + point.x * .5;
			var posY:Number = 0;
			var posZ:Number = point.y - point.x * .5;
			return new Vector3D(posX, posY, posZ);
		}
	}
}
