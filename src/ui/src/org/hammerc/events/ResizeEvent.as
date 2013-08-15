/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	
	/**
	 * <code>ResizedEvent</code> 类为组件尺寸改变后播放的事件类.
	 * @author wizardc
	 */
	public class ResizeEvent extends Event
	{
		/**
		 * 当组件尺寸发生改变时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>oldWidth</code></td><td>组件尺寸改变前的宽度.</td></tr>
		 *   <tr><td><code>oldHeight</code></td><td>组件尺寸改变前的高度.</td></tr>
		 * </table>
		 * @eventType resized
		 */
		public static const RESIZE:String = "resize";
		
		private var _oldWidth:Number;
		private var _oldHeight:Number;
		
		/**
		 * 创建一个 <code>ResizedEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param oldWidth 组件尺寸改变前的宽度.
		 * @param oldHeight 组件尺寸改变前的高度.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 */
		public function ResizeEvent(type:String, oldWidth:Number, oldHeight:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_oldWidth = oldWidth;
			_oldHeight = oldHeight;
		}
		
		/**
		 * 获取组件尺寸改变前的宽度.
		 */
		public function get oldWidth():Number
		{
			return _oldWidth;
		}
		
		/**
		 * 获取组件尺寸改变前的高度.
		 */
		public function get oldHeight():Number
		{
			return _oldHeight;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new ResizeEvent(this.type, this.oldWidth, this.oldHeight, this.bubbles, this.cancelable);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("ResizedEvent", "type", "bubbles", "cancelable", "oldWidth", "oldHeight");
		}
	}
}
