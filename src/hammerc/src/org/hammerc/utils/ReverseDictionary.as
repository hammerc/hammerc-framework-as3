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
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy;
	
	/**
	 * <code>ReverseDictionary</code> 类实现了支持反向查值的哈希表.
	 * <p>注意: 对于使用复杂对象作为键的情况请使用 <code>setValue</code> 和 <code>getValue</code> 方法, 直接获取和赋值会出现仅记录一个键的情况.</p>
	 * @author wizardc
	 */
	public dynamic class ReverseDictionary extends Proxy
	{
		private var _origin:Dictionary;
		private var _reverse:Dictionary;
		
		private var _propertyList:Array;
		
		/**
		 * 创建一个 <code>ReverseDictionary</code> 对象.
		 * @param weakKeys 键值是否使用弱引用.
		 */
		public function ReverseDictionary(weakKeys:Boolean = false)
		{
			_origin = new Dictionary(weakKeys);
			_reverse = new Dictionary(weakKeys);
		}
		
		/**
		 * 设置值.
		 * @param key 键.
		 * @param value 值.
		 */
		public function setValue(key:*, value:*):void
		{
			_reverse[_origin[key]] = undefined;
			_origin[key] = value;
			_reverse[value] = key;
		}
		
		/**
		 * 获取值.
		 * @param key 键.
		 * @return 值.
		 */
		public function getValue(key:*):*
		{
			return _origin[key];
		}
		
		/**
		 * 反向查值, 根据值查找键名.
		 * @param value 值.
		 * @return 对应的键名.
		 */
		public function getKey(value:*):*
		{
			return _reverse[value];
		}
		
		override flash_proxy function callProperty(name:*, ...args):*
		{
			var method:Function = _origin[name] as Function;
			return method.apply(_origin, args);
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_reverse[_origin[name]] = undefined;
			_origin[name] = value;
			_reverse[value] = name;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			_reverse[_origin[name]] = undefined;
			_origin[name] = undefined;
			return true;
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return _origin[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return name in _origin;
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
				for(var key:* in _origin)
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
			return _origin[_propertyList[index - 1]];
		}
	}
}
