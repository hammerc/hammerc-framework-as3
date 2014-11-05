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
	 * <code>INotifier</code> 接口定义了消息发送对象应有的属性和方法.
	 * @author wizardc
	 */
	public interface INotifier
	{
		/**
		 * 发送一个消息.
		 * @param notificationName 消息的名称.
		 * @param body 消息的数据.
		 * @param type 消息的类型.
		 */
		function sendNotification(notificationName:String, body:Object = null, type:String = null):void;
	}
}
