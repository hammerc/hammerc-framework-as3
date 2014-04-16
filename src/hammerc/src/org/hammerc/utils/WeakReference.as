/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy;
	
	/**
	 * <code>WeakReference</code> 类可以代理任意对象并使其代理的对象成为弱引用对象.
	 * @author wizardc
	 */
	public dynamic class WeakReference extends Proxy
	{
		private var _dictionary:Dictionary;
		private var _propertyList:Array;
		
		/**
		 * 创建一个 <code>WeakReference</code> 对象.
		 * @param target 弱引用的代理对象.
		 */
		public function WeakReference(target:* = null)
		{
			this.target = target;
		}
		
		/**
		 * 设置或获取弱引用的代理对象.
		 */
		public function set target(value:*):void
		{
			if(value == undefined || value == null)
			{
				_dictionary = null;
			}
			else
			{
				_dictionary = new Dictionary(true);
				_dictionary[value] = null;
			}
		}
		public function get target():*
		{
			if(_dictionary != null)
			{
				for(var v:* in _dictionary)
				{
					return v;
				}
			}
			return null;
		}
		
		/**
		 * 清除代理对象.
		 */
		public function clear():void
		{
			_dictionary = null;
		}
		
		override flash_proxy function callProperty(name:*, ...args):*
		{
			if(target == null)
			{
				return null;
			}
			var method:Function = target[name] as Function;
			if(method != null)
			{
				method.apply(target, args);
			}
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			if(target == null)
			{
				return;
			}
			target[name] = value;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			if(target == null)
			{
				return null;
			}
			return target[name];
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			if(target == null)
			{
				return false;
			}
			return delete target[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return name in target;
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
				for(var key:* in target)
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
			return target[_propertyList[index - 1]];
		}
	}
}
