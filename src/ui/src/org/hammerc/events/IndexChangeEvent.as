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
	 * <code>IndexChangeEvent</code> 类为索引改变的事件.
	 * @author wizardc
	 */
	public class IndexChangeEvent extends Event
	{
		/**
		 * 指示索引已更改.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>newIndex</code></td><td>进行更改之后的从零开始的索引.</td></tr>
		 *   <tr><td><code>oldIndex</code></td><td>进行更改之前的从零开始的索引.</td></tr>
		 * </table>
		 * @eventType change
		 */
		public static const CHANGE:String = "change";
		
		/**
		 * 指示索引即将更改, 可以通过调用 <code>preventDefault()</code> 方法阻止索引发生更改.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>newIndex</code></td><td>进行更改之后的从零开始的索引.</td></tr>
		 *   <tr><td><code>oldIndex</code></td><td>进行更改之前的从零开始的索引.</td></tr>
		 * </table>
		 * @eventType changing
		 */
		public static const CHANGING:String = "changing";
		
		private var _newIndex:int;
		private var _oldIndex:int;
		
		/**
		 * 创建一个 <code>IndexChangeEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 * @param oldIndex 进行更改之后的从零开始的索引.
		 * @param newIndex 进行更改之前的从零开始的索引.
		 */
		public function IndexChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, oldIndex:int = -1, newIndex:int = -1)
		{
			super(type, bubbles, cancelable);
			_oldIndex = oldIndex;
			_newIndex = newIndex;
		}
		
		/**
		 * 获取进行更改之后的从零开始的索引.
		 */
		public function get newIndex():int
		{
			return _newIndex;
		}
		
		/**
		 * 获取进行更改之前的从零开始的索引.
		 */
		public function get oldIndex():int
		{
			return _oldIndex;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new IndexChangeEvent(this.type, this.bubbles, this.cancelable, this.oldIndex, this.newIndex);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("IndexChangeEvent", "type", "bubbles", "cancelable", "oldIndex", "newIndex");
		}
	}
}
