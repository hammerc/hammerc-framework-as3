/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.pigeon.http.errors
{
	/**
	 * <code>PigeonHTTPError</code> 类代表了 <code>PigeonHTTPObject</code> 类可能产生的错误.
	 * @author wizardc
	 */
	public class PigeonHTTPError extends Error
	{
		/**
		 * 创建一个 <code>PigeonHTTPError</code> 对象.
		 * @param message 该异常描述.
		 */
		public function PigeonHTTPError(message:String)
		{
			super(message);
		}
	}
}
