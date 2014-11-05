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
	 * <code>Quart</code> 类定义了四次方的缓动效果.
	 * <p>算法来自 Robert Penner 的博客: http://www.robertpenner.com/easing/.</p>
	 * @author wizardc
	 */
	public class Quart
	{
		/**
		 * 指定本缓动进行了几次乘方.
		 */
		public static const POWER:uint = 3;
		
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
			return c * (t /= d) * t * t * t + b;
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
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
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
			if((t /= d * .5) < 1)
			{
				return c * .5 * t * t * t * t + b;
			}
			return -c * .5 * ((t -= 2) * t * t * t - 2) + b;
		}
	}
}
