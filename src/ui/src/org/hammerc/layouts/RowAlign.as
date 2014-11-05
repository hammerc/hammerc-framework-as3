// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.layouts
{
	/**
	 * <code>RowAlign</code> 类提供 <code>TileLayout</code> 类的行对齐类型.
	 * @author wizardc
	 */
	public class RowAlign
	{
		/**
		 * 不进行两端对齐.
		 */
		public static const TOP:String = "top";
		
		/**
		 * 通过增大垂直间隙将行两端对齐.
		 */
		public static const JUSTIFY_USING_GAP:String = "justifyUsingGap";
		
		/**
		 * 通过增大行高度将行两端对齐.
		 */
		public static const JUSTIFY_USING_HEIGHT:String = "justifyUsingHeight";
	}
}
