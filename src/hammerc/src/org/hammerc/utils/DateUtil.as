/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	/**
	 * <code>DateUtil</code> 类提供对日期和时间的各种基本操作和格式化操作.
	 * @author wizardc
	 */
	public class DateUtil
	{
		/**
		 * 英文月份表.
		 */
		public static const MONTHS:Array = ["January", "February", "March", "May", "June", "July", "August", "September", "October", "November", "December"];
		
		/**
		 * 英文星期表.
		 */
		public static const WEEKS:Array = ["Sunday", "Monday", "TuesDay", "Wednesday", "Thursday", "Friday", "Saturday"];
		
		/**
		 * 中文星期表.
		 */
		public static const CHINESE_WEEKS:Array = ["日", "一", "二", "三", "四", "五", "六"];
		
		/**
		 * 将一个时间戳转化为日期对象.
		 * @param time 自 1970 年 1 月 1 日午夜以来的豪秒数.
		 * @return 对应的日期对象.
		 */
		public static function numberToDate(timeStamp:Number):Date
		{
			var date:Date = new Date();
			date.setTime(timeStamp);
			return date;
		}
		
		/**
		 * 将一个 <code>Date</code> 对象格式化为一个指定类型的字符串.
		 * @param date 需要转换的日期对象.
		 * @param format 转换后的格式.
		 * <p>
		 * 支持的替换标签有:
		 * <ul>
		 * <li>年: YYYY YY;</li>
		 * <li>月: MMMM MMM MM M (MM 用数字替换[如: 03], MMM 用字符替换[如：Mar]);</li>
		 * <li>日: DD D;</li>
		 * <li>星期: EEEE EEE EE (EE 为中文[如: 一], EEE 用字符替换[如: Wed]);</li>
		 * <li>上午下午: A (输出 am 或 pm);</li>
		 * <li>上午下午: C (输出 上午 或 下午);</li>
		 * <li>时: LL L (12小时制时间, 通常和 A 标签搭配);</li>
		 * <li>时: HH H;</li>
		 * <li>分: NN N;</li>
		 * <li>秒：SS S;</li>
		 * </ul>
		 * </p>
		 * @return 对应该日期对象的格式化字符串.
		 * @throws ArgumentError 参数 <code>date</code> 为空时抛出该异常.
		 */
		public static function dateFormat(date:Date, format:String = "YYYY-MM-DD HH:NN:SS"):String
		{
			if(date == null)
			{
				throw new ArgumentError("参数\"date\"不能为空！");
			}
			var result:String = "",
			year:String = date.getFullYear().toString(),
			month:Number = date.getMonth() + 1,
			fullMonth:String = month < 9 ? "0" + month : month.toString(),
			day:Number = date.getDate(),
			fullDay:String = day < 9 ? "0" + day : day.toString(),
			week:Number = date.getDay(),
			hour:Number = date.getHours(),
			fullHour:String = hour < 9 ? "0" + hour : hour.toString(),
			hourL:Number = hour % 12,
			fullHourL:String = hourL < 9 ? "0" + hourL : hourL.toString(),
			minute:Number = date.getMinutes(),
			fullMinute:String = minute < 9 ? "0" + minute : minute.toString(),
			second:Number = date.getSeconds(),
			fullSecond:String = second < 9 ? "0" + second : second.toString();
			result = format;
			result = result.replace(/YYYY/g, year);
			result = result.replace(/YY/g, year.slice(-2));
			result = result.replace(/MMMM/g, MONTHS[month]);
			result = result.replace(/MMM/g, String(MONTHS[month]).substr(0, 3));
			result = result.replace(/MM/g, fullMonth);
			result = result.replace(/M/g, month);
			result = result.replace(/DD/g, fullDay);
			result = result.replace(/D/g, day);
			result = result.replace(/EEEE/g, WEEKS[week]);
			result = result.replace(/EEE/g, String(WEEKS[week]).substr(0, 3));
			result = result.replace(/EE/g, CHINESE_WEEKS[week]);
			result = result.replace(/A/g, hour < 12 ? "am" : "pm");
			result = result.replace(/C/g, hour < 12 ? "上午" : "下午");
			result = result.replace(/LL/g, fullHourL);
			result = result.replace(/L/g, hourL);
			result = result.replace(/HH/g, fullHour);
			result = result.replace(/H/g, hour);
			result = result.replace(/NN/g, fullMinute);
			result = result.replace(/N/g, minute);
			result = result.replace(/SS/g, fullSecond);
			result = result.replace(/S/g, second);
			return result;
		}
		
		/**
		 * 格式化一个数字为一个时间数, 用于播放器或计时器.
		 * @param time 需要格式化的秒数 (单位秒).
		 * @param format 转换后的格式.
		 * @return 格式化后的字符串.
		 */
		public static function timeFormat(time:uint, format:String = "D:HH:NN:SS"):String
		{
			var result:String = "",
			day:int = int(time / 86400),
			hour:int = int(time / 3600) % 24,
			fullHour:String = hour < 9 ? "0" + hour : hour.toString(),
			minute:int = int(time % 3600 / 60),
			fullMinute:String = minute < 9 ? "0" + minute : minute.toString(),
			second:int = int(time % 60),
			fullSecond:String = second < 9 ? "0" + second : second.toString();
			result = format;
			result = result.replace(/D/g, day);
			result = result.replace(/HH/g, fullHour);
			result = result.replace(/H/g, hour);
			result = result.replace(/NN/g, fullMinute);
			result = result.replace(/N/g, minute);
			result = result.replace(/SS/g, fullSecond);
			result = result.replace(/S/g, second);
			return result;
		}
		
		/**
		 * 比较两个时间的差值.
		 * @param date1 需要比较的时间 1.
		 * @param date2 需要比较的时间 2.
		 * @return 两个时间的间隔, 单位为毫秒.
		 * @throws ArgumentError 参数 <code>date1</code> 或 <code>date2</code> 为空时抛出该异常.
		 */
		public static function compareDate(date1:Date, date2:Date):Number
		{
			if(date1 == null || date2 == null)
			{
				throw new ArgumentError("日期类型的参数不能为空！");
			}
			else
			{
				return Math.abs(date1.getTime() - date2.getTime());
			}
		}
	}
}
