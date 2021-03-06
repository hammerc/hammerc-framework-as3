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
	 * <code>IToolTip</code> 接口定义了工具提示的组件.
	 * @author wizardc
	 */
	public interface IToolTip extends IUIComponent
	{
		/**
		 * 设置或获取工具提示的数据对象.
		 */
		function set toolTipData(value:Object):void;
		function get toolTipData():Object;
	}
}
