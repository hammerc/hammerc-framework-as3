/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.crystal.interfaces
{
	/**
	 * <code>INotification</code> 接口定义了连接 Model 层和 View 层通讯发送的消息体对象应有的属性和方法.
	 * @author wizardc
	 */
	public interface INotification
	{
		/**
		 * 获取消息名称.
		 */
		function get name():String;
		
		/**
		 * 设置或获取消息的类型.
		 */
		function set type(value:String):void;
		function get type():String;
		
		/**
		 * 设置或获取消息的数据.
		 */
		function set body(value:Object):void;
		function get body():Object;
		
		/**
		 * 获取本对象的字符串描述.
		 * @return 本对象的字符串描述.
		 */
		function toString():String;
	}
}
