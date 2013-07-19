/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	
	import org.hammerc.events.HotkeyEvent;
	
	/**
	 * @eventType org.hammerc.events.HotkeyEvent.HOTKEY_COMPLETE
	 */
	[Event(name="hotkeyComplete",type="org.hammerc.events.HotkeyEvent")]
	
	/**
	 * <code>HotkeyManager</code> 类提供了管理多个热键的功能.
	 * @author wizardc
	 */
	public class HotkeyManager extends EventDispatcher
	{
		/**
		 * 从配置好的字符串中取出按键列表, 使用 "," 号分隔, 鼠标左键使用 "ML", 鼠标中键使用 "MM", 鼠标右键使用 "MR".
		 * <p>例如可以使用下面的字符串取出按键列表而无需麻烦的进行创建: <code>var keys:Vector.&lt;uint&gt; = HotkeyManager.getKeys("w,s,s,d,ml");</code>.</p>
		 * @param source 需要取出按键列表的字符串.
		 * @return 对应的按键列表.
		 */
		public static function getKeys(source:String):Vector.<uint>
		{
			var keys:Vector.<uint> = new Vector.<uint>();
			var keyList:Array = source.toUpperCase().split(",");
			for each(var char:String in keyList)
			{
				if(char == "ML")
				{
					keys.push(HotkeyObject.MOUSE_LEFT);
				}
				else if(char == "MM")
				{
					keys.push(HotkeyObject.MOUSE_MIDDLE);
				}
				else if(char == "MR")
				{
					keys.push(HotkeyObject.MOUSE_RIGHT);
				}
				else
				{
					keys.push(uint(char.charCodeAt()));
				}
			}
			return keys;
		}
		
		/**
		 * 记录需要侦听热键的交互对象.
		 */
		protected var _interactiveObject:InteractiveObject;
		
		/**
		 * 记录所有热键的列表对象.
		 */
		protected var _hotkeyList:Vector.<HotkeyObject>;
		
		/**
		 * 创建一个 <code>HotkeyManager</code> 对象.
		 * @param interactiveObject 需要侦听热键的交互对象.
		 * throws Error 参数 <code>interactiveObject</code> 为空时抛出该异常.
		 */
		public function HotkeyManager(interactiveObject:InteractiveObject)
		{
			if(interactiveObject == null)
			{
				throw new Error("参数\"interactiveObject\"不能为\"null\"！");
			}
			_interactiveObject = interactiveObject;
			_hotkeyList = new Vector.<HotkeyObject>();
		}
		
		/**
		 * 获取侦听热键的交互对象.
		 */
		public function get interactiveObject():InteractiveObject
		{
			return _interactiveObject;
		}
		
		/**
		 * 获取所有热键的列表.
		 */
		public function get hotkeys():Vector.<HotkeyObject>
		{
			return _hotkeyList.concat();
		}
		
		/**
		 * 添加一组热键并立即进行热键侦听.
		 * @param hotkeyName 热键名称.
		 * @param keys 需要连续按下的按键列表.
		 * @param intervalTime 连续按下的有效间隔时间, 单位毫秒.
		 * @param releaseKey 触发热键完成事件时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 * @return 关联该组热键的热键对象.
		 */
		public function addHotkey(hotkeyName:String, keys:Vector.<uint>, intervalTime:int = 500, releaseKey:Boolean = false):HotkeyObject
		{
			var hotkeyObject:HotkeyObject = new HotkeyObject(_interactiveObject, hotkeyName, keys, intervalTime, releaseKey);
			hotkeyObject.addEventListener(HotkeyEvent.HOTKEY_COMPLETE, hotkeyCompleteHandler);
			hotkeyObject.start();
			_hotkeyList.push(hotkeyObject);
			return hotkeyObject;
		}
		
		private function hotkeyCompleteHandler(event:HotkeyEvent):void
		{
			this.dispatchEvent(event);
		}
		
		/**
		 * 获取一组热键对象.
		 * @param hotkeyName 热键名称.
		 * @param releaseKey 触发热键完成事件时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 * @return 指定的热键对象.
		 */
		public function getHotkey(hotkeyName:String, releaseKey:Boolean = false):HotkeyObject
		{
			for each(var hotkeyObject:HotkeyObject in _hotkeyList)
			{
				if(hotkeyObject.name == hotkeyName && hotkeyObject.releaseKey == releaseKey)
				{
					return hotkeyObject;
				}
			}
			return null;
		}
		
		/**
		 * 判断指定的热键对象是否存在.
		 * @param hotkeyName 热键名称.
		 * @param releaseKey 触发热键完成事件时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 * @return 如果指定的热键对象存在则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function hasHotkey(hotkeyName:String, releaseKey:Boolean = false):Boolean
		{
			for each(var hotkeyObject:HotkeyObject in _hotkeyList)
			{
				if(hotkeyObject.name == hotkeyName && hotkeyObject.releaseKey == releaseKey)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 移除并停止指定的热键对象.
		 * @param hotkeyName 热键名称.
		 * @param releaseKey 触发热键完成事件时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 * @return 移除的热键对象.
		 */
		public function removeHotkey(hotkeyName:String, releaseKey:Boolean = false):HotkeyObject
		{
			var hotkeyObject:HotkeyObject = this.getHotkey(hotkeyName, releaseKey);
			if(hotkeyObject != null)
			{
				_hotkeyList.splice(_hotkeyList.indexOf(hotkeyObject), 1);
				hotkeyObject.removeEventListener(HotkeyEvent.HOTKEY_COMPLETE, hotkeyCompleteHandler);
				hotkeyObject.stop();
				return hotkeyObject;
			}
			return null;
		}
		
		/**
		 * 移除并停止所有的热键对象.
		 */
		public function removeAllHotkeys():void
		{
			for each(var hotkeyObject:HotkeyObject in _hotkeyList)
			{
				hotkeyObject.removeEventListener(HotkeyEvent.HOTKEY_COMPLETE, hotkeyCompleteHandler);
				hotkeyObject.stop();
			}
			_hotkeyList.length = 0;
		}
	}
}
