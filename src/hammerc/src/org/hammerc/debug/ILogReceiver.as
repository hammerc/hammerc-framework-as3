/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.debug
{
	/**
	 * <code>ILogReceiver</code> 接口实现了自定义的日志接收对象必须实现的方法.
	 * @author wizardc
	 */
	public interface ILogReceiver
	{
		/**
		 * 每当有日志消息到达时会触发该方法.
		 * @param data 接收到的日志消息.
		 */
		function dataArrival(data:String):void;
	}
}
