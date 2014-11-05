// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.core
{
	/**
	 * <code>ITextField</code> 接口定义了呈现文本组件的接口.
	 * @author wizardc
	 */
	public interface IText extends IUIComponent
	{
		/**
		 * 设置或获取文本.
		 */
		function set text(value:String):void;
		function get text():String;
		
		/**
		 * 设置或获取 HTML 文本.
		 */
		function set htmlText(value:String):void;
		function get htmlText():String;
	}
}
