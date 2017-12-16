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
	 * <code>AbstractTween</code> 类抽象出缓动对象应有的属性及方法.
	 * @author wizardc
	 */
	public class AbstractTween extends AbstractTweenCore
	{
		/**
		 * 记录要进行缓动的对象.
		 */
		protected var _target:Object;
		
		/**
		 * 记录缓动的持续时间.
		 */
		protected var _duration:Number;
		
		/**
		 * 记录缓动的目标属性.
		 */
		protected var _variables:Object;
		
		/**
		 * 记录开始缓动前的等待时间.
		 */
		protected var _delay:Number = 0;
		
		/**
		 * 记录缓动的具体方法.
		 */
		protected var _ease:Function;
		
		/**
		 * 记录是否基于帧进行缓动.
		 */
		protected var _useFrames:Boolean = false;
		
		/**
		 * 记录缓动的移动方式.
		 */
		protected var _moveMode:int = MoveMode.ARRIVE;
		
		/**
		 * 记录覆盖的处理方法.
		 */
		protected var _overwrite:int = TweenOverwrite.OVERWRITE;
		
		/**
		 * 记录缓动是否暂停.
		 */
		protected var _paused:Boolean = false;
		
		/**
		 * 缓动执行时间的系数.
		 */
		protected var _timeScale:Number = 1;
		
		/**
		 * 缓动每次更新时的结果处理方法.
		 */
		protected var _math:Function;
		
		/**
		 * 缓动执行完成后是否立即缓动回初始时的状态.
		 */
		protected var _yoyo:Boolean = false;
		
		/**
		 * 缓动的反向执行时的等待时间.
		 */
		protected var _yoyoDelay:Number = 0;
		
		/**
		 * 缓动的重复执行次数, -1 表示无限循环.
		 */
		protected var _repeat:int = 0;
		
		/**
		 * 缓动的重复执行时的等待时间.
		 */
		protected var _repeatDelay:Number = 0;
		
		/**
		 * 本缓动对象的附加资料, 会被传递到事件中.
		 */
		protected var _data:*;
		
		/**
		 * 缓动开始的回调方法.
		 */
		protected var _onStart:Function;
		
		/**
		 * 缓动开始回调方法带的参数.
		 */
		protected var _onStartParams:*;
		
		/**
		 * 缓动更新的回调方法.
		 */
		protected var _onUpdate:Function;
		
		/**
		 * 缓动更新回调方法带的参数.
		 */
		protected var _onUpdateParams:*;
		
		/**
		 * 缓动完成的回调方法.
		 */
		protected var _onComplete:Function;
		
		/**
		 * 缓动完成回调方法带的参数.
		 */
		protected var _onCompleteParams:*;
		
		/**
		 * 缓动重复开始的回调方法.
		 */
		protected var _onRepeat:Function;
		
		/**
		 * 缓动重复开始回调方法带的参数.
		 */
		protected var _onRepeatParams:*;
		
		/**
		 * 缓动反向结束的回调方法.
		 */
		protected var _onYoyoComplete:Function;
		
		/**
		 * 缓动反向结束回调方法带的参数.
		 */
		protected var _onYoyoCompleteParams:*;
		
		/**
		 * <code>AbstractTween</code> 类为抽象类, 不能被实例化.
		 * @param target 要进行缓动的对象, 传入空对象则本缓动对象将无效.
		 * @param duration 缓动的持续时间.
		 * @param variables 缓动的目标属性, 传入空对象则本缓动对象将无效, 可添加属性 <code>paused:true</code> 使缓动不会立即执行.
		 * @param autoUpdate 记录当前缓动对象是否会自动执行, 如果不会需要手动调用缓动对象的 <code>update</code> 方法及手动进行销毁.
		 */
		public function AbstractTween(target:Object, duration:Number, variables:Object, autoUpdate:Boolean = true)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractTween);
			_target = target == null ? {} : target;
			_duration = Math.max(duration, 0);
			_variables = variables == null ? {} : variables;
			super(autoUpdate);
		}
		
		/**
		 * 获取进行缓动的对象.
		 */
		public function get target():Object
		{
			return _target;
		}
		
		/**
		 * 设置或获取缓动的持续时间.
		 * <p>提示: 缓动开始后进行设置会被记录到下一次缓动才起效, 本次缓动中修改无效.</p>
		 */
		public function set duration(value:Number):void
		{
			_duration = value;
		}
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * 获取缓动的目标属性.
		 */
		public function get variables():Object
		{
			return _variables;
		}
		
		/**
		 * 设置或获取开始缓动前的等待时间.
		 * <p>提示: 缓动开始后进行设置会被记录到下一次缓动才起效, 本次缓动中修改无效.</p>
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
		 * 设置或获取缓动的具体方法.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set ease(value:Function):void
		{
			_ease = value;
		}
		public function get ease():Function
		{
			return _ease;
		}
		
		/**
		 * 设置或获取是否基于帧进行缓动.
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
		 * 设置或获取缓动的移动方式.
		 * <p>提示: 修改始终无效.</p>
		 */
		public function set moveMode(value:int):void
		{
			_moveMode = value;
		}
		public function get moveMode():int
		{
			return _moveMode;
		}
		
		/**
		 * 设置或获取覆盖的处理方法.
		 * <p>提示: 修改始终无效.</p>
		 */
		public function set overwrite(value:int):void
		{
			_overwrite = value;
		}
		public function get overwrite():int
		{
			return _overwrite;
		}
		
		/**
		 * 设置或获取缓动是否暂停.
		 * <p>提示: 修改始终无效.</p>
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
		 * 设置或获取缓动执行时间的系数.
		 * <p>提示: 缓动开始后进行设置会被记录到下一次缓动才起效, 本次缓动中修改无效.</p>
		 */
		public function set timeScale(value:Number):void
		{
			_timeScale = Math.max(value, 0);
		}
		public function get timeScale():Number
		{
			return _timeScale;
		}
		
		/**
		 * 设置或获取缓动每次更新时的结果处理方法.
		 * <p>提示: 修改立即生效.</p>
		 * <p>如果需要缓动过程中每次产生的数值都四舍五入请设置本属性的值为 <code>Math.round</code>.</p>
		 */
		public function set math(value:Function):void
		{
			_math = value;
		}
		public function get math():Function
		{
			return _math;
		}
		
		/**
		 * 设置或获取缓动执行完成后是否立即缓动回初始时的状态.
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
		 * 设置或获取缓动的反向执行时的等待时间.
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
		 * 设置或获取缓动的重复执行次数, -1 表示无限循环.
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
		 * 设置或获取缓动的重复执行时的等待时间.
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
		 * 设置或获取本缓动对象的附加资料, 会被传递到事件中.
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
		 * 设置或获取缓动开始的回调方法.
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
		 * 设置或获取缓动开始回调方法带的参数.
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
		 * 设置或获取缓动更新的回调方法.
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
		 * 设置或获取缓动更新回调方法带的参数.
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
		 * 设置或获取缓动完成的回调方法.
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
		 * 设置或获取缓动完成回调方法带的参数.
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
		 * 设置或获取缓动重复开始的回调方法.
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
		 * 设置或获取缓动重复开始回调方法带的参数.
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
		 * 设置或获取缓动反向结束的回调方法.
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
		 * 设置或获取缓动反向结束回调方法带的参数.
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
	}
}
