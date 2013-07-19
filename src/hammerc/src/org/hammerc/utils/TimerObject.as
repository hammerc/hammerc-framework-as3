/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType flash.events.TimerEvent.TIMER
	 */
	[Event(name="timer", type="flash.events.TimerEvent")]
	
	/**
	 * @eventType flash.events.TimerEvent.TIMER_COMPLETE
	 */
	[Event(name="timerComplete", type="flash.events.TimerEvent")]
	
	/**
	 * <code>TimerObject</code> 类提供和 <code>Timer</code> 类一致的功能, 但是多个 <code>TimerObject</code> 只共用一个 <code>Timer</code> 对象进行计时.
	 * <p>和 <code>WakeupTimer</code> 类一致, 提供在 Flash 进入睡眠模式后补全缺失的 <code>TimerEvent.TIMER</code> 事件的功能.</p>
	 * @author wizardc
	 */
	public class TimerObject extends EventDispatcher
	{
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
		 * 记录当前的计时器是否正在运行.
		 */
		protected var _running:Boolean;
		
		/**
		 * 创建一个 <code>TimerObject</code> 对象.
		 * @param delay 每次触发计时器事件的间隔时间.
		 * @param repeatCount 计时器运行总次数.
		 */
		public function TimerObject(delay:Number, repeatCount:int = 0)
		{
			_delay = delay;
			_repeatCount = repeatCount;
			_currentCount = 0;
			_running = false;
		}
		
		/**
		 * 设置或获取每次触发计时器事件的间隔时间.
		 */
		public function set delay(value:Number):void
		{
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
			return _running;
		}
		
		/**
		 * 计时器管理对象更新时会调用本方法.
		 * @param event 计时器事件.
		 */
		hammerc_internal function update(event:TimerEvent):void
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
			TimerManager.getInstance().hammerc_internal::appendTimer(this);
			_lastTime = getTimer();
			_running = true;
		}
		
		/**
		 * 重置计时器.
		 */
		public function reset():void
		{
			this.stop();
			_currentCount = 0;
		}
		
		/**
		 * 停止计时器.
		 */
		public function stop():void
		{
			TimerManager.getInstance().hammerc_internal::removeTimer(this);
			_running = false;
		}
	}
}
