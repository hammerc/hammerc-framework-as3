// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.managers
{
	import flash.display.Stage;
	
	/**
	 * <code>IFocusManager</code> 定义了焦点管理器的接口.
	 * @author wizardc
	 */
	public interface IFocusManager
	{
		/**
		 * 设置或获取舞台引用.
		 */
		function set stage(value:Stage):void;
		function get stage():Stage;
	}
}
