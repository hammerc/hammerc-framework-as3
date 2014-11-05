// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.collections
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	/**
	 * <code>ArrayList</code> 类基于数组提供了一个列表的实现并支持序列化.
	 * @author wizardc
	 */
	public class ArrayList implements IList, IExternalizable
	{
		/**
		 * 记录所有元素数据的数组.
		 */
		protected var _elements:Array;
		
		/**
		 * 创建一个 <code>ArrayList</code> 对象.
		 * @param array 指定初始内容.
		 */
		public function ArrayList(array:Array = null)
		{
			if(array == null)
			{
				_elements = new Array();
			}
			else
			{
				_elements = array;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return _elements.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItem(item:*):int
		{
			return _elements.push(item);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItemAt(item:*, index:int):int
		{
			if(index < 0 || index >= this.length)
			{
				return _elements.push(item);
			}
			else
			{
				return _elements.splice(index, 0, item);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addAll(list:IList):int
		{
			if(list == null)
			{
				return this.length;
			}
			_elements = _elements.concat(list.toArray());
			return this.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addAllAt(list:IList, index:int):int
		{
			if(list == null)
			{
				return this.length;
			}
			if(index < 0 || index >= this.length)
			{
				_elements = _elements.concat(list.toArray());
			}
			else
			{
				_elements.splice.apply(null, [index, 0].concat(list.toArray()));
			}
			return this.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(item:*):Boolean
		{
			if(_elements.indexOf(item) == -1)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsAll(list:IList):Boolean
		{
			if(this.length < list.length)
			{
				return false;
			}
			for(var i:IIterator = list.iterator(); i.hasNext();)
			{
				if(_elements.indexOf(i.next()) == -1)
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:int):*
		{
			return _elements[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public function indexOf(item:*):int
		{
			return _elements.indexOf(item);
		}
		
		/**
		 * @inheritDoc
		 */
		public function lastIndexOf(item:*):int
		{
			return _elements.lastIndexOf(item);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setItemAt(item:*, index:int):*
		{
			if(index < 0 || index >= this.length)
			{
				return null;
			}
			var old:* = _elements[index];
			_elements[index] = item;
			return old;
		}
		
		/**
		 * @inheritDoc
		 */
		public function subList(startIndex:int = 0, endIndex:int = -1):IList
		{
			if(startIndex >= this.length || startIndex > endIndex)
			{
				return null;
			}
			startIndex = (startIndex < 0) ? 0 : startIndex;
			if(endIndex < 0 || endIndex >= this.length)
			{
				endIndex = this.length;
			}
			var temp:Array = _elements.splice(startIndex, endIndex - startIndex + 1);
			return new ArrayList(temp);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItem(item:*):*
		{
			if(this.contains(item))
			{
				return this.removeItemAt(this.indexOf(item));
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:int):*
		{
			if(index < 0 || index >= this.length)
			{
				return null;
			}
			return _elements.splice(index, 1)[0];
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAll(list:IList):Array
		{
			if(list == null)
			{
				return null;
			}
			var result:Array = new Array();
			for(var i:IIterator = list.iterator(); i.hasNext();)
			{
				var item:* = i.next();
				var temp:* = this.removeItem(item);
				if(temp != null)
				{
					result.push(temp);
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function retainAll(list:IList):Array
		{
			if(list == null)
			{
				return null;
			}
			var result:Array = new Array();
			for(var i:IIterator = this.iterator(); i.hasNext();)
			{
				var item:* = i.next();
				if(!list.contains(item))
				{
					i.remove();
					result.push(item);
				}
			}
			return result;
		}
		
		/**
		 * 对列表中的元素进行排序, 请参看 <code>Array.sort()</code> 的帮助.
		 * @param args 指定一个比较函数和确定排序行为的一个或多个值的参数.
		 * @return 返回值取决于传递的参数.
		 */
		public function sort(...args):Array
		{
			return _elements.sort.apply(null, args);
		}
		
		/**
		 * 根据数组中的一个或多个字段对数组中的元素进行排序, 请参看 <code>Array.sortOn()</code> 的帮助.
		 * @param fieldName 一个字符串, 它标识要用作排序值的字段, 或一个数组, 其中的第一个元素表示主排序字段, 第二个元素表示第二排序字段, 依此类推.
		 * @param options 所定义常数的一个或多个数字或名称, 它们可以更改排序行为.
		 * @return 返回值取决于传递的参数.
		 */
		public function sortOn(fieldName:Object, options:Object = null):Array
		{
			return _elements.sortOn(fieldName, options);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			_elements.length = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function iterator():IIterator
		{
			return new Iterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return this.length == 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return _elements.concat();
		}
		
		/**
		 * 获取本对象的字符串描述.
		 * @return 本对象的字符串描述.
		 */
		public function toString():String
		{
			return "ArrayList: " + _elements.toString();
		}
		
		/**
		 * 从字节数组中读取该类.
		 * @param input 目标字节数组对象.
		 */
		public function readExternal(input:IDataInput):void
		{
			_elements = input.readObject() as Array;
		}
		
		/**
		 * 将该类序列化为字节数组.
		 * @param output 目标字节数组对象.
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_elements);
		}
	}
}
