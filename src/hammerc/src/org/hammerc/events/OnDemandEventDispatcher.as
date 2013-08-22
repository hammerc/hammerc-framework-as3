/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>OnDemandEventDispatcher</code> 类实现了可以分派事件但不常侦听的对象.
	 * <p>只有在附加了监听器时才会初始化一个 <code>EventDispatcher</code> 实例, 而不是每次都实例化一个.</p>
	 * @author wizardc
	 */
	public class OnDemandEventDispatcher implements IEventDispatcher
	{
		private var _target:IEventDispatcher;
		private var _dispatcher:EventDispatcher;
		
		/**
		 * 创建一个 <code>OnDemandEventDispatcher</code> 对象.
		 * @param target 事件的目标对象.
		 */
		public function OnDemandEventDispatcher(target:IEventDispatcher = null)
		{
			_target = target;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if(_dispatcher == null)
			{
				_dispatcher = new EventDispatcher(_target);
			}
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			if(_dispatcher != null)
			{
				return _dispatcher.dispatchEvent(event);
			}
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			if(_dispatcher != null)
			{
				return _dispatcher.hasEventListener(type);
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if(_dispatcher != null)
			{
				_dispatcher.removeEventListener(type,listener,useCapture);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean
		{
			if(_dispatcher != null)
			{
				return _dispatcher.willTrigger(type);
			}
			return false;
		}
	}
}
