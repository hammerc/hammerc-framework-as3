// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.styles
{
	/**
	 * <code>IStyleManager</code> 接口定义了样式管理器的接口.
	 * @author wizardc
	 */
	public interface IStyleManager
	{
		/**
		 * 获取全局样式描述对象.
		 * <p>所有 <code>styleName</code> 属性不为 null 的组件的样式都会继承自该样式, 同名属性可覆盖.</p>
		 */
		function get globalStyleDeclaration():SimpleStyleDeclaration;
		
		/**
		 * 注册一个样式.
		 * @param styleName 样式名称.
		 * @param styleDeclaration 对应的样式对象.
		 */
		function registerStyleDeclaration(styleName:String, styleDeclaration:StyleDeclaration):void;
		
		/**
		 * 获取一个样式.
		 * @param styleName 样式名称.
		 * @return 对应的样式对象.
		 */
		function getStyleDeclaration(styleName:String):StyleDeclaration;
		
		/**
		 * 清除一个样式.
		 * @param styleName 样式名称.
		 * @return 清除的样式对象.
		 */
		function clearStyleDeclaration(styleName:String):StyleDeclaration;
	}
}
