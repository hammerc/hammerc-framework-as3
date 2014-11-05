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
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.Injector;
	import org.hammerc.events.PopUpEvent;
	import org.hammerc.managers.impl.PopUpManagerImpl;
	
	/**
	 * <code>PopUpManager</code> 类管理窗口弹出.
	 * @author wizardc
	 */
	public class PopUpManager
	{
		private static var _impl:IPopUpManager;
		
		private static function get impl():IPopUpManager
		{
			if(_impl == null)
			{
				try
				{
					_impl = Injector.getInstance(IPopUpManager);
				}
				catch(error:Error)
				{
					_impl = new PopUpManagerImpl();
				}
			}
			return _impl;
		}
		
		/**
		 * 设置或获取模态遮罩的填充颜色.
		 */
		public function set modalColor(value:uint):void
		{
			impl.modalColor = value;
		}
		public function get modalColor():uint
		{
			return impl.modalColor;
		}
		
		/**
		 * 设置或获取模态遮罩的透明度.
		 */
		public function set modalAlpha(value:Number):void
		{
			impl.modalAlpha = value;
		}
		public function get modalAlpha():Number
		{
			return impl.modalAlpha;
		}
		
		/**
		 * 获取已经弹出的窗口列表.
		 */
		public static function get popUpList():Array
		{
			return impl.popUpList;
		}
		
		/**
		 * 弹出一个窗口.
		 * @param popUp 要弹出的窗口.
		 * @param modal 是否启用模态. 即是否禁用弹出窗口所在层以下的鼠标事件.
		 * @param center 是否居中窗口.
		 * @param systemManager 要弹出到的系统管理器.
		 */
		public static function addPopUp(popUp:IUIComponent, modal:Boolean = false, center:Boolean = true, systemManager:ISystemManager = null):void
		{
			impl.addPopUp(popUp, modal, center, systemManager);
			impl.dispatchEvent(new PopUpEvent(PopUpEvent.ADD_POPUP, popUp, modal));
		}
		
		/**
		 * 将指定窗口的层级调至最前.
		 * @param popUp 要最前显示的窗口.
		 */
		public static function bringToFront(popUp:IUIComponent):void
		{
			impl.bringToFront(popUp);
			impl.dispatchEvent(new PopUpEvent(PopUpEvent.BRING_TO_FRONT, popUp));
		}
		
		/**
		 * 将指定窗口居中显示.
		 * @param popUp 要居中显示的窗口.
		 */
		public static function centerPopUp(popUp:IUIComponent):void
		{
			impl.centerPopUp(popUp);
		}
		
		/**
		 * 移除弹出的窗口.
		 * @param popUp 要移除的窗口.
		 */
		public static function removePopUp(popUp:IUIComponent):void
		{
			impl.removePopUp(popUp);
			impl.dispatchEvent(new PopUpEvent(PopUpEvent.REMOVE_POPUP, popUp));
		}
		
		/**
		 * 注册一个事件侦听.
		 * @param type 事件的类型.
		 * @param listener 处理事件的侦听器函数.
		 * @param useCapture 确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段.
		 * @param priority 事件侦听器的优先级.
		 * @param useWeakReference 确定对侦听器的引用是强引用, 还是弱引用.
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			impl.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * 移除一个事件侦听.
		 * @param type 事件的类型.
		 * @param listener 处理事件的侦听器函数.
		 * @param useCapture 确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段.
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			impl.removeEventListener(type, listener, useCapture);
		}
	}
}
