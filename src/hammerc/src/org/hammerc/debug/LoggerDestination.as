/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.debug
{
	/**
	 * <code>LoggerDestination</code> 类定义了消息输出目的地的枚举.
	 * @author wizardc
	 */
	public class LoggerDestination
	{
		/**
		 * 记录输出消息到控制台.
		 */
		public static const CONSOLE:uint = 1;
		
		/**
		 * 记录输出消息到自定义接收对象, 可在该对象中决定将消息发送到其它地方 (如: 远程服务端或本地文件).
		 */
		public static const CUSTOM:uint = 2;
		
		/**
		 * 记录输出消息到控制台和自定义接收对象.
		 */
		public static const ALL:uint = CONSOLE | CUSTOM;
	}
}
