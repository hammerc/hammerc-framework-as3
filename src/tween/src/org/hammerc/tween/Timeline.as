// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.tween
{
	import flash.utils.Dictionary;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.TimelineEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.TimelineEvent.TIMELINE_START
	 */
	[Event(name="timelineStart", type="org.hammerc.events.TimelineEvent")]
	
	/**
	 * @eventType org.hammerc.events.TimelineEvent.TIMELINE_UPDATE
	 */
	[Event(name="timelineUpdate", type="org.hammerc.events.TimelineEvent")]
	
	/**
	 * @eventType org.hammerc.events.TimelineEvent.TIMELINE_COMPLETE
	 */
	[Event(name="timelineComplete", type="org.hammerc.events.TimelineEvent")]
	
	/**
	 * @eventType org.hammerc.events.TimelineEvent.TIMELINE_REPEAT
	 */
	[Event(name="timelineRepeat", type="org.hammerc.events.TimelineEvent")]
	
	/**
	 * @eventType org.hammerc.events.TimelineEvent.TIMELINE_YOYO_COMPLETE
	 */
	[Event(name="timelineYoyoComplete", type="org.hammerc.events.TimelineEvent")]
	
	/**
	 * <code>Timeline</code> 类实现了基本的时间轴.
	 * @author wizardc
	 */
	public class Timeline extends AbstractTimeline
	{
		/**
		 * 记录了所有可以传递给构造方法的 <code>variables</code> 参数的属性.
		 */
		public static const ATTRIBUTES:Vector.<String> = new <String>["delay", "useFrames", "gc", "yoyo", "yoyoDelay", "repeat", "repeatDelay", "data", "onStart", "onStartParams", "onUpdate", "onUpdateParams", "onComplete", "onCompleteParams", "onRepeat", "onRepeatParams", "onYoyoComplete", "onYoyoCompleteParams"];
		
		/**
		 * 记录每个时间点对应的结束时间.
		 * key 为有缓动添加到的时间, value 为当前 key 指示的时间点上所有的缓动项目列表, align 为 TimelineAlign.CONCURRENT 的项目可以和为 TimelineAlign.SEQUENCE 交叉但是必须保证其顺序为添加时的顺序.
		 */
		protected var _timeMap:Dictionary;
		
		/**
		 * 按正向播放的时间顺序记录所有的缓动对象, <code>startTime</code> 从小到大排序.
		 */
		protected var _forwardTweenList:Vector.<TimelineItem>;
		
		/**
		 * 按逆向播放的时间顺序记录所有的缓动对象, <code>endTime</code> 从大到小排序.
		 */
		protected var _backwardTweenList:Vector.<TimelineItem>;
		
		/**
		 * 记录时间轴播放一次的持续时间, 不包含 <code>delay</code>.
		 */
		protected var _duration:Number = 0;
		
		/**
		 * 缓动已经运行的时间.
		 */
		protected var _runtime:Number = 0;
		
		/**
		 * 缓动需要运行的时间.
		 */
		protected var _totalRuntime:Number = 0;
		
		/**
		 * 缓动已经运行的帧数.
		 */
		protected var _runFrame:int;
		
		/**
		 * 缓动需要运行的帧数.
		 */
		protected var _totalRunFrame:int;
		
		/**
		 * 当前的缓动是否为反向缓动回起始点.
		 */
		protected var _yoyoReverse:Boolean = false;
		
		/**
		 * 当前重复播放的次数.
		 */
		protected var _nowRepeat:int = 0;
		
		/**
		 * 当前的缓动是否为反向播放.
		 */
		protected var _reversed:Boolean = false;
		
		/**
		 * 记录当前播放的缓动对象列表.
		 */
		protected var _playTimelineItems:Vector.<TimelineItem>;
		
		private var _variables:Object;
		
		/**
		 * 创建一个 <code>Timeline</code> 对象.
		 * @param variables 保存初始化时的属性数据的对象.
		 */
		public function Timeline(variables:Object = null)
		{
			_timeMap = new Dictionary();
			_forwardTweenList = new Vector.<TimelineItem>();
			_backwardTweenList = new Vector.<TimelineItem>();
			_variables = variables;
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initTween():void
		{
			for each(var name:String in ATTRIBUTES)
			{
				if(_variables.hasOwnProperty(name))
				{
					this[name] = _variables[name];
				}
			}
			_variables = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set posistion(value:Number):void
		{
			_nowRepeat = 0;
			_yoyoReverse = false;
			_reversed = false;
			value = adjustPosition(value);
			stopTweens(value);
			_playing = false;
		}
		override public function get posistion():Number
		{
			var result:Number = 0;
			var temp:Number = _duration;
			if(_yoyo)
			{
				temp *= 2;
				temp += _yoyoDelay;
			}
			if(_nowRepeat > 0)
			{
				temp *= _nowRepeat;
				temp += (_nowRepeat - 1) * _repeatDelay;
				result += temp;
			}
			return _delay + result + (_useFrames ? _runFrame : _runtime);
		}
		
		/**
		 * 获取时间轴对象一次播放的持续时间.
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get totalDuration():Number
		{
			if(_repeat == -1)
			{
				return Number.POSITIVE_INFINITY;
			}
			var result:Number = _duration;
			if(_yoyo)
			{
				result *= 2;
				result += _yoyoDelay;
			}
			if(_repeat > 0)
			{
				result *= (_repeat + 1);
				result += _repeat * _repeatDelay;
			}
			return _delay + result;
		}
		
		/**
		 * 获取时间排序的所有缓动对象列表.
		 * @param reversed 是否为反向缓动.
		 * @return 时间排序的所有缓动对象列表.
		 */
		protected function getTweens(reversed:Boolean = false):Vector.<TimelineItem>
		{
			if(reversed)
			{
				return _backwardTweenList.concat();
			}
			return _forwardTweenList.concat();
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function update(time:Number):void
		{
			if(_active && _playing)
			{
				var beforeRun:Number = _useFrames ? _runFrame : _runtime;
				_runtime += time;
				_runFrame++;
				var runTemp:Number = _useFrames ? _runFrame : _runtime;
				var totalTemp:Number = _useFrames ? _totalRunFrame : _totalRuntime;
				if(runTemp > 0)
				{
					//记录除了本次缓动外还多出的时间
					var remainTime:Number = 0;
					//记录下多出的时间, 使用帧时不会出现这种情况
					if(runTemp > totalTemp)
					{
						remainTime = runTemp - totalTemp;
						runTemp = totalTemp;
					}
					//计算当前正确的是否在反向缓动
					var yoyoReverse:Boolean = _reversed ? !_yoyoReverse : _yoyoReverse;
					//缓动第一次播放时
					if(beforeRun <= 0)
					{
						call(_onStart, this, _onStartParams);
						this.dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_START, yoyoReverse, _nowRepeat, _data));
					}
					//播放可以播放的缓动
					playTweens(runTemp);
					//更新事件
					call(_onUpdate, this, _onUpdateParams);
					this.dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_UPDATE, yoyoReverse, _nowRepeat, _data));
					//一个阶段的缓动完毕
					if(runTemp >= totalTemp)
					{
						//当前是否为反向播放
						if(_yoyoReverse)
						{
							call(_onYoyoComplete, this, _onYoyoCompleteParams);
							this.dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_YOYO_COMPLETE, yoyoReverse, _nowRepeat, _data));
						}
						else
						{
							call(_onComplete, this, _onCompleteParams);
							this.dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_COMPLETE, yoyoReverse, _nowRepeat, _data));
							//需要反向播放
							if(!_yoyoReverse && _yoyo)
							{
								_yoyoReverse = true;
								//重新计算运行时间值
								_runtime = _runFrame = -_yoyoDelay;
								_totalRuntime = _totalRunFrame = _duration;
								_playTimelineItems = this.getTweens(true);
								//还有时间剩下, 需要再次更新
								if(remainTime != 0)
								{
									this.hammerc_internal::update(remainTime);
								}
								return;
							}
						}
						//是否需要再一次重复播放
						if(_repeat == -1 || _repeat > _nowRepeat)
						{
							call(_onRepeat, this, _onRepeatParams);
							this.dispatchEvent(new TimelineEvent(TimelineEvent.TIMELINE_REPEAT, yoyoReverse, _nowRepeat, _data));
							_nowRepeat++;
							_yoyoReverse = false;
							//重新计算运行时间值
							_runtime = _runFrame = -_repeatDelay;
							_totalRuntime = _totalRunFrame = _duration;
							_playTimelineItems = this.getTweens(!_yoyo);
							//还有时间剩下, 需要再次更新
							if(remainTime != 0)
							{
								this.hammerc_internal::update(remainTime);
							}
							return;
						}
						_playing = false;
					}
				}
			}
		}
		
		private function playTweens(runtime:Number):void
		{
			var reverse:Boolean = _yoyoReverse;
			if(_reversed && !_yoyo)
			{
				reverse = true;
			}
			//处理所有的缓动对象
			for(var i:int = 0; i < _playTimelineItems.length; i++)
			{
				var item:TimelineItem = _playTimelineItems[i];
				var startTime:Number = reverse ? _duration - item.endTime : item.startTime;
				var endTime:Number = reverse ? _duration - item.startTime : item.endTime;
				//缓动尚未开始直接退出循环, 因为列表为有序列表
				if(runtime < startTime)
				{
					break;
				}
				//缓动已经结束
				else if(runtime >= endTime)
				{
					item.tween.posistion = item.tween.totalDuration;
				}
				//缓动正在进行
				else if(runtime >= startTime)
				{
					var offset:Number = runtime - startTime;
					if(reverse)
					{
						item.tween.reverse(offset, false);
					}
					else
					{
						item.tween.play(offset);
					}
				}
				_playTimelineItems.shift();
				i--;
			}
		}
		
		private function stopTweens(runtime:Number):void
		{
			var reverse:Boolean = _yoyoReverse;
			if(_reversed && !_yoyo)
			{
				reverse = true;
			}
			var timelineItems:Vector.<TimelineItem> = this.getTweens(reverse);
			//处理所有的缓动对象
			for(var i:int = 0; i < timelineItems.length; i++)
			{
				var item:TimelineItem = timelineItems[i];
				var startTime:Number = reverse ? _duration - item.endTime : item.startTime;
				var endTime:Number = reverse ? _duration - item.startTime : item.endTime;
				//缓动尚未开始
				if(runtime < startTime)
				{
					item.tween.posistion = 0;
				}
				//缓动已经结束
				else if(runtime >= endTime)
				{
					item.tween.posistion = item.tween.totalDuration;
				}
				//缓动正在进行
				else if(runtime >= startTime)
				{
					var offset:Number = runtime - startTime;
					item.tween.posistion = offset;
				}
			}
		}
		
		private function call(method:Function, thisArg:* = null, params:* = null):void
		{
			if(method != null)
			{
				method.apply(thisArg, params);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function append(tween:AbstractTweenCore, frame:Object = 0, align:int = 0):AbstractTweenCore
		{
			var frameTime:Number = this.frameToTime(frame);
			if(_timeMap[frameTime] == null)
			{
				_timeMap[frameTime] = new Vector.<TimelineItem>();
			}
			var items:Vector.<TimelineItem> = _timeMap[frameTime] as Vector.<TimelineItem>;
			var time:Number = frameTime;
			var i:int, len:int;
			//获取按排序播放的时间
			if(align == TimelineAlign.SEQUENCE)
			{
				for(i = 0, len = items.length - 1; len >= i; len--)
				{
					if(items[len].align == TimelineAlign.SEQUENCE)
					{
						time = items[len].endTime;
						break;
					}
				}
			}
			var item:TimelineItem = new TimelineItem(tween, frameTime, align, time);
			items.push(item);
			for(i = 0, len = _forwardTweenList.length; i < len; i++)
			{
				if(item.startTime <= _forwardTweenList[i].startTime)
				{
					break;
				}
			}
			_forwardTweenList.splice(i, 0, item);
			for(i = 0, len = _backwardTweenList.length; i < len; i++)
			{
				if(item.endTime >= _backwardTweenList[i].endTime)
				{
					break;
				}
			}
			_backwardTweenList.splice(i, 0, item);
			_duration = _backwardTweenList.length == 0 ? 0 : _backwardTweenList[0].endTime;
			//添加后的缓动对象都应该暂停, 等待本时间轴对象的统一调用
			tween.pause();
			return tween;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function remove(tween:AbstractTweenCore):AbstractTweenCore
		{
			var forwardIndex:int = this.getTimelineItemIndex(_forwardTweenList, tween);
			if(forwardIndex == -1)
			{
				return tween;
			}
			var backwardIndex:int = this.getTimelineItemIndex(_backwardTweenList, tween);
			var frame:Number = _forwardTweenList[forwardIndex].frame;
			var items:Vector.<TimelineItem> = _timeMap[frame] as Vector.<TimelineItem>;
			var itemsIndex:int = this.getTimelineItemIndex(items, tween);
			//移除该缓动对象
			_forwardTweenList.splice(forwardIndex, 1);
			_backwardTweenList.splice(backwardIndex, 1);
			items.splice(itemsIndex, 1);
			//更新剩余的 align 为 TimelineAlign.SEQUENCE 的缓动对象
			var i:int, len:int, time:Number = frame;
			for(i = 0, len = items.length; i < len; i++)
			{
				var item:TimelineItem = items[i];
				if(item.align == TimelineAlign.SEQUENCE)
				{
					item.updateTime(time);
					time = item.endTime;
				}
			}
			if(items.length == 0)
			{
				delete _timeMap[frame];
			}
			_duration = _backwardTweenList.length == 0 ? 0 : _backwardTweenList[0].endTime;
			return tween;
		}
		
		/**
		 * 获取指定的缓动对象位于时间轴项目列表中的索引.
		 * @param list 时间轴项目列表.
		 * @param tween 要搜索的缓动对象.
		 * @return 该缓动对象位于列表中的索引, -1 为不存在.
		 */
		protected function getTimelineItemIndex(list:Vector.<TimelineItem>, tween:AbstractTweenCore):int
		{
			for(var i:int = 0, len:int = list.length; i < len; i++)
			{
				var item:TimelineItem = list[i];
				if(item.tween == tween)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function gotoAndPlay(frame:Object):void
		{
			var time:Number = this.frameToTime(frame);
			this.play(time);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function gotoAndReverse(frame:Object):void
		{
			var time:Number = this.frameToTime(frame);
			this.reverse(time);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function gotoAndStop(frame:Object):void
		{
			var time:Number = this.frameToTime(frame);
			this.posistion = time;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function play(position:Number = 0, includeDelay:Boolean = true):void
		{
			_nowRepeat = 0;
			_yoyoReverse = false;
			_reversed = false;
			position = adjustPosition(position, includeDelay);
			_runtime = _runFrame = position;
			_totalRuntime = _totalRunFrame = _duration;
			_playTimelineItems = this.getTweens();
			_playing = true;
		}
		
		private function adjustPosition(position:Number, includeDelay:Boolean = true):Number
		{
			position = Math.max(position, 0);
			if(includeDelay)
			{
				position -= _delay;
			}
			//反向缓动一次的总时间包含延迟
			var reverseTime:Number = _yoyoDelay + _duration;
			//重复缓动一次的总时间包含延迟
			var repeatTime:Number = _repeatDelay + _duration;
			if(_yoyo)
			{
				repeatTime += reverseTime;
			}
			//没有重复之前缓动完成的总时间包含延迟
			var completeTime:Number = _duration + _delay;
			if(_yoyo)
			{
				completeTime += reverseTime;
			}
			//计算当前时间已经重复播放了几次
			var canRepeat:int = 0;
			//计算没有重复之前缓动是否完成
			if(position > completeTime)
			{
				position -= completeTime;
				canRepeat = position / repeatTime + 1;
				//是否超过了重复播放的次数
				if(_repeat == -1 || _repeat >= canRepeat)
				{
					//没有超过时
					_nowRepeat = canRepeat;
					position -= repeatTime * (_nowRepeat - 1);
					position -= _repeatDelay;
				}
				else
				{
					//已经超过时
					_yoyoReverse = _yoyo;
					_nowRepeat = _repeat;
					return duration;
				}
			}
			//是否处于反向播放的位置
			if(_yoyo && position > duration)
			{
				_yoyoReverse = true;
				position -= duration;
				position -= _yoyoDelay;
			}
			return position;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function pause():void
		{
			_playing = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function resume():void
		{
			_playing = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function stop():void
		{
			_playing = false;
			_yoyoReverse = false;
			_reversed = false;
			_runtime = _runFrame = 0;
			_nowRepeat = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function reverse(position:Number = 0, includeDelay:Boolean = true):void
		{
			this.posistion = this.totalDuration;
			_nowRepeat = 0;
			_yoyoReverse = false;
			_reversed = true;
			position = adjustPosition(position, includeDelay);
			_runtime = _runFrame = position;
			_totalRuntime = _totalRunFrame = _duration;
			_playTimelineItems = this.getTweens(!_yoyo);
			_playing = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			_timeMap = null;
			_forwardTweenList = null;
			_backwardTweenList = null;
		}
	}
}
