// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.utils
{
	/**
	 * <code>TextFilter</code> 类实现了文本过滤的功能.
	 * @author wizardc
	 */
	public class TextFilter
	{
		/**
		 * HTML 标签过滤文本.
		 */
		public static const HTML_FILTER:Vector.<String> = new <String>["<(S*?)[^>]*>.*?|<.*?/>"];
		
		/**
		 * 记录所有需要过滤的字符串.
		 */
		protected var _words:Vector.<String>;
		
		/**
		 * 用于过滤的正则表达式对象.
		 */
		protected var _wordsRegExp:RegExp;
		
		/**
		 * 创建一个 <code>TextFilter</code> 对象.
		 */
		public function TextFilter()
		{
			_words = new Vector.<String>();
		}
		
		/**
		 * 添加需要过滤的字符串.
		 * @param words 需要过滤的字符串列表.
		 */
		public function addWords(words:Vector.<String>):void
		{
			_words = _words.concat(words);
			_wordsRegExp = new RegExp("(" + _words.join("|") + ")", "img");
		}
		
		/**
		 * 判断是否包含了需要过滤的字符串.
		 * @param text 需要判断的文本.
		 * @return 是否包含需要过滤的字符串.
		 */
		public function hasWords(text:String):Boolean
		{
			if(_wordsRegExp == null)
			{
				return false;
			}
			return _wordsRegExp.test(text);
		}
		
		/**
		 * 替换需要过滤的字符串为指定的新字符串.
		 * @param text 需要处理的文本.
		 * @param replaceString 要替换为的新字符串.
		 * @return 过滤后的文本.
		 */
		public function filterText(text:String, replaceString:String = "***"):String
		{
			if(_wordsRegExp == null)
			{
				return text;
			}
			return text.replace(_wordsRegExp, replaceString);
		}
	}
}
