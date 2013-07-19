/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.utils.ByteArray;
	
	/**
	 * <code>CRC32</code> 类实现了 Cyclic Redundancy Check 循环冗余检验算法, 提供基于数据计算一组效验码, 用于核对数据传输过程中是否被更改或传输错误的功能.
	 * @author wizardc
	 */
	public class CRC32
	{
		/**
		 * 记录下有用的所有信息, 实际计算时可加快算法速度.
		 */
		private static var _crcTable:Array = makeCrcTable();
		
		/**
		 * 使用查表法, 计算出需要的数据.
		 * @return 预先计算出的需要的数据.
		 */
		private static function makeCrcTable():Array
		{
			var crcTable:Array = new Array(256);
			for(var n:int = 0; n < 256; n++)
			{
				var c:uint = n;
				for(var k:int = 8; --k >= 0;)
				{
					if((c & 1) != 0)
					{
						c = 0xedb88320 ^ (c >>> 1);
					}
					else
					{
						c = c >>> 1;
					}
				}
				crcTable[n] = c;
			}
			return crcTable;
		}
		
		/**
		 * 计算指定字节数组的效验码, 相同的字节数组获取的效验码一致, 否则说明字节数组被更改.
		 * @param bytes 要计算的字节数组.
		 * @return 对应的效验码.
		 */
		public static function getCRC32(bytes:ByteArray):uint
		{
			var crc:uint = 0;
			var off:uint = 0;
			var len:uint = bytes.length;
			var c:uint = ~crc;
			while(--len >= 0)
			{
				c = _crcTable[(c ^ bytes[off++]) & 0xff] ^ (c >>> 8);
			}
			crc = ~c;
			return crc & 0xffffffff;
		}
	}
}
