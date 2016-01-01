// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt.composites
{
	/**
	 * <code>ParallelFailurePolicy</code> 定义了并行节点返回失败的枚举.
	 * @author wizardc
	 */
	public final class ParallelFailurePolicy
	{
		/**
		 * 只要有一个节点返回失败并行节点就返回失败.
		 */
		public static const ONE:int = 0;
		
		/**
		 * 所有节点返回失败并行节点才返回失败.
		 */
		public static const ALL:int = 1;
	}
}
