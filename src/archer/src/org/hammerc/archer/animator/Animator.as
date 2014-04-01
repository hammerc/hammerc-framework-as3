/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.animator
{
	import flash.events.EventDispatcher;
	
	import org.hammerc.archer.clock.IClockManager;
	import org.hammerc.archer.events.AnimationEvent;
	
	/**
	 * @eventType org.hammerc.archer.events.AnimationEvent.SOUND_EVENT
	 */
	[Event(name="soundEvent",type="org.hammerc.archer.events.AnimationEvent")]
	
	/**
	 * @eventType org.hammerc.archer.events.AnimationEvent.FRAME_EVENT
	 */
	[Event(name="frameEvent",type="org.hammerc.archer.events.AnimationEvent")]
	
	/**
	 * @eventType org.hammerc.archer.events.AnimationEvent.COMPLETE
	 */
	[Event(name="complete",type="org.hammerc.archer.events.AnimationEvent")]
	
	/**
	 * @eventType org.hammerc.archer.events.AnimationEvent.LOOP_COMPLETE
	 */
	[Event(name="loopComplete",type="org.hammerc.archer.events.AnimationEvent")]
	
	/**
	 * <code>IAnimator</code> 类实现了基于时间播放的动画控制对象.
	 * @author wizardc
	 */
	public class Animator extends EventDispatcher implements IAnimator
	{
		private var _clockManager:IClockManager;
		private var _target:IAnimatable;
		private var _frameRate:Number = 12;
		private var _repeatPlay:Boolean = false;
		
		/**
		 * 记录当前是否正在播放.
		 */
		protected var _isPlaying:Boolean = false;
		
		/**
		 * 记录一帧的间隔时间.
		 */
		protected var _frameDelay:Number = 1 / 12;
		
		/**
		 * 记录当前帧.
		 */
		protected var _currentFrame:Number = 1;
		
		/**
		 * 创建一个 <code>IAnimator</code> 对象.
		 * @param target 目标动画对象.
		 */
		public function Animator(target:IAnimatable)
		{
			super(this);
			this.target = target;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set clockManager(value:IClockManager):void
		{
			if(_clockManager != value)
			{
				if(_clockManager != null)
				{
					_clockManager.removeClockClient(this);
				}
				_clockManager = value;
				if(_clockManager != null)
				{
					_clockManager.addClockClient(this);
				}
			}
		}
		public function get clockManager():IClockManager
		{
			return _clockManager;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set target(value:IAnimatable):void
		{
			if(value == null)
			{
				throw new Error("目标动画对象不能设置为空！");
			}
			_target = value;
		}
		public function get target():IAnimatable
		{
			return _target;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set frameRate(value:Number):void
		{
			if(value < 1 || isNaN(value))
			{
				value = 1;
			}
			_frameRate = value;
			_frameDelay = 1 / _frameRate;
		}
		public function get frameRate():Number
		{
			return _frameRate;
		}
		
		/**
		 * 获取当前播放到的帧索引, 从 1 开始.
		 */
		public function get currentFrame():Number
		{
			return _currentFrame;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set repeatPlay(value:Boolean):void
		{
			_repeatPlay = value;
		}
		public function get repeatPlay():Boolean
		{
			return _repeatPlay;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * @inheritDoc
		 */
		public function gotoAndPlay(frame:int):void
		{
			_currentFrame = frame;
			this.play();
		}
		
		/**
		 * @inheritDoc
		 */
		public function gotoAndStop(frame:int):void
		{
			_currentFrame = frame;
			this.stop();
		}
		
		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			_isPlaying = true;
			_target.showFrame(int(_currentFrame));
		}
		
		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			_isPlaying = false;
			_currentFrame = int(_currentFrame);
			_target.showFrame(int(_currentFrame));
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(passedTime:Number):void
		{
			if(!_isPlaying)
			{
				return;
			}
			var lastFrame:Number = _currentFrame;
			var passedFrame:Number = passedTime / _frameDelay;
			_currentFrame += passedFrame;
			//计算播放是否完成
			var endFrame:int = _target.totalFrames + 1;
			if(_currentFrame >= endFrame)
			{
				if(_repeatPlay)
				{
					//补全跳过的帧
					while(_currentFrame >= endFrame)
					{
						this.dispatchFrameEvent(lastFrame, _target.totalFrames);
						this.dispatchEvent(new AnimationEvent(AnimationEvent.LOOP_COMPLETE, _target));
						lastFrame = 1;
						_currentFrame -= _target.totalFrames;
					}
					this.dispatchFrameEvent(lastFrame, _currentFrame);
				}
				else
				{
					_currentFrame = _target.totalFrames;
					this.dispatchFrameEvent(lastFrame, _currentFrame);
					this.stop();
					this.dispatchEvent(new AnimationEvent(AnimationEvent.COMPLETE, _target));
				}
			}
			else
			{
				this.dispatchFrameEvent(lastFrame, _currentFrame);
			}
			//显示帧
			_target.showFrame(int(_currentFrame));
		}
		
		/**
		 * 发送指定两帧之间的所有帧事件.
		 * @param beginFrame 开始的帧 (不包含该帧).
		 * @param endFrame 结束的帧 (包含该帧).
		 */
		protected function dispatchFrameEvent(beginFrame:int, endFrame:int):void
		{
			if(endFrame > beginFrame)
			{
				for(var i:int = beginFrame + 1; i <= endFrame; i++)
				{
					var soundLabel:String = _target.getSoundAt(i);
					if(soundLabel != null && soundLabel != "")
					{
						this.dispatchEvent(new AnimationEvent(AnimationEvent.SOUND_EVENT, _target, soundLabel));
					}
					var frameLabel:String = _target.getLabelAt(i);
					if(frameLabel != null && frameLabel != "")
					{
						this.dispatchEvent(new AnimationEvent(AnimationEvent.FRAME_EVENT, _target, frameLabel));
					}
				}
			}
		}
	}
}
