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
	 * <code>NumberUtil</code> 类提供对数字的各种操作.
	 * @author wizardc
	 */
	public class NumberUtil
	{
		/**
		 * 中文数字.
		 */
		public static const CHINESE_NUMBER:Array = ["〇","一","二","三","四","五","六","七","八","九","点","负"];
		
		/**
		 * 单位换算基数.
		 */
		public static const BASE_SIZE:Array = [1024, 1048576, 1073741824, 1099511627776, 1125899906842624, 1152921504606846976];
		
		/**
		 * 格式化一个数字.
		 * @param number 需要被格式化的数字.
		 * @param digit 每隔几位显示一个分隔符 (最多 20 位).
		 * @param separator 显示的分隔符, 使用 "," 号分隔多个分隔符, 如 "万,亿,兆"; 默认 "," 号则就用 "," 号作为分隔符, 多个分隔符是从小数点左方开始排列, 使用完设定的分隔符后则不再使用分隔符.
		 * @param filled 是否填充每一个位数的 0, <code>filled = false</code> 只在 <code>separator</code> 设置了多个符号时才有用.
		 * @param decimals 结果需要保留的小数数位 (最多 20 位).
		 * @param filledDecimals 是否补齐保留的小数数位.
		 * @param pointSymbol 小数点符号.
		 * @param negativeSymbol 负数的符号.
		 * @return 格式化后的字符串.
		 * @example
		 * <listing version="3.0">
		 * //输出 "1,000,000"
		 * trace(NumberUtil.numberFormat(1000000));
		 * //输出 "1亿0000万0000"
		 * trace(NumberUtil.numberFormat(100000000, 4, "万,亿"));
		 * //输出 "10000亿0000万0000"(用完设置的分隔符后就不再使用分隔符了)
		 * trace(NumberUtil.numberFormat(1000000000000, 4, "万,亿"));
		 * //输出 "1兆0000亿0000万0000"
		 * trace(NumberUtil.numberFormat(1000000000000, 4, "万,亿,兆"));
		 * //输出 "1亿"
		 * trace(NumberUtil.numberFormat(100000000, 4, "万,亿", false));
		 * //输出 "1亿200万"
		 * trace(NumberUtil.numberFormat(102000000, 4, "万,亿", false));
		 * //输出 "1,000,000.50000"
		 * trace(NumberUtil.numberFormat(10000000.5, 3, ",", true, 5, true));
		 * //输出 "1亿200万点5"
		 * trace(NumberUtil.numberFormat(102000000.5, 4, "万,亿", false, 5, false, "点"));
		 * //输出 "-1,000,000"
		 * trace(NumberUtil.numberFormat(-1000000));
		 * //输出 "负1亿200万"
		 * trace(NumberUtil.numberFormat(-102000000, 4, "万,亿", false, 0, false, ".", "负"));
		 * </listing>
		 */
		public static function numberFormat(number:Number, digit:uint = 3, separator:String = ",", filled:Boolean = true, decimals:uint = 0, filledDecimals:Boolean = true, pointSymbol:String = ".", negativeSymbol:String = "-"):String
		{
			digit = digit > 20 ? 20 : digit;
			decimals = decimals > 20 ? 20 : decimals;
			separator = separator == null ? "" : separator;
			pointSymbol = pointSymbol == null ? "" : pointSymbol;
			negativeSymbol = negativeSymbol == null ? "" : negativeSymbol;
			var negative:Boolean = number < 0;
			number = Math.abs(number);
			var integer:Number = Math.floor(number),
			decimal:Number = number - integer,
			integerStr:String = integer.toString(),
			decimalStr:String = decimal.toString(),
			index:int = integerStr.length,
			integerArr:Array = new Array(),
			separatorArr:Array,
			tempStr:String,
			tempInt:int,
			result:String = "";
			//将数字的整数部分拆分并作为字符串放置到数组中, 如：10001030 会变成 ["030","001","10"]
			while(index > 0)
			{
				var start:int = index - digit;
				var len:int = start < 0 ? digit + start : digit;
				start = start < 0 ? 0 : start;
				integerArr.push(integerStr.substr(start, len));
				index -= digit;
			}
			//获取每个位数的分隔符
			if(separator.length > 1 && separator.indexOf(",") != -1)
			{
				separatorArr = separator.split(",");
			}
			//组合整数部分
			index = 0;
			while(integerArr.length != 0)
			{
				if(separatorArr != null)
				{
					if(filled)
					{
						result = integerArr.shift() + ((index != 0 && index <= separatorArr.length) ? separatorArr[index - 1] : "") + result;
					}
					else
					{
						tempStr = integerArr.shift();
						tempInt = int(tempStr);
						if(index >= separatorArr.length)						//分隔符用完时
						{
							result = tempStr + ((index != 0 && index <= separatorArr.length) ? separatorArr[index - 1] : "") + result;
						}
						else
						{
							if(tempInt != 0)
							{
								result = tempInt + ((index != 0 && index <= separatorArr.length) ? separatorArr[index - 1] : "") + result;
							}
						}
					}
				}
				else
				{
					result = integerArr.shift() + (index != 0 ? separator : "") + result;
				}
				index++;
			}
			//加入小数部分
			if(decimals > 0)
			{
				if(decimal != 0)
				{
					decimalStr = pointSymbol + decimalStr.substr(2, decimals);
				}
				if(filledDecimals)
				{
					decimalStr += "00000000000000000000".substr(0, decimals - ((decimalStr.length - 1)));
				}
				result += decimalStr;
			}
			//加入负号符号
			if(negative)
			{
				result = negativeSymbol + result;
			}
			return result;
		}
		
		/**
		 * 将一个数字类型或字符串类型中的数字及小数点替换为对应的中文, 字符串中的其他字符不变.
		 * @param origin 需要进行替换的数字类型或字符串类型.
		 * @return 替换后的字符串.
		 * @throws 参数类型不正确会抛出 <code>ArgumentError</code> 错误.
		 */
		public static function toChineseNumber(origin:*):String
		{
			if(!(origin is Number || origin is int || origin is uint || origin is String) || origin == null)
			{
				throw new ArgumentError("参数\"origin\"只能是下面的类型：Number、int、uint、String！");
			}
			var result:String,
			regular:Array = [/0/g, /1/g, /2/g, /3/g, /4/g, /5/g, /6/g, /7/g, /8/g, /9/g, /\./g, /-/g];
			if(origin is Number || origin is int || origin is uint)
			{
				result = Number(origin).toString();
			}
			else
			{
				result = origin;
			}
			for(var i:int = 0; i < 12; i++)
			{
				result = result.replace(regular[i], CHINESE_NUMBER[i]);
			}
			return result;
		}
		
		/**
		 * 格式化一个指定的字节大小为带有单位的尺寸字符串.
		 * <p><code>int</code> 类型最多可以记录的尺寸为 2GB, <code>uint</code> 类型最多可以记录的尺寸为 4GB, <code>Number</code> 类型最多可以记录的尺寸为 8EB</p>
		 * @param size 需要格式化的大小 (会去掉小数部分), 单位为字节, 该参数会被取绝对值.
		 * @param decimals 结果需要保留的小数数位 (最多 20 位).
		 * @param filled 是否补齐保留的小数数位.
		 * @param units 使用的单位字符串, 最多可设置 7 个, 使用 "," 号分隔.
		 * @return 格式化后的字符串.
		 * @example
		 * <listing version="3.0">
		 * //输出 "529MB"
		 * trace(NumberUtil.sizeFormat(568545212536));
		 * //输出 "529.49899MB"
		 * trace(NumberUtil.sizeFormat(568545212536, 5));
		 * //输出 "529.49899112433200000000MB"
		 * trace(NumberUtil.sizeFormat(568545212536, 20, true));
		 * //输出 "529.49899112433200000000兆字节"
		 * trace(NumberUtil.sizeFormat(568545212536, 20, true, "字节,千字节,兆字节,吉字节,太字节"));
		 * </listing>
		 */
		public static function sizeFormat(size:Number, decimals:uint = 0, filled:Boolean = false, units:String = "Byte,KB,MB,GB,TB,PB,EB"):String
		{
			size = Math.floor(size);
			size = Math.abs(size);
			decimals = decimals > 20 ? 20 : decimals;
			var defaultUnits:Array = ["Byte","KB","MB","GB","TB","PB","EB"],
			customUnits:Array = units.split(","),
			i:int = 0,
			integer:Number,
			decimal:Number,
			result:String = "";
			for(i = customUnits.length; i < 7; i++)
			{
				customUnits.push(defaultUnits[i]);
			}
			/*
			 * 将结果进行拆分，变成整数部分和小数部分，这样可以解决 
			 * Math.ceil(n*100000000)/100000000 方法导致的大数越界从而结果不正确的
			 * 问题
			 */
			for(i = 5; i > -1; i--)
			{
				if(size >= BASE_SIZE[i])
				{
					size /= BASE_SIZE[i];
					integer = Math.floor(size);
					decimal = size - integer;
					break;
				}
			}
			if(i == -1)
			{
				integer = size;
				decimal = 0;
			}
			result = integer.toString();
			if(decimals > 0)
			{
				result += decimal.toString().substr(1, decimals + 1);
				result = Number(result).toString();
			}
			if(filled)
			{
				if(result.indexOf(".") == -1)
				{
					result += "." + "00000000000000000000".substr(0, decimals);
				}
				else
				{
					result += "00000000000000000000".substr(0, decimals - ((result.length - 1) - result.indexOf(".")));
				}
			}
			return result + customUnits[i + 1];
		}
		
		/**
		 * 获取一个数字相对于另一个数字的百分比.
		 * @param number1 分子.
		 * @param number2 分母.
		 * @param decimals 结果需要保留的小数数位 (最多 20 位).
		 * @param filled 是否补齐保留的小数数位.
		 * @param showSymbol 是否显示百分号 (%).
		 * @return 格式化后的字符串.
		 */
		public static function percentageFormat(number1:Number, number2:Number, decimals:uint = 0, filled:Boolean = false, showSymbol:Boolean = true):String
		{
			number1 = Math.abs(number1);
			number2 = Math.abs(number2);
			decimals = decimals > 20 ? 20 : decimals;
			var number:Number = number1 / number2 * 100,
			integer:Number,
			decimal:Number,
			result:String = "";
			integer = Math.floor(number);
			decimal = number - integer;
			result = integer.toString();
			if(decimals > 0)
			{
				result += decimal.toString().substr(1, decimals + 1);
				result = Number(result).toString();
			}
			if(filled)
			{
				if(result.indexOf(".") == -1)
				{
					result += "." + "00000000000000000000".substr(0, decimals);
				}
				else
				{
					result += "00000000000000000000".substr(0, decimals - ((result.length - 1) - result.indexOf(".")));
				}
			}
			if(showSymbol)
			{
				result += "%";
			}
			return result;
		}
	}
}
