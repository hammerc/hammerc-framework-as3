/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.ds
{
	/**
	 * <code>BinaryHeaps</code> 类实现了二叉堆.
	 * @author wizardc
	 */
	public class BinaryHeaps
	{
		private var _data:Array;
		
		private var _compare:Function;
		
		/**
		 * 创建一个 <code>BinaryHeaps</code> 对象.
		 * @param compare 指定比较方法, 用来确定获取的对象值是堆中最大还是最小的值.
		 * <p>
		 * 接受的方法如下: <code>function(a:&#42;, b:&#42;):Number</code>, 说明: 
		 * <ul>
		 * <li>使用 a 的数据减去 b 的数据, 取出的数据为堆中的最大值.</li>
		 * <li>使用 b 的数据减去 a 的数据, 取出的数据为堆中的最小值.</li>
		 * </ul>
		 * </p>
		 * <p>设置为 null 则默认使用方法: <code>function(a:Number, b:Number):Number{return a - b;}</code></p>
		 */
		public function BinaryHeaps(compare:Function = null)
		{
			_data = new Array();
			if(compare == null)
			{
				_compare = defaultCompare;
			}
			else
			{
				_compare = compare;
			}
		}
		
		private function defaultCompare(a:Number, b:Number):Number
		{
			return a - b;
		}
		
		/**
		 * 获取数据长度.
		 */
		public function get length():uint
		{
			return _data.length;
		}
		
		/**
		 * 获取数据数组.
		 */
		public function get data():Array
		{
			return _data;
		}
		
		/**
		 * 加入一个对象.
		 * @param obj 要加入的对象.
		 */
		public function enqueue(obj:*):void
		{
			//添加到最后位
			_data.push(obj);
			//计算父级的索引
			var parentIndex:int = (_data.length - 2) >> 1;
			var objIndex:int = _data.length - 1;
			var temp:* = _data[objIndex];
			//只要当前索引不是 0 就有父级
			while(objIndex > 0)
			{
				//如果新插入的数据大于父级的数据, 则交换位置
				if(_compare(temp, _data[parentIndex]) > 0)
				{
					_data[objIndex] = _data[parentIndex];
					objIndex = parentIndex;
					parentIndex = (parentIndex - 1) >> 1;
				}
				else
				{
					break;
				}
			}
			_data[objIndex] = temp;
		}
		
		/**
		 * 修改一个对象.
		 * @param oldObj 已经添加到堆中的对象.
		 * @param newObj 要替换的新对象.
		 * @return 修改是否成功.
		 */
		public function modify(oldObj:*, newObj:*):Boolean
		{
			//数据替换
			var objIndex:int = _data.indexOf(oldObj);
			if(objIndex == -1)
			{
				return false;
			}
			_data[objIndex] = newObj;
			//计算父级的索引
			var parentIndex:int = (objIndex - 1) >> 1;
			var temp:* =  _data[objIndex];
			//只要当前索引不是 0 就有父级
			while(objIndex > 0)
			{
				//如果新插入的数据大于父级的数据, 则交换位置
				if(_compare(temp, _data[parentIndex]) > 0)
				{
					_data[objIndex] = _data[parentIndex];
					objIndex = parentIndex;
					parentIndex = (parentIndex - 1) >> 1;
				}
				else
				{
					break;
				}
			}
			_data[objIndex] = temp;
			return true;
		}
		
		/**
		 * 取出数据最大或最小的对象, 具体规则由 <code>compare</code> 方法指定.
		 * @return 数据最大或最小的对象.
		 */
		public function dequeue():*
		{
			if(_data.length < 2)
			{
				return _data.pop();
			}
			//取出第一个元素并把最后一个元素放到第一个位置
			var result:* = _data[0];
			_data[0] = _data.pop();
			//计算子级的索引
			var parentIndex:int = 0;
			var childIndex:int = 1;
			var temp:* = _data[parentIndex];
			//子级索引小于最后一个索引说明可以继续后移
			while(childIndex <= _data.length - 1)
			{
				//从两个子级中选择较大的子级
				if(_data[childIndex + 1] != null && _compare(_data[childIndex], _data[childIndex + 1]) < 0)
				{
					childIndex++;
				}
				//如果当前节点更小则继续后移
				if(_compare(temp, _data[childIndex]) < 0)
				{
					_data[parentIndex] = _data[childIndex];
					parentIndex = childIndex;
					childIndex = (childIndex << 1) + 1;
				}
				else
				{
					break;
				}
			}
			_data[parentIndex] = temp;
			return result;
		}
		
		/**
		 * 获取本对象的字符串描述.
		 * @return 本对象的字符串描述.
		 */
		public function toString():String
		{
			return _data.toString();
		}
	}
}
