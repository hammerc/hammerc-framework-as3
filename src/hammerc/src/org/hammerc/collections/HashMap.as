/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.collections
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	/**
	 * <code>HashMap</code> 类实现了哈希表的基本常用方法并且该类支持序列化.
	 * @author wizardc
	 */
	public class HashMap implements IMap, IExternalizable
	{
		/**
		 * 记录所有元素的字典对象.
		 */
		protected var _dictionary:Dictionary;
		
		/**
		 * 记录元素的数量.
		 */
		protected var _size:int;
		
		/**
		 * 创建一个 <code>HashMap</code> 对象.
		 */
		public function HashMap()
		{
			registerClassAlias("flash.utils.Dictionary", Dictionary);
			_dictionary = new Dictionary();
			_size = 0;
		}
		
		/**
		 * @inheritDoc
		 * @throws ArgumentError 当指定的键对象为 <code>null</code> 或 <code>undefined</code> 时会抛出该异常.
		 */
		public function put(key:*, value:*):*
		{
			if(key == undefined || key == null)
			{
				throw new ArgumentError("键名\"key\"不能为\"undefined\"或\"null\"！");
			}
			if(!containsKey(key))
			{
				_size++;
			}
			_dictionary[key] = value;
			return value;
		}
		
		/**
		 * 将一个已存在的哈希表的所有映射存储到该哈希表中.
		 * @param hashMap 要复制的已存在的哈希表.
		 */
		public function putAll(hashMap:HashMap):void
		{
			var keys:Array = hashMap.keys();
			for each(var key:* in keys)
			{
				put(key, hashMap.get(key));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get(key:*):*
		{
			if(containsKey(key))
			{
				return _dictionary[key];
			}
			return null;
		}
		
		/**
		 * 获取该哈希表中的所有键的集合.
		 * @return 该哈希表中的所有键的集合.
		 */
		public function keys():Array
		{
			var keys:Array = new Array();
			for(var key:* in _dictionary)
			{
				keys.push(key);
			}
			return keys;
		}
		
		/**
		 * 获取该哈希表中的所有值的集合.
		 * @return 该哈希表中的所有值的集合.
		 */
		public function values():Array
		{
			var values:Array = new Array();
			for each(var value:* in _dictionary)
			{
				values.push(value);
			}
			return values;
		}
		
		/**
		 * 对该哈希表中的每一个键执行函数.
		 * @param callback 要对每一个键运行的函数.
		 * @param thisObject 用作函数的 this 的对象.
		 * @param args 回掉的参数.
		 */
		public function eachKey(callback:Function, thisObject:* = null, ...args):void
		{
			var keys:Array = this.keys();
			for each(var key:* in keys)
			{
				callback.apply(thisObject, [key].concat(args));
			}
		}
		
		/**
		 * 对该哈希表中的每一个值执行函数.
		 * @param callback 要对每一个值运行的函数.
		 * @param thisObject 用作函数的 this 的对象.
		 * @param args 回掉的参数.
		 */
		public function eachValue(callback:Function, thisObject:* = null, ...args):void
		{
			var values:Array = this.values();
			for each(var value:* in values)
			{
				callback.apply(thisObject, [value].concat(args));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove(key:*):*
		{
			if(!containsKey(key))
			{
				return null;
			}
			var value:* = get(key);
			delete _dictionary[key];
			_size--;
			return value;
		}
		
		/**
		 * 判断一个指定键是否已经在该哈希表中映射过.
		 * @param key 需要被判断的一个指定键.
		 * @return 该键是否已经在该哈希表中映射过, 已经被映射过返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function containsKey(key:*):Boolean
		{
			return _dictionary.hasOwnProperty(key);
		}
		
		/**
		 * 判断一个指定值是否已经在该哈希表中被映射过.
		 * @param value 需要被判断的一个指定值.
		 * @return 该值是否已经在该哈希表中被映射过, 已经被映射过返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function containsValue(value:*):Boolean
		{
			for each(var v:* in _dictionary)
			{
				if(v === value)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 获取该哈希表是否为空表.
		 * @return 如果为空表返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function isEmpty():Boolean
		{
			return _size == 0;
		}
		
		/**
		 * 获取该哈希表的大小.
		 * @return 该哈希表的大小.
		 */
		public function size():int
		{
			return _size;
		}
		
		/**
		 * 将该哈希表用字符串的形式进行返回.
		 * @return 该哈希表的字符串形式.
		 */
		public function toString():String
		{
			var result:String = "{";
			for(var key:* in _dictionary)
			{
				result += key + "=" + _dictionary[key] + ", ";
			}
			result = result.substring(0, result.length - 2);
			result += "}";
			return result;
		}
		
		/**
		 * 对该哈希表进行浅复制并返回一个新表.
		 * @return 该表的一个副本.
		 */
		public function clone():HashMap
		{
			var hashMap:HashMap = new HashMap();
			hashMap.putAll(this);
			return hashMap;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			for(var key:* in _dictionary)
			{
				delete _dictionary[key];
			}
			_size = 0;
		}
		
		/**
		 * 从字节数组中读取该类.
		 * @param input 目标字节数组对象.
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_dictionary);
			output.writeInt(_size);
		}
		
		/**
		 * 将该类序列化为字节数组.
		 * @param output 目标字节数组对象.
		 */
		public function readExternal(input:IDataInput):void
		{
			_dictionary = input.readObject() as Dictionary;
			_size = input.readInt();
		}
	}
}
