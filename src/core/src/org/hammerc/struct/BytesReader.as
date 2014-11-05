// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.struct
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.hammerc.utils.Int64;
	import org.hammerc.utils.UInt64;
	
	/**
	 * <code>BytesReader</code> 类提供从字节流中读取数据的功能.
	 * @author wizardc
	 */
	public class BytesReader
	{
		/**
		 * 读取一个布尔值.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readBoolean(input:IDataInput):Boolean
		{
			return input.readByte() != 0;
		}
		
		/**
		 * 读取一个带符号 8 位数字.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readByte(input:IDataInput):int
		{
			return input.readByte();
		}
		
		/**
		 * 读取一个无符号 8 位数字.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readUByte(input:IDataInput):uint
		{
			return input.readUnsignedByte();
		}
		
		/**
		 * 读取一个带符号 16 位数字.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readShort(input:IDataInput):int
		{
			return input.readShort();
		}
		
		/**
		 * 读取一个无符号 16 位数字.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readUShort(input:IDataInput):uint
		{
			return input.readUnsignedShort();
		}
		
		/**
		 * 读取一个带符号 32 位数字.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readInt(input:IDataInput):int
		{
			return input.readInt();
		}
		
		/**
		 * 读取一个无符号 32 位数字.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readUInt(input:IDataInput):uint
		{
			return input.readUnsignedInt();
		}
		
		/**
		 * 读取一个带符号 64 位数字.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readLong(input:IDataInput):Int64
		{
			return Int64.readInt64(input);
		}
		
		/**
		 * 读取一个无符号 64 位数字.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readULong(input:IDataInput):UInt64
		{
			return UInt64.readUnsignedInt64(input);
		}
		
		/**
		 * 读取一个 32 位浮点数.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readFloat(input:IDataInput):Number
		{
			return input.readFloat();
		}
		
		/**
		 * 读取一个 64 位浮点数.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readDouble(input:IDataInput):Number
		{
			return input.readDouble();
		}
		
		/**
		 * 读取一个字符串.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readString(input:IDataInput):String
		{
			return input.readUTF();
		}
		
		/**
		 * 读取一个字节数组.
		 * @param input 输入流对象.
		 * @return 对应的数据.
		 */
		public static function readBytes(input:IDataInput):ByteArray
		{
			var len:uint = input.readUnsignedInt();
			var bytes:ByteArray = new ByteArray();
			input.readBytes(bytes, 0, len);
			return bytes;
		}
		
		/**
		 * 读取一个自定义数据.
		 * @param input 输入流对象.
		 * @param structClass 自定义数据类.
		 * @return 自定义数据.
		 */
		public static function readStruct(input:IDataInput, structClass:Class):Struct
		{
			var target:Struct = new structClass() as Struct;
			target.readExternal(input);
			return target;
		}
	}
}
