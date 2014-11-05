// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.debug
{
	import org.hammerc.utils.BitUtil;
	import org.hammerc.utils.DateUtil;
	
	/**
	 * <code>Logger</code> 类提供了一个简便的日志记录功能.
	 * @author wizardc
	 */
	public class Logger
	{
		/**
		 * 记录当前日志进行记录的消息, 默认会对所有消息进行记录和输出.
		 */
		public static var channels:uint = LoggerChannel.ALL;
		
		/**
		 * 记录消息会输出到的目的地.
		 */
		public static var destination:uint = LoggerDestination.ALL;
		
		/**
		 * 指定消息会被输出到的自定义接收对象.
		 */
		public static var receiver:ILogReceiver;
		
		/**
		 * 指定输出的消息是否包含通道的信息.
		 */
		public static var includeChannels:Boolean = true;
		
		/**
		 * 指定输出的消息是否包含日期.
		 */
		public static var includeDate:Boolean = true;
		
		/**
		 * 指定输出的消息是否包含时间.
		 */
		public static var includeTime:Boolean = true;
		
		/**
		 * 设置或获取是否输出一条会造成应用程序奔溃的消息.
		 */
		public static function set printFatal(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 0, value);
		}
		public static function get printFatal():Boolean
		{
			return BitUtil.getBit32(channels, 0);
		}
		
		/**
		 * 输出一条会造成应用程序奔溃的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function fatal(...args):void
		{
			if(printFatal)
			{
				logging(LoggerChannel.FATAL, "FATAL", args);
			}
		}
		
		/**
		 * 设置或获取是否输出一条用于应用程序调试的消息.
		 */
		public static function set printDebug(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 1, value);
		}
		public static function get printDebug():Boolean
		{
			return BitUtil.getBit32(channels, 1);
		}
		
		/**
		 * 输出一条用于应用程序调试的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function debug(...args):void
		{
			if(printDebug)
			{
				logging(LoggerChannel.DEBUG, "DEBUG", args);
			}
		}
		
		/**
		 * 设置或获取是否输出一条会使应用程序无法继续运行的消息.
		 */
		public static function set printError(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 2, value);
		}
		public static function get printError():Boolean
		{
			return BitUtil.getBit32(channels, 2);
		}
		
		/**
		 * 输出一条会使应用程序无法继续运行的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function error(...args):void
		{
			if(printError)
			{
				logging(LoggerChannel.ERROR, "ERROR", args);
			}
		}
		
		/**
		 * 设置或获取是否输出一条会对应用程序造成损害的消息.
		 */
		public static function set printWarn(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 3, value);
		}
		public static function get printWarn():Boolean
		{
			return BitUtil.getBit32(channels, 3);
		}
		
		/**
		 * 输出一条会对应用程序造成损害的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function warn(...args):void
		{
			if(printWarn)
			{
				logging(LoggerChannel.WARN, "WARN ", args);
			}
		}
		
		/**
		 * 设置或获取是否输出一条对应用程序运行提供说明的消息.
		 */
		public static function set printInfo(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 4, value);
		}
		public static function get printInfo():Boolean
		{
			return BitUtil.getBit32(channels, 4);
		}
		
		/**
		 * 输出一条对应用程序运行提供说明的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function info(...args):void
		{
			if(printInfo)
			{
				logging(LoggerChannel.INFO, "INFO ", args);
			}
		}
		
		private static function logging(channel:uint, channelName:String, args:Array):void
		{
			var tips:String = getTips(channelName);
			if(tips != "")
			{
				args.unshift(tips);
			}
			if(BitUtil.getBit32(destination, 0))
			{
				trace.apply(null, args);
			}
			if(BitUtil.getBit32(destination, 1) && receiver != null)
			{
				receiver.dataArrival(channel, args.join(" "));
			}
		}
		
		private static function getTips(channelName:String):String
		{
			var result:String = "";
			if(includeChannels)
			{
				result += channelName + " ";
			}
			if(includeDate || includeTime)
			{
				var date:Date = new Date();
			}
			if(includeDate)
			{
				result += DateUtil.dateFormat(date, "YYYY-MM-DD") + " ";
			}
			if(includeTime)
			{
				result += DateUtil.dateFormat(date, "HH:NN:SS") + " ";
			}
			if(result.length > 0)
			{
				result = result.substr(0, result.length - 1);
				result = "[" + result + "]";
			}
			return result;
		}
	}
}
