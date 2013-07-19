/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	/**
	 * <code>BitUtil</code> 类提供对比特 (bit) 的各种处理.
	 * @author wizardc
	 */
	public class BitUtil
	{
		/**
		 * 设置指定位为高位还是低位, 本方法使用 32 位数据.
		 * @param target 要设置的数据.
		 * @param position 指定的位的位置, 从低位开始, 范围为 [0-32).
		 * @param value 设置为高位 (<code>true</code>) 还是低位 (<code>false</code>).
		 * @return 设置后的数据.
		 * @throws ArgumentError 参数 <code>position</code> 的数值不正确时抛出该异常.
		 */
		public static function setBit32(target:uint, position:int, value:Boolean):uint
		{
			validPosition(position);
			if(value)
			{
				target |= 1 << position;
			}
			else
			{
				target &= ~(1 << position);
			}
			return target;
		}
		
		/**
		 * 获取指定位为高位还是低位, 本方法使用 32 位数据.
		 * @param target 要设置的数据.
		 * @param position 指定的位的位置, 从低位开始, 范围为 [0-32).
		 * @return 指定的位是高位 (<code>true</code>) 还是低位 (<code>false</code>).
		 * @throws ArgumentError 参数 <code>position</code> 的数值不正确时抛出该异常.
		 */
		public static function getBit32(target:uint, position:int):Boolean
		{
			validPosition(position);
			return target == (target | (1 << position));
		}
		
		/**
		 * 交换指定位的高低位, 本方法使用 32 位数据.
		 * @param target 要设置的数据.
		 * @param position 指定的位的位置, 从低位开始, 范围为 [0-32).
		 * @return 设置后的数据.
		 * @throws ArgumentError 参数 <code>position</code> 的数值不正确时抛出该异常.
		 */
		public static function switchBit32(target:uint, position:int):uint
		{
			validPosition(position);
			target ^= 1 << position;
			return target;
		}
		
		/**
		 * 设置指定位为高位还是低位, 本方法使用 64 位数据.
		 * @param target 要设置的数据.
		 * @param position 指定的位的位置, 从低位开始, 范围为 [0-64).
		 * @param value 设置为高位 (<code>true</code>) 还是低位 (<code>false</code>).
		 * @return 设置后的数据.
		 * @throws ArgumentError 参数 <code>position</code> 的数值不正确时抛出该异常.
		 */
		public static function setBit64(target:Number, position:int, value:Boolean):Number
		{
			validPosition(position, false);
			if(value)
			{
				target |= 1 << position;
			}
			else
			{
				target &= ~(1 << position);
			}
			return target;
		}
		
		/**
		 * 获取指定位为高位还是低位, 本方法使用 64 位数据.
		 * @param target 要设置的数据.
		 * @param position 指定的位的位置, 从低位开始, 范围为 [0-64).
		 * @return 指定的位是高位 (<code>true</code>) 还是低位 (<code>false</code>).
		 * @throws ArgumentError 参数 <code>position</code> 的数值不正确时抛出该异常.
		 */
		public static function getBit64(target:Number, position:int):Boolean
		{
			validPosition(position, false);
			return target == (target | (1 << position));
		}
		
		/**
		 * 交换指定位的高低位, 本方法使用 64 位数据.
		 * @param target 要设置的数据.
		 * @param position 指定的位的位置, 从低位开始, 范围为 [0-64).
		 * @return 设置后的数据.
		 * @throws ArgumentError 参数 <code>position</code> 的数值不正确时抛出该异常.
		 */
		public static function switchBit64(target:Number, position:int):Number
		{
			validPosition(position, false);
			target ^= 1 << position;
			return target;
		}
		
		private static function validPosition(position:int, bit32:Boolean = true):void
		{
			var maxNum:int = bit32 ? 32 : 64;
			if(position < 0 || position >= maxNum)
			{
				throw new ArgumentError("参数\"position\"的数据无效，设置为" + position + "无效！");
			}
		}
	}
}
