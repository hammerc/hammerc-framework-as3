/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>IEventManager</code> 接口扩展了事件的管理.
	 * @author wizardc
	 */
	public interface IExtendEventDispatcher extends IEventDispatcher
	{
		/**
		 * 判断一个函数是否注册成为了该对象一类事件的侦听器.
		 * @param type 事件的类型.
		 * @param listener 处理事件的侦听器函数.
		 * @param useCapture 确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段.
		 * @return 函数注册成为了该对象一类事件的侦听器则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		function hasListener(type:String, listener:Function, useCapture:Boolean = false):Boolean;
		
		/**
		 * 获取一个函数用于本对象的所有侦听类型.
		 * @param listener 处理事件的侦听器函数.
		 * @param useCapture 确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段.
		 * @return 用于本对象的所有侦听类型.
		 */
		function getListenerType(listener:Function, useCapture:Boolean = false):Vector.<String>;
		
		/**
		 * 移除该对象某一类型的所有事件侦听.
		 * @param type 事件的类型.
		 * @param useCapture 确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段.
		 */
		function removeEventListenersByType(type:String, useCapture:Boolean = false):void;
		
		/**
		 * 移除该对象注册的所有事件侦听.
		 * @param useCapture 确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段.
		 */
		function removeAllEventListenersByCapture(useCapture:Boolean = false):void;
		
		/**
		 * 移除该对象注册的所有事件侦听.
		 */
		function removeAllEventListeners():void;
	}
}
