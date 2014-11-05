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
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy;
	
	/**
	 * <code>OrderedObject</code> 类可以记录属性添加时的顺序.
	 * @author wizardc
	 */
	public dynamic class OrderedObject extends Proxy
	{
		private var _target:Object;
		private var _propertyList:Array;
		
		/**
		 * 创建一个 <code>OrderedObject</code> 对象.
		 * @param target 指定要被代理的对象.
		 */
		public function OrderedObject(target:Object = null)
		{
			this.target = target;
		}
		
		/**
		 * 设置或获取要被代理的对象.
		 */
		public function set target(value:Object):void
		{
			if(_target != value)
			{
				_target = value;
				_propertyList = new Array();
				for(var key:* in _target)
				{
					_propertyList.push(key);
				}
			}
		}
		public function get target():Object
		{
			return _target;
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
				if(_propertyList.indexOf(name) == -1)
				{
					_propertyList.push(name);
				}
			}
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return _target[name];
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			var result:Boolean = delete _target[name];
			var deleteIndex:int = _propertyList.indexOf(name);
			if(deleteIndex != -1)
			{
				_propertyList.splice(deleteIndex, 1);
			}
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
	}
}
