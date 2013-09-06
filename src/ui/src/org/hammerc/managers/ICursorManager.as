/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.display.DisplayObject;
	
	/**
	 * <code>ICursorManager</code> 定义了光标管理器的接口.
	 * <p>由于系统光标和自定义光标可能会同时使用所以取消了显示自定义光标就隐藏系统光标的设定, 两种光标可分开设置.</p>
	 * @author wizardc
	 */
	public interface ICursorManager
	{
		/**
		 * 获取当前显示的光标的名称.
		 */
		function get currentCursorName():String;
		
		/**
		 * 获取当前显示的光标对象.
		 */
		function get currentCursor():DisplayObject;
		
		/**
		 * 显示系统光标.
		 */
		function showSystemCursor():void;
		
		/**
		 * 隐藏系统光标.
		 */
		function hideSystemCursor():void;
		
		/**
		 * 显示自定义光标.
		 */
		function showCursor():void;
		
		/**
		 * 隐藏自定义光标.
		 */
		function hideCursor():void;
		
		/**
		 * 设置要显示的光标.
		 * <p>如果该光标的优先级最高则立即显示该光标, 否则显示优先级最高的光标.</p>
		 * @param cursorName 光标的名称.
		 */
		function setCursor(cursorName:String):void;
		
		/**
		 * 隐藏已经设置为会显示的一个光标.
		 * <p>显示剩余要显示的光标中优先级最高的光标, 没有要显示的光标则不显示.</p>
		 * @param cursorName 光标的名称.
		 */
		function removeCursor(cursorName:String):void;
		
		/**
		 * 设置可显示的所有光标都为不可显示.
		 * <p>该方法不会清除光标.</p>
		 */
		function removeAllCursor():void;
		
		/**
		 * 注册一个光标.
		 * @param cursorName 光标的名称.
		 * @param cursor 光标实例.
		 * @param priority 光标显示优先级, 多个光标同时可显示时只会显示优先级最高的光标, 存在多个优先级相同的光标则显示最后设置的那个光标 (即最后调用 <code>setCursor</code> 方法显示的光标).
		 * @param offsetX 光标注册点 x 轴偏移.
		 * @param offsetY 光标注册点 y 轴偏移.
		 * @return 光标实例.
		 */
		function registerCursor(cursorName:String, cursor:DisplayObject, priority:int = 0, offsetX:Number = 0, offsetY:Number = 0):DisplayObject;
		
		/**
		 * 注销一个光标. 如果该光标正在显示则会移除该光标.
		 * @param cursorName 光标的名称.
		 * @return 光标实例.
		 */
		function unregisterCursor(cursorName:String):DisplayObject;
		
		/**
		 * 注销所有光标.
		 */
		function unregisterAllCursor():void;
	}
}
