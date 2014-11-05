// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.crystal.interfaces
{
	/**
	 * <code>ICommand</code> 接口定义了命令对象应有的属性和方法.
	 * <p>命令对象的实例会在接收到指定的消息后被创建, 当 <code>execute</code> 方法执行完成后该对象会被抛弃.</p>
	 * @author wizardc
	 */
	public interface ICommand
	{
		/**
		 * 执行具体命令的方法.
		 * @param notification 对应的消息对象.
		 */
		function execute(notification:INotification):void;
	}
}
