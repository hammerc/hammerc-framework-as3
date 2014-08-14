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
		 * @param px 需要检测的点.
		 * @param py 需要检测的点.
		 * @param rx 矩形区域.
		 * @param ry 矩形区域.
		 * @param rw 矩形区域.
		 * @param rh 矩形区域.
		 * @return 指定点是否在指定的矩形区域中.
		 */
		public static function hitRectanglePoint(px:Number, py:Number, rx:Number, ry:Number, rw:Number, rh:Number):Boolean
		{
			var halfWidth:Number = rw * 0.5;
			var halfHeight:Number = rh * 0.5;
			var distanceX:Number = Math.abs((rx + halfWidth) - px);
			var distanceY:Number = Math.abs((ry + halfHeight) - py);
			if(distanceX <= halfWidth && distanceY <= halfHeight)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 检测指定点是否在指定的矩形区域中.
		 * @param point 需要检测的点.
		 * @param rect 矩形区域.
		 * @return 指定点是否在指定的矩形区域中.
		 */
		public static function hitRectanglePoint2(point:Point, rect:Rectangle):Boolean
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
		 * @param rx1 第一个矩形区域.
		 * @param ry1 第一个矩形区域.
		 * @param rw1 第一个矩形区域.
		 * @param rh1 第一个矩形区域.
		 * @param rx2 第二个矩形区域.
		 * @param ry2 第二个矩形区域.
		 * @param rw2 第二个矩形区域.
		 * @param rh2 第二个矩形区域.
		 * @return 两个矩形区域是否相互重叠.
		 */
		public static function hitRectangle(rx1:Number, ry1:Number, rw1:Number, rh1:Number, rx2:Number, ry2:Number, rw2:Number, rh2:Number):Boolean
		{
			var halfWidth1:Number = rw1 * 0.5;
			var halfHeight1:Number = rh1 * 0.5;
			var halfWidth2:Number = rw2 * 0.5;
			var halfHeight2:Number = rh2 * 0.5;
			var distanceX:Number = Math.abs((rx1 + halfWidth1) - (rx2 + halfWidth2));
			var distanceY:Number = Math.abs((ry1 + halfHeight1) - (ry2 + halfHeight2));
			if(distanceX <= halfWidth1 + halfWidth2 && distanceY <= halfHeight1 + halfHeight2)
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
		public static function hitRectangle2(rect1:Rectangle, rect2:Rectangle):Boolean
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
		 * @param px 需要检测的点.
		 * @param py 需要检测的点.
		 * @param x 圆心相对于父显示对象注册点的 x 位置.
		 * @param y 圆心相对于父显示对象注册点的 y 位置.
		 * @param radius 圆形的半径.
		 * @return 指定点是否在指定的圆形区域中.
		 */
		public static function hitCirclePoint(px:Number, py:Number, x:Number, y:Number, radius:Number):Boolean
		{
			var distanceX:Number = Math.abs(px - (x + radius));
			var distanceY:Number = Math.abs(py - (y + radius));
			var distanceZ:Number = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
			if(distanceZ <= radius)
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
		 * @return 指定点是否在指定的圆形区域中.
		 */
		public static function hitCirclePoint2(point:Point, x:Number, y:Number, radius:Number):Boolean
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
		 * @param px 需要检测的点.
		 * @param py 需要检测的点.
		 * @param x 圆心相对于父显示对象注册点的 x 位置.
		 * @param y 圆心相对于父显示对象注册点的 y 位置.
		 * @param width 椭圆的宽度.
		 * @param height 椭圆的高度.
		 * @return 指定点是否在指定的椭圆形区域中.
		 */
		public static function hitEllipsePoint(px:Number, py:Number, x:Number, y:Number, width:Number, height:Number):Boolean
		{
			var halfWidth:Number = width * 0.5;
			var halfHeight:Number = height * 0.5;
			var distanceX:Number = px - (x + halfWidth);
			var distanceY:Number = py - (y + halfHeight);
			var scaleY:Number = height / width;
			distanceY /= scaleY;
			if(Math.sqrt(distanceX * distanceX + distanceY * distanceY) < halfWidth)
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
		public static function hitEllipsePoint2(point:Point, x:Number, y:Number, width:Number, height:Number):Boolean
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
		 * @param px1 三角形的一个顶点.
		 * @param py1 三角形的一个顶点.
		 * @param px2 三角形的一个顶点.
		 * @param py2 三角形的一个顶点.
		 * @param px3 三角形的一个顶点.
		 * @param py3 三角形的一个顶点.
		 * @param px4 需要检测的点.
		 * @param py4 需要检测的点.
		 * @return 指定点是否在指定的三角形区域中.
		 */
		public static function hitTrianglePoint(px1:Number, py1:Number, px2:Number, py2:Number, px3:Number, py3:Number, px4:Number, py4:Number):Boolean
		{
			var a:int = hitPoint(px1, py1, px2, py2, px3, py3);
			var b:int = hitPoint(px4, py4, px2, py2, px3, py3);
			var c:int = hitPoint(px1, py1, px2, py2, px4, py4);
			var d:int = hitPoint(px1, py1, px4, py4, px3, py3);
			if((b == a) && (c == a) && (d == a))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private static function hitPoint(px1:Number, py1:Number, px2:Number, py2:Number, px3:Number, py3:Number):int
		{
			if((px2 - px1) * (py2 + py1) + (px3 - px2) * (py3 + py2) + (px1 - px3) * (py1 + py3) < 0)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 检测指定点是否在指定的三角形区域中.
		 * @param p1 三角形的一个顶点.
		 * @param p2 三角形的一个顶点.
		 * @param p3 三角形的一个顶点.
		 * @param p4 需要检测的点.
		 * @return 指定点是否在指定的三角形区域中.
		 */
		public static function hitTrianglePoint2(p1:Point, p2:Point, p3:Point, p4:Point):Boolean
		{
			var a:int = hitPoint2(p1, p2, p3);
			var b:int = hitPoint2(p4, p2, p3);
			var c:int = hitPoint2(p1, p2, p4);
			var d:int = hitPoint2(p1, p4, p3);
			if((b == a) && (c == a) && (d == a))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private static function hitPoint2(p1:Point, p2:Point, p3:Point):int
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
