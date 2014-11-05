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
	 * <code>ITreeCollection</code> 接口定义了支持内部修改事件有序列表的通用方法.
	 * @author wizardc
	 */
	public interface ITreeCollection extends ICollection
	{
		/**
		 * 检查指定的节点是否含有子节点.
		 * @param item 要检查的节点.
		 * @return 指定的节点是否含有子节点.
		 */
		function hasChildren(item:Object):Boolean;
		
		/**
		 * 检查指定的节点是否打开.
		 * @param item 要检查的节点.
		 * @return 指定的节点是否打开.
		 */
		function isItemOpen(item:Object):Boolean;
		
		/**
		 * 打开或关闭一个节点.
		 * @param item 要打开或关闭的节点.
		 * @param open 师傅为打开该节点, 否则关闭该节点.
		 */
		function expandItem(item:Object, open:Boolean=true):void;
		
		/**
		 * 获取节点的深度.
		 * @param item 要获取的节点.
		 * @return 节点的深度.
		 */
		function getDepth(item:Object):int;
	}
}
