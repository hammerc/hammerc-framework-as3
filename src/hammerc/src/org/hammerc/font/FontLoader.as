// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.font
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.utils.ByteArray;
	
	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * @eventType flash.events.Event.INIT
	 */
	[Event(name="init",type="flash.events.Event")]
	
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
	 * @eventType flash.events.Event.UNLOAD
	 */
	[Event(name="unload",type="flash.events.Event")]
	
	/**
	 * <code>FontLoader</code> 类用来载入一个字体库文件并注册该文件包含的所有包含的字体库.
	 * @author wizardc
	 */
	public class FontLoader extends EventDispatcher
	{
		private var _loader:Loader;
		private var _loaded:Boolean = false;
		private var _fonts:Vector.<Font>;
		
		/**
		 * 创建一个 <code>FontLoader</code> 对象.
		 */
		public function FontLoader()
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderEventHandler);
			_loader.contentLoaderInfo.addEventListener(Event.INIT, loaderEventHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderEventHandler);
			_loader.contentLoaderInfo.addEventListener(Event.OPEN, loaderEventHandler);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderEventHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEventHandler);
			_loader.contentLoaderInfo.addEventListener(Event.UNLOAD, loaderEventHandler);
			_fonts = new Vector.<Font>();
		}
		
		/**
		 * 获取当前字体类库是否载入完毕.
		 */
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		/**
		 * 获取当前字体类库中包含的所有字体对象.
		 */
		public function get fonts():Vector.<Font>
		{
			return _fonts;
		}
		
		/**
		 * 获取当前字体类库中包含的所有字体名称.
		 */
		public function get fontNames():Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			for each(var item:Font in _fonts)
			{
				result.push(item.fontName);
			}
			return result;
		}
		
		/**
		 * 载入一个外部字体类库.
		 * @param request 地址.
		 */
		public function load(request:URLRequest):void
		{
			_loaded = false;
			_fonts.length = 0;
			_loader.load(request);
		}
		
		/**
		 * 从一个字节数组中载入一个外部字体类库.
		 * @param bytes 包含字体库的字节数组.
		 */
		public function loadBytes(bytes:ByteArray):void
		{
			_loaded = false;
			_fonts.length = 0;
			_loader.loadBytes(bytes);
		}
		
		private function loaderEventHandler(event:Event):void
		{
			switch(event.type)
			{
				case Event.COMPLETE:
					var classNames:Vector.<String> = _loader.contentLoaderInfo.applicationDomain.getQualifiedDefinitionNames();
					for each(var name:* in classNames)
					{
						var assetClass:Class = _loader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
						var font:Font = new assetClass() as Font;
						if(font != null)
						{
							Font.registerFont(assetClass);
							_fonts.push(font);
						}
					}
					_loaded = true;
					break;
			}
			dispatchEvent(event);
		}
		
		/**
		 * 取消当前的下载.
		 */
		public function close():void
		{
			_loader.close();
		}
		
		/**
		 * 卸载掉当前加载的字体库.
		 */
		public function unload():void
		{
			_loader.unloadAndStop();
			_loaded = false;
		}
	}
}
