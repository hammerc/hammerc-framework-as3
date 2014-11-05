// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components
{
	/**
	 * <code>IItemRendererOwner</code> 接口定义了项呈示器的组件接口.
	 * @author wizardc
	 */
	public interface IItemRendererOwner
	{
		/**
		 * 更新项呈示器数据.
		 * @param renderer 项呈示器.
		 * @param itemIndex 项目索引.
		 * @param data 项数据.
		 * @return 项呈示器.
		 */
		function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer;
	}
}
