/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid
{
	/**
	 * <code>IGridCell</code> 接口定义了格子应有的属性和方法.
	 * @author wizardc
	 */
	public interface IGridCell
	{
		/**
		 * 获取格子所在的行数.
		 */
		function get row():int;
		
		/**
		 * 获取格子所在的列数.
		 */
		function get column():int;
		
		/**
		 * 绘制格子.
		 * @param selected 是否被选中.
		 */
		function drawCell(selected:Boolean):void;
	}
}
