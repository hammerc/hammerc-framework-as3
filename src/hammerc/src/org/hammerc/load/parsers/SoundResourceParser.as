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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * <code>SoundResourceParser</code> 类实现了音效类型资源的解析.
	 * @author wizardc
	 */
	public class SoundResourceParser extends EventDispatcher implements IResourceParser
	{
		/**
		 * 本解析对象对应解析的资源类型.
		 */
		public static const PARSER_KEY:String = "Sound";
		
		private var _parser:Sound;
		
		/**
		 * 创建一个 <code>SoundResourceParser</code> 对象.
		 */
		public function SoundResourceParser()
		{
			_parser = new Sound();
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
			context = null;
			_parser.loadCompressedDataFromByteArray(data, data.bytesAvailable);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
