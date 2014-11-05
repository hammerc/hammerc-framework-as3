// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.frame
{
	/**
	 * <code>IFrameClient</code> 接口定义了帧执行对象应有的属性及方法.
	 * @author wizardc
	 */
	public interface IFrameClient
	{
		/**
		 * 帧执行方法.
		 * @param passedTime 据上次更新经过的时间, 单位秒.
		 */
		function frameHandler(passedTime:Number):void;
	}
}
