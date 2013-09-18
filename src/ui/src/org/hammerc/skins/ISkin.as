/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.skins
{
	import org.hammerc.components.SkinnableComponent;
	
	/**
	 * <code>ISkin</code> 接口为皮肤对象的接口. 实现此接口的皮肤会被匹配公开同名变量, 并注入到主机组件上.
	 * @author wizardc
	 */
	public interface ISkin
	{
		/**
		 * 设置或获取宿主组件引用, 仅当皮肤被应用后才会对此属性赋值.
		 */
		function set hostComponent(value:SkinnableComponent):void;
		function get hostComponent():SkinnableComponent;
	}
}
