/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	/**
	 * <code>Int64</code> 类提供 64 位带符号整型数字的支持.
	 * <p>注意: 本类仅有记录数字的功能, 不支持运算.</p>
	 * @author wizardc
	 */
	public class Int64
	{
		/**
		 * 该常量表示数字 -1.
		 */
		public static const NEG_ONE:Int64 = new Int64(uint.MAX_VALUE, uint.MAX_VALUE);
		
		/**
		 * 该常量表示数字 0.
		 */
		public static const ZERO:Int64 = new Int64();
		
		/**
		 * 该常量表示数字 1.
		 */
		public static const ONE:Int64 = new Int64(1);
		
		/**
		 * 该常量表示 <code>Int64</code> 数字的最小值.
		 */
		public static const MIN_VALUE:Int64 = new Int64(0, 0x80000000);
		
		/**
		 * 该常量表示 <code>Int64</code> 数字的最大值.
		 */
		public static const MAX_VALUE:Int64 = new Int64(uint.MAX_VALUE, 0x7fffffff);
		
		/**
		 * 从字节流中读取一个 64 位的带符号整数, 会读取 8 个字节.
		 * @param input 要读取的字节流.
		 * @return 64 位的带符号整数.
		 */
		public static function readInt64(input:IDataInput):Int64
		{
			var low:uint;
			var high:uint;
			if(input.endian == Endian.LITTLE_ENDIAN)
			{
				low = input.readUnsignedInt();
				high = input.readUnsignedInt();
			}
			else
			{
				high = input.readUnsignedInt();
				low = input.readUnsignedInt();
			}
			return new Int64(low, high);
		}
		
		/**
		 * 向字节流写入一个 64 位的带符号整数, 会写入 8 个字节.
		 * @param output 要写入的字节流.
		 * @param value 要写入的 64 位的带符号整数.
		 */
		public static function writeInt64(output:IDataOutput, value:Int64):void
		{
			if(output.endian == Endian.LITTLE_ENDIAN)
			{
				output.writeUnsignedInt(value.low);
				output.writeUnsignedInt(value.high);
			}
			else
			{
				output.writeUnsignedInt(value.high);
				output.writeUnsignedInt(value.low);
			}
		}
		
		/**
		 * 解析字符串为 64 位的带符号整数.
		 * @param value 待解析的字符串.
		 * @param radix 表示要分析的数字的基数 (基) 的整数.
		 * @return 64 位的带符号整数.
		 */
		public static function parseInt64(value:String, radix:uint = 10):Int64
		{
			value = value.toLowerCase();
			//获取是否为负数
			var negative:Boolean = value.indexOf("-") == 0;
			//去掉负号
			if(negative)
			{
				value = value.substr(1);
			}
			//转换为数字
			const div:Number = 4294967296;
			var low:Number = 0;
			var high:Number = 0;
			for(var i:int = 0; i < value.length; i++)
			{
				var num:int = value.charCodeAt(i) - 48;
				if(num > 9)
				{
					num -= 39;
				}
				low = low * radix + num;
				high = high * radix + int(low / div);
				low = low % div;
			}
			//负数需要进行补码
			if(negative)
			{
				//取反
				low = ~low;
				high = ~high;
				//加 1
				if(low == uint.MAX_VALUE)
				{
					++high;
				}
				++low;
			}
			return new Int64(low, high);
		}
		
		private var _low:uint;
		private var _high:uint;
		
		/**
		 * 创建一个 <code>Int64</code> 对象.
		 * @param low 低位数字.
		 * @param high 高位数字.
		 */
		public function Int64(low:uint = 0, high:uint = 0)
		{
			_low = low;
			_high = high;
		}
		
		/**
		 * 设置或获取低位数字.
		 */
		public function set low(value:uint):void
		{
			_low = value;
		}
		public function get low():uint
		{
			return _low;
		}
		
		/**
		 * 设置或获取高位数字.
		 */
		public function set high(value:uint):void
		{
			_high = value;
		}
		public function get high():uint
		{
			return _high;
		}
		
		/**
		 * 判断是否和指定的数字相同.
		 * @param value 需要判断的数字.
		 * @return 两个数字大小是否相同.
		 */
		public function equals(value:Int64):Boolean
		{
			if(value == null)
			{
				return false;
			}
			return (value.low == this.low) && (value.high == this.high);
		}
		
		/**
		 * 将该数字转换为一个字节数组.
		 * @param endian 字节顺序.
		 * @return 对应的字节数组.
		 */
		public function toByteArray(endian:String = "littleEndian"):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.endian = endian;
			if(bytes.endian == Endian.LITTLE_ENDIAN)
			{
				bytes.writeUnsignedInt(_low);
				bytes.writeUnsignedInt(_high);
			}
			else
			{
				bytes.writeUnsignedInt(_high);
				bytes.writeUnsignedInt(_low);
			}
			return bytes;
		}
		
		/**
		 * 获取本对象的字符串表示形式.
		 * @param radix 指定要用于数字到字符串的转换的基数.
		 * @return 本对象的字符串表示形式.
		 */
		public function toString(radix:uint = 10):String
		{
			if(radix < 2 || radix > 36)
			{
				throw new RangeError("基数必须介于2到36之间，当前为" + radix + "！");
			}
			var result:String = "";
			var lowUint:uint = _low;
			var highUint:uint = _high;
			//获取是否为负数, 不包括 0
			var temp:uint = highUint | (1 << 31);
			var negative:Boolean = (highUint == temp);
			//负数需要进行补码
			if(negative)
			{
				//减 1
				if(lowUint == 0)
				{
					--highUint;
				}
				--lowUint;
				//取反
				lowUint = ~lowUint;
				highUint = ~highUint;
			}
			//序列化
			var highRemain:Number;
			var lowRemain:Number;
			var tempNum:Number;
			const maxLowUint:Number = 4294967296;
			while(highUint != 0 || lowUint != 0)
			{
				highRemain = highUint % radix;
				tempNum = highRemain * maxLowUint + lowUint;
				lowRemain = tempNum % radix;
				result = lowRemain.toString(radix) + result;
				highUint = (highUint - highRemain) / radix;
				lowUint = (tempNum - lowRemain) / radix;
			}
			//添加负号
			if(negative)
			{
				result = "-" + result;
			}
			return result;
		}
		
		/**
		 * 复制本对象的副本.
		 * @return 与本对象一致的副本.
		 */
		public function clone():Int64
		{
			return new Int64(_low, _high);
		}
	}
}
