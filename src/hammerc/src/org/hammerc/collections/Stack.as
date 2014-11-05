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
	 * <code>Stack</code> 类实现了栈的操作并支持序列化.
	 * @author wizardc
	 */
	public class Stack extends ArrayList
	{
		/**
		 * 创建一个 <code>Stack</code> 类.
		 * @param array 指定初始内容.
		 */
		public function Stack(array:Array = null)
		{
			super(array);
		}
		
		/**
		 * 获取栈顶元素.
		 * @return 栈顶元素.
		 */
		public function peek():*
		{
			return _elements[this.length - 1];
		}
		
		/**
		 * 向栈顶压入一个元素.
		 * @param object 要被压入的元素.
		 * @return 压入的元素.
		 */
		public function push(item:*):*
		{
			return _elements.push(item);
		}
		
		/**
		 * 弹出栈顶的元素并返回该元素.
		 * @return 被弹出的栈顶元素.
		 */
		public function pop():*
		{
			return _elements.pop();
		}
		
		/**
		 * 从栈顶开始搜索一个元素.
		 * @param object 要被搜索的元素.
		 * @return 该元素位于栈中的索引, 不存在则返回 -1.
		 */
		public function search(item:*):int
		{
			var index:int = this.lastIndexOf(item);
			if(index == -1)
			{
				return -1;
			}
			return this.length - index;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return "Stack: " + _elements.toString();
		}
	}
}
