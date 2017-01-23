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
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * <code>TinyTween</code> 类实现了最基本的缓动同时体积却相当的小巧.
	 * <ul>
	 *   <li>去掉了复杂且不常用的功能, 在简单的交互应用中使用比 <code>Tween</code> 类更合适.</li>
	 *   <li><code>TinyTween</code> 类为了达到超小的体积所以其独立于本包其它的缓动体系, 故不能使用 <code>Timeline</code> 对象操作本对象同时 <code>TweenManager</code> 无法对其进行控制请使用自身的静态方法来控制.</li>
	 *   <li>使用本对象会增加大约 2.6kb 的大小.</li>
	 * </ul>
	 * @author wizardc
	 */
	public class TinyTween
	{
		private static var _initialized:Boolean = false;
		private static var _shape:Shape;
		private static var _lastTime:Number;
		private static var _tweenList:Vector.<TinyTween>;
		private static var _masterMap:Dictionary;
		
		private static function updateAll(event:Event):void
		{
			var nowTime:Number = getTimer() * .001;
			var interval:Number = nowTime - _lastTime;
			for(var i:int = 0, len:int = _tweenList.length; i < len; i++)
			{
				var tween:TinyTween = _tweenList[i];
				tween.update(interval);
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
			for each(var tween:TinyTween in _tweenList)
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
			for each(var tween:TinyTween in _tweenList)
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
			for each(var tween:TinyTween in _tweenList)
			{
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
				for each(var tween:TinyTween in _tweenList)
				{
					if(tween.isActive && !tween.isPlaying)
					{
						tween.destroy();
					}
				}
			}
			else
			{
				_masterMap = new Dictionary();
				_tweenList.length = 0;
			}
		}
		
		/**
		 * 缓动指定对象到达该对象当前的状态.
		 * @param target 要进行缓动的对象.
		 * @param duration 缓动的持续时间.
		 * @param variables 缓动的目标属性.
		 * @param gc 是否自动垃圾回收该缓动. 如果为 <code>true</code> 则该缓动的 <code>gc</code> 属性会被设置为 <code>true</code>, 即缓动结束后会调用自身的 <code>destroy</code> 方法实现垃圾回收. 这种情况下不要添加 <code>paused:true</code> 属性, 否则该缓动一创建好就会被回收, 创建默认不会被回收的缓动请直接用 <code>new Tween(...)</code> 的方法或者将本参数设置为 <code>false</code>.
		 * @return 对应的缓动对象.
		 */
		public static function from(target:Object, duration:Number, variables:Object, gc:Boolean = true):TinyTween
		{
			for(var name:String in variables)
			{
				if(ATTRIBUTES.indexOf(name) == -1)
				{
					if(target.hasOwnProperty(name))
					{
						var value:Number = target[name];
						target[name] = variables[name];
						variables[name] = value;
					}
				}
			}
			return to(target, duration, variables, gc);
		}
		
		/**
		 * 缓动指定对象到达指定的状态.
		 * @param target 要进行缓动的对象.
		 * @param duration 缓动的持续时间.
		 * @param variables 缓动的目标属性.
		 * @param gc 是否自动垃圾回收该缓动. 如果为 <code>true</code> 则该缓动的 <code>gc</code> 属性会被设置为 <code>true</code>, 即缓动结束后会调用自身的 <code>destroy</code> 方法实现垃圾回收. 这种情况下不要添加 <code>paused:true</code> 属性, 否则该缓动一创建好就会被回收, 创建默认不会被回收的缓动请直接用 <code>new Tween(...)</code> 的方法或者将本参数设置为 <code>false</code>.
		 * @return 对应的缓动对象.
		 */
		public static function to(target:Object, duration:Number, variables:Object, gc:Boolean = true):TinyTween
		{
			var tween:TinyTween = new TinyTween(target, duration, variables);
			if(gc)
			{
				tween.gc = true;
			}
			return tween;
		}
		
		/**
		 * 默认缓动, 速度减速到 0 的缓动.
		 * @param t 当前的时间.
		 * @param b 初始值.
		 * @param c 变化量.
		 * @param d 持续时间.
		 * @return 当前时间的值.
		 */
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			b = 0;
			c = 0;
			return 1 - (t = 1 - (t / d)) * t;
		}
		
		/**
		 * 记录了所有可以传递给构造方法的 <code>variables</code> 参数的属性.
		 */
		public static const ATTRIBUTES:Vector.<String> = new <String>["delay", "ease", "useFrames", "moveMode", "overwrite", "paused", "gc", "math", "onUpdate", "onUpdateParams", "onComplete", "onCompleteParams"];
		
		/**
		 * 要进行缓动的对象.
		 */
		public var target:Object;
		
		/**
		 * 缓动的持续时间.
		 */
		public var duration:Number = 0;
		
		/**
		 * 缓动的目标属性.
		 */
		public var variables:Object;
		
		/**
		 * 开始缓动前的等待时间.
		 */
		public var delay:Number = 0;
		
		/**
		 * 缓动的具体方法.
		 */
		public var ease:Function;
		
		/**
		 * 是否基于帧进行缓动.
		 */
		public var useFrames:Boolean = false;
		
		/**
		 * 缓动的移动方式.
		 */
		public var moveMode:int = 0;
		
		/**
		 * 覆盖的处理方法.
		 */
		public var overwrite:int = 0;
		
		/**
		 * 缓动是否暂停.
		 */
		public var paused:Boolean = false;
		
		/**
		 * 缓动对象在停止缓动时是否可以被垃圾回收.
		 */
		public var gc:Boolean = false;
		
		/**
		 * 缓动每次更新时的结果处理方法.
		 */
		public var math:Function;
		
		/**
		 * 缓动更新的回调方法.
		 */
		public var onUpdate:Function;
		
		/**
		 * 缓动更新回调方法带的参数.
		 */
		public var onUpdateParams:*;
		
		/**
		 * 缓动完成的回调方法.
		 */
		public var onComplete:Function;
		
		/**
		 * 缓动完成回调方法带的参数.
		 */
		public var onCompleteParams:*;
		
		/**
		 * 记录当前缓动对象是否会自动执行, 如果不会需要手动调用缓动对象的 <code>update</code> 方法及手动进行销毁.
		 */
		protected var _autoUpdate:Boolean = true;
		
		/**
		 * 记录缓动是否处于激活状态.
		 */
		protected var _active:Boolean = true;
		
		/**
		 * 记录缓动是否正在运行.
		 */
		protected var _playing:Boolean = true;
		
		/**
		 * 缓动已经运行的时间.
		 */
		protected var _runtime:Number = 0;
		
		/**
		 * 缓动已经运行的帧数.
		 */
		protected var _runFrame:int;
		
		/**
		 * 创建一个 <code>TinyTween</code> 对象.
		 * @param target 要进行缓动的对象, 传入空对象则本缓动对象将无效.
		 * @param duration 缓动的持续时间, 负值按 0 处理.
		 * @param variables 缓动的目标属性, 传入空对象则本缓动对象将无效, 可添加属性 <code>paused:true</code> 使缓动不会立即执行.
		 * @param autoUpdate 记录当前缓动对象是否会自动执行, 如果不会需要手动调用缓动对象的 <code>update</code> 方法及手动进行销毁.
		 */
		public function TinyTween(target:Object, duration:Number, variables:Object, autoUpdate:Boolean = true)
		{
			if(!_initialized)
			{
				_shape = new Shape();
				_shape.addEventListener(Event.ENTER_FRAME, updateAll);
				_lastTime = getTimer() * .001;
				_tweenList = new Vector.<TinyTween>();
				_masterMap = new Dictionary();
				_initialized = true;
			}
			this.target = target == null ? {} : target;
			this.duration = Math.max(duration, 0);
			this.variables = variables == null ? {} : variables;
			_autoUpdate = autoUpdate;
			this.ease = easeOut;
			if(_autoUpdate)
			{
				_tweenList.push(this);
			}
			for each(var name:String in ATTRIBUTES)
			{
				if(this.variables.hasOwnProperty(name))
				{
					this[name] = this.variables[name];
				}
			}
			if(_masterMap[this.target] == null)
			{
				_masterMap[this.target] = new Vector.<TinyTweenItem>();
			}
			var propertyList:Vector.<TinyTweenItem> = _masterMap[target];
			if(this.overwrite == 0)
			{
				propertyList.length = 0;
			}
			for(var key:String in this.variables)
			{
				if(ATTRIBUTES.indexOf(key) == -1)
				{
					if(getQualifiedClassName(this.target) == "Object" && !this.target.hasOwnProperty(key))
					{
						this.target[key] = 0;
					}
					else
					{
						if(!this.target.hasOwnProperty(key) || (typeof this.target[key]) != "number")
						{
							continue;
						}
					}
					var item:TinyTweenItem = getTinyTweenItem(propertyList, key);
					if(item == null)
					{
						item = new TinyTweenItem();
						item.master = this;
						item.property = key;
						propertyList.push(item);
					}
					else
					{
						item.master = this;
					}
					item.start = this.target[key];
					if(this.moveMode == 1)
					{
						item.change = this.variables[key];
					}
					else
					{
						item.change = this.variables[key] - item.start;
					}
				}
			}
			_playing = !paused;
			if(_playing)
			{
				this.play();
			}
		}
		
		private function getTinyTweenItem(list:Vector.<TinyTweenItem>, key:String):TinyTweenItem
		{
			var item:TinyTweenItem = null;
			for(var i:int = 0; i < list.length; i++)
			{
				var value:TinyTweenItem = list[i];
				if(value.property == key)
				{
					item = value;
					break;
				}
			}
			return item;
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
		public function update(time:Number):void
		{
			if(_active && _playing)
			{
				_runtime += time;
				_runFrame++;
				var runTemp:Number = this.useFrames ? _runFrame : _runtime;
				if(runTemp > 0)
				{
					var baseValue:Number = this.ease.call(null, runTemp, 0, 1, this.duration);
					if(runTemp >= this.duration)
					{
						baseValue = 1;
					}
					var propertyList:Vector.<TinyTweenItem> = _masterMap[this.target];
					for(var i:int = 0, len:int = propertyList.length; i < len; i++)
					{
						var item:TinyTweenItem = propertyList[i];
						if(item.master == this)
						{
							this.target[item.property] = item.start + item.change * baseValue;
							if(this.math != null)
							{
								this.target[item.property] = this.math.call(null, this.target[item.property]);
							}
						}
					}
					call(this.onUpdate, this, this.onUpdateParams);
					if(runTemp >= this.duration)
					{
						call(this.onComplete, this, this.onCompleteParams);
						_playing = false;
					}
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
		 * 开始播放缓动.
		 * @param position 开始播放时的时间.
		 * @param includeDelay 是否包含延迟的时间.
		 */
		public function play(position:Number = 0, includeDelay:Boolean = true):void
		{
			position = Math.max(position, 0);
			if(includeDelay)
			{
				position -= this.delay;
			}
			_runtime = _runFrame = position;
			_playing = true;
		}
		
		/**
		 * 暂停当前播放的缓动.
		 */
		public function pause():void
		{
			_playing = false;
		}
		
		/**
		 * 从上次的暂停处恢复缓动的播放.
		 */
		public function resume():void
		{
			_playing = true;
		}
		
		/**
		 * 停止缓动.
		 */
		public function stop():void
		{
			_playing = false;
			_runtime = _runFrame = 0;
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
				var index:int = _tweenList.indexOf(this);
				if(index != -1)
				{
					_tweenList.splice(index, 1);
				}
			}
			var propertyList:Vector.<TinyTweenItem> = _masterMap[this.target];
			for(var i:int = 0; i < propertyList.length; i++)
			{
				var item:TinyTweenItem = propertyList[i];
				if(item.master == this)
				{
					propertyList.splice(i, 1);
					i--;
				}
			}
			if(propertyList.length == 0)
			{
				delete _masterMap[this.target];
			}
		}
	}
}

import org.hammerc.tween.TinyTween;

/**
 * <code>TinyTweenItem</code> 类记录一个属性的缓动数据.
 */
class TinyTweenItem
{
	/**
	 * 维护该对象的缓动对象.
	 */
	public var master:TinyTween;
	
	/**
	 * 要进行缓动的属性名称.
	 */
	public var property:String;
	
	/**
	 * 缓动开始时的值.
	 */
	public var start:Number;
	
	/**
	 * 缓动的变化量.
	 */
	public var change:Number;
}
