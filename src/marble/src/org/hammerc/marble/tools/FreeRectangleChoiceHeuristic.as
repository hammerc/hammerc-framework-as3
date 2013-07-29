/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.tools
{
	/**
	 * <code>FreeRectangleChoiceHeuristic</code> 类指定了添加新区域到大图时的位置选择方法.
	 * <p>本类算法实现来自 <b>杜增强.COM</b> 地址: <a href="http://www.duzengqiang.com/blog/post/971.html">http://www.duzengqiang.com/blog/post/971.html</a>.</p>
	 * @author wizardc
	 */
	public class FreeRectangleChoiceHeuristic
	{
		/**
		 * Positions the Rectangle against the short side of a free Rectangle into which it fits the best.
		 */
		public static const BEST_SHORT_SIDE_FIT:int = 0;
		
		/**
		 * Positions the Rectangle against the long side of a free Rectangle into which it fits the best.
		 */
		public static const BEST_LONG_SIDE_FIT:int = 1;
		
		/**
		 * Positions the Rectangle into the smallest free Rectangle into which it fits.
		 */
		public static const BEST_AREA_FIT:int = 2;
		
		/**
		 * Does the Tetris placement.
		 */
		public static const BOTTOM_LEFT_RULE:int = 3;
		
		/**
		 * Choosest the placement where the Rectangle touches other Rectangles as much as possible.
		 */
		public static const CONTACT_POINT_RULE:int = 4;
	}
}
