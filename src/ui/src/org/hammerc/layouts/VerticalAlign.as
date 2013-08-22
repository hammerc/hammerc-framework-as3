/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.layouts
{
	/**
	 * <code>VerticalAlign</code> 类枚举了垂直对齐的类型.
	 * @author wizardc
	 */
	public class VerticalAlign
	{
		/**
		 * 在容器的中央垂直对齐子代.
		 */
		public static const TOP:String = "top";
		
		/**
		 * 在容器的中央垂直对齐子代.
		 */
		public static const MIDDLE:String = "middle";
		
		/**
		 * 相对于容器对齐子代. 这会将所有子代的大小统一调整为与容器相同的高度.
		 */
		public static const BOTTOM:String = "bottom";
		
		/**
		 * 相对于容器对齐子代. 这会将所有子代的大小统一调整为与容器相同的高度.
		 */
		public static const JUSTIFY:String = "justify";
		
		/**
		 * 相对于容器对子代进行内容对齐. 这会将所有子代的大小统一调整为容器的内容高度 <code>contentHeight</code>.
		 * <p>容器的内容高度是最大子代的大小. 如果所有子代都小于容器的高度, 则会将所有子代的大小调整为容器的高度.</p>
		 */
		public static const CONTENT_JUSTIFY:String = "contentJustify";
	}
}
