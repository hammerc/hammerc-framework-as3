/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.easing
{
	/**
	 * <code>Linear</code> 类定义无缓动效果.
	 * <p>算法来自 Robert Penner 的博客: http://www.robertpenner.com/easing/.</p>
	 * @author wizardc
	 */
	public class Linear
	{
		/**
		 * 指定本缓动进行了几次乘方.
		 */
		public static const POWER:uint = 0;
		
		/**
		 * 无缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @return 当前时间的值.
		 */
		public static function easeNone(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c * t / d + b;
		}
	}
}
