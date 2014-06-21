/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.debug
{
	/**
	 * <code>LoggerChannel</code> 类定义了消息通道的枚举.
	 * @author wizardc
	 */
	public class LoggerChannel
	{
		/**
		 * 提示不输出任何消息.
		 */
		public static const NONE:uint = 0;
		
		/**
		 * 提示会造成应用程序奔溃的消息.
		 */
		public static const FATAL:uint = 1;
		
		/**
		 * 提示用于应用程序调试的消息.
		 */
		public static const DEBUG:uint = 2;
		
		/**
		 * 提示会使应用程序无法继续运行的消息.
		 */
		public static const ERROR:uint = 4;
		
		/**
		 * 提示会对应用程序造成损害的消息.
		 */
		public static const WARN:uint = 8;
		
		/**
		 * 提示对应用程序运行提供说明的消息.
		 */
		public static const INFO:uint = 16;
		
		/**
		 * 提示输出所有消息.
		 */
		public static const ALL:uint = FATAL | DEBUG | ERROR | WARN | INFO;
	}
}
