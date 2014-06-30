/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * <code>HitTestUtil</code> 类提供碰撞检测功能.
	 * @author wizardc
	 */
	public class HitTestUtil
	{
		/**
		 * 检测指定点是否在指定的矩形区域中.
		 * @param point 需要检测的点.
		 * @param rect 矩形区域.
		 * @return 指定点是否在指定的矩形区域中.
		 */
		public static function hitRectanglePoint(point:Point, rect:Rectangle):Boolean
		{
			var halfWidth:Number = rect.width * 0.5;
			var halfHeight:Number = rect.height * 0.5;
			var distanceX:Number = Math.abs((rect.x + halfWidth) - point.x);
			var distanceY:Number = Math.abs((rect.y + halfHeight) - point.y);
			if(distanceX <= halfWidth && distanceY <= halfHeight)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 检测两个矩形区域是否相互重叠.
		 * @param rect1 第一个矩形区域.
		 * @param rect2 第二个矩形区域.
		 * @return 两个矩形区域是否相互重叠.
		 */
		public static function hitRectangle(rect1:Rectangle, rect2:Rectangle):Boolean
		{
			var halfWidth1:Number = rect1.width * 0.5;
			var halfHeight1:Number = rect1.height * 0.5;
			var halfWidth2:Number = rect2.width * 0.5;
			var halfHeight2:Number = rect2.height * 0.5;
			var distanceX:Number = Math.abs((rect1.x + halfWidth1) - (rect2.x + halfWidth2));
			var distanceY:Number = Math.abs((rect1.y + halfHeight1) - (rect2.y + halfHeight2));
			if(distanceX <= halfWidth1 + halfWidth2 && distanceY <= halfHeight1 + halfHeight2)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 检测指定点是否在指定的圆形区域中.
		 * @param point 需要检测的点.
		 * @param x 圆心相对于父显示对象注册点的 x 位置.
		 * @param y 圆心相对于父显示对象注册点的 y 位置.
		 * @param radius 圆形的半径.
		 * @return 圆心相对于父显示对象注册点的 x 位置.
		 */
		public static function hitCirclePoint(point:Point, x:Number, y:Number, radius:Number):Boolean
		{
			var distanceX:Number = Math.abs(point.x - (x + radius));
			var distanceY:Number = Math.abs(point.y - (y + radius));
			var distanceZ:Number = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
			if(distanceZ <= radius)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 检测指定点是否在指定的椭圆形区域中.
		 * @param point 需要检测的点.
		 * @param x 圆心相对于父显示对象注册点的 x 位置.
		 * @param y 圆心相对于父显示对象注册点的 y 位置.
		 * @param width 椭圆的宽度.
		 * @param height 椭圆的高度.
		 * @return 指定点是否在指定的椭圆形区域中.
		 */
		public static function hitEllipsePoint(point:Point, x:Number, y:Number, width:Number, height:Number):Boolean
		{
			var halfWidth:Number = width * 0.5;
			var halfHeight:Number = height * 0.5;
			var distanceX:Number = point.x - (x + halfWidth);
			var distanceY:Number = point.y - (y + halfHeight);
			var scaleY:Number = height / width;
			distanceY /= scaleY;
			if(Math.sqrt(distanceX * distanceX + distanceY * distanceY) < halfWidth)
			{
				return true;
			}
			return false;
		}
		
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
