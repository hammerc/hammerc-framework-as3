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
	import flash.events.IEventDispatcher;
	
	import org.hammerc.core.IUIContainer;
	
	/**
	 * <code>ISystemManager</code> 定义了系统管理器的接口.
	 * @author wizardc
	 */
	public interface ISystemManager extends IEventDispatcher
	{
		/**
		 * 获取舞台引用.
		 */
		function get stage():Stage;
		
		/**
		 * 获取弹出窗口层容器.
		 */
		function get popUpContainer():IUIContainer;
		
		/**
		 * 获取工具提示层容器.
		 */
		function get toolTipContainer():IUIContainer;
		
		/**
		 * 获取鼠标样式层容器.
		 */
		function get cursorContainer():IUIContainer;
	}
}
