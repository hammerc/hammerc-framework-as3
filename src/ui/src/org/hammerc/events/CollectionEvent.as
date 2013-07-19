/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	
	/**
	 * <code>CollectionEvent</code> 类定义了列表元素改变时发送的事件.
	 * @author wizardc
	 */
	public class CollectionEvent extends Event
	{
		/**
		 * 列表元素改变的事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>kind</code></td><td>列表元素改变的类型.</td></tr>
		 *   <tr><td><code>items</code></td><td>受事件影响的元素的列表.</td></tr>
		 *   <tr><td><code>oldItems</code></td><td>替换前的元素的列表.</td></tr>
		 *   <tr><td><code>location</code></td><td>指定 <code>items</code> 属性中指定的元素集合中第一个元素的索引.</td></tr>
		 *   <tr><td><code>oldLocation</code></td><td>指定 <code>items</code> 属性中指定的元素集合中第一个元素原来的索引.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType collectionChange
		 */
		public static const COLLECTION_CHANGE:String = "collectionChange";
		
		private var _kind:String;
		private var _items:Array;
		private var _oldItems:Array;
		private var _location:int;
		private var _oldLocation:int;
		
		/**
		 * 创建一个 <code>CollectionEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param kind 列表元素改变的类型.
		 * @param items 受事件影响的元素的列表.
		 * @param oldItems 替换前的元素的列表.
		 * @param location 指定 <code>items</code> 属性中指定的元素集合中第一个元素的索引.
		 * @param oldLocation 指定 <code>items</code> 属性中指定的元素集合中第一个元素原来的索引.
		 */
		public function CollectionEvent(type:String, kind:String, items:Array = null, oldItems:Array = null, location:int = -1, oldLocation:int = -1)
		{
			super(type, false, false);
			_kind = kind;
			_items = items;
			_oldItems = oldItems;
			_location = location;
			_oldLocation = oldLocation;
		}
		
		/**
		 * 获取列表元素改变的类型.
		 */
		public function get kind():String
		{
			return _kind;
		}
		
		/**
		 * 获取受事件影响的元素的列表.
		 */
		public function get items():Array
		{
			return _items;
		}
		
		/**
		 * 获取替换前的元素的列表.
		 * <p>仅当 <code>kind</code> 的值为 <code>CollectionKind.REPLACE</code> 时有效.</p>
		 */
		public function get oldItems():Array
		{
			return _oldItems;
		}
		
		/**
		 * 获取指定 <code>items</code> 属性中指定的元素集合中第一个元素的索引.
		 * <p>当 <code>kind</code> 的值为 <code>CollectionKind.ADD</code>, <code>CollectionKind.MOVE</code>, <code>CollectionKind.REMOVE</code>, <code>CollectionKind.REPLACE</code> 或 <code>CollectionKind.UPDATE</code> 时有效.</p>
		 */
		public function get location():int
		{
			return _location;
		}
		
		/**
		 * 获取指定 <code>items</code> 属性中指定的元素集合中第一个元素原来的索引.
		 * <p>仅当 <code>kind</code> 的值为 <code>CollectionKind.MOVE</code> 时有效.</p>
		 */
		public function get oldLocation():int
		{
			return _oldLocation;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new CollectionEvent(this.type, this.kind, this.items, this.oldItems, this.location, this.oldLocation);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("CollectionEvent", "type", "bubbles", "cancelable", "kind", "items", "oldItems", "location", "oldLocation");
		}
	}
}
