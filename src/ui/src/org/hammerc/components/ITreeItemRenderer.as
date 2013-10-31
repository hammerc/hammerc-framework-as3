/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	/**
	 * <code>ITreeItemRenderer</code> 接口定义了树状列表组件项呈示器的接口.
	 * @author wizardc
	 */
	public interface ITreeItemRenderer extends IItemRenderer
	{
		/**
		 * 设置或获取图标的皮肤名.
		 */
		function set iconSkinName(value:Object):void;
		function get iconSkinName():Object;
		
		/**
		 * 设置或获取缩进深度.
		 * 0 表示顶级节点, 1 表示第一层子节点, 以此类推.
		 */
		function set depth(value:int):void;
		function get depth():int;
		
		/**
		 * 设置或获取是否含有子节点.
		 */
		function set hasChildren(value:Boolean):void;
		function get hasChildren():Boolean;
		
		/**
		 * 设置或获取节点是否处于开启状态.
		 */
		function set opened(value:Boolean):void;
		function get opened():Boolean;
	}
}
