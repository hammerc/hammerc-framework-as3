/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.display
{
	/**
	 * <code>IRepaint</code> 接口定义了重绘的方法.
	 * @author wizardc
	 */
	public interface IRepaint
	{
		/**
		 * 在呈现显示对象之前会调用该方法.
		 */
		function repaint():void;
	}
}
