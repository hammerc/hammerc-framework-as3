/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	/**
	 * <code>SleepModeUtil</code> 类对 Flash 睡眠模式的帧率控制提供支持.
	 * <p>对于 Flash 是否进入睡眠模式可以侦听 <code>flash.events.ThrottleEvent</code> 事件实现. Flash 进入睡眠模式默认为 2 帧的帧率, 如果有音视频正在播放会保持 8 帧的帧率.</p>
	 * @author wizardc
	 */
	public class SleepModeUtil
	{
		private static var _sound:Sound;
		private static var _soundChannel:SoundChannel;
		
		/**
		 * 使 Flash 进入睡眠模式后仍然保持之前的运行帧率.
		 */
		public static function keepOriginalFPS():void
		{
			if(_sound == null)
			{
				_sound = new Sound();
				_sound.load(new URLRequest(""));
				_sound.play();
				_sound.close();
				_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataHandler);
				_soundChannel = _sound.play();
			}
		}
		
		private static function sampleDataHandler(event:SampleDataEvent):void
		{
			event.data.position = event.data.length = 4096 * 4;
		}
		
		/**
		 * 释放保持的帧率, Flash 进入睡眠模式后使用默认的帧率.
		 */
		public static function releaseKeepOriginalFPS():void
		{
			if(_sound != null)
			{
				_soundChannel.stop();
				_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataHandler);
				_soundChannel = null;
				_sound = null;
			}
		}
	}
}
