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
	 * <code>SkinPartEvent</code> 类为皮肤组件附加移除事件类.
	 * @author wizardc
	 */
	public class SkinPartEvent extends Event
	{
		/**
		 * 当添加皮肤公共子部件时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>partName</code></td><td>添加或移除的皮肤组件的实例名.</td></tr>
		 *   <tr><td><code>instance</code></td><td>添加或移除的皮肤组件实例.</td></tr>
		 * </table>
		 * @eventType partAdded
		 */
		public static const PART_ADDED:String = "partAdded";
		
		/**
		 * 当移除皮肤公共子部件时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>partName</code></td><td>添加或移除的皮肤组件的实例名.</td></tr>
		 *   <tr><td><code>instance</code></td><td>添加或移除的皮肤组件实例.</td></tr>
		 * </table>
		 * @eventType partRemoved
		 */
		public static const PART_REMOVED:String = "partRemoved";
		
		private var _partName:String;
		private var _instance:Object;
		
		/**
		 * 创建一个 <code>ResizedEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param partName 添加或移除的皮肤组件的实例名.
		 * @param instance 添加或移除的皮肤组件实例.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 */
		public function SkinPartEvent(type:String, partName:String, instance:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_partName = partName;
			_instance = instance;
		}
		
		/**
		 * 获取添加或移除的皮肤组件的实例名.
		 */
		public function get partName():String
		{
			return _partName;
		}
		
		/**
		 * 获取添加或移除的皮肤组件实例.
		 */
		public function get instance():Object
		{
			return _instance;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new SkinPartEvent(this.type, this.partName, this.instance, this.bubbles, this.cancelable);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("SkinPartEvent", "type", "bubbles", "cancelable", "partName", "instance");
		}
	}
}
