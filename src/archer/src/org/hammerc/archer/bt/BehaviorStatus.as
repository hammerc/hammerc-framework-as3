// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt
{
	/**
	 * <code>BehaviorStatus</code> 类定义了行为树的运行状态枚举.
	 */
	public final class BehaviorStatus
	{
		/**
		 * 运行失败.
		 */
		public static const FAILURE:int = 0;
		
		/**
		 * 运行中.
		 */
		public static const RUNNING:int = 1;
		
		/**
		 * 运行成功.
		 */
		public static const SUCCESS:int = 2;
	}
}
