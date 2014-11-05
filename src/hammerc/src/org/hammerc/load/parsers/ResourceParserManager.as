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
	/**
	 * <code>ResourceParserManager</code> 类管理资源载入的所有解析类对象.
	 * @author wizardc
	 */
	public class ResourceParserManager
	{
		private static var _parseKeyMap:Object = new Object();
		
		/**
		 * 添加一个解析类对象.
		 * @param parse 解析类对象.
		 */
		public static function activeParse(parse:Class):void
		{
			if(parse == null)
			{
				return;
			}
			var instance:IResourceParser = new parse() as IResourceParser;
			if(instance == null)
			{
				return;
			}
			if(!_parseKeyMap.hasOwnProperty(instance.key))
			{
				_parseKeyMap[instance.key] = parse;
			}
		}
		
		/**
		 * 添加多个解析类对象.
		 * @param parses 解析类对象列表.
		 */
		public static function activeParses(parses:Vector.<Class>):void
		{
			for each(var parse:Class in parses)
			{
				activeParse(parse);
			}
		}
		
		/**
		 * 判断键名指定的资源类型是否被解析对象支持.
		 * @param key 要判断的键名.
		 * @return 是否被解析对象支持.
		 */
		public static function isParseSupport(key:String):Boolean
		{
			return _parseKeyMap.hasOwnProperty(key);
		}
		
		/**
		 * 获取键名指定的资源类型的对应解析对象.
		 * @param key 指定的键名.
		 * @return 对应解析对象.
		 */
		public static function getParse(key:String):IResourceParser
		{
			if(_parseKeyMap.hasOwnProperty(key))
			{
				var assetClass:Class = _parseKeyMap[key] as Class;
				return new assetClass() as IResourceParser;
			}
			return null;
		}
	}
}
