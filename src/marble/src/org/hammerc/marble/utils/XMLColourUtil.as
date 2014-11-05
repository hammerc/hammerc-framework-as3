// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.utils
{
	/**
	 * <code>XMLColourUtil</code> 类提供了为 XML 上色的功能.
	 * @author wizardc
	 */
	public class XMLColourUtil
	{
		private static const SYMBOLS:Array = [
			{regex:"<", html:"&lt;"}, 
			{regex:">", html:"&gt;"}, 
			{regex:"\"", html:"&quot;"}, 
			{regex:'\'', html:"&apos;"}, 
		];
		
		private static const TAGS:Array = [
			{regex:"(&lt;\\?(.|[\r\n])*?\\?&gt;)", lightColor:"#9900CC", darkColor:"#7A7A7A"}, 
			{regex:"(&lt;!--(.|[\r\n])*?--&gt;)", lightColor:"#666666", darkColor:"#7A7A7A"}, 
			{regex:"(&lt;[0-9a-zA-Z]+&gt;)", lightColor:"#000099", darkColor:"#D4A74D"}, 
			{regex:"(&lt;/[0-9a-zA-Z]+&gt;)", lightColor:"#000099", darkColor:"#D4A74D"}, 
			{regex:"(&lt;[0-9a-zA-Z]+/&gt;)", lightColor:"#000099", darkColor:"#D4A74D"}, 
			{regex:"(&lt;[0-9a-zA-Z =(&quot;)(&quot;)(&apos;)(&apos;)]+&gt;)", lightColor:"#000099", darkColor:"#D4A74D"}, 
			{regex:"(&lt;[0-9a-zA-Z =(&quot;)(&quot;)(&apos;)(&apos;)]+/&gt;)", lightColor:"#000099", darkColor:"#D4A74D"}, 
		];
		
		private static const STRINGS:Array = [
			{regex:"(&quot;(.|[\r\n])*?&quot;)", lightColor:"#990000", darkColor:"#609454"}, 
			{regex:"(&apos;(.|[\r\n])*?&apos;)", lightColor:"#990000", darkColor:"#609454"}, 
		];
		
		private static const SPACES:Array = [
			{regex:"\n", html:"<br/>"}, 
			{regex:"\t", html:"&nbsp;&nbsp;&nbsp;&nbsp;"}, 
		];
		
		/**
		 * 将 XML 转换为带有颜色的 XML 文本.
		 * @param code XML 文件.
		 * @param lightTheme 是否使用亮色风格.
		 * @return 对应上色后的 XML 文本.
		 */
		public static function colour(code:String, lightTheme:Boolean = true):String
		{
			//as3 正则表达式可以按 \n 回车符进行行的分别, 所以需要将换行进行统一
			code = code.replace(/(\r\n)|\r/g, "\n");
			//根据配置进行上色
			var item:Object;
			for each(item in SYMBOLS)
			{
				code = code.replace(new RegExp(item.regex, "g"), item.html);
			}
			for each(item in TAGS)
			{
				code = code.replace(new RegExp(item.regex, "g"), "<font color=\'" + (lightTheme ? item.lightColor : item.darkColor) + "\'>$1</font>");
			}
			for each(item in STRINGS)
			{
				code = code.replace(new RegExp(item.regex, "g"), "<font color=\'" + (lightTheme ? item.lightColor : item.darkColor) + "\'>$1</font>");
			}
			for each(item in SPACES)
			{
				code = code.replace(new RegExp(item.regex, "g"), item.html);
			}
			return code;
		}
	}
}
