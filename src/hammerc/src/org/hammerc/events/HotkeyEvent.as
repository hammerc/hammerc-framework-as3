/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	
	/**
	 * <code>HotkeyEvent</code> 类为热键的事件类.
	 * @author wizardc
	 */
	public class HotkeyEvent extends Event
	{
		/**
		 * 当预设的热键完成时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>hotkeyName</code></td><td>热键的名称.</td></tr>
		 *   <tr><td><code>releaseKey</code></td><td>完成时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType hotkeyComplete
		 */
		public static const HOTKEY_COMPLETE:String = "hotkeyComplete";
		
		private var _hotkeyName:String;
		private var _releaseKey:Boolean;
		
		/**
		 * 创建一个 <code>HotkeyEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param hotkeyName 热键的名称.
		 * @param releaseKey 完成时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 */
		public function HotkeyEvent(type:String, hotkeyName:String, releaseKey:Boolean)
		{
			super(type, false, false);
			_hotkeyName = hotkeyName;
			_releaseKey = releaseKey;
		}
		
		/**
		 * 获取热键的名称.
		 */
		public function get hotkeyName():String
		{
			return _hotkeyName;
		}
		
		/**
		 * 获取完成时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 */
		public function get releaseKey():Boolean
		{
			return _releaseKey;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new HotkeyEvent(this.type, this.hotkeyName, this.releaseKey);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("HotkeyEvent", "type", "bubbles", "cancelable", "hotkeyName", "releaseKey");
		}
	}
}
