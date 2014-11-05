// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.worker
{
	import flash.display.Sprite;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	/**
	 * <code>SimpleWorker</code> 类为所有子线程的 swf 文档类基类, 可以获取和主线程通信的通道.
	 * @author wizardc
	 */
	public class SimpleWorker extends Sprite
	{
		/**
		 * 记录主线程向本子线程通信的输入通道.
		 */
		protected var _inputChannel:MessageChannel;
		
		/**
		 * 记录本子线程向主线程通信的输出通道.
		 */
		protected var _outputChannel:MessageChannel;
		
		/**
		 * 创建一个 <code>SimpleWorker</code> 对象.
		 */
		public function SimpleWorker()
		{
			this.init();
			this.run();
		}
		
		/**
		 * 线程初始化时会调用该方法.
		 */
		protected function init():void
		{
			_inputChannel = Worker.current.getSharedProperty(WorkerManager.OUTPUT_CHANNEL) as MessageChannel;
			_outputChannel = Worker.current.getSharedProperty(WorkerManager.INPUT_CHANNEL) as MessageChannel;
		}
		
		/**
		 * 线程运行时会调用该方法.
		 */
		protected function run():void
		{
		}
	}
}
