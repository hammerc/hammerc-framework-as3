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
	 * <code>Iterator</code> 实现了列表的迭代器.
	 * @author wizardc
	 */
	public class Iterator implements IIterator
	{
		private var _list:IList;
		private var _index:int;
		
		/**
		 * 创建一个 <code>Iterator</code> 对象.
		 * @param list 需要被迭代的列表对象.
		 */
		public function Iterator(list:IList)
		{
			_list = list;
			_index = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasNext():Boolean
		{
			return _index < _list.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function next():*
		{
			return _list.getItemAt(_index++);
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove():void
		{
			_list.removeItemAt(--_index);
		}
	}
}
