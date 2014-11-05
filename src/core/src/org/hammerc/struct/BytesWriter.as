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
	import flash.utils.IDataOutput;
	
	import org.hammerc.utils.Int64;
	import org.hammerc.utils.UInt64;
	
	/**
	 * <code>BytesWriter</code> 类提供写入数据到字节流中的功能.
	 * @author wizardc
	 */
	public class BytesWriter
	{
		/**
		 * 写入一个布尔值.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeBoolean(output:IDataOutput, value:Boolean):void
		{
			output.writeByte(value ? 1 : 0);
		}
		
		/**
		 * 写入一个 8 位数字.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeByte(output:IDataOutput, value:int):void
		{
			output.writeByte(value);
		}
		
		/**
		 * 写入一个 16 位数字.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeShort(output:IDataOutput, value:int):void
		{
			output.writeShort(value);
		}
		
		/**
		 * 写入一个带符号 32 位数字.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeInt(output:IDataOutput, value:int):void
		{
			output.writeInt(value);
		}
		
		/**
		 * 写入一个无符号 32 位数字.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeUInt(output:IDataOutput, value:uint):void
		{
			output.writeUnsignedInt(value);
		}
		
		/**
		 * 写入一个带符号 64 位数字.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeLong(output:IDataOutput, value:Int64):void
		{
			Int64.writeInt64(output, value);
		}
		
		/**
		 * 写入一个无符号 64 位数字.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeULong(output:IDataOutput, value:UInt64):void
		{
			UInt64.writeUnsignedInt64(output, value);
		}
		
		/**
		 * 写入一个 32 位浮点数.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeFloat(output:IDataOutput, value:Number):void
		{
			output.writeFloat(value);
		}
		
		/**
		 * 写入一个 64 位浮点数.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeDouble(output:IDataOutput, value:Number):void
		{
			output.writeDouble(value);
		}
		
		/**
		 * 写入一个字符串.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeString(output:IDataOutput, value:String):void
		{
			output.writeUTF(value);
		}
		
		/**
		 * 写入一个字节数组.
		 * @param output 输出流对象.
		 * @param value 要写入的数据.
		 */
		public static function writeBytes(output:IDataOutput, value:ByteArray):void
		{
			value.position = 0;
			output.writeUnsignedInt(value.length);
			output.writeBytes(value);
		}
		
		/**
		 * 写入一个自定义数据.
		 * @param output 输出流对象.
		 * @param value 自定义数据.
		 */
		public static function writeStruct(output:IDataOutput, value:Struct):void
		{
			value.writeExternal(output);
		}
	}
}
