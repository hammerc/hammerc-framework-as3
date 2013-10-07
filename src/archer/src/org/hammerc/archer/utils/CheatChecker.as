/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.utils
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * @eventType flash.events.ErrorEvent.ERROR
	 */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 * <code>CheatChecker</code> 类定义了作弊检查的功能, 主要检查玩家使用变速齿轮的作弊情况.
	 * @author wizardc
	 */
	public class CheatChecker extends EventDispatcher
	{
		/**
		 * 记录检测作弊的阀值, 如果应用的时间和系统时间指定的间隔超过该值则判断为作弊, 单位为秒.
		 */
		protected var _threshold:int;
		
		/**
		 * 记录检测作弊的容错, 即累计超过阀值多少次后就判断为作弊.
		 */
		protected var _tolerant:int;
		
		/**
		 * 记录计时器对象.
		 */
		protected var _timer:Timer;
		
		/**
		 * 记录上一次程序的运行时间.
		 */
		protected var _appLastTime:int;
		
		/**
		 * 记录上一次的系统时间.
		 */
		protected var _realLastTime:Number;
		
		/**
		 * 记录异常的次数.
		 */
		protected var _exceptionTimes:int;
		
		/**
		 * 创建一个 <code>CheatChecker</code> 对象.
		 * @param checkInterval 每次检测的间隔, 单位为秒.
		 * @param threshold 检测作弊的阀值.
		 * @param tolerant 检测作弊的容错.
		 */
		public function CheatChecker(checkInterval:int = 1000, threshold:int = 300, tolerant:int = 1)
		{
			_timer = new Timer(Math.max(checkInterval, 100));
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			this.threshold = threshold;
			this.tolerant = tolerant;
		}
		
		/**
		 * 设置或获取检测作弊的阀值, 如果应用的时间和系统时间指定的间隔超过该值则判断为作弊, 单位为秒.
		 */
		public function set threshold(value:int):void
		{
			_threshold = Math.abs(value);
		}
		public function get threshold():int
		{
			return _threshold;
		}
		
		/**
		 * 设置或获取检测作弊的容错, 即累计超过阀值多少次后就判断为作弊.
		 */
		public function set tolerant(value:int):void
		{
			_tolerant = Math.max(value, 1);
		}
		public function get tolerant():int
		{
			return _tolerant;
		}
		
		/**
		 * 开始检测玩家是否使用作弊工具, 如果正在使用则会一直抛出 <code>ErrorEvent</code> 事件.
		 */
		public function start():void
		{
			_appLastTime = getTimer();
			_realLastTime = new Date().getTime();
			_exceptionTimes = 0;
			_timer.start();
		}
		
		/**
		 * 停止检测.
		 */
		public function stop():void
		{
			_timer.stop();
		}
		
		/**
		 * 计时器每次计时事件到达时会触发该方法.
		 * @param event 计时器事件.
		 */
		protected function timerHandler(event:TimerEvent):void
		{
			var nowAppLastTime:int = getTimer();
			var nowRealLastTime:Number = new Date().getTime();
			var appInterval:int = nowAppLastTime - _appLastTime;
			var realInterval:Number = nowRealLastTime - _realLastTime;
			_appLastTime = nowAppLastTime;
			_realLastTime = nowRealLastTime;
			//获取程序和系统之间一段时间内的差值, 差值过大则存在使用变速齿轮的情况
			var gap:int = Math.abs(appInterval - realInterval);
			if(gap >= _threshold)
			{
				_exceptionTimes++;
				if(_exceptionTimes >= _tolerant)
				{
					this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "程序时间异常，检测到可能使用了作弊工具！"));
				}
			}
		}
	}
}
