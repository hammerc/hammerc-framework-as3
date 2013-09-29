/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.clock
{
	/**
	 * <code>IClockManager</code> 接口定义了时钟管理器应有的属性及方法.
	 * @author wizardc
	 */
	public interface IClockManager
	{
		/**
		 * 设置或获取时钟运行的速率.
		 */
		function set runningRate(value:Number):void;
		function get runningRate():Number;
		
		/**
		 * 获取当前的时间.
		 */
		function get time():Number;
		
		/**
		 * 添加一个时钟对象.
		 * @param client 时钟对象.
		 */
		function addClockClient(client:IClockClient):void;
		
		/**
		 * 判断指定的时钟对象是否存在.
		 * @param client 时钟对象.
		 * @return 指定的时钟对象是否存在.
		 */
		function hasClockClient(client:IClockClient):Boolean;
		
		/**
		 * 移除一个时钟对象.
		 * @param client 时钟对象.
		 */
		function removeClockClient(client:IClockClient):void;
		
		/**
		 * 移除所有的时钟对象.
		 */
		function clear():void;
	}
}