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
	
	/**
	 * <code>WeakObjectPool</code> 类定义了弱引用的对象池对象.
	 * <p>如果添加到本对象池的对象仅被本对象池对象引用则该对象会在下一次垃圾回收时被回收.</p>
	 * @author wizardc
	 */
	public class WeakObjectPool implements IObjectPool
	{
		/**
		 * 记录所有对象的弱引用表.
		 */
		protected var _record:Dictionary;
		
		/**
		 * 记录对象的类型.
		 */
		protected var _type:Class;
		
		/**
		 * 创建一个 <code>WeakObjectPool</code> 对象.
		 */
		public function WeakObjectPool()
		{
			_record = new Dictionary(true);
		}
		
		/**
		 * @inheritDoc
		 */
		public function register(type:Class):void
		{
			if(_type == null)
			{
				_type = type;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function join(object:*):*
		{
			if(object == null || (_type != null && !(object is _type)))
			{
				return null;
			}
			_record[object] = true;
			return object;
		}
		
		/**
		 * @inheritDoc
		 */
		public function find(filter:Function = null):*
		{
			var object:*;
			if(filter == null)
			{
				for(object in _record)
				{
					delete _record[object];
					return object;
				}
				return null;
			}
			for(object in _record)
			{
				if(filter.call(null, object))
				{
					delete _record[object];
					return object;
				}
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function take(filter:Function = null, ...args):*
		{
			var object:* = this.find(filter);
			if(object != null)
			{
				return object;
			}
			if(_type != null)
			{
				var ib:InstanceBuilder = new InstanceBuilder(_type, args);
				return ib.create();
			}
			return null;
		}
		
		/**
		 * 获取对象池中个数, 始终返回 0.
		 * @return 始终返回 0.
		 */
		public function size():uint
		{
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_record = new Dictionary(true);
		}
	}
}
