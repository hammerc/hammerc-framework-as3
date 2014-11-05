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
	
	import org.hammerc.core.IToolTip;
	import org.hammerc.core.Injector;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.managers.impl.ToolTipManagerImpl;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ToolTipManager</code> 类为工具提示管理器.
	 * @author wizardc
	 */
	public class ToolTipManager
	{
		private static var _impl:IToolTipManager;
		
		private static function get impl():IToolTipManager
		{
			if(_impl == null)
			{
				try
				{
					_impl = Injector.getInstance(IToolTipManager);
				}
				catch(error:Error)
				{
					_impl = new ToolTipManagerImpl();
				}
			}
			return _impl;
		}
		
		/**
		 * 设置或获取当前弹出工具提示的组件.
		 */
		public static function set currentTarget(value:IToolTipManagerClient):void
		{
			impl.currentTarget = value;
		}
		public static function get currentTarget():IToolTipManagerClient
		{
			return impl.currentTarget;
		}
		
		/**
		 * 设置或获取当前弹出的工具提示对象.
		 */
		public static function set currentToolTip(value:IToolTip):void
		{
			impl.currentToolTip = value;
		}
		public static function get currentToolTip():IToolTip
		{
			return impl.currentToolTip;
		}
		
		/**
		 * 设置或获取是否启用工具提示功能.
		 */
		public static function set enabled(value:Boolean):void
		{
			impl.enabled = value;
		}
		public static function get enabled():Boolean
		{
			return impl.enabled;
		}
		
		/**
		 * 设置或获取工具提示鼠标悬停时的出现等待时间, 单位毫秒.
		 */
		public static function set showDelay(value:Number):void
		{
			impl.showDelay = value;
		}
		public static function get showDelay():Number
		{
			return impl.showDelay;
		}
		
		/**
		 * 设置或获取工具提示自显示后自动消失的等待时间, 单位毫秒, 0 或负数则表示该工具提示不会自动消失.
		 */
		public static function set hideDelay(value:Number):void
		{
			impl.hideDelay = value;
		}
		public static function get hideDelay():Number
		{
			return impl.hideDelay;
		}
		
		/**
		 * 设置或获取当一个工具提示显示完毕后, 若在此时间间隔内快速移动到下一个组件上就直接显示该组件的工具提示而不进行延迟, 单位毫秒.
		 */
		public static function set scrubDelay(value:Number):void
		{
			impl.scrubDelay = value;
		}
		public static function get scrubDelay():Number
		{
			return impl.scrubDelay;
		}
		
		/**
		 * 设置或获取默认的工具提示渲染类.
		 */
		public static function set toolTipRenderer(value:Class):void
		{
			impl.toolTipRenderer = value;
		}
		public static function get toolTipRenderer():Class
		{
			return impl.toolTipRenderer;
		}
		
		/**
		 * 注册需要显示工具提示的组件.
		 * @param target 目标显示对象.
		 * @param oldToolTip 旧的工具提示数据.
		 * @param newToolTip 新的工具提示数据.
		 */
		hammerc_internal static function registerToolTip(target:DisplayObject, oldToolTip:Object, newToolTip:Object):void
		{
			impl.registerToolTip(target, oldToolTip, newToolTip);
		}
		
		/**
		 * 创建指定的工具提示对象到舞台中.
		 * @param toolTip 工具提示的内容.
		 * @param x 舞台 x 轴坐标.
		 * @param y 舞台 y 轴坐标.
		 * @param toolTipRenderer 工具提示渲染类.
		 * @return 创建后的工具提示对象.
		 */
		public static function createToolTip(toolTipData:String, x:Number, y:Number, toolTipRenderer:Class = null):IToolTip
		{
			return impl.createToolTip(toolTipData, x, y, toolTipRenderer);
		}
		
		/**
		 * 销毁指定的工具提示对象.
		 * @param toolTipRenderer 要销毁的工具提示对象.
		 */
		public static function destroyToolTip(toolTip:IToolTip):void
		{
			impl.destroyToolTip(toolTip);
		}
	}
}
