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
	 * <code>SimulateAsyncEvent</code> 类定义了模拟异步处理类发送的事件对象.
	 * @author wizardc
	 */
	public class SimulateAsyncEvent extends Event
	{
		/**
		 * 一个代码段执行完毕时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>runTime</code></td><td>代码段执行时间.</td></tr>
		 *   <tr><td><code>id</code></td><td>代码段的标示 ID.</td></tr>
		 *   <tr><td><code>error</code></td><td>代码段执行错误信息.</td></tr>
		 * </table>
		 * @eventType snippetDone
		 */
		public static const SNIPPET_DONE:String = "snippetDone";
		
		/**
		 * 一个代码段执行错误时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>runTime</code></td><td>代码段执行时间.</td></tr>
		 *   <tr><td><code>id</code></td><td>代码段的标示 ID.</td></tr>
		 *   <tr><td><code>error</code></td><td>代码段执行错误信息.</td></tr>
		 * </table>
		 * @eventType snippetRunningError
		 */
		public static const SNIPPET_RUNNING_ERROR:String = "snippetRunningError";
		
		/**
		 * 所有代码段都执行完毕时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>runTime</code></td><td>代码段执行时间.</td></tr>
		 *   <tr><td><code>id</code></td><td>代码段的标示 ID.</td></tr>
		 *   <tr><td><code>error</code></td><td>代码段执行错误信息.</td></tr>
		 * </table>
		 * @eventType complete
		 */
		public static const COMPLETE:String = "complete";
		
		private var _runTime:int;
		private var _id:String;
		private var _error:Error;
		
		/**
		 * 创建一个 <code>SimulateAsyncEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param runTime 代码段执行时间.
		 * @param id 代码段的标示 ID.
		 * @param error 代码段执行错误信息.
		 */
		public function SimulateAsyncEvent(type:String, runTime:int = 0, id:String = null, error:Error = null)
		{
			super(type, false, false);
			_runTime = runTime;
			_id = id;
			_error = error;
		}
		
		/**
		 * 获取代码段执行时间.
		 */
		public function get runTime():int
		{
			return _runTime;
		}
		
		/**
		 * 获取代码段的标示 ID.
		 */
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * 获取代码段执行错误信息.
		 */
		public function get error():Error
		{
			return _error;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new SimulateAsyncEvent(this.type, this.runTime, this.id, this.error);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("SimulateAsyncEvent", "type", "bubbles", "cancelable", "runTime", "id", "error");
		}
	}
}
