/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.display.DisplayObject;
	
	import org.hammerc.core.IToolTip;
	
	/**
	 * <code>IToolTipManager</code> 接口定义了工具提示管理器.
	 * <p>若项目需要自定义工具提示管理器, 请实现此接口, 并在项目初始化前调用 <code>Injector.mapClass(IToolTipManager,YourToolTipManager);</code> 注入自定义的工具提示管理器类.</p>
	 * @author wizardc
	 */
	public interface IToolTipManager
	{
		/**
		 * 设置或获取当前弹出工具提示的组件.
		 */
		function set currentTarget(value:IToolTipManagerClient):void;
		function get currentTarget():IToolTipManagerClient;
		
		/**
		 * 设置或获取当前弹出的工具提示对象.
		 */
		function set currentToolTip(value:IToolTip):void;
		function get currentToolTip():IToolTip;
		
		/**
		 * 设置或获取是否启用工具提示功能.
		 */
		function set enabled(value:Boolean):void;
		function get enabled():Boolean;
		
		/**
		 * 设置或获取工具提示鼠标悬停时的出现等待时间, 单位毫秒.
		 */
		function set showDelay(value:Number):void;
		function get showDelay():Number;
		
		/**
		 * 设置或获取工具提示自显示后自动消失的等待时间, 单位毫秒, 0 或负数则表示该工具提示不会自动消失.
		 */
		function set hideDelay(value:Number):void;
		function get hideDelay():Number;
		
		/**
		 * 设置或获取当一个工具提示显示完毕后, 若在此时间间隔内快速移动到下一个组件上就直接显示该组件的工具提示而不进行延迟, 单位毫秒.
		 */
		function set scrubDelay(value:Number):void;
		function get scrubDelay():Number;
		
		/**
		 * 设置或获取默认的工具提示渲染类.
		 */
		function set toolTipClass(value:Class):void;
		function get toolTipClass():Class;
		
		/**
		 * 注册需要显示工具提示的组件.
		 * @param target 目标显示对象.
		 * @param oldToolTip 旧的工具提示数据.
		 * @param newToolTip 新的工具提示数据.
		 */
		function registerToolTip(target:DisplayObject, oldToolTip:Object, newToolTip:Object):void;
		
		/**
		 * 创建指定的工具提示对象到舞台中.
		 * @param toolTip 工具提示的内容.
		 * @param x 舞台 x 轴坐标.
		 * @param y 舞台 y 轴坐标.
		 * @param toolTipRenderer 工具提示渲染类.
		 * @return 创建后的工具提示对象.
		 */
		function createToolTip(toolTip:Object, x:Number = 0, y:Number = 0, toolTipRenderer:Class = null):IToolTip;
		
		/**
		 * 销毁指定的工具提示对象.
		 * @param toolTipRenderer 要销毁的工具提示对象.
		 */
		function destroyToolTip(toolTip:IToolTip):void;
	}
}
