/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
 package org.hammerc.collections
{
	/**
	 * <code>IList</code> 接口定义了有序列表的通用方法.
	 * @author wizardc
	 */
	public interface IList extends IIterable
	{
		/**
		 * 获取当前列表的元素个数.
		 */
		function get length():int;
		
		/**
		 * 在列表尾部添加一个元素.
		 * @param item 要添加的元素.
		 * @return 当前列表的元素个数.
		 */
		function addItem(item:*):int;
		
		/**
		 * 在列表指定的索引处添加一个元素.
		 * @param item 要添加的元素.
		 * @param index 指定的索引.
		 * @return 当前列表的元素个数.
		 */
		function addItemAt(item:*, index:int):int;
		
		/**
		 * 将指定的列表添加到该列表之后.
		 * @param list 要被添加的列表.
		 * @return 当前列表的元素个数.
		 */
		function addAll(list:IList):int;
		
		/**
		 * 将指定的列表添加到该列表指定的索引处.
		 * @param list 要被添加的列表.
		 * @param index 指定的索引.
		 * @return 当前列表的元素个数.
		 */
		function addAllAt(list:IList, index:int):int;
		
		/**
		 * 判断列表是否包含指定的元素.
		 * @param item 用于判断的元素.
		 * @return 如果该列表包含指定的元素则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		function contains(item:*):Boolean;
		
		/**
		 * 判断列表是否包含指定列表的所有元素.
		 * @param list 用于判断的列表.
		 * @return 如果该列表包含指定列表的所有元素则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		function containsAll(list:IList):Boolean;
		
		/**
		 * 获取指定索引处的元素.
		 * @param index 要获取的元素的索引.
		 * @return 指定索引处的元素.
		 */
		function getItemAt(index:int):*;
		
		/**
		 * 在本列表中从头部查找指定的元素.
		 * @param item 需要查找的元素.
		 * @return 如果存在查找的元素则返回该元素位于本列表的索引, 如果不存在该元素则返回 -1.
		 */
		function indexOf(item:*):int;
		
		/**
		 * 在本列表中从尾部查找指定的元素.
		 * @param item 需要查找的元素.
		 * @return 如果存在查找的元素则返回该元素位于本列表的索引, 如果不存在该元素则返回 -1.
		 */
		function lastIndexOf(item:*):int;
		
		/**
		 * 用指定的元素替换列表中对应的元素.
		 * @param item 替换的元素.
		 * @param index 指定的索引.
		 * @return 被替换掉的元素.
		 */
		function setItemAt(item:*, index:int):*;
		
		/**
		 * 将此列表的部分元素区域取出.
		 * @param startIndex 开始的索引.
		 * @param endIndex 结束的索引.
		 * @return 包含本列表指定区域元素的新列表.
		 */
		function subList(startIndex:int = 0, endIndex:int = -1):IList;
		
		/**
		 * 移除掉指定的元素.
		 * @param index 要移除的元素.
		 * @return 被移除的元素.
		 */
		function removeItem(item:*):*;
		
		/**
		 * 移除掉指定索引处的元素.
		 * @param index 要移除的元素的索引.
		 * @return 被移除的元素.
		 */
		function removeItemAt(index:int):*;
		
		/**
		 * 从列表中移除参数 <code>list</code> 中包含的其所有元素.
		 * @param list 需要被移除的列表.
		 * @return 列表中被移除的元素.
		 */
		function removeAll(list:IList):Array;
		
		/**
		 * 仅在列表中保留指定列表中所包含的元素. 换句话说, 该方法从列表中移除未包含在指定列表中的所有元素.
		 * @param list 需要被保留的列表.
		 * @return 列表中被移除的元素.
		 */
		function retainAll(list:IList):Array;
		
		/**
		 * 移除列表中的所有元素.
		 */
		function clear():void;
		
		/**
		 * 获取当前的列表是否为空.
		 * @return 当前的列表是否为空.
		 */
		function isEmpty():Boolean;
		
		/**
		 * 将当前列表装换为对应的 <code>Array</code> 对象.
		 * @return 和当前列表对应的 <code>Array</code> 对象.
		 */
		function toArray():Array;
	}
}
