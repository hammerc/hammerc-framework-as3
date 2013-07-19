/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.load.parsers
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * <code>PictureResourceParser</code> 类实现了图片类型资源的解析.
	 * @author wizardc
	 */
	public class PictureResourceParser extends EventDispatcher implements IResourceParser
	{
		/**
		 * 本解析对象对应解析的资源类型.
		 */
		public static const PARSER_KEY:String = "Picture";
		
		private var _parser:Loader;
		private var _data:Bitmap;
		
		/**
		 * 创建一个 <code>PictureResourceParser</code> 对象.
		 */
		public function PictureResourceParser()
		{
			_parser = new Loader();
			_parser.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get key():String
		{
			return PARSER_KEY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get data():*
		{
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function parse(data:ByteArray, context:LoaderContext):void
		{
			context = null;
			_parser.loadBytes(data);
		}
		
		private function completeHandler(event:Event):void
		{
			_parser.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			_data = _parser.content as Bitmap;
			_parser.unload();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
