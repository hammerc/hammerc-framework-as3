/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
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
			{regex:"(//.*)", color:"#009900"}, 
			{regex:"(/\\*([^\\*]|[\r\n])*?\\*/)", color:"#009900"}, 
			{regex:"(/\\*\\*(.|[\r\n])*?\\*/)", color:"#3F5FBF"}, 
		];
		
		private static const STRINGS:Array = [
			{regex:"(&quot;(.|[\r\n])*?&quot;)", color:"#990000"}, 
			{regex:"(&apos;(.|[\r\n])*?&apos;)", color:"#990000"}, 
		];
		
		private static const KEYWORDS:Array = [
			{color:"#0033FF", words:["import", "public", "private", "protected", "internal", "set", "get", "if", "else", "switch", "case", "break", "default", "for", "each", "in", "continue", "do", "while", "is", "as", "typeof", "instanceof", "use", "with", "return", "true", "false", "null", "void", "try", "catch", "finally", "throw", "new", "delete", "static", "final", "const", "dynamic", "extends", "implements"]}, 
			{color:"#6699CC", words:["var"]}, 
			{color:"#339966", words:["function"]}, 
			{color:"#9900CC", words:["package", "class", "interface"]}, 
		];
		
		private static const PREFIX:Array = [
			{regex:"(:\\s*)", color:"#0033FF", words:["void"]}, 
			{regex:"(=\\s*)", color:"#0033FF", words:["new", "null", "this", "super", "true", "false"]}, 
		];
		
		private static const SUFFIX:Array = [
			{regex:"(\\{)", color:"#9900CC", words:["package"]}, 
			{regex:"(\\{|\\()", color:"#0033FF", words:["for", "if", "each", "else", "switch", "do", "while", "typeof", "instanceof", "with", "try", "catch", "finally", "throw"]}, 
			{regex:"(:)", color:"#0033FF", words:["case", "default"]}, 
			{regex:"(;)", color:"#0033FF", words:["return", "continue", "true", "false", "null"]},
			{regex:"(.)", color:"#0033FF", words:["this", "super"]}, 
		];
		
		private static const SPACES:Array = [
			{regex:"\r", html:"<br/>"}, 
			{regex:"\t", html:"&nbsp;&nbsp;&nbsp;&nbsp;"}, 
		];
		
		/**
		 * 将 as3 源代码转换为带有颜色的 HTML 文本.
		 * @param code as3 源代码.
		 * @return 对应上色后的 HTML 文本.
		 */
		public static function colour(code:String):String
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
				code = code.replace(new RegExp(item.regex, "g"), "<font color=\'" + item.color + "\'>$1</font>");
			}
			for each(item in STRINGS)
			{
				code = code.replace(new RegExp(item.regex, "g"), "<font color=\'" + item.color + "\'>$1</font>");
			}
			for each(item in KEYWORDS)
			{
				for each(var word:String in item.words)
				{
					var newWord:String = "<font color=\'" + item.color + "\'>" + word + "</font>";
					code = code.replace(new RegExp("^(" + word + ")(\\s)", "g"), newWord + "$2");
					code = code.replace(new RegExp("(\\s)(" + word + ")(\\s)", "g"), "$1" + newWord + "$3");
				}
			}
			for each(item in PREFIX)
			{
				for each(word in item.words)
				{
					code = code.replace(new RegExp(item.regex + "(" + word + ")", "g"), "$1<font color=\'" + item.color + "\'>$2</font>");
				}
			}
			for each(item in SUFFIX)
			{
				for each(word in item.words)
				{
					code = code.replace(new RegExp("(" + word + ")" + item.regex, "g"), "<font color=\'" + item.color + "\'>$1</font>$2");
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
