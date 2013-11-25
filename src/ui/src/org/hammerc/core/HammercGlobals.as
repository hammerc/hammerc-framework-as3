/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.core
{
	import flash.display.Stage;
	
	import org.hammerc.managers.FocusManager;
	import org.hammerc.managers.IFocusManager;
	import org.hammerc.managers.ISystemManager;
	import org.hammerc.managers.LayoutManager;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>HammercGlobals</code> 类记录了全局静态量.
	 * @author wizardc
	 */
	public class HammercGlobals
	{
		/**
		 * 一个全局标志, 控制在某些鼠标操作或动画特效播放时, 是否开启 <code>updateAfterEvent</code> 方法, 开启时能增加平滑的体验感, 但是会提高屏幕渲染 (Render 事件) 的频率. 默认为 true.
		 */
		public static var useUpdateAfterEvent:Boolean = true;
		
		/**
		 * 一个全局标志, 是否屏蔽失效验证阶段和 <code>callLater</code> 方法延迟调用的所有报错. 建议在发行版中启用, 避免因为一处报错引起全局的延迟调用失效.
		 */
		public static var catchCallLaterExceptions:Boolean = false;
		
		/**
		 * 记录舞台.
		 */
		private static var _stage:Stage;
		
		/**
		 * 记录已经初始化完成标志.
		 */
		private static var _initlized:Boolean = false;
		
		/**
		 * 延迟渲染布局管理器.
		 */
		hammerc_internal static var layoutManager:LayoutManager;
		
		/**
		 * 焦点管理器.
		 */
		hammerc_internal static var focusManager:IFocusManager;
		
		/**
		 * 系统管理器列表.
		 */
		hammerc_internal static var _systemManagers:Vector.<ISystemManager> = new Vector.<ISystemManager>();
		
		/**
		 * 获取舞台引用.
		 */
		public static function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * 初始化全局静态量.
		 * @param stage 舞台引用.
		 */
		hammerc_internal static function initlize(stage:Stage):void
		{
			if(_initlized)
			{
				return;
			}
			_stage = stage;
			layoutManager = new LayoutManager();
			try
			{
				focusManager = Injector.getInstance(IFocusManager);
			}
			catch(error:Error)
			{
				focusManager = new FocusManager();
			}
			focusManager.stage = stage;
			_initlized = true;
		}
		
		/**
		 * 获取顶级应用容器.
		 */
		public static function get systemManager():ISystemManager
		{
			for(var i:int = _systemManagers.length - 1; i >= 0; i--)
			{
				if(_systemManagers[i].stage != null)
				{
					return _systemManagers[i];
				}
			}
			return null;
		}
	}
}
