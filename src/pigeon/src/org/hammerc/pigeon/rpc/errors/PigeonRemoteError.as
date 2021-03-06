// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.pigeon.rpc.errors
{
	/**
	 * <code>PigeonRemoteError</code> 类代表了 <code>PigeonRemoteObject</code> 类可能产生的错误.
	 * @author wizardc
	 */
	public class PigeonRemoteError extends Error
	{
		/**
		 * 创建一个 <code>PigeonRemoteError</code> 对象.
		 * @param message 该异常描述.
		 */
		public function PigeonRemoteError(message:String)
		{
			super(message);
		}
	}
}
