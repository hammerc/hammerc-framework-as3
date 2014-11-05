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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.PropertyChangeEvent;
	
	use namespace flash_proxy;
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.PropertyChangeEvent.PROPERTY_CHANGE
	 */
	[Event(name="propertyChange", type="org.hammerc.events.PropertyChangeEvent")]
	
	/**
	 * <code>ObjectProxy</code> 类可用来代理任意的对象并可以侦听该对象的属性的改变.
	 * <p>如果被代理的对象有属性也为 <code>ObjectProxy</code> 类型则也能侦听到该属性的内部属性改变, 并以此类推.</p>
	 * @author wizardc
	 */
	public dynamic class ObjectProxy extends Proxy implements IEventDispatcher
	{
		private var _eventDispatcher:EventDispatcher;
		private var _target:Object;
		private var _propertyList:Array;
		
		/**
		 * 创建一个 <code>ObjectProxy</code> 对象.
		 * @param target 指定要被代理的对象.
		 */
		public function ObjectProxy(target:Object = null)
		{
			_eventDispatcher = new EventDispatcher(this);
			this.target = target;
		}
		
		/**
		 * 设置或获取要被代理的对象.
		 */
		public function set target(value:Object):void
		{
			if(_target != value)
			{
				if(_target != null)
				{
					for each(var v:* in _target)
					{
						if(v != null && v is ObjectProxy)
						{
							(v as ObjectProxy).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
						}
					}
				}
				_target = value;
				if(_target != null)
				{
					for each(v in _target)
					{
						if(v != null && v is ObjectProxy)
						{
							(v as ObjectProxy).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
						}
					}
				}
			}
		}
		public function get target():Object
		{
			return _target;
		}
		
		/**
		 * 获取事件发送对象.
		 * @return 事件发送对象.
		 */
		hammerc_internal function get eventDispatcher():EventDispatcher
		{
			return _eventDispatcher;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
		
		override flash_proxy function callProperty(name:*, ...args):*
		{
			var method:Function = _target[name] as Function;
			return method.apply(_target, args);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var oldValue:* = _target[name];
			if(oldValue !== value)
			{
				_target[name] = value;
				if(oldValue != null && oldValue is ObjectProxy)
				{
					(oldValue as ObjectProxy).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
				}
				if(value != null && value is ObjectProxy)
				{
					(value as ObjectProxy).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
				}
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, value, oldValue, _target, [name]));
			}
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return _target[name];
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			var oldValue:* = _target[name];
			var result:Boolean = delete _target[name];
			if(oldValue != null && oldValue is ObjectProxy)
			{
				(oldValue as ObjectProxy).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
			}
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, null, oldValue, _target, [name]));
			return result;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return name in _target;
		}
		
		override flash_proxy function nextName(index:int):String
		{
			return _propertyList[index - 1];
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			if(index == 0)
			{
				_propertyList = new Array();
				for(var key:* in _target)
				{
					_propertyList.push(key);
				}
			}
			if(index < _propertyList.length)
			{
				return index + 1;
			}
			else
			{
				return 0;
			}
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			return _target[_propertyList[index - 1]];
		}
		
		private function propertyChangeHandler(event:PropertyChangeEvent):void
		{
			//获取是那个属性发出的
			var key:*;
			for(var name:* in _target)
			{
				var item:* = _target[name];
				if (item != null && item is ObjectProxy && item.hammerc_internal::eventDispatcher == (event.target as ObjectProxy).hammerc_internal::eventDispatcher)
				{
					key = name;
					break;
				}
			}
			//添加属性名称到属性层级记录数组中
			var property:Array = event.property as Array;
			property.unshift(key);
			//继续发送事件
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, event.isDelete, event.newValue, event.oldValue, event.source, property));
		}
	}
}
