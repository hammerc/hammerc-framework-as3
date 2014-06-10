/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.project
{
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>IProject</code> 接口定义了工程对象应有的属性和方法, 内置弹出对话框功能.
	 * @author wizardc
	 */
	public interface IProject extends IEventDispatcher
	{
		/**
		 * 获取当前打开的工程文件的路径.
		 */
		function get path():String;
		
		/**
		 * 获取当前是否打开了工程文件.
		 */
		function get opened():Boolean;
		
		/**
		 * 获取当前的文件是否已经存在硬盘上了.
		 */
		function get isInDisk():Boolean;
		
		/**
		 * 获取当前打开的工程文件的数据.
		 */
		function get data():*;
		
		/**
		 * 新建一个工程.
		 */
		function newProject():void;
		
		/**
		 * 打开一个工程.
		 * @param typeFilter 文件类型过滤数组.
		 * @param title 对话框标题.
		 * @param defaultPath 默认路径.
		 */
		function openProject(typeFilter:Array = null, title:String = "浏览文件", defaultPath:String = null):void;
		
		/**
		 * 保存当前工程.
		 * @param defaultPath 默认路径.
		 * @param title 对话框标题.
		 */
		function saveProject(defaultPath:String = null, title:String = "保存文件"):void;
		
		/**
		 * 另存为当前工程.
		 * @param defaultPath 默认路径.
		 * @param title 对话框标题.
		 */
		function saveAsProject(defaultPath:String = null, title:String = "保存文件"):void;
		
		/**
		 * 关闭当前工程.
		 */
		function closeProject():void;
	}
}
