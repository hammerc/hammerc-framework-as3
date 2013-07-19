/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
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
		
		/**
		 * 记录当前日志进行记录的消息, 默认会对所有消息进行记录和输出.
		 */
		public static var channels:uint = ALL;
		
		/**
		 * 记录输出消息到控制台.
		 */
		public static const CONSOLE:uint = 1;
		
		/**
		 * 记录输出消息到自定义接收对象, 可在该对象中决定将消息发送到其它地方 (如: 远程服务端或本地文件).
		 */
		public static const CUSTOM:uint = 2;
		
		/**
		 * 记录消息会输出到的目的地.
		 */
		public static var destination:uint = CONSOLE;
		
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
		public static function set isFatal(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 0, value);
		}
		public static function get isFatal():Boolean
		{
			return BitUtil.getBit32(channels, 0);
		}
		
		/**
		 * 输出一条会造成应用程序奔溃的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function fatal(...args):void
		{
			if(isFatal)
			{
				logging("FATAL", args);
			}
		}
		
		/**
		 * 设置或获取是否输出一条用于应用程序调试的消息.
		 */
		public static function set isDebug(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 1, value);
		}
		public static function get isDebug():Boolean
		{
			return BitUtil.getBit32(channels, 1);
		}
		
		/**
		 * 输出一条用于应用程序调试的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function debug(...args):void
		{
			if(isDebug)
			{
				logging("DEBUG", args);
			}
		}
		
		/**
		 * 设置或获取是否输出一条会使应用程序无法继续运行的消息.
		 */
		public static function set isError(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 2, value);
		}
		public static function get isError():Boolean
		{
			return BitUtil.getBit32(channels, 2);
		}
		
		/**
		 * 输出一条会使应用程序无法继续运行的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function error(...args):void
		{
			if(isError)
			{
				logging("ERROR", args);
			}
		}
		
		/**
		 * 设置或获取是否输出一条会对应用程序造成损害的消息.
		 */
		public static function set isWarn(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 3, value);
		}
		public static function get isWarn():Boolean
		{
			return BitUtil.getBit32(channels, 3);
		}
		
		/**
		 * 输出一条会对应用程序造成损害的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function warn(...args):void
		{
			if(isWarn)
			{
				logging("WARN ", args);
			}
		}
		
		/**
		 * 设置或获取是否输出一条对应用程序运行提供说明的消息.
		 */
		public static function set isInfo(value:Boolean):void
		{
			channels = BitUtil.setBit32(channels, 4, value);
		}
		public static function get isInfo():Boolean
		{
			return BitUtil.getBit32(channels, 4);
		}
		
		/**
		 * 输出一条对应用程序运行提供说明的消息.
		 * @param args 各种需要输出的数据.
		 */
		public static function info(...args):void
		{
			if(isInfo)
			{
				logging("INFO ", args);
			}
		}
		
		private static function logging(channelName:String, args:Array):void
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
				receiver.dataArrival(args.join(" "));
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
