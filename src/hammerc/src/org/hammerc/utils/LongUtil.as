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
	import flash.utils.ByteArray;
	
	/**
	 * <code>LongUtil</code> 用来在字节数组中读取和写入 Long 类型的数据.
	 * 注意: AS3 中 Number 数据类型最多只可使用 53 位来表示整数.
	 * @author wizardc
	 */
	public class LongUtil
	{
		/**
		 * 2 的 32 次方的常量.
		 */
		public static const MAX_UINT:Number = Math.pow(2, 32);
		
		/**
		 * 读取一个 Long 类型数据, 8 个字节.
		 * @param bytes 需要读取的字节数组.
		 * @return 取出的长整形数据.
		 */
		public static function readLong(bytes:ByteArray):Number
		{
			var highInt:uint = bytes.readUnsignedInt();
			var lowInt:uint = bytes.readUnsignedInt();
			return highInt * MAX_UINT + lowInt;
		}
		
		/**
		 * 向指定的字节数组中写入一个长整形数据, 8 个字节.
		 * @param bytes 需要被写入数据的字节数组.
		 * @param value 需要写入的数据.
		 */
		public static function writeLong(bytes:ByteArray, value:Number):void
		{
			bytes.writeUnsignedInt(Math.floor(value / MAX_UINT));
			bytes.writeUnsignedInt(value % MAX_UINT);
		}
	}
}
