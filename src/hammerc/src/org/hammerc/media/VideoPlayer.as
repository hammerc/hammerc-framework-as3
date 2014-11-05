// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.media
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.hammerc.events.VideoEvent;
	
	/**
	 * @eventType org.hammerc.events.HVideoEvent.CONNECT_SUCCESS
	 */
	[Event(name="connectSuccess", type="org.hammerc.events.VideoEvent")]
	
	/**
	 * @eventType org.hammerc.events.HVideoEvent.CONNECT_FAILED
	 */
	[Event(name="connectFailed", type="org.hammerc.events.VideoEvent")]
	
	/**
	 * @eventType org.hammerc.events.HVideoEvent.STREAM_NOT_FOUND
	 */
	[Event(name="streamNotFound", type="org.hammerc.events.VideoEvent")]
	
	/**
	 * @eventType org.hammerc.events.HVideoEvent.GET_META_DATA
	 */
	[Event(name="getMetaData", type="org.hammerc.events.VideoEvent")]
	
	/**
	 * @eventType org.hammerc.events.HVideoEvent.GET_READY
	 */
	[Event(name="getReady", type="org.hammerc.events.VideoEvent")]
	
	/**
	 * @eventType org.hammerc.events.HVideoEvent.VIDEO_COMPLETE
	 */
	[Event(name="videoComplete", type="org.hammerc.events.VideoEvent")]
	
	/**
	 * @eventType org.hammerc.events.HVideoEvent.BUFFER_BEGIN
	 */
	[Event(name="bufferBegin", type="org.hammerc.events.VideoEvent")]
	
	/**
	 * @eventType org.hammerc.events.HVideoEvent.BUFFER_END
	 */
	[Event(name="bufferEnd", type="org.hammerc.events.VideoEvent")]
	
	/**
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * @eventType flash.events.AsyncErrorEvent.ASYNC_ERROR
	 */
	[Event(name="asyncError", type="flash.events.AsyncErrorEvent")]
	
	/**
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * <code>VideoPlayer</code> 类封装和简化了视频对象的播放与控制.
	 * @author wizardc
	 */
	public class VideoPlayer extends Sprite
	{
		/**
		 * 网络连接对象.
		 */
		protected var _netConnection:NetConnection;
		
		/**
		 * 网络流对象.
		 */
		protected var _netStream:NetStream;
		
		/**
		 * 视频播放对象.
		 */
		protected var _video:Video;
		
		/**
		 * 记录当前的声音转换对象.
		 */
		protected var _soundTransform:SoundTransform;
		
		/**
		 * 记录视频文件的帧频.
		 */
		protected var _fps:int = 0;
		
		/**
		 * 记录视频文件的原始宽度.
		 */
		protected var _originWidth:int = 0;
		
		/**
		 * 记录视频文件的原始高度.
		 */
		protected var _originHeight:int = 0;
		
		/**
		 * 记录视频文件的总播放时间.
		 */
		protected var _duration:Number = 0;
		
		/**
		 * 创建一个 <code>VideoPlayer</code> 对象.
		 * @param width 指定视频的宽度.
		 * @param height 指定视频的高度.
		 */
		public function VideoPlayer(width:int = 320, height:int = 240)
		{
			this.mouseChildren = this.mouseEnabled = false;
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			_netStream = new NetStream(_netConnection);
			_netStream.client = this;
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			_netStream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_video = new Video(width, height);
			_video.attachNetStream(_netStream);
			_soundTransform = new SoundTransform();
			this.addChild(_video);
		}
		
		/**
		 * 连接服务器.
		 * @param command 连接命令.
		 */
		public function connect(command:String = null):void
		{
			if(_netConnection.connected)
			{
				_netConnection.close();
			}
			_netConnection.connect(command);
		}
		
		/**
		 * 载入一个视频流并开始播放.
		 * @param url 媒体文件的位置.
		 */
		public function load(url:String):void
		{
			this.close();
			_netStream.play(url);
			_netStream.soundTransform = _soundTransform;
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch(event.info["code"])
			{
				case "NetConnection.Connect.Success":
					this.dispatchEvent(new VideoEvent(VideoEvent.CONNECT_SUCCESS));
					break;
				case "NetConnection.Connect.Failed":
					this.dispatchEvent(new VideoEvent(VideoEvent.CONNECT_FAILED));
					break;
				case "NetStream.Play.StreamNotFound":
					this.dispatchEvent(new VideoEvent(VideoEvent.STREAM_NOT_FOUND));
					break;
				case "NetStream.Play.Start":
					this.dispatchEvent(new VideoEvent(VideoEvent.GET_READY));
					break;
				case "NetStream.Play.Stop":
					this.dispatchEvent(new VideoEvent(VideoEvent.VIDEO_COMPLETE));
					break;
				case "NetStream.Buffer.Empty":
					this.dispatchEvent(new VideoEvent(VideoEvent.BUFFER_BEGIN));
					break;
				case "NetStream.Buffer.Full":
					this.dispatchEvent(new VideoEvent(VideoEvent.BUFFER_END));
					break;
			}
		}
		
		/**
		 * @private
		 * 当可以读取视频文件的基本信息时回调该方法.
		 * @param metadata 视频文件的基本信息.
		 */
		public function onMetaData(metadata:Object):void
		{
			_fps = metadata["framerate"];
			_originWidth = metadata["width"];
			_originHeight = metadata["height"];
			_duration = metadata["duration"];
			this.dispatchEvent(new VideoEvent(VideoEvent.GET_META_DATA));
		}
		
		private function errorHandler(event:ErrorEvent):void
		{
			this.dispatchEvent(event);
		}
		
		/**
		 * 获取视频的当前播放时间, 单位为秒.
		 */
		public function get position():Number
		{
			return _netStream.time;
		}
		
		/**
		 * 获取视频的帧频.
		 */
		public function get fps():int
		{
			return _fps;
		}
		
		/**
		 * 获取视频的原始宽度.
		 */
		public function get originWidth():int
		{
			return _originWidth;
		}
		
		/**
		 * 获取视频的原始高度.
		 */
		public function get originHeight():int
		{
			return _originHeight;
		}
		
		/**
		 * 获取视频的总播放时间, 单位为秒.
		 */
		public function get duration():Number
		{
			return _duration;
		}
		
		/**
		 * 获取或设置视频的音量.
		 */
		public function set volume(value:Number):void
		{
			_soundTransform.volume = value;
			_netStream.soundTransform = _soundTransform;
		}
		public function get volume():Number
		{
			return _soundTransform.volume;
		}
		
		/**
		 * 获取或设置视频的平移量.
		 */
		public function set pan(value:Number):void
		{
			_soundTransform.pan = value;
			_netStream.soundTransform = _soundTransform;
		}
		public function get pan():Number
		{
			return _soundTransform.pan;
		}
		
		/**
		 * 获取视频流.
		 */
		public function get netStream():NetStream
		{
			return _netStream;
		}
		
		/**
		 * 从指定的位置处播放.
		 * @param position 开始播放的秒数.
		 */
		public function play(position:Number = 0):void
		{
			_netStream.play();
			_netStream.seek(position);
		}
		
		/**
		 * 暂停播放.
		 */
		public function pause():void
		{
			_netStream.pause();
		}
		
		/**
		 * 继续播放.
		 */
		public function resume():void
		{
			_netStream.play();
			_netStream.resume();
		}
		
		/**
		 * 停止播放.
		 */
		public function stop():void
		{
			_netStream.pause();
			_netStream.seek(0);
		}
		
		/**
		 * 关闭视频流.
		 */
		public function close():void
		{
			_netStream.pause();
			_netStream.close();
			_video.clear();
			if(_netConnection.connected)
			{
				_netConnection.close();
			}
		}
	}
}
