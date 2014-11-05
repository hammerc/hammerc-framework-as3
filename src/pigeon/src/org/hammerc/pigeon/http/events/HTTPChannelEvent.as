// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.pigeon.http.events
{
	import flash.events.Event;
	
	/**
	 * <code>HTTPChannelEvent</code> 类定义了 HTTP 请求的事件.
	 * @author wizardc
	 */
	public class HTTPChannelEvent extends Event
	{
		/**
		 * 当服务端有数据到达时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>dataFormat</code></td><td></td></tr>
		 *   <tr><td><code>data</code></td><td></td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送事件的对象.</td></tr>
		 * </table>
		 * @eventType dataArrive
		 */
		public static const DATA_ARRIVE:String = "dataArrive";
		
		private var _dataFormat:String;
		private var _data:Object;
		
		/**
		 * 创建一个 <code>HTTPChannelEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param dataFormat 接收到的数据格式.
		 * @param data 接收到的数据.
		 */
		public function HTTPChannelEvent(type:String, dataFormat:String = null, data:Object = null)
		{
			super(type, false, false);
			_dataFormat = dataFormat;
			_data = data;
		}
		
		/**
		 * 获取接收到的数据格式.
		 * @return 接收到的数据格式.
		 */
		public function get dataFormat():String
		{
			return _dataFormat;
		}
		
		/**
		 * 获取接收到的数据.
		 * @return 接收到的数据.
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 创建该事件的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 与该事件相同的事件对象.
		 */
		override public function clone():Event
		{
			return new HTTPChannelEvent(this.type, this.dataFormat, this.data);
		}
		
		/**
		 * 返回一个字符串, 其中包含该事件的所有属性.
		 * @return 包含该事件的所有属性的字符串.
		 */
		override public function toString():String
		{
			return formatToString("HTTPChannelEvent", "type", "bubbles", "cancelable", "dataFormat", "data");
		}
	}
}
