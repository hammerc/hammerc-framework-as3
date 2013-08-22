/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.layouts
{
	/**
	 * <code>ColumnAlign</code> 类提供 <code>TileLayout</code> 类的列对齐类型.
	 * @author wizardc
	 */
	public class ColumnAlign
	{
		/**
		 * 不将行两端对齐.
		 */
		public static const LEFT:String = "left";
		
		/**
		 * 通过增大水平间隙将行两端对齐.
		 */
		public static const JUSTIFY_USING_GAP:String = "justifyUsingGap";
		
		/**
		 * 通过增大行高度将行两端对齐.
		 */
		public static const JUSTIFY_USING_WIDTH:String = "justifyUsingWidth";
	}
}
