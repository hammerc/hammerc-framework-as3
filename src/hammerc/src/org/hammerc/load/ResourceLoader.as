// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.load
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.hammerc.load.parsers.IResourceParser;
	import org.hammerc.load.parsers.PictureResourceParser;
	import org.hammerc.load.parsers.RSLResourceParser;
	import org.hammerc.load.parsers.ResourceParserManager;
	import org.hammerc.load.parsers.SWFResourceParser;
	import org.hammerc.load.parsers.SoundResourceParser;
	
	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	
	/**
	 * @eventType flash.events.Event.OPEN
	 */
	[Event(name="open",type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress",type="flash.events.ProgressEvent")]
	
	/**
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]
	
	/**
	 * <code>ResourceLoader</code> 类实现了载入各种类型的文件并对其进行解析为可使用的类型的功能.
	 * <p>可将本对象看成加强版的 <code>URLLoader</code> 对象, 因为本对象支持解析各种类型的文件为可用的 as3 对象, 需要添加解析的文件类型可以应用 <code>IResourceParser</code> 接口自行扩展.</p>
	 * @author wizardc
	 */
	public class ResourceLoader extends EventDispatcher
	{
		private static var _initialized:Boolean = false;
		
		/**
		 * 记录数据要解析为的类型.
		 */
		protected var _parseType:String;
		
		/**
		 * 记录载入上下文对象.
		 */
		protected var _context:LoaderContext;
		
		/**
		 * 记录解析后的对象.
		 */
		protected var _data:*;
		
		/**
		 * 数据载入对象.
		 */
		protected var _urlLoader:URLLoader;
		
		/**
		 * 解析数据的具体对象.
		 */
		protected var _resourceParser:IResourceParser;
		
		/**
		 * 创建一个 <code>ResourceLoader</code> 对象.
		 */
		public function ResourceLoader()
		{
			if(!_initialized)
			{
				ResourceParserManager.activeParses(new <Class>[PictureResourceParser, SoundResourceParser, SWFResourceParser, RSLResourceParser]);
				_initialized = true;
			}
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.OPEN, eventsHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, eventsHandler);
			_urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, eventsHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventsHandler);
		}
		
		/**
		 * 获取已下载的字节.
		 */
		public function get bytesLoaded():uint
		{
			return _urlLoader.bytesLoaded;
		}
		
		/**
		 * 获取要下载的字节.
		 */
		public function get bytesTotal():uint
		{
			return _urlLoader.bytesTotal;
		}
		
		/**
		 * 获取数据要解析为的类型.
		 */
		public function get parseType():String
		{
			return _parseType;
		}
		
		/**
		 * 获取解析后的对象.
		 */
		public function get data():*
		{
			return _data;
		}
		
		/**
		 * 载入指定的文件并进行解析.
		 * @param request 要下载地址对象.
		 * @param type 解析类型.
		 * @param context 载入上下文对象.
		 */
		public function load(request:URLRequest, parseType:String = "Bytes", context:LoaderContext = null):void
		{
			this.close();
			_parseType = parseType;
			_context = context;
			_data = null;
			switch(_parseType)
			{
				case ResourceParserType.TEXT:
				case ResourceParserType.JSON:
				case ResourceParserType.XML:
					_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
					break;
				case ResourceParserType.VARIABLES:
					_urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
					break;
				default:
					_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					break;
			}
			_urlLoader.load(request);
		}
		
		private function eventsHandler(event:Event):void
		{
			this.dispatchEvent(event);
		}
		
		private function completeHandler(event:Event):void
		{
			switch(_parseType)
			{
				case null:
				case ResourceParserType.TEXT:
				case ResourceParserType.VARIABLES:
				case ResourceParserType.BYTES:
					_data = _urlLoader.data;
					break;
				case ResourceParserType.JSON:
					_data = JSON.parse(_urlLoader.data as String);
					break;
				case ResourceParserType.XML:
					_data = new XML(_urlLoader.data as String);
					break;
				case ResourceParserType.AMF3:
					_data = (_urlLoader.data as ByteArray).readObject();
					break;
				default:
					if(ResourceParserManager.isParseSupport(_parseType))
					{
						_resourceParser = ResourceParserManager.getParse(_parseType);
						_resourceParser.addEventListener(Event.COMPLETE, parseCompleteHandler);
						_resourceParser.parse(_urlLoader.data as ByteArray, _context);
						return;
					}
					_data = _urlLoader.data;
					return;
			}
			_urlLoader.data = null;
			this.dispatchEvent(event);
		}
		
		private function parseCompleteHandler(event:Event):void
		{
			_resourceParser.removeEventListener(Event.COMPLETE, parseCompleteHandler);
			_data = _resourceParser.data;
			_resourceParser = null;
			(_urlLoader.data as ByteArray).clear();
			_urlLoader.data = null;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 关闭当前的下载.
		 */
		public function close():void
		{
			try
			{
				_urlLoader.close();
			}
			catch(error:Error)
			{
			}
			if(_resourceParser != null)
			{
				_resourceParser.removeEventListener(Event.COMPLETE, parseCompleteHandler);
				_resourceParser = null;
			}
		}
	}
}
