/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.collections
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	/**
	 * <code>History</code> 类提供了历史记录的功能并支持序列化.
	 * @author wizardc
	 */
	public class History implements IExternalizable
	{
		/**
		 * 记录所有元素数据的数组.
		 */
		protected var _elements:Array;
		
		/**
		 * 记录最大保存的历史记录.
		 */
		protected var _max:int;
		
		/**
		 * 记录当前指向的索引.
		 */
		protected var _current:int;
		
		/**
		 * 创建一个 <code>History</code> 对象.
		 * @param max 最大保存的历史记录.
		 */
		public function History(max:int = 64)
		{
			_elements = new Array();
			_max = max;
			_current = 0;
		}
		
		/**
		 * 设置或获取当前指针位置.
		 */
		public function set current(value:int):void
		{
			value = (value < 0) ? 0 : value;
			value = (value > _max - 1) ? _max - 1 : value;
			_current = value;
		}
		public function get current():int
		{
			return _current;
		}
		
		/**
		 * 在当前指针之后添加一条记录.
		 * <p>如果添加之前该指针之后就存在记录则会删除指针之后的所有记录. 如果超过了最大的记录则会删除第一个元素.</p>
		 * @param object 需要添加的元素.
		 * @return 当前指针位置.
		 */
		public function record(object:*):int
		{
			//如果指针之后有数据则移除指针之后的数据
			if(_current > this.size() - 1)
			{
				_elements.splice(_current + 1);
			}
			_elements.push(object);
			if(_elements.length > _max)
			{
				_elements.shift();
			}
			_current = _elements.length - 1;
			return _current;
		}
		
		/**
		 * 将当前指针指向记录的最后一个元素.
		 */
		public function toLast():void
		{
			_current = _elements.length - 1;
		}
		
		/**
		 * 获取当前指针指向的元素.
		 * @return 当前指针指向的元素.
		 */
		public function now():*
		{
			return _elements[_current];
		}
		
		/**
		 * 是否存在上一个记录.
		 * @return 如果否存在上一个记录则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function hasBack():Boolean
		{
			return _current > 0;
		}
		
		/**
		 * 指向上一个记录并返回该记录的元素.
		 * @return 上一个记录的元素.
		 */
		public function back():*
		{
			if(this.hasBack())
			{
				_current--;
				return this.now();
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 是否存在下一个记录.
		 * @return 如果否存在下一个记录则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function hasNext():Boolean
		{
			return _current < _elements.length - 1;
		}
		
		/**
		 * 指向下一个记录并返回该记录的元素.
		 * @return 下一个记录的元素.
		 */
		public function next():*
		{
			if(this.hasNext())
			{
				_current++;
				return this.now();
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 从第一条记录开始搜索一个元素.
		 * @param object 要被搜索的元素.
		 * @return 该元素位于记录中的索引, 不存在则返回 -1.
		 */
		public function search(object:*):int
		{
			return _elements.indexOf(object);
		}
		
		/**
		 * 移除列表中的所有元素.
		 */
		public function clear():void
		{
			_elements.splice(0, _elements.length);
			_current = 0;
		}
		
		/**
		 * 获取当前的列表是否为空.
		 * @return 当前的列表是否为空.
		 */
		public function isEmpty():Boolean
		{
			return this.size() == 0;
		}
		
		/**
		 * 获取当前列表的元素个数.
		 * @return 当前列表的元素个数.
		 */
		public function size():int
		{
			return _elements.length;
		}
		
		/**
		 * 将当前列表装换为对应的 <code>Array</code> 对象.
		 * @return 和当前列表对应的 <code>Array</code> 对象.
		 */
		public function toArray():Array
		{
			return _elements.concat();
		}
		
		/**
		 * 从字节数组中读取该类.
		 * @param input 目标字节数组对象.
		 */
		public function readExternal(input:IDataInput):void
		{
			_elements = input.readObject() as Array;
			_max = input.readInt();
			_current = input.readInt();
		}
		
		/**
		 * 将该类序列化为字节数组.
		 * @param output 目标字节数组对象.
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_elements);
			output.writeInt(_max);
			output.writeInt(_current);
		}
	}
}
