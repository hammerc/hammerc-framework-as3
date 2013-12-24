/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.pigeon.http.errors
{
	/**
	 * <code>HTTPChannelError</code> 类代表了 <code>HTTPChannel</code> 类可能产生的错误.
	 * @author wizardc
	 */
	public class HTTPChannelError extends Error
	{
		/**
		 * 创建一个 <code>HTTPChannelError</code> 对象.
		 * @param message 该异常描述.
		 */
		public function HTTPChannelError(message:String)
		{
			super(message);
		}
	}
}
