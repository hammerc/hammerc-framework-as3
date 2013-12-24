/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.pigeon.rpc.errors
{
	/**
	 * <code>RemoteChannelError</code> 类代表了远程方法调用通道的错误.
	 * @author wizardc
	 */
	public class RemoteChannelError extends Error
	{
		/**
		 * 创建一个 <code>RemoteChannelError</code> 对象.
		 * @param message 该异常描述.
		 */
		public function RemoteChannelError(message:String)
		{
			super(message);
		}
	}
}
