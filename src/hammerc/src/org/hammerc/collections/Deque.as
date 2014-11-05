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
	 * <code>Deque</code> 类实现了双端队列的操作并支持序列化.
	 * @author wizardc
	 */
	public class Deque extends ArrayList
	{
		/**
		 * 创建一个 <code>Deque</code> 类.
		 * @param array 指定初始内容.
		 */
		public function Deque(array:Array = null)
		{
			super(array);
		}
		
		/**
		 * 获取队列的第一个元素.
		 * @return 队列的第一个元素.
		 */
		public function peekFirst():*
		{
			return _elements[0];
		}
		
		/**
		 * 获取队列的最后一个元素.
		 * @return 队列的最后一个元素.
		 */
		public function peekLast():*
		{
			return _elements[this.length - 1];
		}
		
		/**
		 * 将元素加入队列头部.
		 * @param item 要被加入的元素.
		 * @return 加入的元素.
		 */
		public function offerFirst(item:*):*
		{
			return _elements.unshift(item);
		}
		
		/**
		 * 将元素加入队列末尾.
		 * @param item 要被加入的元素.
		 * @return 加入的元素.
		 */
		public function offerLast(item:*):*
		{
			return _elements.push(item);
		}
		
		/**
		 * 弹出队列的第一个元素并返回该元素.
		 * @return 队列的第一个元素.
		 */
		public function pollFirst():*
		{
			return _elements.shift();
		}
		
		/**
		 * 弹出队列的最后一个元素并返回该元素.
		 * @return 队列的最后一个元素.
		 */
		public function pollLast():*
		{
			return _elements.pop();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return "Deque: " + _elements.toString();
		}
	}
}
