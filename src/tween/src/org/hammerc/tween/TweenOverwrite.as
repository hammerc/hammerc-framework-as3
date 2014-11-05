// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.tween
{
	/**
	 * <code>TweenOverwrite</code> 类枚举了添加一个 Tween 到一个对象上时的处理方法.
	 * @author wizardc
	 */
	public class TweenOverwrite
	{
		/**
		 * 覆盖该对象上的其他 Tween, 该对象之前添加过的 Tween 会被移除.
		 */
		public static const OVERWRITE:int = 0;
		
		/**
		 * 与之前指定对象上的其他 Tween 共存, 多个 Tween 能同时运作.
		 * <ul>
		 * <li>注意: 如果多个 Tween 间存在同样的属性则后添加的值会覆盖之前的值.</li>
		 * <li><code>Tween.to(sprite, 1, {x:100, y:100, overwrite:TweenOverwrite.CONCURRENT});</code></li>
		 * <li><code>Tween.to(sprite, 1, {x:200, overwrite:TweenOverwrite.CONCURRENT});</code></li>
		 * <li>最后 sprite 会到达 200, 100 的位置.</li>
		 * </ul>
		 */
		public static const CONCURRENT:int = 1;
	}
}
