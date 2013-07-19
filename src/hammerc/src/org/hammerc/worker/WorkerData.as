/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.worker
{
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	/**
	 * <code>WorkerData</code> 类记录基于主线程的子线程及主线程和子线程的消息通道对象.
	 * @author wizardc
	 */
	public class WorkerData
	{
		/**
		 * 记录子线程对象.
		 */
		protected var _worker:Worker;
		
		/**
		 * 记录子线程向主线程通信的通道.
		 */
		protected var _inputChannel:MessageChannel;
		
		/**
		 * 记录主线程向子线程通信的通道.
		 */
		protected var _outputChannel:MessageChannel;
		
		/**
		 * 创建一个 <code>WorkerData</code> 对象.
		 * @param worker 子线程对象.
		 * @param inputChannel 子线程向主线程通信的通道.
		 * @param outputChannel 主线程向子线程通信的通道.
		 */
		public function WorkerData(worker:Worker, inputChannel:MessageChannel, outputChannel:MessageChannel)
		{
			_worker = worker;
			_inputChannel = inputChannel;
			_outputChannel = outputChannel;
		}
		
		/**
		 * 获取子线程对象.
		 */
		public function get worker():Worker
		{
			return _worker;
		}
		
		/**
		 * 获取子线程向主线程通信的通道.
		 */
		public function get inputChannel():MessageChannel
		{
			return _inputChannel;
		}
		
		/**
		 * 获取主线程向子线程通信的通道.
		 */
		public function get outputChannel():MessageChannel
		{
			return _outputChannel;
		}
	}
}
