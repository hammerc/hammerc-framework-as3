/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.geom
{
	/**
	 * <code>Color</code> 类实现了可调整一个具体颜色的功能.
	 * @author wizardc
	 */
	public class Color
	{
		/**
		 * 获取指定的颜色值.
		 * @param r 红色通道值.
		 * @param g 绿色通道值.
		 * @param b 蓝色通道值.
		 * @param a 透明色通道值.
		 * @return 颜色值.
		 */
		public static function getColor(r:uint, g:uint, b:uint, a:uint = 255):uint
		{
			return (a << 24) | (r << 16) | (g << 8) | b;
		}
		
		private var _color:uint;
		
		/**
		 * 创建一个 <code>Color</code> 对象.
		 * @param color 颜色值.
		 */
		public function Color(color:uint)
		{
			this.color = color;
		}
		
		/**
		 * 设置或获取颜色值.
		 */
		public function set color(value:uint):void
		{
			_color = value;
		}
		public function get color():uint
		{
			return _color;
		}
		
		/**
		 * 设置或获取红色通道值.
		 */
		public function set r(value:uint):void
		{
			value = value > 255 ? 255 : value;
			value <<= 16;
			_color &= 0xff00ffff;
			_color |= value;
		}
		public function get r():uint
		{
			return _color >> 16 & 0xff;
		}
		
		/**
		 * 设置或获取绿色通道值.
		 */
		public function set g(value:uint):void
		{
			value = value > 255 ? 255 : value;
			value <<= 8;
			_color &= 0xffff00ff;
			_color |= value;
		}
		public function get g():uint
		{
			return _color >> 8 & 0xff;
		}
		
		/**
		 * 设置或获取蓝色通道值.
		 */
		public function set b(value:uint):void
		{
			value = value > 255 ? 255 : value;
			_color &= 0xffffff00;
			_color |= value;
		}
		public function get b():uint
		{
			return _color & 0xff;
		}
		
		/**
		 * 设置或获取透明色通道值.
		 */
		public function set a(value:uint):void
		{
			value = value > 255 ? 255 : value;
			value <<= 24;
			_color &= 0x00ffffff;
			_color |= value;
		}
		public function get a():uint
		{
			return _color >> 24 & 0xff;
		}
		
		/**
		 * 返回一个新对象, 它是与当前对象完全相同的副本.
		 * @return 一个新对象, 是当前对象的副本.
		 */
		public function clone():Color
		{
			return new Color(_color);
		}
		
		/**
		 * 返回当前对象的字符串表示形式.
		 * @return 包含属性的值的字符串.
		 */
		public function toString():String
		{
			return "Color [ R:" + this.r + ", G:" + this.g + ", B:" + this.b + ", A:" + this.a + " ]";
		}
	}
}
