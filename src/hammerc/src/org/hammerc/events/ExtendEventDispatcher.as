/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.EventDispatcher;
	
	/**
	 * <code>ExtendEventDispatcher</code> 类实现了事件的管理.
	 * @author wizardc
	 */
	public class ExtendEventDispatcher extends EventDispatcher implements IExtendEventDispatcher
	{
		/**
		 * 记录捕获阶段的所有事件.
		 */
		protected var _bubbleEventMap:Object;
		
		/**
		 * 记录目标和冒泡阶段的所有事件.
		 */
		protected var _captureEventMap:Object;
		
		/**
		 * 创建一个 <code>ExtendEventDispatcher</code> 对象.
		 */
		public function ExtendEventDispatcher()
		{
			_bubbleEventMap = new Object();
			_captureEventMap = new Object();
		}
		
		/**
		 * 注册一个事件侦听.
		 * @param type 事件的类型.
		 * @param listener 处理事件的侦听器函数.
		 * @param useCapture 确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段.
		 * @param priority 事件侦听器的优先级.
		 * @param useWeakReference 确定对侦听器的引用是强引用, 还是弱引用.
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			var eventMap:Object = useCapture ? _captureEventMap : _bubbleEventMap;
			if(!eventMap.hasOwnProperty(type))
			{
				eventMap[type] = new Vector.<Function>();
			}
			var listenerList:Vector.<Function> = eventMap[type] as Vector.<Function>;
			if(listenerList.indexOf(listener) == -1)
			{
				listenerList.push(listener);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasListener(type:String, listener:Function, useCapture:Boolean = false):Boolean
		{
			var eventMap:Object = useCapture ? _captureEventMap : _bubbleEventMap;
			if(!eventMap.hasOwnProperty(type))
			{
				return false;
			}
			var listenerList:Vector.<Function> = eventMap[type] as Vector.<Function>;
			if(listenerList.indexOf(listener) == -1)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getListenerType(listener:Function, useCapture:Boolean = false):Vector.<String>
		{
			var eventMap:Object = useCapture ? _captureEventMap : _bubbleEventMap;
			var result:Vector.<String> = new Vector.<String>();
			for(var key:String in eventMap)
			{
				var listenerList:Vector.<Function> = eventMap[key] as Vector.<Function>;
				if(listenerList.indexOf(listener) != -1)
				{
					result.push(key);
				}
			}
			return result;
		}
		
		/**
		 * 移除一个事件侦听.
		 * @param type 事件的类型.
		 * @param listener 处理事件的侦听器函数.
		 * @param useCapture 确定侦听器是运行于捕获阶段还是运行于目标和冒泡阶段.
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
			var eventMap:Object = useCapture ? _captureEventMap : _bubbleEventMap;
			if(!eventMap.hasOwnProperty(type))
			{
				return;
			}
			var listenerList:Vector.<Function> = eventMap[type] as Vector.<Function>;
			var index:int = listenerList.indexOf(listener);
			if(index != -1)
			{
				listenerList.splice(index, 1);
				if(listenerList.length == 0)
				{
					delete eventMap[type];
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListenersByType(type:String, useCapture:Boolean = false):void
		{
			var eventMap:Object = useCapture ? _captureEventMap : _bubbleEventMap;
			if(!eventMap.hasOwnProperty(type))
			{
				return;
			}
			var listenerList:Vector.<Function> = eventMap[type] as Vector.<Function>;
			for each(var listener:Function in listenerList)
			{
				super.removeEventListener(type, listener, useCapture);
			}
			delete eventMap[type];
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllEventListenersByCapture(useCapture:Boolean = false):void
		{
			var eventMap:Object = useCapture ? _captureEventMap : _bubbleEventMap;
			for(var key:String in eventMap)
			{
				this.removeEventListenersByType(key, useCapture);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void
		{
			this.removeAllEventListenersByCapture(true);
			this.removeAllEventListenersByCapture(false);
		}
	}
}
