// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TimerManager</code> 类管理所有的 <code>TimerObject</code> 对象并实现其运作. 本对象内部持有一个用于管理所有 <code>TimerObject</code> 对象的 <code>Timer</code> 对象.
	 * @author wizardc
	 */
	public class TimerManager
	{
		private static var _instance:TimerManager;
		
		/**
		 * 获取本类的唯一实例.
		 * @return 本类的唯一实例.
		 */
		public static function getInstance():TimerManager
		{
			if(_instance == null)
			{
				_instance = new TimerManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/**
		 * 计时器对象的间隔, Flash 支持的最小间隔为 60 帧帧率时的间隔.
		 */
		public static const TIMER_DELAY:Number = 1000 / 60;
		
		private var _timer:Timer;
		private var _timerObjectList:Vector.<TimerObject>;
		
		/**
		 * 本类为单例类不能实例化.
		 * @param singletonEnforcer 单例类实现对象.
		 */
		public function TimerManager(singletonEnforcer:SingletonEnforcer)
		{
			if(singletonEnforcer == null)
			{
				throw new Error("单例类不能进行实例化！");
			}
			_timer = new Timer(TIMER_DELAY);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timerObjectList = new Vector.<TimerObject>();
		}
		
		/**
		 * 添加一个 <code>TimerObject</code> 对象并对其进行管理.
		 * @param timer 需要添加的计时器对象.
		 */
		hammerc_internal function appendTimer(timer:TimerObject):void
		{
			if(timer == null || _timerObjectList.indexOf(timer) != -1)
			{
				return;
			}
			_timerObjectList.push(timer);
			if(!_timer.running)
			{
				_timer.start();
			}
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			for each(var timer:TimerObject in _timerObjectList)
			{
				timer.hammerc_internal::update(event);
			}
		}
		
		/**
		 * 移除一个 <code>TimerObject</code> 对象.
		 * @param timer 需要移除的计时器对象.
		 */
		hammerc_internal function removeTimer(timer:TimerObject):void
		{
			if(timer == null)
			{
				return;
			}
			var index:int = _timerObjectList.indexOf(timer);
			if(index == -1)
			{
				return;
			}
			_timerObjectList.splice(index, 1);
			if(_timerObjectList.length == 0 && _timer.running)
			{
				_timer.stop();
			}
		}
		
		/**
		 * 重置当前正在运行的所有计时器对象.
		 */
		public function reset():void
		{
			while(_timerObjectList.length != 0)
			{
				(_timerObjectList.pop() as TimerObject).reset();
			}
		}
		
		/**
		 * 停止当前正在运行的所有计时器对象.
		 */
		public function stop():void
		{
			while(_timerObjectList.length != 0)
			{
				(_timerObjectList.pop() as TimerObject).stop();
			}
		}
	}
}

class SingletonEnforcer{}
