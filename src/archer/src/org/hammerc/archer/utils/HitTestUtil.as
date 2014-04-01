/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.utils
{
	import flash.geom.Point;
	
	/**
	 * <code>HitTestUtil</code> 类提供碰撞检测功能.
	 * @author wizardc
	 */
	public class HitTestUtil
	{
		/**
		 * 检测指定点是否在指定的三角形区域中.
		 * @param p1 三角形的一个顶点.
		 * @param p2 三角形的一个顶点.
		 * @param p3 三角形的一个顶点.
		 * @param p4 需要检测的点.
		 * @return 指定点是否在指定的三角形区域中.
		 */
		public static function hitTrianglePoint(p1:Point, p2:Point, p3:Point, p4:Point):Boolean
		{
			var a:int = hitPoint(p1, p2, p3);
			var b:int = hitPoint(p4, p2, p3);
			var c:int = hitPoint(p1, p2, p4);
			var d:int = hitPoint(p1, p4, p3);
			if((b == a) && (c == a) && (d == a))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private static function hitPoint(p1:Point, p2:Point, p3:Point):int
		{
			if((p2.x - p1.x) * (p2.y + p1.y) + (p3.x - p2.x) * (p3.y + p2.y) + (p1.x - p3.x) * (p1.y + p3.y) < 0)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}
}
