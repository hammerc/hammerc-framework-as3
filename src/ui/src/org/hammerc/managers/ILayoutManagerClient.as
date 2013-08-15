/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>ILayoutManagerClient</code> 接口定义了布局管理器的组件.
	 * @author wizardc
	 */
	public interface ILayoutManagerClient extends IEventDispatcher
	{
		/**
		 * 设置或获取是否完成初始化.
		 * <p>注意: 此标志只能由 <code>LayoutManager</code> 修改.</p>
		 */
		function set initialized(value:Boolean):void;
		function get initialized():Boolean;
		
		/**
		 * 获取是否含有父级显示对象.
		 */
		function get hasParent():Boolean;
		
		/**
		 * 设置或获取在显示列表的嵌套深度.
		 */
		function set nestLevel(value:int):void;
		function get nestLevel():int;
		
		/**
		 * 设置或获取确定某个对象是否正在等待分派其 <code>updateComplete</code> 事件.
		 * <p>注意: 此标志只能由 <code>LayoutManager</code> 修改.</p>
		 */
		function set updateCompletePendingFlag(value:Boolean):void;
		function get updateCompletePendingFlag():Boolean;
		
		/**
		 * 验证组件的属性.
		 */
		function validateProperties():void;
		
		/**
		 * 验证组件的尺寸.
		 * @param recursive 是否同时验证所有子组件的尺寸.
		 */
		function validateSize(recursive:Boolean = false):void;
		
		/**
		 * 验证子项的位置和大小, 并绘制其他可视内容.
		 */
		function validateDisplayList():void;
	}
}
