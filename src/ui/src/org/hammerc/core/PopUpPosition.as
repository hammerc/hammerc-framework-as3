// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.core
{
	use namespace hammerc_internal;
	
	/**
	 * <code>PopUpPosition</code> 类定义弹出位置的常量值. 该常量决定目标对象相对于父级组件的弹出位置.
	 * @author wizardc
	 */
	public class PopUpPosition
	{
		/**
		 * 在组件上方弹出.
		 */
		public static const ABOVE:String = "above";
		
		/**
		 * 在组件下方弹出.
		 */
		public static const BELOW:String = "below";
		
		/**
		 * 在组件中心弹出.
		 */
		public static const CENTER:String = "center";
		
		/**
		 * 在组件左上角弹出.
		 */
		public static const TOP_LEFT:String = "topLeft";
		
		/**
		 * 在组件左边弹出.
		 */
		public static const LEFT:String = "left";
		
		/**
		 * 在组件右边弹出.
		 */
		public static const RIGHT:String = "right";
		
		/**
		 * 优先在组件下方弹出, 如果空间不够则在组件上方弹出.
		 */
		hammerc_internal static const DROP_DOWN_LIST:String = "dropDownList";
	}
}
