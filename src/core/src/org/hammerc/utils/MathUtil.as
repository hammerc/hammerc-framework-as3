// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.utils
{
	import flash.geom.Point;
	
	/**
	 * <code>MathUtil</code> 类提供各种游戏中的基础数学运算.
	 * @author wizardc
	 */
	public class MathUtil
	{
		/**
		 * 计算两个点之间的距离.
		 * @param x1 第一个点的 x 轴坐标.
		 * @param y1 第一个点的 y 轴坐标.
		 * @param x2 第二个点的 x 轴坐标.
		 * @param y2 第二个点的 y 轴坐标.
		 * @return 两个点之间的距离.
		 */
		public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * 计算两个点之间的距离.
		 * @param point1 第一个点.
		 * @param point2 第二个点.
		 * @return 两个点之间的距离.
		 */
		public static function distance2(point1:Point, point2:Point):Number
		{
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * 计算两个点之间的弧度.
		 * @param x1 第一个点的 x 轴坐标.
		 * @param y1 第一个点的 y 轴坐标.
		 * @param x2 第二个点的 x 轴坐标.
		 * @param y2 第二个点的 y 轴坐标.
		 * @return 两个点之间的弧度.
		 */
		public static function radians(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.atan2(dy,dx);
		}
		
		/**
		 * 计算两个点之间的弧度.
		 * @param point1 第一个点.
		 * @param point2 第二个点.
		 * @return 两个点之间的弧度.
		 */
		public static function radians2(point1:Point, point2:Point):Number
		{
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			return Math.atan2(dy,dx);
		}
		
		/**
		 * 计算两个点之间的角度.
		 * @param x1 第一个点的 x 轴坐标.
		 * @param y1 第一个点的 y 轴坐标.
		 * @param x2 第二个点的 x 轴坐标.
		 * @param y2 第二个点的 y 轴坐标.
		 * @return 两个点之间的角度.
		 */
		public static function degrees(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return toDegrees(radians(x1, y1, x2, y2));
		}
		
		/**
		 * 计算两个点之间的角度.
		 * @param point1 第一个点.
		 * @param point2 第二个点.
		 * @return 两个点之间的角度.
		 */
		public static function degrees2(point1:Point, point2:Point):Number
		{
			return toDegrees(radians2(point1, point2));
		}
		
		/**
		 * 将一个角度转换为弧度.
		 * @param degrees 需要被转换的角度.
		 * @return 该角度对应的弧度.
		 */
		public static function toRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		/**
		 * 将一个弧度转换为角度.
		 * @param radians 需要被转换的弧度.
		 * @return 该角度对应的角度.
		 */
		public static function toDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
	}
}
