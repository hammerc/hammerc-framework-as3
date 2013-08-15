/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
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
