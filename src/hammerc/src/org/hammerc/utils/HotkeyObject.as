// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.utils
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.hammerc.events.HotkeyEvent;
	
	/**
	 * @eventType org.hammerc.events.HotkeyEvent.HOTKEY_COMPLETE
	 */
	[Event(name="hotkeyComplete",type="org.hammerc.events.HotkeyEvent")]
	
	/**
	 * <code>HotkeyObject</code> 类提供了侦听一组热键的功能.
	 * <p>设置侦听键盘按键时请使用 <code>Keyborad</code> 类的静态常量, 侦听鼠标按键时请使用本类的静态常量.</p>
	 * @author wizardc
	 */
	public class HotkeyObject extends EventDispatcher
	{
		/**
		 * 与鼠标左键关联的常数.
		 */
		public static const MOUSE_LEFT:uint = 0x0c000000;
		
		/**
		 * 与鼠标中键关联的常数.
		 */
		public static const MOUSE_MIDDLE:uint = 0x0c000001;
		
		/**
		 * 与鼠标右键关联的常数.
		 */
		public static const MOUSE_RIGHT:uint = 0x0c000002;
		
		/**
		 * 记录需要侦听热键的交互对象.
		 */
		protected var _interactiveObject:InteractiveObject;
		
		/**
		 * 记录热键对象的名称.
		 */
		protected var _name:String;
		
		/**
		 * 记录需要连续按下的按键列表.
		 */
		protected var _keys:Vector.<uint>;
		
		/**
		 * 记录连续按下的有效间隔时间, 单位毫秒.
		 */
		protected var _intervalTime:int;
		
		/**
		 * 记录触发热键完成事件时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 */
		protected var _releaseKey:Boolean;
		
		/**
		 * 当前是否正在进行热键侦听.
		 */
		protected var _listening:Boolean = false;
		
		private var _timeoutID:uint;
		private var _currentKeyIndex:int;
		
		/**
		 * 创建一个 <code>HotkeyObject</code> 对象.
		 * @param interactiveObject 需要侦听热键的交互对象.
		 * @param name 热键对象的名称.
		 * @param keys 需要连续按下的按键列表.
		 * @param intervalTime 连续按下的有效间隔时间, 单位毫秒.
		 * @param releaseKey 触发热键完成事件时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 * throws Error 参数 <code>interactiveObject</code> 为空时抛出该异常.
		 */
		public function HotkeyObject(interactiveObject:InteractiveObject, name:String = null, keys:Vector.<uint> = null, intervalTime:int = 500, releaseKey:Boolean = false)
		{
			if(interactiveObject == null)
			{
				throw new Error("参数\"interactiveObject\"不能为\"null\"！");
			}
			_interactiveObject = interactiveObject;
			_name = name;
			this.keys = keys;
			this.intervalTime = intervalTime;
			this.releaseKey = releaseKey;
		}
		
		/**
		 * 获取侦听热键的交互对象.
		 */
		public function get interactiveObject():InteractiveObject
		{
			return _interactiveObject;
		}
		
		/**
		 * 获取热键对象的名称.
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * 设置或获取需要连续按下的按键列表.
		 * <p>开始侦听热键后本属性不可更改.</p>
		 */
		public function set keys(value:Vector.<uint>):void
		{
			if(!_listening)
			{
				_keys = value;
			}
		}
		public function get keys():Vector.<uint>
		{
			if(_keys != null)
			{
				return _keys.concat();
			}
			return null;
		}
		
		/**
		 * 设置或获取连续按下的有效间隔时间, 单位毫秒.
		 */
		public function set intervalTime(value:int):void
		{
			_intervalTime = Math.max(0, value);
		}
		public function get intervalTime():int
		{
			return _intervalTime;
		}
		
		/**
		 * 设置或获取触发热键完成事件时最后一个按键是按下 (<code>false</code>) 还是释放 (<code>true</code>).
		 */
		public function set releaseKey(value:Boolean):void
		{
			_releaseKey = value;
		}
		public function get releaseKey():Boolean
		{
			return _releaseKey;
		}
		
		/**
		 * 开始热键侦听.
		 * @throws Error 当没有设置需要连续按下的按键列表或该列表为空时抛出该异常.
		 */
		public function start():void
		{
			if(_keys == null || _keys.length == 0)
			{
				throw new Error("需要连续按下的按键列表不能为空或长度为0！");
			}
			_currentKeyIndex = 0;
			registeEvents();
			_listening = true;
		}
		
		private function registeEvents():void
		{
			_interactiveObject.addEventListener(KeyboardEvent.KEY_DOWN, hotkeyHandler);
			_interactiveObject.addEventListener(KeyboardEvent.KEY_UP, hotkeyHandler);
			_interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, hotkeyHandler);
			_interactiveObject.addEventListener(MouseEvent.MOUSE_UP, hotkeyHandler);
			_interactiveObject.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, hotkeyHandler);
			_interactiveObject.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, hotkeyHandler);
			_interactiveObject.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, hotkeyHandler);
			_interactiveObject.addEventListener(MouseEvent.RIGHT_MOUSE_UP, hotkeyHandler);
		}
		
		private function unregisteEvents():void
		{
			_interactiveObject.removeEventListener(KeyboardEvent.KEY_DOWN, hotkeyHandler);
			_interactiveObject.removeEventListener(KeyboardEvent.KEY_UP, hotkeyHandler);
			_interactiveObject.removeEventListener(MouseEvent.MOUSE_DOWN, hotkeyHandler);
			_interactiveObject.removeEventListener(MouseEvent.MOUSE_UP, hotkeyHandler);
			_interactiveObject.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, hotkeyHandler);
			_interactiveObject.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, hotkeyHandler);
			_interactiveObject.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, hotkeyHandler);
			_interactiveObject.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, hotkeyHandler);
		}
		
		private function hotkeyHandler(event:Event):void
		{
			var key:uint;
			var release:Boolean;
			if(event is KeyboardEvent)
			{
				key = (event as KeyboardEvent).keyCode;
				release = event.type == KeyboardEvent.KEY_UP;
			}
			else if(event is MouseEvent)
			{
				if(event.type == MouseEvent.MOUSE_DOWN || event.type == MouseEvent.MOUSE_UP)
				{
					key = MOUSE_LEFT;
					release = event.type == MouseEvent.MOUSE_UP;
				}
				else if(event.type == MouseEvent.MIDDLE_MOUSE_DOWN || event.type == MouseEvent.MIDDLE_MOUSE_UP)
				{
					key = MOUSE_MIDDLE;
					release = event.type == MouseEvent.MIDDLE_MOUSE_UP;
				}
				else if(event.type == MouseEvent.RIGHT_MOUSE_DOWN || event.type == MouseEvent.RIGHT_MOUSE_UP)
				{
					key = MOUSE_RIGHT;
					release = event.type == MouseEvent.RIGHT_MOUSE_UP;
				}
			}
			//按下的就是等待的按键时
			if(!release && key == _keys[_currentKeyIndex])
			{
				clearTimeout(_timeoutID);
				_currentKeyIndex++;
				//已经是最后的按键了
				if(_currentKeyIndex == keys.length)
				{
					//如果最后的按键不需要释放时
					if(!_releaseKey)
					{
						_currentKeyIndex = 0;
						this.dispatchEvent(new HotkeyEvent(HotkeyEvent.HOTKEY_COMPLETE, _name, false));
					}
					//最后的按键需要释放
					else
					{
						_timeoutID = setTimeout(hotkeyTimeout, _intervalTime);
					}
				}
				//不是最后的按键时
				else
				{
					_timeoutID = setTimeout(hotkeyTimeout, _intervalTime);
				}
			}
			//释放的是最后的按键同时侦听的是最后按键释放时
			if(release && _currentKeyIndex == keys.length && key == _keys[_currentKeyIndex - 1] && _releaseKey)
			{
				clearTimeout(_timeoutID);
				_currentKeyIndex = 0;
				this.dispatchEvent(new HotkeyEvent(HotkeyEvent.HOTKEY_COMPLETE, _name, true));
			}
		}
		
		private function hotkeyTimeout():void
		{
			_currentKeyIndex = 0;
		}
		
		/**
		 * 停止热键侦听.
		 */
		public function stop():void
		{
			clearTimeout(_timeoutID);
			_currentKeyIndex = 0;
			unregisteEvents();
			_listening = false;
		}
	}
}
