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
	 * <code>PropertyChangeEvent</code> 类定义了对象属性改变时发送的事件.
	 * @see org.hammerc.utils.ObjectProxy
	 * @author wizardc
	 */
	public class PropertyChangeEvent extends Event
	{
		/**
		 * 每当对象属性改变时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>isDelete</code></td><td>记录属性是改变 (<code>false</code>) 还是删除 (<code>true</code>).</td></tr>
		 *   <tr><td><code>newValue</code></td><td>改变后的值.</td></tr>
		 *   <tr><td><code>oldValue</code></td><td>改变前的值.</td></tr>
		 *   <tr><td><code>source</code></td><td>改变了值的源对象, 并非代理对象.</td></tr>
		 *   <tr><td><code>property</code></td><td>改变的属性名称. 如果改变的值和当前侦听的对象有多个层级关系则该对象为数组并表示属性名称的层级.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType propertyChange
		 */
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		private var _isDelete:Boolean;
		private var _newValue:*;
		private var _oldValue:*;
		private var _source:Object;
		private var _property:Object;
		
		/**
		 * 创建一个 <code>PropertyChangeEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param isDelete 记录属性是改变 (<code>false</code>) 还是删除 (<code>true</code>).
		 * @param newValue 改变后的值.
		 * @param oldValue 改变前的值.
		 * @param source 改变了值的源对象, 并非代理对象.
		 * @param property 改变的属性名称. 如果改变的值和当前侦听的对象有多个层级关系则该对象为数组并表示属性名称的层级.
		 */
		public function PropertyChangeEvent(type:String, isDelete:Boolean, newValue:*, oldValue:*, source:Object, property:Object)
		{
			super(type, false, false);
			_isDelete = isDelete;
			_newValue = newValue;
			_oldValue = oldValue;
			_source = source;
			_property = property;
		}
		
		/**
		 * 获取属性是改变 (<code>false</code>) 还是删除 (<code>true</code>).
		 */
		public function get isDelete():Boolean
		{
			return _isDelete;
		}
		
		/**
		 * 获取改变后的值.
		 */
		public function get newValue():*
		{
			return _newValue;
		}
		
		/**
		 * 获取改变前的值.
		 */
		public function get oldValue():*
		{
			return _oldValue;
		}
		
		/**
		 * 获取改变了值的源对象, 并非代理对象.
		 */
		public function get source():Object
		{
			return _source;
		}
		
		/**
		 * 获取改变的值的属性名称, 若为数组则表示当前侦听对象改变的值的层级关系.
		 * <p>如: <code>ObjectProxy</code> 对象 A 代理了对象 B, 对象 B 中有一个名
		 * 为 c 的属性为 <code>ObjectProxy</code> 类型的对象 D, 对象 D 代理了对象 
		 * E, 对象 E 中有一个名为 f 的属性为对象 G, G 的属性 h 改变了, 对象 A 收到
		 * 的事件中的 <code>property</code> 为 ["c", "f", "h"].</p>
		 */
		public function get property():Object
		{
			return _property;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new PropertyChangeEvent(this.type, this.isDelete, this.newValue, this.oldValue, this.source, this.property);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("PropertyChangeEvent", "type", "bubbles", "cancelable", "isDelete", "newValue", "oldValue", "source", "property");
		}
	}
}
