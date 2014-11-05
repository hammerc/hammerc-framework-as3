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
	 * <code>AS3CodeColourUtil</code> 类提供了为 as3 代码上色的功能.
	 * @author wizardc
	 */
	public class AS3CodeColourUtil
	{
		private static const SYMBOLS:Array = [
			{regex:"<", html:"&lt;"}, 
			{regex:">", html:"&gt;"}, 
			{regex:"\"", html:"&quot;"}, 
			{regex:'\'', html:"&apos;"}, 
		];
		
		private static const COMMENTS:Array = [
			{regex:"(//.*)", lightColor:"#009900", darkColor:"#7A7A7A"}, 
			{regex:"(/\\*([^\\*]|[\r\n])*?\\*/)", lightColor:"#009900", darkColor:"#7A7A7A"}, 
			{regex:"(/\\*\\*(.|[\r\n])*?\\*/)", lightColor:"#3F5FBF", darkColor:"#609454"}, 
		];
		
		private static const STRINGS:Array = [
			{regex:"(&quot;(.|[\r\n])*?&quot;)", lightColor:"#990000", darkColor:"#609454"}, 
			{regex:"(&apos;(.|[\r\n])*?&apos;)", lightColor:"#990000", darkColor:"#609454"}, 
		];
		
		private static const KEYWORDS:Array = [
			{lightColor:"#0033FF", darkColor:"#C8762F", words:["import", "public", "private", "protected", "internal", "set", "get", "if", "else", "switch", "case", "break", "default", "for", "each", "in", "continue", "do", "while", "is", "as", "typeof", "instanceof", "use", "with", "return", "true", "false", "null", "void", "try", "catch", "finally", "throw", "new", "delete", "static", "final", "const", "dynamic", "extends", "implements", "override"]}, 
			{lightColor:"#6699CC", darkColor:"#D4A74D", words:["var"]}, 
			{lightColor:"#339966", darkColor:"#D4A74D", words:["function"]}, 
			{lightColor:"#9900CC", darkColor:"#D4A74D", words:["package", "class", "interface"]}, 
		];
		
		private static const PREFIX:Array = [
			{regex:"(:\\s*)", lightColor:"#0033FF", darkColor:"#C8762F", words:["void"]}, 
			{regex:"(=\\s*)", lightColor:"#0033FF", darkColor:"#C8762F", words:["new", "null", "this", "super", "true", "false"]}, 
		];
		
		private static const SUFFIX:Array = [
			{regex:"(\\{)", lightColor:"#9900CC", darkColor:"#D4A74D", words:["package"]}, 
			{regex:"(\\{|\\()", lightColor:"#0033FF", darkColor:"#C8762F", words:["for", "if", "each", "else", "switch", "do", "while", "typeof", "instanceof", "with", "try", "catch", "finally", "throw"]}, 
			{regex:"(:)", lightColor:"#0033FF", darkColor:"#C8762F", words:["case", "default"]}, 
			{regex:"(;)", lightColor:"#0033FF", darkColor:"#C8762F", words:["return", "continue", "true", "false", "null"]},
			{regex:"(.)", lightColor:"#0033FF", darkColor:"#C8762F", words:["this", "super"]}, 
		];
		
		private static const SPACES:Array = [
			{regex:"\n", html:"<br/>"}, 
			{regex:"\t", html:"&nbsp;&nbsp;&nbsp;&nbsp;"}, 
		];
		
		/**
		 * 将 as3 源代码转换为带有颜色的 HTML 文本.
		 * @param code as3 源代码.
		 * @param lightTheme 是否使用亮色风格.
		 * @return 对应上色后的 HTML 文本.
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
			for each(item in COMMENTS)
			{
				code = code.replace(new RegExp(item.regex, "g"), "<font color=\'" + (lightTheme ? item.lightColor : item.darkColor) + "\'>$1</font>");
			}
			for each(item in STRINGS)
			{
				code = code.replace(new RegExp(item.regex, "g"), "<font color=\'" + (lightTheme ? item.lightColor : item.darkColor) + "\'>$1</font>");
			}
			for each(item in KEYWORDS)
			{
				for each(var word:String in item.words)
				{
					var newWord:String = "<font color=\'" + (lightTheme ? item.lightColor : item.darkColor) + "\'>" + word + "</font>";
					code = code.replace(new RegExp("^(" + word + ")(\\s)", "g"), newWord + "$2");
					code = code.replace(new RegExp("(\\s)(" + word + ")(\\s)", "g"), "$1" + newWord + "$3");
				}
			}
			for each(item in PREFIX)
			{
				for each(word in item.words)
				{
					code = code.replace(new RegExp(item.regex + "(" + word + ")", "g"), "$1<font color=\'" + (lightTheme ? item.lightColor : item.darkColor) + "\'>$2</font>");
				}
			}
			for each(item in SUFFIX)
			{
				for each(word in item.words)
				{
					code = code.replace(new RegExp("(" + word + ")" + item.regex, "g"), "<font color=\'" + (lightTheme ? item.lightColor : item.darkColor) + "\'>$1</font>$2");
				}
			}
			for each(item in SPACES)
			{
				code = code.replace(new RegExp(item.regex, "g"), item.html);
			}
			return code;
		}
	}
}
