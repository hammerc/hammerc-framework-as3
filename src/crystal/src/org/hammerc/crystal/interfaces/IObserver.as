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
	 * <code>IObserver</code> 接口定义了观察者对象应有的属性和方法.
	 * @author wizardc
	 */
	public interface IObserver
	{
		/**
		 * 当有消息到达时会执行该方法处理消息对象.
		 * @param notification 对应的消息对象.
		 */
		function notificationHandler(notification:INotification):void;
	}
}
