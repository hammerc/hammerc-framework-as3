/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.skins
{
	import org.hammerc.core.IUIComponent;

	/**
	 * <code>ISkinnableClient</code> 接口定义了可设置外观的组件接口.
	 * @author wizardc
	 */
	public interface ISkinnableClient extends IUIComponent
	{
		/**
		 * 设置或获取皮肤标识符, 可以为 <code>Class</code>, <code>String</code>, 或 <code>DisplayObject</code> 实例等任意类型.
		 * <p>具体规则由项目注入的 <code>ISkinAdapter</code> 决定, 皮肤适配器将在运行时解析此标识符, 然后返回皮肤对象给组件.</p>
		 */
		function set skinName(value:Object):void;
		function get skinName():Object;
	}
}
