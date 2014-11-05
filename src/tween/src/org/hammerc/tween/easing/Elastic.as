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
	 * <code>Elastic</code> 类定义了指数衰减的正弦曲线缓动效果.
	 * <p>算法来自 Robert Penner 的博客: http://www.robertpenner.com/easing/.</p>
	 * @author wizardc
	 */
	public class Elastic
	{
		private static const PI2:Number = Math.PI * 2;
		
		/**
		 * 速度从 0 开始加速的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @param a aplitude 的正弦曲线, 较低的数字比高数字更加极端.
		 * @param p 当前的正弦波, 较高数字比较光滑.
		 * @return 当前时间的值.
		 */
		public static function easeIn(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number
		{
			var s:Number;
			if(t == 0)
			{
				return b;
			}
			if((t /= d) == 1)
			{
				return b + c;
			}
			if(!p)
			{
				p = d * .3;
			}
			if(!a || (c > 0 && a < c) || (c < 0 && a < -c))
			{
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / PI2 * Math.asin(c / a);
			}
			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p )) + b;
		}
		
		/**
		 * 速度减速到 0 的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @param a aplitude 的正弦曲线, 较低的数字比高数字更加极端.
		 * @param p 当前的正弦波, 较高数字比较光滑.
		 * @return 当前时间的值.
		 */
		public static function easeOut(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number
		{
			var s:Number;
			if(t == 0)
			{
				return b;
			}
			if((t /= d) == 1)
			{
				return b + c;
			}
			if(!p)
			{
				p = d * .3;
			}
			if(!a || (c > 0 && a < c) || (c < 0 && a < -c))
			{
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / PI2 * Math.asin(c / a);
			}
			return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * PI2 / p ) + c + b);
		}
		
		/**
		 * 速度前半段从 0 开始加速, 后半段减速到 0 的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @param a aplitude 的正弦曲线, 较低的数字比高数字更加极端.
		 * @param p 当前的正弦波, 较高数字比较光滑.
		 * @return 当前时间的值.
		 */
		public static function easeInOut(t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number
		{
			var s:Number;
			if(t == 0)
			{
				return b;
			}
			if((t /= d * .5) == 2)
			{
				return b + c;
			}
			if(!p)
			{
				p = d * (.3 * 1.5);
			}
			if(!a || (c > 0 && a < c) || (c < 0 && a < -c))
			{
				a = c;
				s = p / 4;
			}
			else
			{
				s = p / PI2 * Math.asin(c / a);
			}
			if(t < 1)
			{
				return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p)) + b;
			}
			return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * PI2 / p)* .5 + c + b;
		}
	}
}
