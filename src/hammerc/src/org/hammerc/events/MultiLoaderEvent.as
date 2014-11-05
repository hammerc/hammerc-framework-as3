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
	
	import org.hammerc.load.MultiLoaderItem;
	
	/**
	 * <code>MultiLoaderEvent</code> 类定义了多项载入对象的事件.
	 * @see org.hammerc.load.MultiLoaderQueue
	 * @author wizardc
	 */
	public class MultiLoaderEvent extends Event
	{
		/**
		 * 每当多项下载开始时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>item</code></td><td>当前的下载项.</td></tr>
		 *   <tr><td><code>numLoaded</code></td><td>当前下载的项目索引.</td></tr>
		 *   <tr><td><code>numTotal</code></td><td>需要下载的项目总数.</td></tr>
		 *   <tr><td><code>itemBytesLoaded</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>itemBytesTotal</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>networkSpeed</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType multiLoadStart
		 */
		public static const MULTI_LOAD_START:String = "multiLoadStart";
		
		/**
		 * 每当进行网络下载时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>item</code></td><td>当前的下载项.</td></tr>
		 *   <tr><td><code>numLoaded</code></td><td>当前下载的项目索引.</td></tr>
		 *   <tr><td><code>numTotal</code></td><td>需要下载的项目总数.</td></tr>
		 *   <tr><td><code>itemBytesLoaded</code></td><td>当前下载项已下载的字节.</td></tr>
		 *   <tr><td><code>itemBytesTotal</code></td><td>当前下载项要下载的字节.</td></tr>
		 *   <tr><td><code>networkSpeed</code></td><td>当前的网速.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType multiLoadProgress
		 */
		public static const MULTI_LOAD_PROGRESS:String = "multiLoadProgress";
		
		/**
		 * 每当一个下载项开始下载时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>item</code></td><td>当前的下载项.</td></tr>
		 *   <tr><td><code>numLoaded</code></td><td>当前下载的项目索引.</td></tr>
		 *   <tr><td><code>numTotal</code></td><td>需要下载的项目总数.</td></tr>
		 *   <tr><td><code>itemBytesLoaded</code></td><td>当前下载项已下载的字节.</td></tr>
		 *   <tr><td><code>itemBytesTotal</code></td><td>当前下载项要下载的字节.</td></tr>
		 *   <tr><td><code>networkSpeed</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType multiLoadItemComplete
		 */
		public static const MULTI_LOAD_ITEM_START:String = "multiLoadItemStart";
		
		/**
		 * 每当一个下载项下载完成时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>item</code></td><td>当前的下载项.</td></tr>
		 *   <tr><td><code>numLoaded</code></td><td>当前下载的项目索引.</td></tr>
		 *   <tr><td><code>numTotal</code></td><td>需要下载的项目总数.</td></tr>
		 *   <tr><td><code>itemBytesLoaded</code></td><td>当前下载项已下载的字节.</td></tr>
		 *   <tr><td><code>itemBytesTotal</code></td><td>当前下载项要下载的字节.</td></tr>
		 *   <tr><td><code>networkSpeed</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType multiLoadItemComplete
		 */
		public static const MULTI_LOAD_ITEM_COMPLETE:String = "multiLoadItemComplete";
		
		/**
		 * 每当一个下载项出现 IO 错误时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>item</code></td><td>当前的下载项.</td></tr>
		 *   <tr><td><code>numLoaded</code></td><td>当前下载的项目索引.</td></tr>
		 *   <tr><td><code>numTotal</code></td><td>需要下载的项目总数.</td></tr>
		 *   <tr><td><code>itemBytesLoaded</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>itemBytesTotal</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>networkSpeed</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType multiLoadItemIOError
		 */
		public static const MULTI_LOAD_ITEM_IO_ERROR:String = "multiLoadItemIOError";
		
		/**
		 * 每当一个下载项出现安全沙箱错误时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>item</code></td><td>当前的下载项.</td></tr>
		 *   <tr><td><code>numLoaded</code></td><td>当前下载的项目索引.</td></tr>
		 *   <tr><td><code>numTotal</code></td><td>需要下载的项目总数.</td></tr>
		 *   <tr><td><code>itemBytesLoaded</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>itemBytesTotal</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>networkSpeed</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType multiLoadItemSecurityError
		 */
		public static const MULTI_LOAD_ITEM_SECURITY_ERROR:String = "multiLoadItemSecurityError";
		
		/**
		 * 每当所有下载项都下载完毕时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>item</code></td><td>始终为 <code>null</code>.</td></tr>
		 *   <tr><td><code>numLoaded</code></td><td>当前下载的项目索引.</td></tr>
		 *   <tr><td><code>numTotal</code></td><td>需要下载的项目总数.</td></tr>
		 *   <tr><td><code>itemBytesLoaded</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>itemBytesTotal</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>networkSpeed</code></td><td>始终为 0.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType multiLoadComplete
		 */
		public static const MULTI_LOAD_COMPLETE:String = "multiLoadComplete";
		
		private var _item:MultiLoaderItem;
		private var _numLoaded:int;
		private var _numTotal:int;
		private var _itemBytesLoaded:uint;
		private var _itemBytesTotal:uint;
		private var _networkSpeed:uint;
		
		/**
		 * 创建一个 <code>MultiLoaderEvent</code> 对象.
		 * @param item 当前的下载项.
		 * @param numLoaded 当前下载的项目索引.
		 * @param numTotal 需要下载的项目总数.
		 * @param itemBytesLoaded 当前下载项已下载的字节.
		 * @param itemBytesTotal 当前下载项要下载的字节.
		 * @param networkSpeed 当前的网速.
		 */
		public function MultiLoaderEvent(type:String, item:MultiLoaderItem, numLoaded:int, numTotal:int, itemBytesLoaded:uint = 0, itemBytesTotal:uint = 0, networkSpeed:uint = 0)
		{
			super(type, false, false);
			_item = item;
			_numLoaded = numLoaded;
			_numTotal = numTotal;
			_itemBytesLoaded = itemBytesLoaded;
			_itemBytesTotal = itemBytesTotal;
			_networkSpeed = networkSpeed;
		}
		
		/**
		 * 获取当前的下载项.
		 */
		public function get item():MultiLoaderItem
		{
			return _item;
		}
		
		/**
		 * 获取当前下载的项目索引.
		 */
		public function get numLoaded():int
		{
			return _numLoaded;
		}
		
		/**
		 * 获取需要下载的项目总数.
		 */
		public function get numTotal():int
		{
			return _numTotal;
		}
		
		/**
		 * 获取当前下载项已下载的字节.
		 */
		public function get itemBytesLoaded():uint
		{
			return _itemBytesLoaded;
		}
		
		/**
		 * 获取当前下载项要下载的字节.
		 */
		public function get itemBytesTotal():uint
		{
			return _itemBytesTotal;
		}
		
		/**
		 * 获取当前的网速.
		 */
		public function get networkSpeed():uint
		{
			return _networkSpeed;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new MultiLoaderEvent(this.type, this.item, this.numLoaded, this.numTotal, this.itemBytesLoaded, this.itemBytesTotal, this.networkSpeed);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("MultiLoaderEvent", "type", "bubbles", "cancelable", "item", "numLoaded", "numTotal", "itemBytesLoaded", "itemBytesTotal", "networkSpeed");
		}
	}
}
