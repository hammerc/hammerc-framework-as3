/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween
{
	import flash.utils.getQualifiedClassName;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.TweenEvent;
	import org.hammerc.tween.plugins.ITweenPlugin;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.TweenEvent.TWEEN_START
	 */
	[Event(name="tweenStart", type="org.hammerc.events.TweenEvent")]
	
	/**
	 * @eventType org.hammerc.events.TweenEvent.TWEEN_UPDATE
	 */
	[Event(name="tweenUpdate", type="org.hammerc.events.TweenEvent")]
	
	/**
	 * @eventType org.hammerc.events.TweenEvent.TWEEN_COMPLETE
	 */
	[Event(name="tweenComplete", type="org.hammerc.events.TweenEvent")]
	
	/**
	 * @eventType org.hammerc.events.TweenEvent.TWEEN_REPEAT
	 */
	[Event(name="tweenRepeat", type="org.hammerc.events.TweenEvent")]
	
	/**
	 * @eventType org.hammerc.events.TweenEvent.TWEEN_YOYO_COMPLETE
	 */
	[Event(name="tweenYoyoComplete", type="org.hammerc.events.TweenEvent")]
	
	/**
	 * <code>Tween</code> 类实现了基本的缓动.
	 * @author wizardc
	 */
	public class Tween extends AbstractTween
	{
		/**
		 * 缓动指定对象到达该对象当前的状态.
		 * @param target 要进行缓动的对象.
		 * @param duration 缓动的持续时间.
		 * @param variables 缓动的目标属性.
		 * @param gc 是否自动垃圾回收该缓动. 如果为 <code>true</code> 则该缓动的 <code>gc</code> 属性会被设置为 <code>true</code>, 即缓动结束后会调用自身的 <code>destroy</code> 方法实现垃圾回收. 这种情况下不要添加 <code>paused:true</code> 属性, 否则该缓动一创建好就会被回收, 创建默认不会被回收的缓动请直接用 <code>new Tween(...)</code> 的方法或者将本参数设置为 <code>false</code>.
		 * @return 对应的缓动对象.
		 */
		public static function from(target:Object, duration:Number, variables:Object, gc:Boolean = true):Tween
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
		public static function to(target:Object, duration:Number, variables:Object, gc:Boolean = true):Tween
		{
			var tween:Tween = new Tween(target, duration, variables);
			if(gc)
			{
				tween.gc = true;
			}
			return tween;
		}
		
		/**
		 * 缓动指定的多个对象到达该对象当前的状态.
		 * @param target 要进行缓动的对象.
		 * @param duration 缓动的持续时间.
		 * @param variables 缓动的目标属性.
		 * @param gc 是否自动垃圾回收该缓动. 如果为 <code>true</code> 则该缓动的 <code>gc</code> 属性会被设置为 <code>true</code>, 即缓动结束后会调用自身的 <code>destroy</code> 方法实现垃圾回收. 这种情况下不要添加 <code>paused:true</code> 属性, 否则该缓动一创建好就会被回收, 创建默认不会被回收的缓动请直接用 <code>new Tween(...)</code> 的方法或者将本参数设置为 <code>false</code>.
		 * @return 对应的缓动对象列表.
		 */
		public static function allFrom(targets:Array, duration:Number, variables:Object, gc:Boolean = true):Vector.<Tween>
		{
			var tweenList:Vector.<Tween> = new Vector.<Tween>();
			for each(var target:Object in targets)
			{
				tweenList.push(from(target, duration, variables, gc));
			}
			return tweenList;
		}
		
		/**
		 * 缓动指定的多个对象到达指定的状态.
		 * @param target 要进行缓动的对象.
		 * @param duration 缓动的持续时间.
		 * @param variables 缓动的目标属性.
		 * @param gc 是否自动垃圾回收该缓动. 如果为 <code>true</code> 则该缓动的 <code>gc</code> 属性会被设置为 <code>true</code>, 即缓动结束后会调用自身的 <code>destroy</code> 方法实现垃圾回收. 这种情况下不要添加 <code>paused:true</code> 属性, 否则该缓动一创建好就会被回收, 创建默认不会被回收的缓动请直接用 <code>new Tween(...)</code> 的方法或者将本参数设置为 <code>false</code>.
		 * @return 对应的缓动对象列表.
		 */
		public static function allTo(targets:Array, duration:Number, variables:Object, gc:Boolean = true):Vector.<Tween>
		{
			var tweenList:Vector.<Tween> = new Vector.<Tween>();
			for each(var target:Object in targets)
			{
				tweenList.push(to(target, duration, variables, gc));
			}
			return tweenList;
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
		 * 根据补丁键名获取对应的补丁实例对象.
		 * @param key 补丁键名.
		 * @return 对应的补丁实例对象.
		 */
		hammerc_internal static function getPlugin(key:String):ITweenPlugin
		{
			if(hammerc_internal::pluginKeyMap.hasOwnProperty(key))
			{
				var assetClass:Class = hammerc_internal::pluginKeyMap[key] as Class;
				return new assetClass() as ITweenPlugin;
			}
			return null;
		}
		
		/**
		 * 记录所有支持补丁的表.
		 */
		hammerc_internal static var pluginKeyMap:Object = new Object();
		
		/**
		 * 记录了所有可以传递给构造方法的 <code>variables</code> 参数的属性.
		 */
		public static const ATTRIBUTES:Vector.<String> = new <String>["delay", "ease", "useFrames", "moveMode", "overwrite", "paused", "gc", "timeScale", "math", "yoyo", "yoyoDelay", "repeat", "repeatDelay", "data", "onStart", "onStartParams", "onUpdate", "onUpdateParams", "onComplete", "onCompleteParams", "onRepeat", "onRepeatParams", "onYoyoComplete", "onYoyoCompleteParams"];
		
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
		 * 创建一个 <code>Tween</code> 对象.
		 * @param target 要进行缓动的对象, 传入空对象则本缓动对象将无效.
		 * @param duration 缓动的持续时间, 负值按 0 处理.
		 * @param variables 缓动的目标属性, 传入空对象则本缓动对象将无效, 可添加属性 <code>paused:true</code> 使缓动不会立即执行.
		 */
		public function Tween(target:Object, duration:Number, variables:Object)
		{
			this.ease = easeOut;
			super(target, duration, variables);
			_playing = !_paused;
			if(_playing)
			{
				this.play();
			}
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
			//获取记录数据
			if(TweenManager.hammerc_internal::masterMap[_target] == null)
			{
				TweenManager.hammerc_internal::masterMap[_target] = new Vector.<TweenItem>();
			}
			var propertyList:Vector.<TweenItem> = TweenManager.hammerc_internal::masterMap[_target];
			//是否覆写之前的数据
			if(_overwrite == TweenOverwrite.OVERWRITE)
			{
				propertyList.length = 0;
			}
			var plugin:ITweenPlugin;
			//添加每个缓动项目
			for(var key:String in _variables)
			{
				if(ATTRIBUTES.indexOf(key) == -1)
				{
					//该键是否被补丁支持同时其值是否为动态对象
					if(hammerc_internal::pluginKeyMap.hasOwnProperty(key) != -1 && getQualifiedClassName(_variables[key]) == "Object")
					{
						//创建对应的补丁对象
						plugin = hammerc_internal::getPlugin(key);
						//检测目标是否支持该补丁
						if(!plugin.checkSupport(_target))
						{
							continue;
						}
					}
					//非补丁判断
					else
					{
						//剔除不存在和不是数字类型的键
						if(getQualifiedClassName(_target) == "Object" && !_target.hasOwnProperty(key))
						{
							_target[key] = 0;
						}
						else
						{
							if(!_target.hasOwnProperty(key) || (typeof _target[key]) != "number")
							{
								continue;
							}
						}
					}
					//之前是否已经存在
					var item:TweenItem = getTweenItem(propertyList, key);
					if(item == null)
					{
						item = new TweenItem(this, key);
						propertyList.push(item);
					}
					else
					{
						item.master = this;
					}
					//是补丁还是普通缓动属性
					if(plugin != null)
					{
						plugin.initPlugin(_target, _variables[key], _moveMode);
						item.plugin = plugin;
					}
					else
					{
						item.start = _target[key];
						if(_moveMode == MoveMode.ADDITION)
						{
							item.change = _variables[key];
						}
						else
						{
							item.change = _variables[key] - item.start;
						}
					}
					plugin = null;
				}
			}
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
			updateValue(value, _duration * _timeScale);
			_playing = false;
		}
		override public function get posistion():Number
		{
			var result:Number = 0;
			var temp:Number = _duration * _timeScale;
			if(_yoyo)
			{
				temp *= 2;
				temp += _yoyoDelay * _timeScale;
			}
			if(_nowRepeat > 0)
			{
				temp *= _nowRepeat;
				temp += (_nowRepeat - 1) * _repeatDelay * _timeScale;
				result += temp;
			}
			return _delay * _timeScale + result + (_useFrames ? _runFrame : _runtime);
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
			var result:Number = _duration * _timeScale;
			if(_yoyo)
			{
				result *= 2;
				result += _yoyoDelay * _timeScale;
			}
			if(_repeat > 0)
			{
				result *= (_repeat + 1);
				result += _repeat * _repeatDelay * _timeScale;
			}
			return _delay * _timeScale + result;
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
						this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START, yoyoReverse, _nowRepeat, _data));
					}
					//更新所有的属性
					updateValue(runTemp, totalTemp);
					//更新事件
					call(_onUpdate, this, _onUpdateParams);
					this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE, yoyoReverse, _nowRepeat, _data));
					//本阶段的缓动完毕
					if(runTemp == totalTemp)
					{
						//当前是否为反向播放
						if(_yoyoReverse)
						{
							call(_onYoyoComplete, this, _onYoyoCompleteParams);
							this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_YOYO_COMPLETE, yoyoReverse, _nowRepeat, _data));
						}
						else
						{
							call(_onComplete, this, _onCompleteParams);
							this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_COMPLETE, yoyoReverse, _nowRepeat, _data));
							//需要反向播放
							if(!_yoyoReverse && _yoyo)
							{
								_yoyoReverse = true;
								//重新计算运行时间值
								_runtime = _runFrame = -_yoyoDelay * _timeScale;
								_totalRuntime = _totalRunFrame = _duration * _timeScale;
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
							this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_REPEAT, yoyoReverse, _nowRepeat, _data));
							_nowRepeat++;
							_yoyoReverse = false;
							//重新计算运行时间值
							_runtime = _runFrame = -_repeatDelay * _timeScale;
							_totalRuntime = _totalRunFrame = _duration * _timeScale;
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
		
		private function updateValue(runtime:Number, totalRuntime:Number):void
		{
			var reverse:Boolean = _yoyoReverse;
			if(_reversed && !_yoyo)
			{
				reverse = true;
			}
			//获取移动基数并为所有的属性赋值实现缓动
			var run:Number = reverse ? totalRuntime - runtime : runtime;
			var baseValue:Number = _ease.call(null, run, 0, 1, totalRuntime);
			//时间到达时校正移动基数
			if(runtime >= totalRuntime)
			{
				baseValue = reverse ? 0 : 1;
			}
			var propertyList:Vector.<TweenItem> = TweenManager.hammerc_internal::masterMap[_target];
			for(var i:int = 0, len:int = propertyList.length; i < len; i++)
			{
				var item:TweenItem = propertyList[i];
				if(item.master == this)
				{
					//是否为补丁
					if(item.plugin != null)
					{
						item.plugin.update(baseValue);
					}
					else
					{
						_target[item.property] = item.start + item.change * baseValue;
						if(_math != null)
						{
							_target[item.property] = _math.call(null, _target[item.property]);
						}
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
		 * 更新或添加新的缓动目标属性.
		 * @param variables 具体的目标属性.
		 * @param restart 是否要重新开始播放.
		 */
		public function updateVariables(variables:Object, restart:Boolean = false):void
		{
			var propertyList:Vector.<TweenItem> = TweenManager.hammerc_internal::masterMap[_target];
			for(var key:String in variables)
			{
				if(ATTRIBUTES.indexOf(key) == -1)
				{
					if(getQualifiedClassName(_target) == "Object" && !_target.hasOwnProperty(key))
					{
						_target[key] = 0;
					}
					else
					{
						if(!_target.hasOwnProperty(key) || (typeof _target[key]) != "number")
						{
							continue;
						}
					}
					var item:TweenItem = getTweenItem(propertyList, key);
					if(item == null)
					{
						item = new TweenItem(this, key);
						propertyList.push(item);
					}
					item.master = this;
					//是补丁还是普通缓动属性
					if(item.plugin != null)
					{
						item.plugin.updateVariables(_variables[key], _moveMode);
					}
					else
					{
						item.start = _target[key];
						if(_moveMode == MoveMode.ADDITION)
						{
							item.change = _variables[key];
						}
						else
						{
							item.change = _variables[key] - item.start;
						}
					}
				}
			}
			if(restart)
			{
				this.play();
			}
		}
		
		/**
		 * 移除一个已经存在的缓动目标属性, 该属性不会继续进行缓动.
		 * @param variables 要移除的目标属性. 如果移除一个属性并希望设置该属性的值请这样写 <code>tween.removeVariables({x:100});</code> 这样属性 x 会在被移除的同时设置为 100, 如果希望该属性回到缓动前的值请这样写 <code>tween.removeVariables({x:false});</code> 这样属性 x 会在被移除的同时设置回缓动前的值, 如果希望该属性停留在移除前的缓动值请这样写 <code>tween.removeVariables({x:true});</code> 这样属性 x 会停止进行缓动.
		 * @param restart 是否要重新开始播放.
		 */
		public function removeVariables(variables:Object, restart:Boolean = false):void
		{
			var propertyList:Vector.<TweenItem> = TweenManager.hammerc_internal::masterMap[_target];
			for(var key:String in variables)
			{
				if(ATTRIBUTES.indexOf(key) == -1)
				{
					//取出对应的项目
					var item:TweenItem = getTweenItem(propertyList, key, true, true);
					if(item == null)
					{
						continue;
					}
					//补丁对象的检测
					if(hammerc_internal::pluginKeyMap.hasOwnProperty(key) != -1 && getQualifiedClassName(variables[key]) == "Object")
					{
						if(!item.plugin.checkSupport(_target))
						{
							continue;
						}
					}
					//非补丁对象的检测
					else
					{
						if(!_target.hasOwnProperty(key) || (typeof _target[key]) != "number")
						{
							continue;
						}
					}
					//更新对应的值
					if(item.plugin != null)
					{
						item.plugin.removeVariables(variables[key]);
					}
					else
					{
						var value:* = variables[key];
						if(value is Boolean && !value)
						{
							_target[key] = item.start;
						}
						else if(value is Number)
						{
							_target[key] = value;
						}
					}
				}
			}
			if(restart)
			{
				this.play();
			}
		}
		
		private function getTweenItem(list:Vector.<TweenItem>, key:String, checkMaster:Boolean = false, remove:Boolean = false):TweenItem
		{
			var item:TweenItem = null;
			for(var i:int = 0; i < list.length; i++)
			{
				var value:TweenItem = list[i];
				if(value.property == key && (!checkMaster || value.master == this))
				{
					item = value;
					break;
				}
			}
			if(remove && item != null)
			{
				list.splice(i, 1);
			}
			return item;
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
			_totalRuntime = _totalRunFrame = _duration * _timeScale;
			_playing = true;
		}
		
		private function adjustPosition(position:Number, includeDelay:Boolean = true):Number
		{
			position = Math.max(position, 0);
			if(includeDelay)
			{
				position -= _delay * _timeScale;
			}
			var duration:Number = _duration * _timeScale;
			//反向缓动一次的总时间包含延迟
			var reverseTime:Number = _yoyoDelay * _timeScale + duration;
			//重复缓动一次的总时间包含延迟
			var repeatTime:Number = _repeatDelay * _timeScale + duration;
			if(_yoyo)
			{
				repeatTime += reverseTime;
			}
			//没有重复之前缓动完成的总时间包含延迟
			var completeTime:Number = duration + _delay;
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
					position -= _repeatDelay * _timeScale;
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
				position -= _yoyoDelay * _timeScale;
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
			this.play(position, includeDelay);
			_reversed = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			var propertyList:Vector.<TweenItem> = TweenManager.hammerc_internal::masterMap[_target];
			//之前的数据被覆写后会取不到数据
			if(propertyList == null)
			{
				return;
			}
			for(var i:int = 0; i < propertyList.length; i++)
			{
				var item:TweenItem = propertyList[i];
				if(item.master == this)
				{
					propertyList.splice(i, 1);
					i--;
				}
			}
			if(propertyList.length == 0)
			{
				delete TweenManager.hammerc_internal::masterMap[_target];
			}
		}
	}
}
