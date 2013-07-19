/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.easing
{
	/**
	 * <code>Expo</code> 类定义了指数曲线的缓动效果.
	 * <p>算法来自 Robert Penner 的博客: http://www.robertpenner.com/easing/.</p>
	 * @author wizardc
	 */
	public class Expo
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
			return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b - c * .001;
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
			return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
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
			if(t == 0)
			{
				return b;
			}
			if(t == d)
			{
				return b + c;
			}
			if((t /= d * .5) < 1)
			{
				return c * .5 * Math.pow(2, 10 * (t - 1)) + b;
			}
			return c * .5 * (-Math.pow(2, -10 * --t) + 2) + b;
		}
	}
}
