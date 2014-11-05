// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.collections
{
	/**
	 * <code>IMap</code> 接口定义了散列集合的方法.
	 * @author wizardc
	 */
	public interface IMap
	{
		/**
		 * 将一个指定值与指定键进行关联, 如果该键已有值进行关联则用当前的新值覆盖旧值.
		 * @param key 指定的键对象.
		 * @param value 指定的值对象.
		 * @return 值对象.
		 */
		function put(key:*, value:*):*;
		
		/**
		 * 根据指定键获取该键对应的值对象, 如果没有对应的键对象将返回 <code>null</code>.
		 * @param key 指定的键.
		 * @return 该键对应的值对象.
		 */
		function get(key:*):*;
		
		/**
		 * 移除一个指定键及其映射的值对象.
		 * @param key 要被移除的指定键.
		 * @return 其映射的值对象.
		 */
		function remove(key:*):*;
		
		/**
		 * 清除该哈希表的内部所有映射关系.
		 */
		function clear():void;
	}
}
