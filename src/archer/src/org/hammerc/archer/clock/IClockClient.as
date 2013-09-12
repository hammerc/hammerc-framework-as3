/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.clock
{
	/**
	 * <code>IClockClient</code> 接口定义了时钟对象应有的属性及方法.
	 * @author wizardc
	 */
	public interface IClockClient
	{
		/**
		 * 更新方法.
		 * @param passedTime 据上次更新经过的时间, 单位秒.
		 */
		function update(passedTime:Number):void;
	}
}
