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
	 * <code>Queue</code> 类实现了队列的操作并支持序列化.
	 * @author wizardc
	 */
	public class Queue extends ArrayList
	{
		/**
		 * 创建一个 <code>Queue</code> 类.
		 * @param array 指定初始内容.
		 */
		public function Queue(array:Array = null)
		{
			super(array);
		}
		
		/**
		 * 获取队列的第一个元素.
		 * @return 队列的第一个元素.
		 */
		public function peek():*
		{
			return _elements[0];
		}
		
		/**
		 * 将元素加入队列末尾.
		 * @param item 要被加入的元素.
		 * @return 加入的元素.
		 */
		public function offer(item:*):*
		{
			return _elements.push(item);
		}
		
		/**
		 * 弹出队列的第一个元素并返回该元素.
		 * @return 队列的第一个元素.
		 */
		public function poll():*
		{
			return _elements.shift();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return "Queue: " + _elements.toString();
		}
	}
}
