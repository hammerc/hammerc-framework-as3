/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.collections
{
	import flash.utils.Dictionary;
	
	/**
	 * <code>WeakHashMap</code> 类实现了弱引用哈希表的基本常用方法, 添加的元素如果仅被该对象引用则可能会被当做垃圾回收.
	 * @author wizardc
	 */
	public class WeakHashMap implements IMap
	{
		/**
		 * 记录所有元素的字典对象.
		 */
		protected var _dictionary:Dictionary;
		
		/**
		 * 创建一个 <code>WeakHashMap</code> 对象.
		 */
		public function WeakHashMap()
		{
			_dictionary = new Dictionary(true);
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
			var weak:Dictionary = new Dictionary(true);
			weak[value] = null;
			_dictionary[key] = weak;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get(key:*):*
		{
			var weak:* = _dictionary[key];
			if(weak != null)
			{
				for(var v:* in weak)
				{
					return v;
				}
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove(key:*):*
		{
			var value:* = get(key);
			delete _dictionary[key];
			return value;
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
		}
	}
}
