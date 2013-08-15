/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	
	/**
	 * <code>MoveEvent</code> 类为组件位置改变后播放的事件类.
	 * @author wizardc
	 */
	public class MoveEvent extends Event
	{
		/**
		 * 当组件位置发生改变时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>oldX</code></td><td>组件位置改变前的 x 轴坐标.</td></tr>
		 *   <tr><td><code>oldY</code></td><td>组件位置改变前的 y 轴坐标.</td></tr>
		 * </table>
		 * @eventType resized
		 */
		public static const MOVE:String = "move";
		
		private var _oldX:Number;
		private var _oldY:Number;
		
		/**
		 * 创建一个 <code>MoveEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param oldX 组件位置改变前的 x 轴坐标.
		 * @param oldY 组件位置改变前的 y 轴坐标.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 */
		public function MoveEvent(type:String, oldX:Number, oldY:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_oldX = oldX;
			_oldY = oldY;
		}
		
		/**
		 * 获取组件位置改变前的 x 轴坐标.
		 */
		public function get oldX():Number
		{
			return _oldX;
		}
		
		/**
		 * 获取组件位置改变前的 y 轴坐标.
		 */
		public function get oldY():Number
		{
			return _oldY;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new MoveEvent(this.type, this.oldX, this.oldY, this.bubbles, this.cancelable);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("MoveEvent", "type", "bubbles", "cancelable", "oldX", "oldY");
		}
	}
}
