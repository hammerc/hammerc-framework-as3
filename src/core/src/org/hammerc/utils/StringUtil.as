/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	/**
	 * <code>StringUtil</code> 类提供对字符串的各种处理.
	 * @author wizardc
	 */
	public class StringUtil
	{
		/**
		 * 替换字符串中的字符.
		 * @param string 要操作的字符串.
		 * @param oldString 旧的字符.
		 * @param newString 新的字符.
		 * @return 替换后的字符串.
		 */
		public static function replace(string:String, oldString:String, newString:String):String
		{
 			return string.split(oldString).join(newString);
 		}
		
		/**
		 * 如果指定的字符串是单个空格, 制表符, 回车符, 换行符或换页符, 则返回 <code>true</code>.
		 * @param character 查询的字符.
		 * @return 如果指定的字符串是单个空格, 制表符, 回车符, 换行符或换页符, 则返回 <code>true</code>.
		 */
		public static function isWhitespace(character:String):Boolean
		{
			switch(character)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
				default:
					return false;
			}
		}
		
		/**
		 * 如果指定的字符串都是由空格, 制表符, 回车符, 换行符或换页符组成, 则返回 <code>true</code>.
		 * @param character 查询的字符串.
		 * @return 如果指定的字符串都是由空格, 制表符, 回车符, 换行符或换页符组成, 则返回 <code>true</code>.
		 */
		public static function isAllWhitespace(string:String):Boolean
		{
			for(var i:int = 0, len:int = string.length; i < len; i++)
			{
				var char:String = string.charAt(i);
				if(!isWhitespace(char))
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 去掉字符串的首尾空白.
		 * @param string 需要处理的字符串.
		 * @return 去掉首尾空白的字符串.
		 */
		public static function trim(string:String):String
		{
	 			return trimLeft(trimRight(string));
	 	}
		
		/**
		 * 去掉字符串的首部空白.
		 * @param string 需要处理的字符串.
		 * @return 去掉首部空白的字符串.
		 */
		public static function trimLeft(string:String):String
		{
	 		var index:int = 0;
	 		var char:String = "";
	 		for(var i:int = 0, len:int = string.length; i < len; i++)
			{
	 			char = string.charAt(i);
	 			if(!isWhitespace(char))
				{
	 				index = i;
	 				break;
	 			}
	 		}
	 		return string.substr(index);
	 	}
		
		/**
		 * 去掉字符串的尾部空白.
		 * @param string 需要处理的字符串.
		 * @return 去掉尾部空白的字符串.
		 */
		public static function trimRight(string:String):String
		{
	 		var index:int = string.length - 1;
	 		var char:String = "";
	 		for(var i:int = string.length - 1; i >= 0; i--)
			{
	 			char = string.charAt(i);
	 			if(!isWhitespace(char))
				{
	 				index = i;
	 				break;
	 			}
	 		}
	 		return string.substring(0, index + 1);
	 	}
		
		/**
		 * 使用传入的各个参数替换指定的字符串内的 "{n}" 标记.
		 * @param string 要在其中进行替换的字符串. 该字符串可包含 {n} 形式的特殊标记, 其中 n 为从零开始的索引, 它将被该索引处的其他参数 (如果指定) 替换.
		 * @param rest 可在 <code>string</code> 参数中的每个 {n} 位置被替换的其他参数, 其中 n 是一个对指定值数组的整数索引值 (从 0 开始). 如果第一个参数是一个数组, 则该数组将用作参数列表.
		 * @return 使用指定的各个参数替换了所有 {n} 标记的新字符串.
		 */
		public static function substitute(string:String, ...rest):String
		{
			var len:uint = rest.length;
			var args:Array;
			if(len == 1 && rest[0] is Array)
			{
				args = rest[0] as Array;
				len = args.length;
			}
			else
			{
				args = rest;
			}
			for(var i:int = 0; i < len; i++)
			{
				string = string.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
			return string;
		}
		
		/**
		 * 返回一个字符串, 该字符串由其自身与指定次数串联的指定字符串构成.
		 * @param string 要重复的字符串.
		 * @param n 重复计数.
		 * @return 重复指定次数的字符串.
		 */
		public static function repeat(string:String, n:int):String
		{
			if(n <= 0)
			{
				return "";
			}
			var s:String = string;
			for(var i:int = 1; i < n; i++)
			{
				s += string;
			}
			return s;
		}
		
		/**
		 * 从字符串中删除 "不允许的" 字符. "限制字符串" (如 "A-Z0-9") 用于指定允许的字符. 此方法使用的是与 <code>TextField</code> 的 <code>restrict</code> 属性相同的逻辑.
		 * @param string 输入字符串.
		 * @param restrict 限制字符串.
		 * @return 剔除 "不允许的" 字符后的字符串.
		 */
		public static function restrict(string:String, restrict:String):String
		{
			if(restrict == null)
			{
				return string;
			}
			if(restrict == "")
			{
				return "";
			}
			var charCodes:Array = [];
			var n:int = string.length;
			for(var i:int = 0; i < n; i++)
			{
				var charCode:uint = string.charCodeAt(i);
				if(testCharacter(charCode, restrict))
				{
					charCodes.push(charCode);
				}
			}
			return String.fromCharCode.apply(null, charCodes);
		}
		
		private static function testCharacter(charCode:uint, restrict:String):Boolean
		{
			var allowIt:Boolean = false;
			var inBackSlash:Boolean = false;
			var inRange:Boolean = false;
			var setFlag:Boolean = true;
			var lastCode:uint = 0;
			var n:int = restrict.length;
			var code:uint;
			if(n > 0)
			{
				code = restrict.charCodeAt(0);
				if(code == 94)
				{
					allowIt = true;
				}
			}
			for(var i:int = 0; i < n; i++)
			{
				code = restrict.charCodeAt(i);
				var acceptCode:Boolean = false;
				if(!inBackSlash)
				{
					if(code == 45)
					{
						inRange = true;
					}
					else if(code == 94)
					{
						setFlag = !setFlag;
					}
					else if(code == 92)
					{
						inBackSlash = true;
					}
					else
					{
						acceptCode = true;
					}
				}
				else
				{
					acceptCode = true;
					inBackSlash = false;
				}
				if(acceptCode)
				{
					if(inRange)
					{
						if(lastCode <= charCode && charCode <= code)
						{
							allowIt = setFlag;
							inRange = false;
							lastCode = 0;
						}
					}
					else
					{
						if(charCode == code)
						{
							allowIt = setFlag;
							lastCode = code;
						}
					}
				}
			}
			return allowIt;
		}
		
		/**
		 * 判断一个字符串是否以指定的字符串开头.
		 * @param string 要判断的字符串.
		 * @param subString 开头的字符串.
		 * @return 字符串是否以指定的字符串开头.
		 */
		public static function startsWith(string:String, subString:String):Boolean
		{
	 		return (string.indexOf(subString) == 0);
	 	}
		
		/**
		 * 判断一个字符串是否以指定的字符串结尾.
		 * @param string 要判断的字符串.
		 * @param subString 结尾的字符串.
		 * @return 字符串是否以指定的字符串结尾.
		 */
	 	public static function endsWith(string:String, subString:String):Boolean
		{
	 		return (string.lastIndexOf(subString) == (string.length - subString.length));
	 	}
		
	 	/**
	 	 * 判断一个字符串是否都为小写.
	 	 * @param string 需要判断的字符串.
	 	 * @return 字符串是否都为小写.
	 	 */
	 	public static function isLetter(string:String):Boolean
		{
	 		if(string == null || string == "")
			{
	 			return false;
	 		}
	 		for(var i:int = 0; i < string.length; i++)
			{
	 			var code:uint = string.charCodeAt(i);
	 			if(code < 65 || code > 122 || (code > 90 && code < 97))
				{
	 				return false;
	 			}
	 		}
	 		return true;
	 	}
		
		/**
		 * 返回一个字符串的长度, 字符串中的中文及全角字符等将按长度为 2 来计算.
		 * @param string 需要计算长度的字符串.
		 * @return 该字符串的长度.
		 */
		public static function getStringLength(string:String):int
		{
			var array:Array = string.match(/[^\x00-\xff]/g);
			var length:int = string.length;
			if(array)
			{
				length += array.length;
			}
			return length;
		}
		
		/**
		 * 截取指定字符串的一部分, 字符串中的中文及全角字符等将按长度为 2 来计算.
		 * <p>如果开始索引不足或结束索引不足则认为放弃该字符, 如 <code>sliceString("hammerc基础类库v0.1", 8, 13)</code> 会返回 "础类", 因为基字占用了 7 和 8 位, 而库字占用了 13 和 14 位.</p>
		 * @param string 需要截取的字符串.
		 * @param startIndex 开始截取索引.
		 * @param endIndex 结束截取索引.
		 * @return 截取后的字符串.
		 */
		public static function sliceString(string:String, startIndex:int = 0, endIndex:int = 0x7fffffff):String
		{
			var tempStart:int = 0, tempEnd:int = 0, tempIndex:int = -1;			//记录截取字符串的开始索引及结束索引
			var regExp:RegExp = new RegExp("[^\\x00-\\xff]");					//双字节字符的判断正则表达式
			//计算真正截取的索引区域
			for(var i:int=0; i < string.length; i++)
			{
				//按中文及全角字符长度为 2 递增
				if(regExp.test(string.charAt(i)))
				{
					tempIndex += 2;
				}
				else
				{
					tempIndex++;
				}
				//如果当前遍历过的长度还小于起始长度则递增真正要截取的起始长度
				if(tempIndex < startIndex)
				{
					tempStart++;
				}
				/*
				 * 如果当前遍历的索引 tempIndex 等于记录的索引 tempStart 再 +1 则
				 * 当前遍历的必为双字节字符, 那么当前遍历的索引 tempIndex 指向当前双
				 * 字节字符的后一半, 同时如果要截取的开始索引 startIndex 就等于当前
				 * 遍历的索引 tempIndex 的话, 则说明当前要截取的开始处为一个双字节字
				 * 符的一半, 应舍弃就将要截取的索引 tempStart 再 +1 即可
				 */
				if(tempIndex == tempStart + 1 && tempIndex == startIndex)
				{
					tempStart++;
				}
				/*
				 * 如果当前遍历的索引 tempIndex 小于等于要截取的结束索引 endIndex 
				 * 就说明要截取的字符已经包含, 递增要截取的索引 tempEnd 即可, 如果
				 * 大于则说明要截取的字符已经超出, 退出循环即可
				 */
				if(tempIndex <= endIndex)
				{
					tempEnd++;
				}
				else
				{
					break;
				}
			}
			//截取字符串并返回
			return string.substring(tempStart, tempEnd);
		}
	}
}
