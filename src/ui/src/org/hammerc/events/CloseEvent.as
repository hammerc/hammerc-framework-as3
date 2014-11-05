// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.events
{
	import flash.events.Event;
	
	/**
	 * <code>CloseEvent</code> 类为窗口关闭事件类.
	 * @author wizardc
	 */
	public class CloseEvent extends Event
	{
		/**
		 * 当窗口关闭会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>detail</code></td><td>触发关闭事件的细节.</td></tr>
		 * </table>
		 * @eventType close
		 */
		public static const CLOSE:String = "close";
		
		private var _detail:int;
		
		/**
		 * 创建一个 <code>CloseEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 * @param detail 触发关闭事件的细节.
		 */
		public function CloseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, detail:int = -1)
		{
			super(type, bubbles, cancelable);
			_detail = detail;
		}
		
		/**
		 * 获取触发关闭事件的细节.
		 */
		public function get detail():int
		{
			return _detail;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new CloseEvent(this.type, this.bubbles, this.cancelable, this.detail);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("CloseEvent", "type", "bubbles", "cancelable", "detail");
		}
	}
}
