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
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TweenManager</code> 类用来管理所有可使用的缓动对象.
	 * @author wizardc
	 */
	public class TweenManager
	{
		/**
		 * 记录所有对象需要进行缓动的属性数据.
		 */
		hammerc_internal static var masterMap:Dictionary = new Dictionary();
		
		/**
		 * 记录是否初始化.
		 */
		hammerc_internal static var initialized:Boolean = false;
		
		private static var _shape:Shape;
		private static var _lastTime:Number;
		private static var _tweenList:Vector.<AbstractTweenCore>;				//记录和管理所有在使用中的 Tween
		
		/**
		 * 进行初始化.
		 */
		hammerc_internal static function initialize():void
		{
			_lastTime = getTimer() * .001;
			_tweenList = new Vector.<AbstractTweenCore>();
			_shape = new Shape();
			_shape.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * 添加一个缓动对象.
		 * @param tween 要添加的缓动对象.
		 */
		hammerc_internal static function appendTween(tween:AbstractTweenCore):void
		{
			_tweenList.push(tween);
		}
		
		/**
		 * 移除一个缓动对象.
		 * @param tween 要移除的缓动对象.
		 */
		hammerc_internal static function removeTween(tween:AbstractTweenCore):void
		{
			var index:int = _tweenList.indexOf(tween);
			if(index != -1)
			{
				_tweenList.splice(index, 1);
			}
		}
		
		/**
		 * 覆写指定缓动之前的数据.
		 * @param tween 要覆写之前数据的缓动对象.
		 */
		hammerc_internal static function overwriteTween(tween:AbstractTween):void
		{
			var target:Object = tween.target;
			//移除之前的作用于同一目标对象的所有缓动对象
			for (var i:int = 0; i < _tweenList.length; i++)
			{
				var item:AbstractTween = _tweenList[i] as AbstractTween;
				if(item != null)
				{
					//排除当前的缓动对象, 同时作用于同一目标的对象要移除
					if(item != tween && item.target == target)
					{
						_tweenList.splice(i, 1);
						i--;
					}
				}
			}
			//删除目标对象所有记录的属性
			delete hammerc_internal::masterMap[target];
		}
		
		private static function update(event:Event):void
		{
			var nowTime:Number = getTimer() * .001;
			var interval:Number = nowTime - _lastTime;
			for(var i:int = 0, len:int = _tweenList.length; i < len; i++)
			{
				var tween:AbstractTweenCore = _tweenList[i];
				tween.hammerc_internal::update(interval);
			}
			for each(tween in _tweenList)
			{
				if(tween.isActive && !tween.isPlaying && tween.gc)
				{
					tween.destroy();
				}
			}
			_lastTime = nowTime;
		}
		
		/**
		 * 暂停所有正在播放的缓动对象.
		 */
		public static function pauseAll():void
		{
			for each(var tween:AbstractTweenCore in _tweenList)
			{
				if(tween.isActive && tween.isPlaying)
				{
					tween.pause();
				}
			}
		}
		
		/**
		 * 重新播放所有暂停的缓动对象.
		 */
		public static function resumeAll():void
		{
			for each(var tween:AbstractTweenCore in _tweenList)
			{
				if(tween.isActive && !tween.isPlaying)
				{
					tween.resume();
				}
			}
		}
		
		/**
		 * 销毁所有和指定目标相关的缓动对象.
		 * @param target 指定的目标.
		 * @param withoutPlaying 指定正在播放中的缓动对象是否不进行销毁.
		 */
		public static function destroyOf(target:Object, withoutPlaying:Boolean = false):void
		{
			for each(var tweenCore:AbstractTweenCore in _tweenList)
			{
				var tween:AbstractTween = tweenCore as AbstractTween;
				if(tween != null && tween.target == target)
				{
					if(withoutPlaying && tween.isActive && tween.isPlaying)
					{
						continue;
					}
					tween.destroy();
				}
			}
		}
		
		/**
		 * 销毁所有存在的缓动对象.
		 * @param withoutPlaying 指定正在播放中的缓动对象是否不进行销毁.
		 */
		public static function destroyAll(withoutPlaying:Boolean = false):void
		{
			if(withoutPlaying)
			{
				for each(var tween:AbstractTweenCore in _tweenList)
				{
					if(tween.isActive && !tween.isPlaying)
					{
						tween.destroy();
					}
				}
			}
			else
			{
				hammerc_internal::masterMap = new Dictionary();
				_tweenList.length = 0;
			}
		}
	}
}
