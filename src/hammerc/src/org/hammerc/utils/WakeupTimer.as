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
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * @eventType flash.events.TimerEvent.TIMER
	 */
	[Event(name="timer", type="flash.events.TimerEvent")]
	
	/**
	 * @eventType flash.events.TimerEvent.TIMER_COMPLETE
	 */
	[Event(name="timerComplete", type="flash.events.TimerEvent")]
	
	/**
	 * <code>WakeupTimer</code> 类和 <code>Timer</code> 类的功能一致, 同时提供在 Flash 进入睡眠模式后补全缺失的 <code>TimerEvent.TIMER</code> 事件的功能.
	 * @author wizardc
	 */
	public class WakeupTimer extends EventDispatcher
	{
		/**
		 * 实现计时器的对象.
		 */
		protected var _timer:Timer;
		
		/**
		 * 上一次计时的时间.
		 */
		protected var _lastTime:int;
		
		/**
		 * 每次触发计时器事件的间隔时间.
		 */
		protected var _delay:Number;
		
		/**
		 * 记录计时器运行总次数.
		 */
		protected var _repeatCount:int;
		
		/**
		 * 记录计时器从 0 开始后触发的总次数.
		 */
		protected var _currentCount:int;
		
		/**
		 * 创建一个 <code>WakeupTimer</code> 对象.
		 * @param delay 每次触发计时器事件的间隔时间.
		 * @param repeatCount 计时器运行总次数.
		 */
		public function WakeupTimer(delay:Number, repeatCount:int = 0)
		{
			_delay = delay;
			_repeatCount = repeatCount;
			_currentCount = 0;
			_timer = new Timer(_delay, 0);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		/**
		 * 设置或获取每次触发计时器事件的间隔时间.
		 */
		public function set delay(value:Number):void
		{
			_timer.delay = value;
			_delay = value;
		}
		public function get delay():Number
		{
			return _delay;
		}
		
		/**
		 * 设置或获取计时器运行总次数.
		 */
		public function set repeatCount(value:Number):void
		{
			_timer.repeatCount = value;
			_repeatCount = value;
		}
		public function get repeatCount():Number
		{
			return _repeatCount;
		}
		
		/**
		 * 获取计时器从 0 开始后触发的总次数.
		 */
		public function get currentCount():Number
		{
			return _currentCount;
		}
		
		/**
		 * 获取计时器的当前是否正在运行.
		 */
		public function get running():Boolean
		{
			return _timer.running;
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			var now:int = getTimer();
			var interval:int = now - _lastTime;
			//记录上一次计时的时间
			if(interval >= _delay)
			{
				_lastTime = now;
			}
			//触发时间间隔内的所有事件
			while(interval >= _delay)
			{
				_currentCount++;
				this.dispatchEvent(event);
				if(_repeatCount > 0 && _currentCount >= _repeatCount)
				{
					this.stop();
					this.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
					break;
				}
				interval -= _delay;
			}
		}
		
		/**
		 * 启动计时器.
		 */
		public function start():void
		{
			_timer.start();
			_lastTime = getTimer();
		}
		
		/**
		 * 重置计时器.
		 */
		public function reset():void
		{
			_timer.reset();
			_currentCount = 0;
		}
		
		/**
		 * 停止计时器.
		 */
		public function stop():void
		{
			_timer.stop();
		}
	}
}
