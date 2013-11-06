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
		
		/**
		 * 绘制四个角不同的圆角矩形.
		 * @param graphics 要绘制到的对象.
		 * @param x 起始点 x 坐标.
		 * @param y 起始点 y 坐标.
		 * @param width 矩形宽度.
		 * @param height 矩形高度.
		 * @param topLeftRadius 左上圆角半径.
		 * @param topRightRadius 右上圆角半径.
		 * @param bottomLeftRadius 左下圆角半径.
		 * @param bottomRightRadius 右下圆角半径.
		 */
		public static function drawRoundRectComplex(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			var xw:Number = x + width;
			var yh:Number = y + height;
			var minSize:Number = width < height ? width * 2 : height * 2;
			topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
			topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
			bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
			bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;
			var a:Number = bottomRightRadius * 0.292893218813453;
			var s:Number = bottomRightRadius * 0.585786437626905;
			graphics.moveTo(xw, yh - bottomRightRadius);
			graphics.curveTo(xw, yh - s, xw - a, yh - a);
			graphics.curveTo(xw - s, yh, xw - bottomRightRadius, yh);
			a = bottomLeftRadius * 0.292893218813453;
			s = bottomLeftRadius * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadius, yh);
			graphics.curveTo(x + s, yh, x + a, yh - a);
			graphics.curveTo(x, yh - s, x, yh - bottomLeftRadius);
			a = topLeftRadius * 0.292893218813453;
			s = topLeftRadius * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadius);
			graphics.curveTo(x, y + s, x + a, y + a);
			graphics.curveTo(x + s, y, x + topLeftRadius, y);
			a = topRightRadius * 0.292893218813453;
			s = topRightRadius * 0.585786437626905;
			graphics.lineTo(xw - topRightRadius, y);
			graphics.curveTo(xw - s, y, xw - a, y + a);
			graphics.curveTo(xw, y + s, xw, y + topRightRadius);
			graphics.lineTo(xw, yh - bottomRightRadius);
		}
		
		/**
		 * 绘制一个扇形, 按顺时针进行绘制.
		 * @param graphics 要绘制到的对象.
		 * @param x 中心点 x 坐标.
		 * @param y 中心点 y 坐标.
		 * @param radius 半径.
		 * @param angleFrom 开始的角度.
		 * @param angleTo 结束的角度.
		 * @param precision 精度, 精度越大线条越近似弧线. 做 CD 遮罩时可设置为 0.1 以提高效率.
		 */
		public static function drawSector(graphics:Graphics, x:Number, y:Number, radius:Number, angleFrom:Number, angleTo:Number, precision:Number = 1):void
		{
			angleFrom = angleFrom % 360;
			angleTo = angleTo % 360;
			const degreeToRadian:Number = 0.0174532925;
			var angleDiff:Number = (angleTo - angleFrom) % 360;
			var steps:Number = Math.abs(Math.round(angleDiff * precision));
			var angle:Number = angleFrom;
			var px:Number = x + radius * Math.cos(angle * degreeToRadian);
			var py:Number = y + radius * Math.sin(angle * degreeToRadian);
			graphics.moveTo(px, py);
			for(var i:int = 1; i <= steps; i++)
			{
				var radian:Number = (angleFrom + angleDiff / steps * i) * degreeToRadian;
				graphics.lineTo(x + radius * Math.cos(radian), y + radius * Math.sin(radian));
			}
			graphics.lineTo(x, y);
			graphics.lineTo(px, py);
		}
	}
}
