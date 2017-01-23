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
	import flash.events.EventDispatcher;
	
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>AbstractTweenCore</code> 类抽象出了缓动类的基本数据.
	 * @author wizardc
	 */
	public class AbstractTweenCore extends EventDispatcher
	{
		/**
		 * 记录当前缓动对象是否会自动执行, 如果不会需要手动调用缓动对象的 <code>update</code> 方法及手动进行销毁.
		 */
		protected var _autoUpdate:Boolean = true;
		
		/**
		 * 记录缓动对象在停止缓动时是否可以被垃圾回收, 缓动手动执行时无效.
		 */
		protected var _gc:Boolean = false;
		
		/**
		 * 记录缓动是否处于激活状态.
		 */
		protected var _active:Boolean = true;
		
		/**
		 * 记录缓动是否正在运行.
		 */
		protected var _playing:Boolean = true;
		
		/**
		 * <code>AbstractTweenCore</code> 类为抽象类, 不能被实例化.
		 * @param autoUpdate 记录当前缓动对象是否会自动执行, 如果不会需要手动调用缓动对象的 <code>update</code> 方法及手动进行销毁.
		 */
		public function AbstractTweenCore(autoUpdate:Boolean = true)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractTweenCore);
			if(!TweenManager.hammerc_internal::initialized)
			{
				TweenManager.hammerc_internal::initialize();
				TweenManager.hammerc_internal::initialized = true;
			}
			_autoUpdate = autoUpdate;
			if(_autoUpdate)
			{
				TweenManager.hammerc_internal::appendTween(this);
			}
			this.initTween();
		}
		
		/**
		 * 初始化缓动对象时调用.
		 */
		protected function initTween():void
		{
		}
		
		/**
		 * 设置或获取整个缓动过程中当前的时间点.
		 */
		public function set posistion(value:Number):void
		{
			AbstractEnforcer.enforceMethod();
		}
		public function get posistion():Number
		{
			AbstractEnforcer.enforceMethod();
			return 0;
		}
		
		/**
		 * 获取整个缓动过程的总耗时.
		 */
		public function get totalDuration():Number
		{
			AbstractEnforcer.enforceMethod();
			return 0;
		}
		
		/**
		 * 设置或获取本缓动对象在停止缓动时是否可以被垃圾回收, 缓动手动执行时无效.
		 * <p>提示: 修改立即生效.</p>
		 */
		public function set gc(value:Boolean):void
		{
			_gc = value;
		}
		public function get gc():Boolean
		{
			return _gc;
		}
		
		/**
		 * 获取缓动是否处于激活状态.
		 */
		public function get isActive():Boolean
		{
			return _active;
		}
		
		/**
		 * 获取缓动是否正在运行.
		 */
		public function get isPlaying():Boolean
		{
			return _playing;
		}
		
		/**
		 * 每次进行帧绘制之前会调用本方法, 缓动被移除和被加入时间轴对象中时不会被调用.
		 * @param time 上一次调用和本次调用的间隔, 单位为秒.
		 */
		hammerc_internal function update(time:Number):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 开始播放缓动.
		 * @param position 开始播放时的时间.
		 * @param includeDelay 是否包含延迟的时间.
		 */
		public function play(position:Number = 0, includeDelay:Boolean = true):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 暂停当前播放的缓动.
		 */
		public function pause():void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 从上次的暂停处恢复缓动的播放.
		 */
		public function resume():void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 停止缓动.
		 */
		public function stop():void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 反方向进行缓动回起点.
		 * @param position 开始播放时的时间.
		 * @param includeDelay 是否包含延迟的时间. 注意延迟时间为开始反向缓动前需要等待的时间, 并非是所有缓动结束后再等待的时间.
		 */
		public function reverse(position:Number = 0, includeDelay:Boolean = true):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 释放本缓动对象, 使该对象可以被垃圾回收.
		 */
		public function destroy():void
		{
			_active = false;
			_playing = false;
			if(_autoUpdate)
			{
				TweenManager.hammerc_internal::removeTween(this);
			}
		}
	}
}
