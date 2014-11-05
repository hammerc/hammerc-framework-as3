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
	 * <code>IIterable</code> 接口提供了进行迭代的方法.
	 * @author wizardc
	 */
	public interface IIterable
	{
		/**
		 * 获取用于迭代的迭代器对象.
		 * @return 用于迭代的迭代器对象.
		 */
		function iterator():IIterator;
	}
}
