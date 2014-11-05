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
	import flash.utils.Dictionary;
	
	/**
	 * <code>ArrayUtil</code> 类提供对数组的各种处理.
	 * @author wizardc
	 */
	public class ArrayUtil
	{
		/**
		 * 对指定数组中的每一项元素都进行指定的操作.
		 * @param array 要被操作的元素.
		 * @param operation 进行操作的方法, 接收两个参数, 第一个为该数组的元素, 第二个为该元素位于数组中的索引.
		 */
		public static function each(array:Array, operation:Function):void
		{
			for(var i:int = 0, len:uint = array.length; i < len; i++)
			{
				operation.call(null, array[i], i);
			}
		}
		
		/**
		 * 对数组进行浅复制.
		 * @param array 要被复制的数组.
		 * @return 返回一个新数组, 该数组内部的元素都拥有一个指向原数组元素的引用.
		 */
		public static function simpleClone(array:Array):Array
		{
			if(array != null)
			{
				return array.concat();
			}
			return null;
		}
		
		/**
		 * 对数组进行深复制.
		 * @param array 要被复制的数组.
		 * @return 返回一个新数组, 该数组内部的元素都拥有一个独立于原数组元素的对象.
		 */
		public static function deepClone(array:Array):Array
		{
			if(array != null)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(array);
				bytes.position = 0;
				return bytes.readObject();
			}
			return null;
		}
		
		/**
		 * 将一个数组中的元素都添加到另一个数组中去, 该方法会返回一个新的数组.
		 * @param array 需要被添加的数组.
		 * @param spliceArray 要添加的数组.
		 * @param index 要添加的索引, 负数和超过被添加数组的长度时都会添加到该数组的最后.
		 * @return 拼接好的数组.
		 */
		public static function spliceArray(array:Array, spliceArray:Array, index:int = -1):Array
		{
			if(array != null && spliceArray != null)
			{
				if(index < 0 || index > array.length)
				{
					return array.concat(spliceArray);
				}
				var result:Array = simpleClone(array);
				var behind:Array = result.splice(index, result.length - index);
				result = result.concat(spliceArray);
				result = result.concat(behind);
				return result;
			}
			return array;
		}
		
		/**
		 * 搜索数组中的项, 判断项指定的键的值是否相等, 并返回项的索引位置.
		 * @param array 需要搜索的数组.
		 * @param key 用于对比的键.
		 * @param value 用于对比的值.
		 * @param index 数组中的位置, 从该位置开始搜索项.
		 * @return 数组项的索引位置(从 0 开始). 如果未找到则返回值为 -1.
		 * @throws ArgumentError 当参数 <code>array</code> 为 <code>null</code> 时会抛出该异常.
		 */
		public static function dynamicIndexOf(array:Array, key:String, value:*, index:int = 0):int
		{
			if(array == null)
			{
				throw new ArgumentError("参数\"array\"不能为空！");
			}
			for(var i:int = index, len:uint = array.length; i < len; i++)
			{
				if(array[i][key] == value)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 从最后一项开始向前搜索数组中的项, 判断项的动态属性是否相等, 并返回项的索引位置.
		 * @param array 需要搜索的数组.
		 * @param key 用于对比的键.
		 * @param value 用于对比的值.
		 * @param index 数组中的位置, 从该位置开始向前搜索项. 默认为允许的最大索引值. 如果不指定将从数组中的最后一项开始进行搜索.
		 * @return 数组项的索引位置(从 0 开始). 如果未找到则返回值为 -1.
		 * @throws ArgumentError 当参数 <code>array</code> 为 <code>null</code> 时会抛出该异常.
		 */
		public static function dynamicLastIndexOf(array:Array, key:String, value:*, index:int = 0x7fffffff):int
		{
			if(array == null)
			{
				throw new ArgumentError("参数\"array\"不能为空！");
			}
			for(var i:int = index > array.length-1 ? array.length - 1 : index; i > -1; i--)
			{
				if(array[i][key] == value)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 交换数组中两个索引上的元素位置.
		 * @param array 要进行操作的数组.
		 * @param index1 数组的索引1.
		 * @param index2 数组的索引2.
		 */
		public static function exchange(array:Array, index1:int, index2:int):void
		{
			var element:* = array[index1];
			array[index1] = array[index2];
			array[index2] = element;
		}
		
		/**
		 * 打乱一个数组, 使其中的元素随机排列, 该方法会返回一个打乱了的数组副本, 而不对源数组进行更改.
		 * @param array 要被打乱的数组.
		 * @return 一个副本, 已经被随机打乱的数组.
		 * @throws ArgumentError 要打乱的数组为空时抛出该异常.
		 */
		public static function upset(array:Array):Array
		{
			if(array == null)
			{
				throw new ArgumentError("参数\"array\"不能为空！");
			}
			var result:Array = new Array(), temp:Array = simpleClone(array), upsetIndex:int;
			for(var i:int = 0, len:uint = temp.length; i < len; i++)
			{
				upsetIndex = int(Math.random() * temp.length);
				result.push(temp.splice(upsetIndex, 1)[0]);
			}
			return result;
		}
		
		/**
		 * 将两个数组中的相同项取出.
		 * @param array1 第一个数组.
		 * @param array2 第二个数组.
		 * @return 返回两个数组中都存在的相同项.
		 */
		public static function same(array1:Array, array2:Array):Array
		{
			var result:Array = new Array();
			for each(var value:* in array1)
			{
				if(array2.indexOf(value) != -1 && result.indexOf(value) == -1)
				{
					result.push(value);
				}
			}
			return result;
		}
		
		/**
		 * 将两个数组中的相同项取出, 本方法针对大量数据查找进行过效率优化.
		 * @param array1 第一个数组.
		 * @param array2 第二个数组.
		 * @return 返回两个数组中都存在的相同项.
		 */
		public static function sameWithinBigData(array1:Array, array2:Array):Array
		{
			var result:Array = new Array();
			var hashmap:Dictionary = new Dictionary();
			for each(var value:* in array1)
			{
				hashmap[value] = true;
			}
			for each(value in array2)
			{
				if(hashmap.hasOwnProperty(value))
				{
					result.push(value);
					delete hashmap[value];
				}
			}
			return result;
		}
	}
}
