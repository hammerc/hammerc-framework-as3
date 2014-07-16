/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid
{
	import flash.geom.Point;
	
	/**
	 * <code>IGridDrawArea</code> 接口定义了格子编辑器绘制区域显示对象的属性和方法.
	 * @author wizardc
	 */
	public interface IGridDrawArea
	{
		/**
		 * 鼠标指向的格子对象改变时会调用该方法.
		 * @param target 当前指向的格子对象.
		 */
		function targetChanged(target:Point):void;
	}
}
