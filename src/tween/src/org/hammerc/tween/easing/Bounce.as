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
	 * <code>Bounce</code> 类定义了会在目标点反弹的缓动效果.
	 * <p>算法来自 Robert Penner 的博客: http://www.robertpenner.com/easing/.</p>
	 * @author wizardc
	 */
	public class Bounce
	{
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
			return c - easeOut(d - t, 0, c, d) + b;
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
			if((t /= d) < (1 / 2.75))
			{
				return c * (7.5625 * t * t) + b;
			}
			else if(t < (2 / 2.75))
			{
				return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
			}
			else if(t < (2.5 / 2.75))
			{
				return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
			}
			else
			{
				return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
			}
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
			if(t < d * .5)
			{
				return easeIn (t * 2, 0, c, d) * .5 + b;
			}
			return easeOut (t * 2 - d, 0, c, d) * .5 + c * .5 + b;
		}
	}
}
