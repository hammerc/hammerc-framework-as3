// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.load.parsers
{
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
	 * <code>SWFResourceParser</code> 类实现了 swf 类型资源的解析.
	 * @author wizardc
	 */
	public class SWFResourceParser extends EventDispatcher implements IResourceParser
	{
		/**
		 * 本解析对象对应解析的资源类型.
		 */
		public static const PARSER_KEY:String = "SWF";
		
		private var _parser:Loader;
		
		/**
		 * 创建一个 <code>SWFResourceParser</code> 对象.
		 */
		public function SWFResourceParser()
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
			return _parser;
		}
		
		/**
		 * @inheritDoc
		 */
		public function parse(data:ByteArray, context:LoaderContext):void
		{
			_parser.loadBytes(data, context);
		}
		
		private function completeHandler(event:Event):void
		{
			_parser.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
