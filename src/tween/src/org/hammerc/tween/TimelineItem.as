/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween
{
	/**
	 * <code>TimelineItem</code> 类记录了一个位于时间轴对象中的缓动对象.
	 * @author wizardc
	 */
	public class TimelineItem
	{
		/**
		 * 缓动对象.
		 */
		protected var _tween:AbstractTweenCore;
		
		/**
		 * 缓动的帧时间点.
		 */
		protected var _frame:Number;
		
		/**
		 * 播放排列方式.
		 */
		protected var _align:int;
		
		/**
		 * 缓动开始运行时的时间.
		 */
		protected var _startTime:Number;
		
		/**
		 * 缓动结束运行时的时间.
		 */
		protected var _endTime:Number;
		
		/**
		 * 创建一个 <code>TimelineItem</code> 对象.
		 * @param tween 缓动对象.
		 * @param frame 缓动的帧时间点.
		 * @param align 播放排列方式.
		 * @param time 缓动开始运行时的时间.
		 */
		public function TimelineItem(tween:AbstractTweenCore, frame:Number, align:int, time:Number)
		{
			_tween = tween;
			_frame = frame;
			_align = align;
			this.updateTime(time);
		}
		
		/**
		 * 获取缓动对象.
		 */
		public function get tween():AbstractTweenCore
		{
			return _tween;
		}
		
		/**
		 * 获取缓动的帧时间点.
		 */
		public function get frame():Number
		{
			return _frame;
		}
		
		/**
		 * 获取播放排列方式.
		 */
		public function get align():int
		{
			return _align;
		}
		
		/**
		 * 获取缓动开始运行时的时间.
		 */
		public function get startTime():Number
		{
			return _startTime;
		}
		
		/**
		 * 获取缓动结束运行时的时间.
		 */
		public function get endTime():Number
		{
			return _endTime;
		}
		
		/**
		 * 更新缓动的时间.
		 * @param time 开始缓动的时间.
		 */
		public function updateTime(time:Number):void
		{
			_startTime = time;
			_endTime = time + _tween.totalDuration;
		}
	}
}
