/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.getTimer;
	
	/**
	 * <code>SystemUtil</code> 类提供用于系统的功能.
	 * @author wizardc
	 */
	public class SystemUtil
	{
		private static var _markTime:uint = 0;
		
		/**
		 * 获取播放器及运行平台的信息.
		 * @return 播放器及运行平台的信息.
		 */
		public static function getPlayerInfo():String
		{
			var type:String = (Capabilities.isDebugger) ? "Debugger" : "Release";
			return "Flash Platform: " + type + " " + Capabilities.version + " VM: " + System.vmVersion;
		}
		
		/**
		 * 标记一个时间作为运行的开始时间.
		 */
		public static function markTime():void
		{
			_markTime = getTimer();
		}
		
		/**
		 * 获得最近一次标记的时间到现在为止程序运行的时间.
		 * @return 最近一次标记的时间到现在为止经过的毫秒数.
		 */
		public static function getRunTime():uint
		{
			return getTimer() - _markTime;
		}
		
		/**
		 * 获取当前 FlashPlayer 使用的内存.
		 * @return 使用的内存, 单位为字节.
		 */
		public static function getUsedMemory():uint
		{
			var usedMemory:Number = System.totalMemory - System.freeMemory;
			if(usedMemory < 0)
			{
				usedMemory = System.totalMemory;
			}
			return uint(usedMemory);
		}
		
		/**
		 * 强制垃圾回收.
		 * @return 垃圾回收后返回给系统的内存字节大小.
		 */
		public static function gc():uint
		{
			var _memory:uint = getUsedMemory();
			if(Capabilities.isDebugger)
			{
				System.gc();
			}
			else
			{
				try
				{
					new LocalConnection().connect("gc");
					new LocalConnection().connect("gc");
				}
				catch(e:Error)
				{
				}
			}
			return _memory - getUsedMemory();
		}
	}
}
