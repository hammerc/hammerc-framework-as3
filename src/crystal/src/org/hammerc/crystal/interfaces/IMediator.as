/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.crystal.interfaces
{
	/**
	 * <code>IMediator</code> 接口定义了中介类应有的属性和方法.
	 * @author wizardc
	 */
	public interface IMediator extends IObserver
	{
		/**
		 * 获取中介对象的名称.
		 */
		function get name():String;
		
		/**
		 * 设置或获取该中介对象对应的具体显示对象.
		 */
		function set viewComponent(value:Object):void;
		function get viewComponent():Object;
		
		/**
		 * 当中介对象注册后会调用该方法.
		 */
		function onRegister():void;
		
		/**
		 * 当中介对象移除后会调用该方法.
		 */
		function onRemove():void;
		
		/**
		 * 获取中介对象感兴趣的消息名称列表.
		 * @return 中介对象感兴趣的消息名称列表.
		 */
		function interestNotificationList():Array;
	}
}
