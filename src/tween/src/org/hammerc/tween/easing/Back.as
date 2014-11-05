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
	 * <code>Back</code> 类定义了会超过目标一定距离再弹回的缓动效果.
	 * <p>算法来自 Robert Penner 的博客: http://www.robertpenner.com/easing/.</p>
	 * @author wizardc
	 */
	public class Back
	{
		/**
		 * 速度从 0 开始加速的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @param s 超过目标的距离, 这个数字越高就会越远.
		 * @return 当前时间的值.
		 */
		public static function easeIn(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number
		{
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}
		
		/**
		 * 速度减速到 0 的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @param s 超过目标的距离, 这个数字越高就会越远.
		 * @return 当前时间的值.
		 */
		public static function easeOut(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number
		{
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}
		
		/**
		 * 速度前半段从 0 开始加速, 后半段减速到 0 的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @param s 超过目标的距离, 这个数字越高就会越远.
		 * @return 当前时间的值.
		 */
		public static function easeInOut(t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number
		{
			if((t /= d * .5) < 1)
			{
				return c * .5 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
			}
			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}
	}
}
