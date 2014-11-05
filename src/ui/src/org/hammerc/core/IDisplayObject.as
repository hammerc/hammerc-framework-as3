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
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>IDisplayObject</code> 接口定义了显示对象的方法及属性.
	 * <p>由于 AS3 原生 API 没有提供显示对象的接口, 这里写一个对应的接口.</p>
	 * @author wizardc
	 */
	public interface IDisplayObject extends IEventDispatcher, IBitmapDrawable
	{
		/**
		 * 设置或获取显示对象的名称.
		 */
		function set name(value:String):void;
		function get name():String;
		
		/**
		 * 获取父容器.
		 */
		function get parent():DisplayObjectContainer;
		
		/**
		 * 设置或获取显示对象是否显示.
		 */
		function set visible(value:Boolean):void;
		function get visible():Boolean;
		
		/**
		 * 设置或获取显示对象的透明度.
		 */
		function set alpha(value:Number):void;
		function get alpha():Number;
		
		/**
		 * 设置或获取显示对象的 x 轴坐标.
		 */
		function set x(value:Number):void;
		function get x():Number;
		
		/**
		 * 设置或获取显示对象的 y 轴坐标.
		 */
		function set y(value:Number):void;
		function get y():Number;
		
		/**
		 * 设置或获取显示对象的宽度.
		 */
		function set width(value:Number):void;
		function get width():Number;
		
		/**
		 * 设置或获取显示对象的高度.
		 */
		function set height(value:Number):void;
		function get height():Number;
	}
}
