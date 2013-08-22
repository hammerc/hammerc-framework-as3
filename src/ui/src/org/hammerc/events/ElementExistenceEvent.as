/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	
	import org.hammerc.core.IUIComponent;
	
	/**
	 * <code>ElementExistenceEvent</code> 类为容器添加或移除元素时播放的事件类.
	 * @author wizardc
	 */
	public class ElementExistenceEvent extends Event
	{
		/**
		 * 元素添加时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>element</code></td><td>添加或删除的元素.</td></tr>
		 *   <tr><td><code>index</code></td><td>已添加或删除元素的位置的索引.</td></tr>
		 * </table>
		 * @eventType elementAdd
		 */
		public static const ELEMENT_ADD:String = "elementAdd";
		
		/**
		 * 元素移除时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>element</code></td><td>添加或删除的元素.</td></tr>
		 *   <tr><td><code>index</code></td><td>已添加或删除元素的位置的索引.</td></tr>
		 * </table>
		 * @eventType elementRemove
		 */
		public static const ELEMENT_REMOVE:String = "elementRemove";
		
		private var _element:IUIComponent;
		private var _index:int;
		
		/**
		 * 创建一个 <code>ElementExistenceEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param element 添加或删除的元素.
		 * @param index 已添加或删除元素的位置的索引.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 */
		public function ElementExistenceEvent(type:String,element:IUIComponent = null, index:int = -1, bubbles:Boolean = false,cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_element = element;
			_index = index;
		}
		
		/**
		 * 获取添加或删除的元素.
		 */
		public function get element():IUIComponent
		{
			return _element;
		}
		
		/**
		 * 获取已添加或删除元素的位置的索引.
		 */
		public function get index():int
		{
			return _index;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new ElementExistenceEvent(this.type, this.element, this.index, this.bubbles, this.cancelable);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("ElementExistenceEvent", "type", "bubbles", "cancelable", "element", "index");
		}
	}
}
