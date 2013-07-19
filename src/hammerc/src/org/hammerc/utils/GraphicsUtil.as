/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * <code>GraphicUtil</code> 类提供各种矢量绘制的操作.
	 * @author wizardc
	 */
	public class GraphicsUtil
	{
		/**
		 * 绘制一个带有镂空矩形的矩形区域.
		 * @param target 图形绘制对象.
		 * @param rect 包含镂空图形的大矩形区域.
		 * @param hollowRect 镂空的矩形区域.
		 * @param color 图形的颜色.
		 * @param alpha 图形的透明度.
		 */
		public static function drawHollowRect(target:Graphics, rect:Rectangle, hollowRect:Rectangle, color:uint = 0x000000, alpha:Number = 1):void
		{
			target.beginFill(color, alpha);
			target.drawRect(rect.x, rect.y, rect.width, rect.height);
			target.drawRect(hollowRect.x, hollowRect.y, hollowRect.width, hollowRect.height);
			target.endFill();
		}
		
		/**
		 * 绘制一个带有镂空圆形的矩形区域.
		 * @param target 图形绘制对象.
		 * @param rect 包含镂空图形的大矩形区域.
		 * @param hollowX 镂空的圆形圆心 x 轴坐标.
		 * @param hollowY 镂空的圆形圆心 y 轴坐标.
		 * @param hollowRadius 镂空的圆形半径.
		 * @param color 图形的颜色.
		 * @param alpha 图形的透明度.
		 */
		public static function drawHollowCircle(target:Graphics, rect:Rectangle, hollowX:Number, hollowY:Number, hollowRadius:Number, color:uint = 0x000000, alpha:Number = 1):void
		{
			target.beginFill(color, alpha);
			target.drawRect(rect.x, rect.y, rect.width, rect.height);
			target.drawCircle(hollowX, hollowY, hollowRadius);
			target.endFill();
		}
		
		/**
		 * 绘制一条虚线.
		 * @param graphics 绘制对象.
		 * @param beginPoint 开始的点.
		 * @param endPoint 结束的点.
		 * @param size 线条长度.
		 * @param gap 线条间间隔长度.
		 */
		public static function drawDottedLine(graphics:Graphics, beginPoint:Point, endPoint:Point, size:Number = 1, gap:Number = 2):void
		{
			if(!graphics || !beginPoint || !endPoint || size <= 0 || gap <= 0)
			{
				return;
			}
			var ox:Number = beginPoint.x;
			var oy:Number = beginPoint.y;
			var radian:Number = Math.atan2(endPoint.y - oy, endPoint.x - ox);
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var x:Number, y:Number;
			while(currLen <= totalLen)
			{
				x = ox + Math.cos(radian) * currLen;
				y = oy + Math.sin(radian) * currLen;
				graphics.moveTo(x, y);
				currLen += size;
				if (currLen > totalLen)
				{
					currLen = totalLen;
				}
				x = ox + Math.cos(radian) * currLen;
				y = oy + Math.sin(radian) * currLen;
				graphics.lineTo(x, y);
				currLen += gap;
			}
		}
	}
}
