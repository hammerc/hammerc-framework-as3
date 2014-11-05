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
	/**
	 * <code>ObjectPool</code> 类定义了基本的对象池对象.
	 * @author wizardc
	 */
	public class ObjectPool implements IObjectPool
	{
		/**
		 * 记录所有对象的数组.
		 */
		protected var _record:Array;
		
		/**
		 * 记录对象的类型.
		 */
		protected var _type:Class;
		
		/**
		 * 创建一个 <code>ObjectPool</code> 对象.
		 */
		public function ObjectPool()
		{
			_record = new Array();
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
			_record.push(object);
			return object;
		}
		
		/**
		 * @inheritDoc
		 */
		public function find(filter:Function = null):*
		{
			if(filter == null)
			{
				if(_record.length > 0)
				{
					return _record.pop();
				}
				return null;
			}
			for(var i:int, len:int = _record.length; i < len; i++)
			{
				if(filter.call(null, _record[i]))
				{
					return _record.splice(i, 1)[0];
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
		 * @inheritDoc
		 */
		public function size():uint
		{
			return _record.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_record.length = 0;
		}
	}
}
