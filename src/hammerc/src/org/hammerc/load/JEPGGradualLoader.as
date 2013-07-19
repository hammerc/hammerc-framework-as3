/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.load
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	/**
	 * @eventType flash.events.Event.OPEN
	 */
	[Event(name="open", type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
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
	 * <code>JEPGGradualLoader</code> 类用于下载 JEPG 渐进式图片, 实际效果为下载时图片是模糊的, 然后渐渐的会清晰起来.
	 * @author wizardc
	 */
	public class JEPGGradualLoader extends Bitmap
	{
		private var _bufferLoader:Loader;
		private var _completeLoader:Loader;
		private var _stream:URLStream;
		private var _bytes:ByteArray;
		
		/**
		 * 创建一个 <code>JEPGGradualLoader</code> 对象.
		 */
		public function JEPGGradualLoader()
		{
			_bufferLoader = new Loader();
			_bufferLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_completeLoader = new Loader();
			_completeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_stream = new URLStream();
			_stream.addEventListener(Event.OPEN, streamEventHandler);
			_stream.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_stream.addEventListener(Event.COMPLETE, completeHandler);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, streamEventHandler);
			_stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, streamEventHandler);
			_bytes = new ByteArray();
		}
		
		private function streamEventHandler(event:Event):void
		{
			this.dispatchEvent(event);
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			if(_stream.bytesAvailable > 0)
			{
				_stream.readBytes(_bytes, _bytes.length);
			}
			if(_bytes.length > 0)
			{
				_bufferLoader.loadBytes(_bytes);
			}
			this.dispatchEvent(event);
		}
		
		private function completeHandler(event:Event):void
		{
			if(_stream.bytesAvailable > 0)
			{
				_stream.readBytes(_bytes, _bytes.length);
			}
			_completeLoader.loadBytes(_bytes);
			this.dispatchEvent(event);
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			this.bitmapData = ((event.target as LoaderInfo).content as Bitmap).bitmapData;
		}
		
		/**
		 * 载入 JEPG 渐进式图片.
		 * @param request 要下载地址对象.
		 */
		public function load(request:URLRequest):void
		{
			_stream.load(request);
		}
		
		/**
		 * 卸载掉加载的图片.
		 */
		public function unload():void
		{
			this.bitmapData = null;
		}
		
		/**
		 * 取消当前的下载.
		 */
		public function close():void
		{
			if(_stream.connected)
			{
				_stream.close();
				this.bitmapData = null;
			}
		}
	}
}
