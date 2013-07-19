/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * <code>ExtendKeyboardEvent</code> 类为键盘扩展对象播放的事件类.
	 * <p>注意: 相对于自带的 <code>KeyboardEvent</code> 而言, 本事件并不会冒泡.</p>
	 * @author wizardc
	 */
	public class ExtendKeyboardEvent extends KeyboardEvent
	{
		/**
		 * 当有按键按下时会播放该事件, 同时能获取到当前按下的所有按键值.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>charCodes</code></td><td>按下的所有键的字符代码列表.</td></tr>
		 *   <tr><td><code>keyCodes</code></td><td>按下的所有键的键控代码列表.</td></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>charCode</code></td><td>按下或释放的键的字符代码值.</td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>keyCode</code></td><td>按下或释放的键的键控代码值.</td></tr>
		 *   <tr><td><code>keyLocation</code></td><td>按键在键盘上的位置.</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType multiKeyDowm
		 */
		public static const MULTI_KEY_DOWN:String = "multiKeyDowm";
		
		/**
		 * 当有按键一直处在按下状态时, 会根据设定每隔一定时间播放一次该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>charCodes</code></td><td>按下的所有键的字符代码列表.</td></tr>
		 *   <tr><td><code>keyCodes</code></td><td>按下的所有键的键控代码列表.</td></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>charCode</code></td><td>按下或释放的键的字符代码值.</td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>keyCode</code></td><td>按下或释放的键的键控代码值.</td></tr>
		 *   <tr><td><code>keyLocation</code></td><td>按键在键盘上的位置.</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType alwaysKeyDown
		 */
		public static const ALWAYS_KEY_DOWN:String = "alwaysKeyDown";
		
		private var _charCodes:Vector.<uint>;
		private var _keyCodes:Vector.<uint>;
		
		/**
		 * 创建一个 <code>ExtendKeyboardEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param charCodes 按下的所有键的字符代码列表.
		 * @param keyCodes 按下的所有键的键控代码列表.
		 * @param charCode 按下或释放的键的字符代码值.
		 * @param keyCode 按下或释放的键的键控代码值.
		 * @param keyLocation 按键在键盘上的位置.
		 * @param ctrlKey 指示是否已激活 Ctrl 键.
		 * @param altKey 指示是否已激活 Alt 键(仅限 Windows).
		 * @param shiftKey 指示是否已激活 Shift 键.
		 */
		public function ExtendKeyboardEvent(type:String, charCodes:Vector.<uint> = null, keyCodes:Vector.<uint> = null, charCode:uint = 0, keyCode:uint = 0, keyLocation:uint = 0, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false)
		{
			super(type, false, false, charCode, keyCode, keyLocation, ctrlKey, altKey, shiftKey);
			_charCodes = charCodes;
			_keyCodes = keyCodes;
		}
		
		/**
		 * 获取按下的所有键的字符代码列表.
		 */
		public function get charCodes():Vector.<uint>
		{
			return _charCodes;
		}
		
		/**
		 * 获取按下的所有键的键控代码列表.
		 */
		public function get keyCodes():Vector.<uint>
		{
			return _keyCodes;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new ExtendKeyboardEvent(this.type, this.charCodes, this.keyCodes, this.charCode, this.keyCode, this.keyLocation, this.ctrlKey, this.altKey, this.shiftKey);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("ExtendKeyboardEvent", "type", "bubbles", "cancelable", "charCodes", "keyCodes", "charCode", "keyCode", "keyLocation", "ctrlKey", "altKey", "shiftKey");
		}
	}
}
