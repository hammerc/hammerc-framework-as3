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
	 * <code>ParallelSuccessPolicy</code> 定义了并行节点返回成功的枚举.
	 * @author wizardc
	 */
	public final class ParallelSuccessPolicy
	{
		/**
		 * 只要有一个节点返回成功并行节点就返回成功.
		 */
		public static const ONE:int = 0;
		
		/**
		 * 所有节点返回成功并行节点才返回成功.
		 */
		public static const ALL:int = 1;
	}
}
