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
	 * <code>IIterator</code> 接口提供了对集合进行迭代的迭代器.
	 * @author wizardc
	 */
	public interface IIterator
	{
		/**
		 * 判断是否还有元素可以迭代.
		 * @return 如果还有元素可以迭代则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		function hasNext():Boolean;
		
		/**
		 * 返回迭代的下一个元素.
		 * <p>重复调用此方法直到 <code>hasNext()</code> 方法返回 <code>false</code>, 这将精确地一次性返回迭代器指向的集合中的所有元素.</p>
		 * @return 迭代的下一个元素.
		 */
		function next():*;
		
		/**
		 * 从迭代器指向的集合中移除迭代器返回的最后一个元素.
		 * <p>每次调用 <code>next</code> 只能调用一次此方法. 如果进行迭代时用调用此方法之外的其他方式修改了该迭代器所指向的集合，则迭代器的行为是不明确的.</p>
		 */
		function remove():void;
	}
}
