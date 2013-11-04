/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.styles
{
	/**
	 * <code>IStyleClient</code> 接口为可配置样式的组件接口.
	 * @author wizardc
	 */
	public interface IStyleClient
	{
		/**
		 * 设置或获取该组件默认的样式名称.
		 */
		function set styleName(value:String):void;
		function get styleName():String;
		
		/**
		 * 设置样式的一个属性.
		 * @param styleProp 样式属性的名称.
		 * @param newValue 样式的新值.
		 */
		function setStyle(styleProp:String, newValue:*):void;
		
		/**
		 * 获取样式的一个属性.
		 * @param styleProp 样式属性的名称.
		 * @return 样式的值.
		 */
		function getStyle(styleProp:String):*;
		
		/**
		 * 删除此组件实例的样式属性.
		 * @param styleProp 样式属性的名称.
		 * @return 样式的值.
		 */
		function clearStyle(styleProp:String):*;
	}
}
