/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.collections
{
	/**
	 * <code>ListNode</code> 类提供了一个列表元素节点的实现.
	 * @author wizardc
	 */
	public class ListNode
	{
		private var _prevNode:ListNode;
		private var _nextNode:ListNode;
		private var _data:*;
		
		/**
		 * 创建一个 <code>ListNode</code> 对象.
		 * @param data 指定该节点的数据.
		 * @param prevNode 指定该节点的前一节点.
		 * @param nextNode 指定该节点的后一节点.
		 */
		public function ListNode(data:* = null, prevNode:ListNode = null, nextNode:ListNode = null)
		{
			_prevNode = prevNode;
			_nextNode = nextNode;
			_data = data;
		}
		
		/**
		 * 设置或获取前一节点.
		 */
		public function set prevNode(value:ListNode):void
		{
			_prevNode = value;
		}
		public function get prevNode():ListNode
		{
			return _prevNode;
		}
		
		/**
		 * 设置或获取后一节点.
		 */
		public function set nextNode(value:ListNode):void
		{
			_nextNode = value;
		}
		public function get nextNode():ListNode
		{
			return _nextNode;
		}
		
		/**
		 * 设置或获取数据.
		 */
		public function set data(value:*):void
		{
			_data = value;
		}
		public function get data():*
		{
			return _data;
		}
	}
}
