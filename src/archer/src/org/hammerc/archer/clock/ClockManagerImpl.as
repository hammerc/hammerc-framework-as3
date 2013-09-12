/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.clock
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * <code>ClockManagerImpl</code> 类实现了一个时钟管理器对象.
	 * @author wizardc
	 */
	public class ClockManagerImpl implements IClockManager
	{
		private var _initialized:Boolean = false;
		
		private var _runningRate:Number = 1;
		private var _lastTime:Number = 0;
		private var _clientList:Vector.<IClockClient>;
		
		private var _shape:Shape;
		
		/**
		 * 创建一个 <code>ClockManagerImpl</code> 对象.
		 */
		public function ClockManagerImpl()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function set runningRate(value:Number):void
		{
			if(value < 0 || isNaN(value))
			{
				value = 0;
			}
			_runningRate = value;
		}
		public function get runningRate():Number
		{
			return _runningRate;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get time():Number
		{
			return _lastTime;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addClockClient(client:IClockClient):void
		{
			if(!_initialized)
			{
				this.initialize();
				_initialized = true;
			}
			if(client != null && _clientList.indexOf(client) == -1)
			{
				_clientList.push(client);
			}
		}
		
		/**
		 * 初始化方法.
		 */
		protected function initialize():void
		{
			_lastTime = getTimer() * .001;
			_clientList = new Vector.<IClockClient>();
			_shape = new Shape();
			_shape.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * 进入帧事件处理方法.
		 * @param event 对应的事件对象.
		 */
		protected function update(event:Event):void
		{
			var nowTime:Number = getTimer() * .001;
			var passedTime:Number = nowTime - _lastTime;
			var length:int = _clientList.length;
			if(length == 0)
			{
				return;
			}
			passedTime *= _runningRate;
			var currentIndex:int = 0;
			for(var i:int = 0; i < length; i++)
			{
				var client:IClockClient = _clientList[i];
				if(client != null)
				{
					if(currentIndex != i)
					{
						_clientList[currentIndex] = client;
						_clientList[i] = null;
					}
					client.update(passedTime);
					currentIndex++;
				}
			}
			if(currentIndex != i)
			{
				length = _clientList.length;
				while(i < length)
				{
					_clientList[currentIndex++] = _clientList[i++];
				}
				_clientList.length = currentIndex;
			}
			_lastTime = nowTime;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasClockClient(client:IClockClient):Boolean
		{
			return _clientList.indexOf(client) != -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeClockClient(client:IClockClient):void
		{
			var index:int = _clientList.indexOf(client);
			if(index != -1)
			{
				_clientList[index] = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_clientList.length = 0;
		}
	}
}
