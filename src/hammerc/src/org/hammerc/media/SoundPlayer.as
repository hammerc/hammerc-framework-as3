/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.media
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * @eventType flash.events.Event.OPEN
	 */
	[Event(name="open", type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * @eventType flash.events.Event.ID3
	 */
	[Event(name="id3", type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * @eventType flash.events.Event.SOUND_COMPLETE
	 */
	[Event(name="soundComplete", type="flash.events.Event")]
	
	/**
	 * <code>SoundPlayer</code> 类封装和简化了声音对象的控制.
	 * @author wizardc
	 */
	public class SoundPlayer extends EventDispatcher
	{
		/**
		 * 声音对象.
		 */
		protected var _sound:Sound;
		
		/**
		 * 声音通道对象.
		 */
		protected var _soundChannel:SoundChannel;
		
		/**
		 * 音量偏移对象.
		 */
		protected var _soundTransform:SoundTransform;
		
		/**
		 * 当前播放的位置.
		 */
		protected var _position:Number = 0;
		
		/**
		 * 当前是否播放.
		 */
		protected var _playing:Boolean = false;
		
		/**
		 * 循环次数.
		 */
		protected var _currentLoop:int = 0;
		
		/**
		 * 总循环次数.
		 */
		protected var _totalLoop:int = 0;
		
		/**
		 * 创建一个 <code>SoundPlayer</code> 对象.
		 */
		public function SoundPlayer()
		{
			_soundTransform = new SoundTransform();
		}
		
		/**
		 * 获取 ID3 信息.
		 */
		public function get id3():ID3Info
		{
			if(_sound != null)
			{
				return _sound.id3;
			}
			return null;
		}
		
		/**
		 * 获取声音文件读取是否正在播放.
		 */
		public function get playing():Boolean
		{
			return _playing;
		}
		
		/**
		 * 获取当前循环的次数.
		 */
		public function get currentLoop():int
		{
			return _currentLoop;
		}
		
		/**
		 * 获取需要循环的总数.
		 */
		public function get totalLoop():int
		{
			return _totalLoop;
		}
		
		/**
		 * 设置或获取当前的播放点.
		 */
		public function set position(value:Number):void
		{
			if(_sound != null)
			{
				value = value > _sound.length ? _sound.length : value;
				if(_playing)
				{
					_soundChannel.stop();
					_soundChannel = _sound.play(value, 0, _soundTransform);
					_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
				}
				else
				{
					_position = value;
				}
			}
		}
		public function get position():Number
		{
			if(_playing)
			{
				return _soundChannel.position;
			}
			return _position;
		}
		
		/**
		 * 获取音乐的持续时间.
		 */
		public function get duration():Number
		{
			if(_sound && _sound.length)
			{
				return Math.ceil(_sound.length / (_sound.bytesLoaded / _sound.bytesTotal));
			}
			return 0;
		}
		
		/**
		 * 设置或获取音量.
		 */
		public function set volume(value:Number):void
		{
			_soundTransform.volume = value;
			if(_soundChannel != null)
			{
				_soundChannel.soundTransform = _soundTransform;
			}
		}
		public function get volume():Number
		{
			return _soundTransform.volume;
		}
		
		/**
		 * 设置或获取音乐偏移.
		 */
		public function set pan(value:Number):void
		{
			_soundTransform.pan = value;
			if(_soundChannel != null)
			{
				_soundChannel.soundTransform = _soundTransform;
			}
		}
		public function get pan():Number
		{
			return _soundTransform.pan;
		}
		
		/**
		 * 载入外部的 MP3 音乐文件.
		 * @param stream 指向外部 MP3 文件的 URL.
		 * @param context 一个可选的上下文对象，可以定义缓冲时间并且可以指定加载声音前应用程序是否应该检查跨域策略文件.
		 */
		public function load(stream:URLRequest, context:SoundLoaderContext = null):void
		{
			if(stream != null)
			{
				if(_sound != null)
				{
					this.close();
				}
				_sound = new Sound();
				_sound.addEventListener(Event.OPEN, soundEventHandler);
				_sound.addEventListener(ProgressEvent.PROGRESS, soundEventHandler);
				_sound.addEventListener(Event.ID3, soundEventHandler);
				_sound.addEventListener(Event.COMPLETE, soundEventHandler);
				_sound.addEventListener(IOErrorEvent.IO_ERROR, soundEventHandler);
				_sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, soundEventHandler);
				_sound.load(stream, context);
			}
		}
		
		private function soundEventHandler(event:Event):void
		{
			this.dispatchEvent(event);
		}
		
		/**
		 * 打开一个现有的 <code>Sound</code> 对象来播放.
		 * @param sound 需要播放的 <code>Sound</code> 对象.
		 */
		public function open(sound:Sound):void
		{
			if(sound != null)
			{
				if(_sound != null)
				{
					this.close();
				}
				_sound = sound;
			}
		}
		
		/**
		 * 开始播放声音, 设置的时间超出下载的能播放的时间或总时间时会自动设置到该声音的尾部.
		 * @param position 开始播放的时间秒数.
		 * @param loop 播放的次数, 0 为无限.
		 * @throws Error 没有可用的播放通道时抛出该异常.
		 */
		public function play(position:Number=0, loop:int = 1):void
		{
			if(_sound != null)
			{
				if(_soundChannel != null)
				{
					_soundChannel.stop();
				}
				_soundChannel = _sound.play(position, 0, _soundTransform);
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
				_playing = true;
				_currentLoop = 1;
				_totalLoop = loop;
			}
		}
		
		private function soundCompleteHandler(event:Event):void
		{
			this.dispatchEvent(event);
			if(_totalLoop == 0 || _currentLoop < _totalLoop)
			{
				_currentLoop++;
				_soundChannel.stop();
				_soundChannel = _sound.play(0, 0, _soundTransform);
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
				_playing = true;
			}
			else
			{
				_playing = false;
			}
		}
		
		/**
		 * 暂停播放声音.
		 */
		public function pause():void
		{
			if(_soundChannel != null)
			{
				_position = _soundChannel.position;
				_soundChannel.stop();
				_playing = false;
			}
		}
		
		/**
		 * 从暂停处开始继续播放.
		 */
		public function resume():void
		{
			if(_soundChannel != null && !_playing)
			{
				_soundChannel = _sound.play(_position, 0, _soundTransform);
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler, false, 0, true);
				_playing = true;
			}
		}
		
		/**
		 * 停止播放声音, 该声音的播放位置重置到开头.
		 */
		public function stop():void
		{
			if(_soundChannel != null)
			{
				_position = 0;
				_soundChannel.stop();
				_playing = false;
			}
		}
		
		/**
		 * 关闭并清除该声音对象, 如果正在下载则停止下载.
		 */
		public function close():void
		{
			this.stop();
			_soundChannel = null;
			if(_sound != null)
			{
				_sound.close();
				_sound.removeEventListener(Event.OPEN, soundEventHandler);
				_sound.removeEventListener(ProgressEvent.PROGRESS, soundEventHandler);
				_sound.removeEventListener(Event.ID3, soundEventHandler);
				_sound.removeEventListener(Event.COMPLETE, soundEventHandler);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, soundEventHandler);
				_sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, soundEventHandler);
			}
			_sound = null;
		}
	}
}
