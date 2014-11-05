// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.managers
{
	import flash.display.DisplayObject;
	
	import org.hammerc.core.Injector;
	import org.hammerc.managers.impl.CursorManagerImpl;
	
	/**
	 * <code>CursorManager</code> 类管理光标.
	 * @author wizardc
	 */
	public class CursorManager
	{
		private static var _impl:ICursorManager;
		
		private static function get impl():ICursorManager
		{
			if(_impl == null)
			{
				try
				{
					_impl = Injector.getInstance(ICursorManager);
				}
				catch(error:Error)
				{
					_impl = new CursorManagerImpl();
				}
			}
			return _impl;
		}
		
		/**
		 * 获取当前显示的光标的名称.
		 */
		public static function get currentCursorName():String
		{
			return impl.currentCursorName;
		}
		
		/**
		 * 获取当前显示的光标对象.
		 */
		public static function get currentCursor():DisplayObject
		{
			return impl.currentCursor;
		}
		
		/**
		 * 显示系统光标.
		 */
		public static function showSystemCursor():void
		{
			impl.showSystemCursor();
		}
		
		/**
		 * 隐藏系统光标.
		 */
		public static function hideSystemCursor():void
		{
			impl.hideSystemCursor();
		}
		
		/**
		 * 显示自定义光标.
		 */
		public static function showCursor():void
		{
			impl.showCursor();
		}
		
		/**
		 * 隐藏自定义光标.
		 */
		public static function hideCursor():void
		{
			impl.hideCursor();
		}
		
		/**
		 * 设置要显示的光标.
		 * <p>如果该光标的优先级最高则立即显示该光标, 否则显示优先级最高的光标.</p>
		 * @param cursorName 光标的名称.
		 */
		public static function setCursor(cursorName:String):void
		{
			impl.setCursor(cursorName);
		}
		
		/**
		 * 隐藏已经设置为会显示的一个光标.
		 * <p>显示剩余要显示的光标中优先级最高的光标, 没有要显示的光标则不显示.</p>
		 * @param cursorName 光标的名称.
		 */
		public static function removeCursor(cursorName:String):void
		{
			impl.removeCursor(cursorName);
		}
		
		/**
		 * 设置可显示的所有光标都为不可显示.
		 * <p>该方法不会清除光标.</p>
		 */
		public static function removeAllCursor():void
		{
			impl.removeAllCursor();
		}
		
		/**
		 * 注册一个光标.
		 * @param cursorName 光标的名称.
		 * @param cursor 光标实例.
		 * @param priority 光标显示优先级, 多个光标同时可显示时只会显示优先级最高的光标, 存在多个优先级相同的光标则显示最后设置的那个光标 (即最后调用 <code>setCursor</code> 方法显示的光标).
		 * @param offsetX 光标注册点 x 轴偏移.
		 * @param offsetY 光标注册点 y 轴偏移.
		 * @return 光标实例.
		 */
		public static function registerCursor(cursorName:String, cursor:DisplayObject, priority:int = 0, offsetX:Number = 0, offsetY:Number = 0):DisplayObject
		{
			return impl.registerCursor(cursorName, cursor, priority, offsetX, offsetY);
		}
		
		/**
		 * 注销一个光标. 如果该光标正在显示则会移除该光标.
		 * @param cursorName 光标的名称.
		 * @return 光标实例.
		 */
		public static function unregisterCursor(cursorName:String):DisplayObject
		{
			return impl.unregisterCursor(cursorName);
		}
		
		/**
		 * 注销所有光标.
		 */
		public static function unregisterAllCursor():void
		{
			impl.unregisterAllCursor();
		}
	}
}
