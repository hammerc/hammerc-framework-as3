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
	import org.hammerc.core.AbstractEnforcer;
	
	/**
	 * <code>AbstractTimeline</code> 类抽象出时间轴对象应有的属性及方法.
	 * @author wizardc
	 */
	public class AbstractTimeline extends AbstractTweenCore
	{
		/**
		 * 记录时间轴开始播放前的等待时间.
		 */
		protected var _delay:Number = 0;
		
		/**
		 * 记录时间轴是否基于帧运行.
		 */
		protected var _useFrames:Boolean = false;
		
		/**
		 * 时间轴播放完成后是否立即播放回初始时的状态.
		 */
		protected var _yoyo:Boolean = false;
		
		/**
		 * 时间轴的反向播放时的等待时间.
		 */
		protected var _yoyoDelay:Number = 0;
		
		/**
		 * 时间轴的重复播放次数, -1 表示无限循环.
		 */
		protected var _repeat:int = 0;
		
		/**
		 * 时间轴的重复播放时的等待时间.
		 */
		protected var _repeatDelay:Number = 0;
		
		/**
		 * 本时间轴对象的附加资料, 会被传递到事件和带有参数的回调方法中.
		 */
		protected var _data:*;
		
		/**
		 * 时间轴开始播放的回调方法.
		 */
		protected var _onStart:Function;
		
		/**
		 * 时间轴开始播放回调方法带的参数.
		 */
		protected var _onStartParams:*;
		
		/**
		 * 时间轴更新播放的回调方法.
		 */
		protected var _onUpdate:Function;
		
		/**
		 * 时间轴更新播放回调方法带的参数.
		 */
		protected var _onUpdateParams:*;
		
		/**
		 * 时间轴完成播放的回调方法.
		 */
		protected var _onComplete:Function;
		
		/**
		 * 时间轴完成播放回调方法带的参数.
		 */
		protected var _onCompleteParams:*;
		
		/**
		 * 时间轴重复开始播放的回调方法.
		 */
		protected var _onRepeat:Function;
		
		/**
		 * 时间轴重复开始播放回调方法带的参数.
		 */
		protected var _onRepeatParams:*;
		
		/**
		 * 时间轴反向播放结束的回调方法.
		 */
		protected var _onYoyoComplete:Function;
		
		/**
		 * 时间轴反向播放结束回调方法带的参数.
		 */
		protected var _onYoyoCompleteParams:*;
		
		/**
		 * 记录所有标签对象的数据.
		 */
		protected var _labels:Object;
		
		/**
		 * <code>AbstractTimeline</code> 类为抽象类, 不能被实例化.
		 * @param autoUpdate 记录当前缓动对象是否会自动执行, 如果不会需要手动调用缓动对象的 <code>update</code> 方法及手动进行销毁.
		 */
		public function AbstractTimeline(autoUpdate:Boolean = true)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractTimeline);
			_labels = new Object();
			super(autoUpdate);
		}
		
		/**
		 * 设置或获取开始播放时间轴前的等待时间.
		 * <p>提示: 时间轴播放开始后进行设置会被记录到下一次时间轴播放才起效, 本次时间轴播放中修改无效.</p>
		 */
		public function set delay(value:Number):void
		{
			_delay = Math.max(value, 0);
		}
		public function get delay():Number
		{
			return _delay;
		}
		
		/**
		 * 设置或获取时间轴是否基于帧运行.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set useFrames(value:Boolean):void
		{
			_useFrames = value;
		}
		public function get useFrames():Boolean
		{
			return _useFrames;
		}
		
		/**
		 * 设置或获取时间轴播放完成后是否立即播放回初始时的状态.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set yoyo(value:Boolean):void
		{
			_yoyo = value;
		}
		public function get yoyo():Boolean
		{
			return _yoyo;
		}
		
		/**
		 * 设置或获取时间轴的反向播放时的等待时间.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set yoyoDelay(value:Number):void
		{
			_yoyoDelay = Math.max(value, 0);
		}
		public function get yoyoDelay():Number
		{
			return _yoyoDelay;
		}
		
		/**
		 * 设置或获取时间轴的重复播放次数, -1 表示无限循环.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set repeat(value:int):void
		{
			_repeat = value < 0 ? -1 : value;
		}
		public function get repeat():int
		{
			return _repeat;
		}
		
		/**
		 * 设置或获取时间轴的重复播放时的等待时间.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set repeatDelay(value:Number):void
		{
			_repeatDelay = Math.max(value, 0);
		}
		public function get repeatDelay():Number
		{
			return _repeatDelay;
		}
		
		/**
		 * 设置或获取本时间轴对象的附加资料, 会被传递到事件和带有参数的回调方法中.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set data(value:*):void
		{
			_data = value;
		}
		public function get data():*
		{
			return _data;
		}
		
		/**
		 * 设置或获取时间轴开始播放的回调方法.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onStart(value:Function):void
		{
			_onStart = value;
		}
		public function get onStart():Function
		{
			return _onStart;
		}
		
		/**
		 * 设置或获取时间轴开始播放回调方法带的参数.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onStartParams(value:*):void
		{
			_onStartParams = value;
		}
		public function get onStartParams():*
		{
			return _onStartParams;
		}
		
		/**
		 * 设置或获取时间轴更新播放的回调方法.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onUpdate(value:Function):void
		{
			_onUpdate = value;
		}
		public function get onUpdate():Function
		{
			return _onUpdate;
		}
		
		/**
		 * 设置或获取时间轴更新播放回调方法带的参数.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onUpdateParams(value:*):void
		{
			_onUpdateParams = value;
		}
		public function get onUpdateParams():*
		{
			return _onUpdateParams;
		}
		
		/**
		 * 设置或获取时间轴完成播放的回调方法.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onComplete(value:Function):void
		{
			_onComplete = value;
		}
		public function get onComplete():Function
		{
			return _onComplete;
		}
		
		/**
		 * 设置或获取时间轴完成播放回调方法带的参数.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onCompleteParams(value:*):void
		{
			_onCompleteParams = value;
		}
		public function get onCompleteParams():*
		{
			return _onCompleteParams;
		}
		
		/**
		 * 设置或获取时间轴重复开始播放的回调方法.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onRepeat(value:Function):void
		{
			_onRepeat = value;
		}
		public function get onRepeat():Function
		{
			return _onRepeat;
		}
		
		/**
		 * 设置或获取时间轴重复开始播放回调方法带的参数.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onRepeatParams(value:*):void
		{
			_onRepeatParams = value;
		}
		public function get onRepeatParams():*
		{
			return _onRepeatParams;
		}
		
		/**
		 * 设置或获取时间轴反向播放结束的回调方法.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onYoyoComplete(value:Function):void
		{
			_onYoyoComplete = value;
		}
		public function get onYoyoComplete():Function
		{
			return _onYoyoComplete;
		}
		
		/**
		 * 设置或获取时间轴反向播放结束回调方法带的参数.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set onYoyoCompleteParams(value:*):void
		{
			_onYoyoCompleteParams = value;
		}
		public function get onYoyoCompleteParams():*
		{
			return _onYoyoCompleteParams;
		}
		
		/**
		 * 在指定的时间点上设置一个标签.
		 * @param label 指定的标签名.
		 * @param time 指定的时间点.
		 */
		public function setLabel(label:String, time:Number = 0):void
		{
			_labels[label] = Math.max(time, 0);
		}
		
		/**
		 * 获取指定的标签上的时间点.
		 * @param label 指定的标签名.
		 * @return 该标签对应的时间点.
		 */
		public function getLabel(label:String):Number
		{
			if(_labels.hasOwnProperty(label))
			{
				return _labels[label];
			}
			return 0;
		}
		
		/**
		 * 删除指定的标签上的时间点.
		 * @param label 指定的标签名.
		 * @return 该标签对应的时间点.
		 */
		public function cancelLabel(label:String):Number
		{
			if(_labels.hasOwnProperty(label))
			{
				var time:Number = _labels[label];
				delete _labels[label];
				return time;
			}
			return 0;
		}
		
		/**
		 * 将帧表示对象装换为对应的时间.
		 * @param frame 标签或时间.
		 * @return 对应的时间.
		 */
		protected function frameToTime(frame:Object):Number
		{
			if(frame is String)
			{
				return this.getLabel(frame as String);
			}
			else if(frame is Number)
			{
				return frame as Number;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 添加一个缓动对象到时间轴对象中.
		 * <ul>注意: 
		 *   <li>添加后该缓动的运行起终时间点会被记录, 之后修改该缓动的持续时间会被本时间轴对象忽略.</li>
		 *   <li>如果多个缓动对象要对同一个对象的属性进行缓动请配置其 <code>overwrite</code> 的属性为 <code>TweenOverwrite.CONCURRENT</code> 否则只会缓动最后添加的 Tween 中的属性.</li>
		 * </ul>
		 * @param tween 要添加的缓动或时间轴对象.
		 * @param frame 指定的对象开始播放的帧标签或时间.
		 * @param align 该对象和位于同一帧的其它对象的播放方式. 第一个添加的 <code>TimelineAlign.SEQUENCE</code> 的缓动对象其开始时间为 0.
		 * @return 
		 */
		public function append(tween:AbstractTweenCore, frame:Object = 0, align:int = 0):AbstractTweenCore
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * 移除一个缓动对象到时间轴对象中.
		 * @param tween 要移除的缓动或时间轴对象.
		 * @return 
		 */
		public function remove(tween:AbstractTweenCore):AbstractTweenCore
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * 跳转到指定帧并开始播放.
		 * @param frame 要跳转到的帧.
		 */
		public function gotoAndPlay(frame:Object):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 跳转到指定帧并开始反向播放.
		 * @param frame 要跳转到的帧.
		 */
		public function gotoAndReverse(frame:Object):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 跳转到指定帧并停止.
		 * @param frame 要跳转到的帧.
		 */
		public function gotoAndStop(frame:Object):void
		{
			AbstractEnforcer.enforceMethod();
		}
	}
}
