/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.geom
{
	/**
	 * <code>Vector2D</code> 类描述了位于 2D 空间中的一个点或一个原点为 (0, 0) 指向点 (x, y) 的向量.
	 * @author wizardc
	 */
	public class Vector2D
	{
		/**
		 * 计算两个向量夹角的弧度.
		 * @param v1 用来计算的第一个向量.
		 * @param v2 用来计算的第二个向量.
		 * @return 两个参数向量夹角的弧度.
		 */
		public static function angleBetween(v1:Vector2D, v2:Vector2D):Number
		{
			if(v1.length != 0)
			{
				v1 = v1.clone();
				v1.normalize();
			}
			if(v2.length != 0)
			{
				v2 = v1.clone();
				v2.normalize();
			}
			return Math.acos(v1.dotProduct(v2));
		}
		
		/**
		 * 计算 2D 空间中两个点的距离.
		 * @param v1 用来计算的第一个点.
		 * @param v2 用来计算的第二个点.
		 * @return 两个参数点在 2D 空间中的距离.
		 */
		public static function distance(v1:Vector2D, v2:Vector2D):Number
		{
			var dx:Number = v1.x - v2.x;
			var dy:Number = v1.y - v2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		private var _x:Number;													//记录该向量的 x 坐标.
		private var _y:Number;													//记录该向量的 y 坐标.
		
		/**
		 * 创建一个 <code>Vector2D</code> 对象.
		 * @param x 设置该向量的 <code>x</code> 坐标.
		 * @param y 设置该向量的 <code>y</code> 坐标.
		 */
		public function Vector2D(x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
		}
		
		/**
		 * 设置或获取该向量的 <code>x</code> 坐标.
		 */
		public function set x(value:Number):void
		{
			_x = value;
		}
		public function get x():Number
		{
			return _x;
		}
		
		/**
		 * 设置或获取该向量的 <code>y</code> 坐标.
		 */
		public function set y(value:Number):void
		{
			_y = value;
		}
		public function get y():Number
		{
			return _y;
		}
		
		/**
		 * 获取该向量的长度(大小)的平方.
		 */
		public function get lengthSquared():Number
		{
			return _x * _x + _y * _y;
		}
		
		/**
		 * 获取该向量的长度(大小).
		 */
		public function get length():Number
		{
			return Math.sqrt(lengthSquared);
		}
		
		/**
		 * 设置或获取该向量的弧度.
		 */
		public function set angle(value:Number):void
		{
			var len:Number = length;
			_x = Math.cos(value) * len;
			_y = Math.sin(value) * len;
		}
		public function get angle():Number
		{
			return Math.atan2(_y, _x);
		}
		
		/**
		 * 设置该向量为单位向量.
		 */
		public function normalize():void
		{
			var len:Number = length;
			if(len == 0)
			{
				_x = 1;
			}
			else
			{
				_x /= len;
				_y /= len;
			}
		}
		
		/**
		 * 返回一个新 <code>Vector2D</code> 对象, 它是与当前 <code>Vector2D</code> 对象完全相同的副本.
		 * @return 一个新 <code>Vector2D</code> 对象, 是当前 <code>Vector2D</code> 对象的副本.
		 */
		public function clone():Vector2D
		{
			return new Vector2D(_x, _y);
		}
		
		/**
		 * 将当前 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素的值与另一个 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素的值相加.
		 * <p>该方法不更改当前的 <code>Vector2D</code> 对象. 相反, 此方法将返回具有新值的新 <code>Vector2D</code> 对象.</p>
		 * @param vector2D 要与当前 <code>Vector2D</code> 对象相加的 <code>Vector2D</code> 对象.
		 * @return 一个 <code>Vector2D</code> 对象, 它是将当前 <code>Vector2D</code> 对象与另一个 <code>Vector2D</code> 对象相加所产生的结果.
		 */
		public function add(vector2D:Vector2D):Vector2D
		{
			return new Vector2D(_x + vector2D.x, _y + vector2D.y);
		}
		
		/**
		 * 按照指定的 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素的值递增当前 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素的值.
		 * <p>与 <code>add()</code> 方法不同, 该方法会更改当前的 <code>Vector2D</code> 对象并且不返回新的 <code>Vector2D</code> 对象.</p>
		 * @param vector2D 要与当前的 <code>Vector2D</code> 对象相加的 <code>Vector2D</code> 对象.
		 */
		public function incrementBy(vector2D:Vector2D):void
		{
			_x += vector2D.x;
			_y += vector2D.y;
		}
		
		/**
		 * 从另一个 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素的值中减去当前 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素的值.
		 * <p>该方法不更改当前的 <code>Vector2D</code> 对象. 相反, 此方法将返回一个具有新值的新的 <code>Vector2D</code> 对象.</p>
		 * @param vector2D 要从当前 <code>Vector2D</code> 对象中减去的 <code>Vector2D</code> 对象.
		 * @return 一个新的 <code>Vector2D</code> 对象, 它是当前 <code>Vector2D</code> 对象与指定的 <code>Vector2D</code> 对象之差.
		 */
		public function subtract(vector2D:Vector2D):Vector2D
		{
			return new Vector2D(_x - vector2D.x, _y - vector2D.y);
		}
		
		/**
		 * 按照指定的 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素的值递减当前 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素的值.
		 * 与 <code>subtract()</code> 方法不同, 该方法会更改当前的 <code>Vector2D</code> 对象并且不返回新的 <code>Vector2D</code> 对象.
		 * @param vector2D 要从当前 <code>Vector2D</code> 对象中减去的值的 <code>Vector2D</code> 对象.
		 */
		public function decrementBy(vector2D:Vector2D):void
		{
			_x -= vector2D.x;
			_y -= vector2D.y;
		}
		
		/**
		 * 按标量(大小)缩放当前的 <code>Vector2D</code> 对象.
		 * <p><code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 元素乘以参数中指定的标量数字.</p>
		 * @param scale 一个用于缩放 <code>Vector2D</code> 对象的乘数(标量).
		 */
		public function scaleBy(scale:Number):void
		{
			_x *= scale;
			_y *= scale;
		}
		
		/**
		 * 返回一个新的 <code>Vector2D</code> 对象, 它与当前 <code>Vector2D</code> 对象垂直(成直角).
		 * @return 一个新的 <code>Vector2D</code> 对象, 它与当前 <code>Vector2D</code> 对象垂直.
		 */
		public function crossProduct():Vector2D
		{
			return new Vector2D(-y, x);
		}
		
		/**
		 * 将当前 <code>Vector2D</code> 对象设置为其逆对象.
		 * <p>当前 <code>Vector2D</code> 对象的 <code>x</code> 和 <code>y</code> 属性的值将更改为 <code>-x</code> 和 <code>-y</code>.</p>
		 */
		public function negate():void
		{
			_x = -_x;
			_y = -_y;
		}
		
		/**
		 * 计算当前 <code>Vector2D</code> 对象与指定的 <code>Vector2D</code> 对象之间的点积.
		 * @param vector2D 第二个 <code>Vector2D</code> 对象.
		 * @return 一个标量, 它是当前 <code>Vector2D</code> 对象与指定的 <code>Vector2D</code> 对象之间的点积.
		 */
		public function dotProduct(vector2D:Vector2D):Number
		{
			return _x * vector2D.x + _y * vector2D.y;
		}
		
		/**
		 * 判断两个 <code>Vector2D</code> 对象是否相等.
		 * @param toCompare 要与当前 <code>Vector2D</code> 对象进行比较的 <code>Vector2D</code> 对象.
		 * @return 如果指定的 <code>Vector2D</code> 对象与当前 <code>Vector2D</code> 对象相等, 则为 <code>true</code> 值; 否则为 <code>false</code>.
		 */
		public function equals(toCompare:Vector2D):Boolean
		{
			return _x == toCompare.x && _y == toCompare.y;
		}
		
		/**
		 * 返回当前 <code>Vector2D</code> 对象的字符串表示形式.
		 * @return 包含 <code>x</code> 和 <code>y</code> 属性的值的字符串.
		 */
		public function toString():String
		{
			return "[Vector2D (x:" + _x + ", y:" + _y + ")]";
		}
	}
}
