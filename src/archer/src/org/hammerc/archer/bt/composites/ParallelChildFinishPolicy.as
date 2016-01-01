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
	 * <code>ParallelExitPolicy</code> 定义了并行节点子节点结束后是否还要继续调用的枚举.
	 * @author wizardc
	 */
	public final class ParallelChildFinishPolicy
	{
		/**
		 * 子节点返回成功或失败后就不再执行.
		 */
		public static const ONCE:int = 0;
		
		/**
		 * 子节点返回成功或失败后仍然继续执行.
		 */
		public static const LOOP:int = 1;
	}
}
