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
	 * <code>HorizontalAlign</code> 类枚举了水平对齐的类型.
	 * @author wizardc
	 */
	public class HorizontalAlign
	{
		/**
		 * 将子代与容器的左侧对齐.
		 */
		public static const LEFT:String = "left";
		
		/**
		 * 在容器的中心对齐子代.
		 */
		public static const CENTER:String = "center";
		
		/**
		 * 将子代与容器的右侧对齐.
		 */
		public static const RIGHT:String = "right";
		
		/**
		 * 相对于容器对齐子代. 这会将所有子代的大小统一调整为与容器相同的宽度.
		 */
		public static const JUSTIFY:String = "justify";
		
		/**
		 * 相对于容器对子代进行内容对齐. 这会将所有子代的大小统一调整为容器的内容宽度 <code>contentWidth</code>.
		 * <p>容器的内容宽度是最大子代的大小. 如果所有子代都小于容器的宽度, 则会将所有子代的大小调整为容器的宽度.</p>
		 */
		public static const CONTENT_JUSTIFY:String = "contentJustify";
	}
}
