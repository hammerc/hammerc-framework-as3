// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.grid
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * <code>GridMouseEvent</code> 类为格子的鼠标事件模拟的事件类.
	 * @author wizardc
	 */
	public class GridMouseEvent extends Event
	{
		/**
		 * 格子移入时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>gridCell</code></td><td>当前的格子位置.</td></tr>
		 * </table>
		 * @eventType gridMouseOver
		 */
		public static const GRID_MOUSE_OVER:String = "gridMouseOver";
		
		/**
		 * 格子按下时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>gridCell</code></td><td>当前的格子位置.</td></tr>
		 * </table>
		 * @eventType gridMouseDown
		 */
		public static const GRID_MOUSE_DOWN:String = "gridMouseDown";
		
		/**
		 * 鼠标移动时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>gridCell</code></td><td>当前的格子位置.</td></tr>
		 * </table>
		 * @eventType gridMouseMove
		 */
		public static const GRID_MOUSE_MOVE:String = "gridMouseMove";
		
		private var _gridCell:Point;
		
		/**
		 * 创建一个 <code>GridMouseEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param gridCell 当前的格子位置.
		 */
		public function GridMouseEvent(type:String, gridCell:Point)
		{
			super(type, false, false);
			_gridCell = gridCell;
		}
		
		/**
		 * 获取当前的格子位置.
		 */
		public function get gridCell():Point
		{
			return _gridCell;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new GridMouseEvent(this.type, this.gridCell.clone());
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("GridMouseEvent", "type", "gridCell", "bubbles", "cancelable");
		}
	}
}
