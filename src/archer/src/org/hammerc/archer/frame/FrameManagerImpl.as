// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.frame
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[ExcludeClass]
	
	/**
	 * <code>FrameManagerImpl</code> 类实现了帧执行管理器的功能.
	 * @author wizardc
	 */
	public class FrameManagerImpl implements IFrameManager
	{
		private var _paused:Boolean = false;
		private var _lastTime:int;
		private var _clientList:Vector.<IFrameClient>;
		private var _timeoutId:uint;
		private var _numTimeoutCount:int;
		private var _timeoutMap:Dictionary;
		
		private var _shape:Shape;
		
		/**
		 * 创建一个 <code>FrameManagerImpl</code> 对象.
		 */
		public function FrameManagerImpl()
		{
			_lastTime = getTimer();
			_clientList = new Vector.<IFrameClient>();
			_timeoutMap = new Dictionary();
			_shape = new Shape();
			_shape.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numFrameClent():int
		{
			return _clientList.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numTimeoutCount():int
		{
			return _numTimeoutCount;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set paused(value:Boolean):void
		{
			_paused = value;
		}
		public function get paused():Boolean
		{
			return _paused;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addFrameClient(client:IFrameClient):void
		{
			if(client != null && _clientList.indexOf(client) == -1)
			{
				_clientList.push(client);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasFrameClient(client:IFrameClient):Boolean
		{
			return _clientList.indexOf(client) != -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeFrameClient(client:IFrameClient):void
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
		public function setTimeout(closure:Function, delay:int, ...args):uint
		{
			++_numTimeoutCount;
			var client:TimeoutClient = new TimeoutClient(_timeoutId, closure, delay, args);
			_timeoutMap[_timeoutId] = client;
			return _timeoutId++;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clearTimeout(id:uint):void
		{
			if(_timeoutMap[id] != null)
			{
				--_numTimeoutCount;
				delete _timeoutMap[id];
			}
		}
		
		private function update(event:Event):void
		{
			if(_paused)
			{
				return;
			}
			var nowTime:int = getTimer();
			var passedTime:int = nowTime - _lastTime;
			var passedSecond:Number = passedTime * 0.001;
			_lastTime = nowTime;
			var length:int = _clientList.length;
			if(length != 0)
			{
				var currentIndex:int = 0;
				for(var i:int = 0; i < length; i++)
				{
					var client:IFrameClient = _clientList[i];
					if(client != null)
					{
						if(currentIndex != i)
						{
							_clientList[currentIndex] = client;
							_clientList[i] = null;
						}
						client.frameHandler(passedSecond);
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
			}
			var executeList:Array = new Array();
			for each(var timeout:TimeoutClient in _timeoutMap)
			{
				timeout.delay -= passedTime;
				if(timeout.delay <= 0)
				{
					executeList.push(timeout);
				}
			}
			if(executeList.length > 0)
			{
				_numTimeoutCount -= executeList.length;
				executeList.sortOn("delay", Array.NUMERIC);
				for each(timeout in executeList)
				{
					if(timeout.closure != null)
					{
						timeout.closure.apply(null, timeout.args);
					}
					delete _timeoutMap[timeout.id];
				}
			}
		}
	}
}

/**
 * <code>TimeoutClient</code> 类记录一个超时回调的数据.
 */
class TimeoutClient
{
	/**
	 * 超时回调 ID.
	 */
	public var id:uint;
	
	/**
	 * 延迟回调方法.
	 */
	public var closure:Function;
	
	/**
	 * 距开始执行还剩余的时间.
	 */
	public var delay:int;
	
	/**
	 * 会传递给延迟回调方法的参数.
	 */
	public var args:Array;
	
	/**
	 * 创建一个 <code>TimeoutClient</code> 对象.
	 * @param id 超时回调 ID.
	 * @param closure 延迟回调方法.
	 * @param delay 距开始执行还剩余的时间.
	 * @param args 会传递给延迟回调方法的参数.
	 */
	public function TimeoutClient(id:uint, closure:Function, delay:int, args:Array)
	{
		this.id = id;
		this.closure = closure;
		this.delay = delay;
		this.args = args;
	}
}
