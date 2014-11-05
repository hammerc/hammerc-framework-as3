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
	 * <code>IProxy</code> 接口定义代理类应有的属性和方法.
	 * @author wizardc
	 */
	public interface IProxy
	{
		/**
		 * 获取代理对象的名称.
		 */
		function get name():String;
		
		/**
		 * 设置或获取代理对象持有的数据.
		 */
		function set data(value:Object):void;
		function get data():Object;
		
		/**
		 * 当代理对象注册后会调用该方法.
		 */
		function onRegister():void;
		
		/**
		 * 当代理对象移除后会调用该方法.
		 */
		function onRemove():void;
	}
}
