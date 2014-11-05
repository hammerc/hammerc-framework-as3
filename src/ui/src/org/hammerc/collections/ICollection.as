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
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>ICollection</code> 接口定义了集合类数据源对象的接口.
	 * @author wizardc
	 */
	public interface ICollection extends IEventDispatcher
	{
		/**
		 * 获取当前列表的元素个数, 0 表示不包含项目, 而 -1 表示长度未知.
		 */
		function get length():int;
		
		/**
		 * 获取指定索引处的元素.
		 * @param index 要获取的元素的索引.
		 * @return 指定索引处的元素.
		 */
		function getItemAt(index:int):Object;
		
		/**
		 * 在本列表中从头部查找指定的元素.
		 * @param item 需要查找的元素.
		 * @return 如果存在查找的元素则返回该元素位于本列表的索引, 如果不存在该元素则返回 -1.
		 */
		function getItemIndex(item:Object):int;
	}
}
