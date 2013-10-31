/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	
	import org.hammerc.components.TreeItemRenderer;
	
	/**
	 * <code>TreeEvent</code> 类定义了树形组件的事件.
	 * @author wizardc
	 */
	public class TreeEvent extends Event
	{
		/**
		 * 节点关闭.
		 * <p>注意: 只有通过交互操作引起的节点关闭才会抛出此事件.</p>
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>item</code></td><td>触发鼠标事件的项呈示器数据源项.</td></tr>
		 *   <tr><td><code>itemRenderer</code></td><td>触发鼠标事件的项呈示器.</td></tr>
		 *   <tr><td><code>itemIndex</code></td><td>触发鼠标事件的项索引.</td></tr>
		 *   <tr><td><code>opening</code></td><td>即将出现的状态.</td></tr>
		 * </table>
		 * @eventType itemClose
		 */
		public static const ITEM_CLOSE:String = "itemClose";
		
		/**
		 * 节点打开.
		 * <p>注意: 只有通过交互操作引起的节点打开才会抛出此事件.</p>
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>item</code></td><td>触发鼠标事件的项呈示器数据源项.</td></tr>
		 *   <tr><td><code>itemRenderer</code></td><td>触发鼠标事件的项呈示器.</td></tr>
		 *   <tr><td><code>itemIndex</code></td><td>触发鼠标事件的项索引.</td></tr>
		 *   <tr><td><code>opening</code></td><td>即将出现的状态.</td></tr>
		 * </table>
		 * @eventType itemOpen
		 */
		public static const ITEM_OPEN:String = "itemOpen";
		
		/**
		 * 子节点打开或关闭前一刻分派.
		 * <p>可以调用 <code>preventDefault()</code> 方法阻止节点的状态改变.</p>
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>item</code></td><td>触发鼠标事件的项呈示器数据源项.</td></tr>
		 *   <tr><td><code>itemRenderer</code></td><td>触发鼠标事件的项呈示器.</td></tr>
		 *   <tr><td><code>itemIndex</code></td><td>触发鼠标事件的项索引.</td></tr>
		 *   <tr><td><code>opening</code></td><td>即将出现的状态.</td></tr>
		 * </table>
		 * @eventType itemOpening
		 */
		public static const ITEM_OPENING:String = "itemOpening";
		
		private var _item:Object;
		private var _itemRenderer:TreeItemRenderer;
		private var _itemIndex:int;
		private var _opening:Boolean;
		
		/**
		 * 创建一个 <code>TreeEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 * @param itemIndex 触发鼠标事件的项索引.
		 * @param item 触发鼠标事件的项呈示器数据源项.
		 * @param itemRenderer 触发鼠标事件的项呈示器.
		 */
		public function TreeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, itemIndex:int = -1, item:Object = null, itemRenderer:TreeItemRenderer = null)
		{
			super(type, bubbles, cancelable);
			_item = item;
			_itemRenderer = itemRenderer;
			_itemIndex = itemIndex;
		}
		
		/**
		 * 获取触发鼠标事件的项呈示器数据源项.
		 */
		public function get item():Object
		{
			return _item;
		}
		
		/**
		 * 获取触发鼠标事件的项呈示器.
		 */
		public function get itemRenderer():TreeItemRenderer
		{
			return _itemRenderer;
		}
		
		/**
		 * 获取触发鼠标事件的项索引.
		 */
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		/**
		 * 设置或获取即将出现的状态.
		 * <p>当事件类型为 ITEM_OPENING 时, true 表示即将打开节点, 反之关闭.</p>
		 */
		public function set opening(value:Boolean):void
		{
			_opening = value;
		}
		public function get opening():Boolean
		{
			return _opening;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			var cloneEvent:TreeEvent = new TreeEvent(this.type, this.bubbles, this.cancelable, this.itemIndex, this.item, this.itemRenderer);
			cloneEvent.opening = this.opening;
			return cloneEvent;
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("TreeEvent", "type", "bubbles", "cancelable", "itemIndex", "item", "itemRenderer", "opening");
		}
	}
}
