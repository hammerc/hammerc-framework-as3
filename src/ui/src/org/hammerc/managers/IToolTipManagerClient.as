/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.geom.Point;
	
	/**
	 * <code>IToolTipManagerClient</code> 接口定义了可以弹出工具提示对象的通用方法及属性.
	 * @author wizardc
	 */
	public interface IToolTipManagerClient
	{
		/**
		 * 设置或获取工具提示的内容.
		 */
		function set toolTip(value:Object):void;
		function get toolTip():Object;
		
		/**
		 * 设置或获取工具提示的渲染类, 为空使用默认的渲染类.
		 */
		function set toolTipRenderer(value:Class):void;
		function get toolTipRenderer():Class;
		
		/**
		 * 设置或获取工具提示的弹出位置.
		 */
		function set toolTipPosition(value:String):void;
		function get toolTipPosition():String;
		
		/**
		 * 设置或获取工具提示的弹出位置的偏移量.
		 */
		function set toolTipOffset(value:Point):void;
		function get toolTipOffset():Point;
	}
}
