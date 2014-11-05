// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.pigeon.rpc.events
{
	import flash.events.Event;
	
	import org.hammerc.pigeon.rpc.RemoteFault;
	
	/**
	 * <code>RemoteChannelEvent</code> 类定义了远程通道的事件.
	 * @author wizardc
	 */
	public class RemoteChannelEvent extends Event
	{
		/**
		 * 当和服务端成功连接时触发, 注意根据服务端的配置不同该事件不一定会触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>fault</code></td><td>始终为 <code>null</code>.</td></tr>
		 *   <tr><td><code>result</code></td><td>始终为 <code>null</code>.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送事件的对象.</td></tr>
		 * </table>
		 * @eventType connectSuccess
		 */
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		
		/**
		 * 当和服务端连接失败时触发, 注意根据服务端的配置不同该事件不一定会触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>fault</code></td><td>远程调用失败的消息对象.</td></tr>
		 *   <tr><td><code>result</code></td><td>始终为 <code>null</code>.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送事件的对象.</td></tr>
		 * </table>
		 * @eventType connectFailed
		 */
		public static const CONNECT_FAILED:String = "connectFailed";
		
		/**
		 * 当和服务端连接断开时触发, 注意根据服务端的配置不同该事件不一定会触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>fault</code></td><td>始终为 <code>null</code>.</td></tr>
		 *   <tr><td><code>result</code></td><td>始终为 <code>null</code>.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送事件的对象.</td></tr>
		 * </table>
		 * @eventType connectClosed
		 */
		public static const CONNECT_CLOSED:String = "connectClosed";
		
		/**
		 * 当远程方法调用失败时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>fault</code></td><td>远程调用失败的消息对象.</td></tr>
		 *   <tr><td><code>result</code></td><td>始终为 <code>null</code>.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送事件的对象.</td></tr>
		 * </table>
		 * @eventType serverResult
		 */
		public static const SERVER_RESULT:String = "serverResult";
		
		/**
		 * 当远程方法调用成功并返回数据时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>fault</code></td><td>始终为 <code>null</code>.</td></tr>
		 *   <tr><td><code>result</code></td><td>远程调用成功后获得的服务端返回的数据.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送事件的对象.</td></tr>
		 * </table>
		 * @eventType serverFault
		 */
		public static const SERVER_FAULT:String = "serverFault";
		
		private var _result:Object;
		private var _fault:RemoteFault;
		
		/**
		 * 创建一个 <code>RemoteChannelEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param result 服务端返回的数据.
		 * @param fault 服务端失败的信息.
		 */
		public function RemoteChannelEvent(type:String, result:Object = null, fault:RemoteFault = null)
		{
			super(type, false, false);
			_result = result;
			_fault = fault;
		}
		
		/**
		 * 获取服务端返回的数据.
		 */
		public function get result():Object
		{
			return _result;
		}
		
		/**
		 * 获取服务端失败的信息.
		 */
		public function get fault():RemoteFault
		{
			return _fault;
		}
		
		/**
		 * 创建该事件的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 与该事件相同的事件对象.
		 */
		override public function clone():Event
		{
			return new RemoteChannelEvent(this.type, this.result, this.fault);
		}
		
		/**
		 * 返回一个字符串, 其中包含该事件的所有属性.
		 * @return 包含该事件的所有属性的字符串.
		 */
		override public function toString():String
		{
			return formatToString("RemoteChannelEvent", "type", "bubbles", "cancelable", "result", "fault");
		}
	}
}
