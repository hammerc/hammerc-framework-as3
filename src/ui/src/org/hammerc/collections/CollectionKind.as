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
	 * <code>CollectionKind</code> 类指示集合的更改类型.
	 * @author wizardc
	 */
	public class CollectionKind
	{
		/**
		 * 指示集合添加了一个或多个元素.
		 */
		public static const ADD:String = "add";
		
		/**
		 * 指示集合删除了一个或多个元素.
		 */
		public static const REMOVE:String = "remove";
		
		/**
		 * 指示指定的位置处的元素已被替换.
		 */
		public static const REPLACE:String = "replace";
		
		/**
		 * 指示元素位置进行了移动.
		 */
		public static const MOVE:String = "move";
		
		/**
		 * 指示集合应用了排序或筛选.
		 */
		public static const REFRESH:String = "refresh";
		
		/**
		 * 指示集合中一个或多个元素进行了更新.
		 */
		public static const UPDATE:String = "update";
		
		/**
		 * 指示集合已彻底更改, 需要进行重置.
		 */
		public static const RESET:String = "reset";
		
		/**
		 * 指示集合中某个节点的子项列表已打开.
		 */
		public static const OPEN:String = "open";
		
		/**
		 * 指示集合中某个节点的子项列表已关闭.
		 */
		public static const CLOSE:String = "close";
	}
}
