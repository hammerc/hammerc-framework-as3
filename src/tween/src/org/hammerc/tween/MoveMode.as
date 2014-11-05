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
	 * <code>MoveMode</code> 类枚举了缓动移动的所有方式.
	 * @author wizardc
	 */
	public class MoveMode
	{
		/**
		 * 到达模式, 对象的属性最终会到达指定的值.
		 * <p>例: <code>Tween.to(sprite, 1, {x:100, moveMode:MoveMode.ARRIVE});</code>, 如果 sprite 对象的 x 坐标起始值为 50 则最终会缓动到 100.</p>
		 */
		public static const ARRIVE:int = 0;
		
		/**
		 * 累加模式, 对象的属性会累加指定的值.
		 * <p>例: <code>Tween.to(sprite, 1, {x:100, moveMode:MoveMode.ADDITION});</code>, 如果 sprite 对象的 x 坐标起始值为 50 则最终会缓动到 150.</p>
		 */
		public static const ADDITION:int = 1;
	}
}
