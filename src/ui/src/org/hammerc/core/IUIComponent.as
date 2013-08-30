/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.core
{
	import org.hammerc.managers.ISystemManager;
	
	/**
	 * <code>IUIComponent</code> 接口定义了组件的通用方法及属性.
	 * @author wizardc
	 */
	public interface IUIComponent extends ILayoutElement
	{
		/**
		 * 获取本对象的所有者.
		 */
		function get owner():Object;
		
		/**
		 * 内部设置本对象的所有者. 请不要自行改变它的值, 否则可能引发未知的问题.
		 * @param value 本对象的所有者.
		 */
		function ownerChanged(value:Object):void;
		
		/**
		 * 设置或获取所属的系统管理器.
		 */
		function set systemManager(value:ISystemManager):void;
		function get systemManager():ISystemManager;
		
		/**
		 * 设置或获取组件是否可以接受用户交互.
		 */
		function set enabled(value:Boolean):void;
		function get enabled():Boolean;
		
		/**
		 * 设置或获取当鼠标在组件上按下时, 是否能够自动获得焦点.
		 */
		function set focusEnabled(value:Boolean):void;
		function get focusEnabled():Boolean;
		
		/**
		 * 获取外部显式指定的宽度.
		 */
		function get explicitWidth():Number;
		
		/**
		 * 获取外部显式指定的高度.
		 */
		function get explicitHeight():Number;
		
		/**
		 * 设置或获取该组件是否被弹出.
		 */
		function set isPopUp(value:Boolean):void;
		function get isPopUp():Boolean;
		
		/**
		 * 设置组件的尺寸.
		 * @param newWidth 新的宽度.
		 * @param newHeight 新的高度.
		 */
		function setActualSize(newWidth:Number, newHeight:Number):void;
		
		/**
		 * 设置当前组件为拥有焦点的对象.
		 */
		function setFocus():void;
	}
}
