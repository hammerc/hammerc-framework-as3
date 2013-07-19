/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import org.hammerc.utils.StringUtil;
	
	/**
	 * <code>LanguageManager</code> 类提供多语言管理的支持.
	 * <ul><code>addLanguage</code> 方法中的 <code>content</code> 传入的语言内容文本须符合下面的规定：
	 *   <li>使用换行分割每一条数据;</li>
	 *   <li>取每一行的第一个等号 "=" 为键与值的分割标示;</li>
	 *   <li>如果新的一行中没有等号 "=" 则本行数据视为上一行数据的值;</li>
	 *   <li>键名不能包含任何的空白字符;</li>
	 *   <li>使用 "\r" 或 "\n" 来表示换行;</li>
	 *   <li>每行开头使用 "!" 或 "#" 可以标示该一行为注释文本;</li>
	 *   <li>使用 "{0}" 进行参数替换, 括号中间的数字为参数索引;</li>
	 * </ul>
	 * @author wizardc
	 */
	public class LanguageManager
	{
		private static var _languageMap:Object = new Object();
		private static var _defaultLanguage:String;
		
		/**
		 * 设置或获取默认使用的语言包.
		 */
		public static function set defaultLanguage(value:String):void
		{
			_defaultLanguage = value;
		}
		public static function get defaultLanguage():String
		{
			return _defaultLanguage;
		}
		
		/**
		 * 获取当前可以使用的所有语言包名称列表.
		 */
		public static function get languageList():Vector.<String>
		{
			var list:Vector.<String> = new Vector.<String>();
			for(var key:String in _languageMap)
			{
				list.push(key);
			}
			return list;
		}
		
		/**
		 * 添加一个语言包.
		 * @param language 要添加的语言包名称.
		 * @param content 要添加的语言包内容.
		 */
		public static function addLanguage(language:String, content:String):void
		{
			var contentMap:Object = new Object();
			var textLines:Array = content.split(/\r?\n|\n/);
			var key:String, value:String;
			for each(var textLine:String in textLines)
			{
				if(textLine != null && textLine.length > 0 && textLine.charAt(0) != "!" && textLine.charAt(0) != "#")
				{
					if (/^\S+=.*/.test(textLine))
					{
						var index:int = textLine.indexOf("=");
						key = textLine.slice(0, index);
						value = textLine.slice(index + 1);
						contentMap[key] = analyzeText(value);
					}
					else if(key != null)
					{
						contentMap[key] += analyzeText(textLine);
					}
				}
			}
			_languageMap[language] = contentMap;
		}
		
		private static function analyzeText(text:String):String
		{
			text = text.replace(/\\t/g, "\t");
			text = text.replace(/\\r/g, "\r");
			text = text.replace(/\\n/g, "\n");
			return text;
		}
		
		/**
		 * 获取指定的文本.
		 * @param key 文本的键名.
		 * @param args 用于替换文本内容的参数.
		 * @return 指定的文本.
		 */
		public static function getString(key:String, ...args):String
		{
			return getStringByLanguage.apply(null, [_defaultLanguage, key].concat(args));
		}
		
		/**
		 * 获取指定语言包的文本.
		 * @param language 指定的语言包.
		 * @param key 文本的键名.
		 * @param args 用于替换文本内容的参数.
		 * @return 指定的文本.
		 */
		public static function getStringByLanguage(language:String, key:String, ...args):String
		{
			if(_languageMap.hasOwnProperty(language))
			{
				var contentMap:Object = _languageMap[language];
				if(contentMap.hasOwnProperty(key))
				{
					var text:String = contentMap[key];
					return StringUtil.substitute.apply(null, [text].concat(args));
				}
			}
			return null;
		}
		
		/**
		 * 移除指定的语言包.
		 * @param language 要移除的语言包.
		 */
		public static function removeLanguage(language:String):void
		{
			if(_languageMap.hasOwnProperty(language))
			{
				delete _languageMap[language];
			}
			if(_defaultLanguage == language)
			{
				_defaultLanguage = null;
			}
		}
		
		/**
		 * 移除所有的语言包.
		 */
		public static function removeAllLanguage():void
		{
			_languageMap = new Object();
			_defaultLanguage = null;
		}
	}
}
