/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.worker
{
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	/**
	 * <code>WorkerManager</code> 类提供和 <code>WorkerDomain</code> 类类似的方法, 同时封装了线程的连接.
	 * <p>注意静态方法 <code>createWorker</code> 创建一个基于主线程的子线程, 同时会创建两个消息通道连接主线程和子线程.</p>
	 * @author wizardc
	 */
	public class WorkerManager
	{
		/**
		 * 表示当前线程的输入消息通道.
		 */
		public static const INPUT_CHANNEL:String = "inputChannel";
		
		/**
		 * 表示当前线程的输出消息通道.
		 */
		public static const OUTPUT_CHANNEL:String = "outputChannel";
		
		/**
		 * 获取当前运行时上下文是否支持将 <code>WorkerDomain</code> 和 <code>Worker</code> 对象用于并行代码执行.
		 */
		public static function get isSupported():Boolean
		{
			return WorkerDomain.isSupported;
		}
		
		/**
		 * 获取 <code>WorkerDomain</code> 中当前正在运行的 <code>worker</code>(<code>Worker</code> 实例的 <code>state</code> 属性为 <code>WorkerState.RUNNING</code>)集的访问.
		 */
		public static function get listWorkers():Vector.<Worker>
		{
			return WorkerDomain.current.listWorkers();
		}
		
		/**
		 * 基于某个 swf 的字节创建一个新的 <code>Worker</code> 实例并和主线程建立消息通道.
		 * @param swf 包含有效 swf 的字节的 <code>ByteArray</code>.
		 * @param giveAppPrivileges 指示在 AIR 中是否应当向 <code>worker</code> 授予应用程序沙箱权限.
		 * @return 成功时返回新创建的 <code>WorkerData</code> 对象. 返回值为 <code>null</code> 时表示无法创建 <code>worker</code>, 因为当前上下文不支持并发或者创建新 <code>worker</code> 将超出实现限制.
		 */
		public static function createWorker(swf:ByteArray, giveAppPrivileges:Boolean = false):WorkerData
		{
			var worker:Worker = WorkerDomain.current.createWorker(swf, giveAppPrivileges);
			if(worker == null)
			{
				return null;
			}
			var inputChannel:MessageChannel = worker.createMessageChannel(Worker.current);
			var outputChannel:MessageChannel = Worker.current.createMessageChannel(worker);
			worker.setSharedProperty(INPUT_CHANNEL, inputChannel);
			worker.setSharedProperty(OUTPUT_CHANNEL, outputChannel);
			return new WorkerData(worker, inputChannel, outputChannel);
		}
	}
}
