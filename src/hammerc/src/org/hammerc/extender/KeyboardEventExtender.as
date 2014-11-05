// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.extender
{
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.hammerc.events.ExtendKeyboardEvent;
	
	/**
	 * @eventType org.hammerc.events.ExtendKeyboardEvent.MULTI_KEY_DOWN
	 */
	[Event(name="multiKeyDowm",type="org.hammerc.events.ExtendKeyboardEvent")]
	
	/**
	 * @eventType org.hammerc.events.ExtendKeyboardEvent.ALWAYS_KEY_DOWN
	 */
	[Event(name="alwaysKeyDown",type="org.hammerc.events.ExtendKeyboardEvent")]
	
	/**
	 * <code>KeyboardEventExtender</code> 类可以为指定的交互对象扩展出丰富的键盘交互事件.
	 * @author wizardc
	 */
	public class KeyboardEventExtender
	{
		/**
		 * 记录需要扩展事件的交互对象.
		 */
		protected var _interactiveObject:InteractiveObject;
		
		/**
		 * 记录是否启用长按功能.
		 */
		protected var _alwaysPressable:Boolean;
		
		/**
		 * 记录长按的延迟时间, 单位毫秒.
		 */
		protected var _alwaysPressDelay:int;
		
		/**
		 * 记录长按的间隔时间, 单位毫秒.
		 */
		protected var _alwaysPressInterval:int;
		
		/**
		 * 记录当前按下的所有键的字符代码列表.
		 */
		protected var _charCodes:Dictionary;
		
		/**
		 * 记录当前按下的所有键的键控代码列表.
		 */
		protected var _keyCodes:Dictionary;
		
		private var _pressTimeout:uint;
		private var _pressInterval:uint;
		
		private var _lastPressKeyboradEvent:KeyboardEvent;
		
		/**
		 * 创建一个 <code>KeyboardEventExtender</code> 对象.
		 * @param interactiveObject 设置需要扩展事件的交互对象.
		 * @param alwaysPressable 设置是否启用长按功能.
		 * @param alwaysPressDelay 设置长按的延迟时间, 单位毫秒.
		 * @param alwaysPressInterval 设置长按的间隔时间, 单位毫秒.
		 */
		public function KeyboardEventExtender(interactiveObject:InteractiveObject = null, alwaysPressable:Boolean = false, alwaysPressDelay:int = 500, alwaysPressInterval:int = 100)
		{
			this.interactiveObject = interactiveObject;
			this.alwaysPressable = alwaysPressable;
			this.alwaysPressDelay = alwaysPressDelay;
			this.alwaysPressInterval = alwaysPressInterval;
			_charCodes = new Dictionary();
			_keyCodes = new Dictionary();
		}
		
		/**
		 * 设置或获取需要扩展事件的交互对象.
		 */
		public function set interactiveObject(value:InteractiveObject):void
		{
			if(_interactiveObject == value)
			{
				return;
			}
			if(_interactiveObject != null)
			{
				unregisteEvents();
				clearTimeout(_pressTimeout);
				clearInterval(_pressInterval);
			}
			_interactiveObject = value;
			if(_interactiveObject != null)
			{
				registeEvents();
			}
		}
		public function get interactiveObject():InteractiveObject
		{
			return _interactiveObject;
		}
		
		/**
		 * 设置或获取是否启用长按功能.
		 */
		public function set alwaysPressable(value:Boolean):void
		{
			_alwaysPressable = value;
			if(!_alwaysPressable)
			{
				clearTimeout(_pressTimeout);
				clearInterval(_pressInterval);
			}
		}
		public function get alwaysPressable():Boolean
		{
			return _alwaysPressable;
		}
		
		/**
		 * 设置或获取长按的延迟时间, 单位毫秒.
		 */
		public function set alwaysPressDelay(value:int):void
		{
			_alwaysPressDelay = Math.max(0, value);
		}
		public function get alwaysPressDelay():int
		{
			return _alwaysPressDelay;
		}
		
		/**
		 * 设置或获取长按的间隔时间, 单位毫秒.
		 */
		public function set alwaysPressInterval(value:int):void
		{
			_alwaysPressInterval = Math.max(0, value);
		}
		public function get alwaysPressInterval():int
		{
			return _alwaysPressInterval;
		}
		
		/**
		 * 获取当前按下的所有键的字符代码列表.
		 */
		public function get charCodes():Vector.<uint>
		{
			return dictionaryToVector(_charCodes);
		}
		
		/**
		 * 获取当前按下的所有键的键控代码列表.
		 */
		public function get keyCodes():Vector.<uint>
		{
			return dictionaryToVector(_keyCodes);
		}
		
		private function dictionaryToVector(dictionary:Dictionary):Vector.<uint>
		{
			var result:Vector.<uint> = new Vector.<uint>();
			for(var key:* in dictionary)
			{
				result.push(key);
			}
			return result;
		}
		
		private function registeEvents():void
		{
			_interactiveObject.addEventListener(KeyboardEvent.KEY_DOWN, keyboardEventsHandler);
			_interactiveObject.addEventListener(KeyboardEvent.KEY_UP, keyboardEventsHandler);
		}
		
		private function unregisteEvents():void
		{
			_interactiveObject.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardEventsHandler);
			_interactiveObject.removeEventListener(KeyboardEvent.KEY_UP, keyboardEventsHandler);
		}
		
		private function keyboardEventsHandler(event:KeyboardEvent):void
		{
			switch(event.type)
			{
				case KeyboardEvent.KEY_DOWN:
					if(_keyCodes[event.keyCode] == null)
					{
						_charCodes[event.charCode] = true;
						_keyCodes[event.keyCode] = true;
						this.dispatchKeyboardEvent(ExtendKeyboardEvent.MULTI_KEY_DOWN, event);
						if(_alwaysPressable)
						{
							clearTimeout(_pressTimeout);
							clearInterval(_pressInterval);
							_lastPressKeyboradEvent = event.clone() as KeyboardEvent;
							_pressTimeout = setTimeout(alwaysPressStart, _alwaysPressDelay);
						}
					}
					break;
				case KeyboardEvent.KEY_UP:
					delete _charCodes[event.charCode];
					delete _keyCodes[event.keyCode];
					if(_lastPressKeyboradEvent != null && _lastPressKeyboradEvent.keyCode == event.keyCode)
					{
						clearTimeout(_pressTimeout);
						clearInterval(_pressInterval);
						_lastPressKeyboradEvent = null;
					}
					break;
			}
		}
		
		/**
		 * 播放键盘扩展事件.
		 */
		protected function dispatchKeyboardEvent(type:String, keyboardEvent:KeyboardEvent):void
		{
			_interactiveObject.dispatchEvent(new ExtendKeyboardEvent(type, this.charCodes, this.keyCodes, keyboardEvent.charCode, keyboardEvent.keyCode, keyboardEvent.keyLocation, keyboardEvent.ctrlKey, keyboardEvent.altKey, keyboardEvent.shiftKey));
		}
		
		private function alwaysPressStart():void
		{
			this.dispatchKeyboardEvent(ExtendKeyboardEvent.ALWAYS_KEY_DOWN, _lastPressKeyboradEvent);
			_pressInterval = setInterval(dispatchAlwaysPressEvent, _alwaysPressInterval);
		}
		
		private function dispatchAlwaysPressEvent():void
		{
			this.dispatchKeyboardEvent(ExtendKeyboardEvent.ALWAYS_KEY_DOWN, _lastPressKeyboradEvent);
		}
		
		/**
		 * 销毁键盘扩展对象.
		 */
		public function destroy():void
		{
			this.interactiveObject = null;
			this.alwaysPressable = false;
			this.alwaysPressDelay = 500;
			this.alwaysPressInterval = 100;
		}
	}
}
