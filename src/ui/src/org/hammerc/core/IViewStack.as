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
	/**
	 * <code>IViewStack</code> 接口定义了层级堆叠容器的接口.
	 * @author wizardc
	 */
	public interface IViewStack
	{
		/**
		 * 设置或获取当前可见子元素的索引. 索引从 0 开始.
		 */
		function set selectedIndex(value:int):void;
		function get selectedIndex():int;
		
		/**
		 * 设置或获取当前可见的子元素.
		 */
		function set selectedChild(value:IUIComponent):void;
		function get selectedChild():IUIComponent;
	}
}
