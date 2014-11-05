// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.tween.easing
{
	/**
	 * <code>Sine</code> 类定义了正弦的缓动效果.
	 * <p>算法来自 Robert Penner 的博客: http://www.robertpenner.com/easing/.</p>
	 * @author wizardc
	 */
	public class Sine
	{
		private static const PI1_2:Number = Math.PI * .5;
		
		/**
		 * 速度从 0 开始加速的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @return 当前时间的值.
		 */
		public static function easeIn(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * Math.cos(t / d * PI1_2) + c + b;
		}
		
		/**
		 * 速度减速到 0 的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @return 当前时间的值.
		 */
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * Math.sin(t / d * PI1_2) + b;
		}
		
		/**
		 * 速度前半段从 0 开始加速, 后半段减速到 0 的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @return 当前时间的值.
		 */
		public static function easeInOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * .5 * (Math.cos(Math.PI * t / d) - 1) + b;
		}
	}
}
