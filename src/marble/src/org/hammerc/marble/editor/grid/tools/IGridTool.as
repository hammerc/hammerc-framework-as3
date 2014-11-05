// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.grid.tools
{
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>IGridTool</code> 接口定义了格子编辑器绘制工具应有的属性和方法.
	 * @author wizardc
	 */
	public interface IGridTool extends IEventDispatcher
	{
		/**
		 * 开始使用该工具时会调用本方法.
		 */
		function onRegister():void;
		
		/**
		 * 取消使用该工具时会调用本方法.
		 */
		function onRemove():void;
	}
}
