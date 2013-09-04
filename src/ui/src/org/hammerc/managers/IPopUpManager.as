/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.events.IEventDispatcher;
	
	import org.hammerc.core.IUIComponent;
	
	/**
	 * <code>IPopUpManager</code> 定义了弹出管理器的接口.
	 * @author wizardc
	 */
	public interface IPopUpManager extends IEventDispatcher
	{
		/**
		 * 设置或获取模态遮罩的填充颜色.
		 */
		function set modalColor(value:uint):void;
		function get modalColor():uint;
		
		/**
		 * 设置或获取模态遮罩的透明度.
		 */
		function set modalAlpha(value:Number):void;
		function get modalAlpha():Number;
		
		/**
		 * 获取已经弹出的窗口列表.
		 */
		function get popUpList():Array;
		
		/**
		 * 弹出一个窗口.
		 * @param popUp 要弹出的窗口.
		 * @param modal 是否启用模态. 即是否禁用弹出窗口所在层以下的鼠标事件.
		 * @param center 是否居中窗口.
		 * @param systemManager 要弹出到的系统管理器.
		 */
		function addPopUp(popUp:IUIComponent, modal:Boolean = false, center:Boolean = true, systemManager:ISystemManager = null):void;
		
		/**
		 * 将指定窗口的层级调至最前.
		 * @param popUp 要最前显示的窗口.
		 */
		function bringToFront(popUp:IUIComponent):void;
		
		/**
		 * 将指定窗口居中显示.
		 * @param popUp 要居中显示的窗口.
		 */
		function centerPopUp(popUp:IUIComponent):void;
		
		/**
		 * 移除弹出的窗口.
		 * @param popUp 要移除的窗口.
		 */
		function removePopUp(popUp:IUIComponent):void;
	}
}
