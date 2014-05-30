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
		private static var _crcTable:Array = initCRCTable();
		
		/**
		 * 使用查表法, 计算出需要的数据.
		 * @return 预先计算出的需要的数据.
		 */
		private static function initCRCTable():Array
		{
			var crcTable:Array = new Array(256);
			for(var i:int = 0; i < 256; i++)
			{
				var crc:uint = i;
				for(var j:int = 0; j < 8; j++)
				{
					crc = (crc & 1) ? (crc >>> 1) ^ 0xEDB88320 : (crc >>> 1);
				}
				crcTable[i] = crc;
			}
			return crcTable;
		}
		
		private var _crc32:uint;
		
		/**
		 * 创建一个 <code>CRC32</code> 对象.
		 */
		public function CRC32()
		{
		}
		
		/**
		 * 获取校验码.
		 */
		public function get value():uint
		{
			return _crc32 & 0xFFFFFFFF;
		}
		
		/**
		 * 计算指定字节数组的效验码, 相同的字节数组获取的效验码一致, 否则说明字节数组被更改.
		 * @param buffer 要计算的字节数组.
		 * @param offset 处理的偏移量.
		 * @param length 处理的长度.
		 */
		public function update(buffer:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			offset = offset != 0 ? offset : 0;
			length = length != 0 ? length : buffer.length;
			var crc:uint = ~_crc32;
			for(var i:int = offset; i < length; i++)
			{
				crc = _crcTable[(crc ^ buffer[i]) & 0xFF] ^ (crc >>> 8);
			}
			_crc32 = ~crc;
		}
		
		/**
		 * 重置校验码.
		 */
		public function reset():void
		{
			_crc32 = 0;
		}
	}
}
