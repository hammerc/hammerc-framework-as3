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
	 * <code>LinkedList</code> 类基于双向链表提供了一个列表的实现并支持序列化.
	 * @author wizardc
	 */
	public class LinkedList implements IList, IExternalizable
	{
		/**
		 * 记录头结点.
		 */
		protected var _headNode:ListNode;
		
		/**
		 * 记录尾节点.
		 */
		protected var _tailNode:ListNode;
		
		/**
		 * 记录节点的数量.
		 */
		protected var _length:int;
		
		/**
		 * 创建一个 <code>LinkedList</code> 对象.
		 * @param array 指定初始内容.
		 */
		public function LinkedList(array:Array = null)
		{
			this.createFromArray(array);
		}
		
		/**
		 * 从数组中初始化本对象.
		 * @param array 源数组对象.
		 */
		protected function createFromArray(array:Array):void
		{
			if(array == null || array.length == 0)
			{
				_length = 0;
			}
			else
			{
				var prevNode:ListNode;
				for each(var item:* in array)
				{
					var node:ListNode = new ListNode(item, prevNode);
					if(prevNode != null)
					{
						prevNode.nextNode = node;
					}
					prevNode = node;
					if(_headNode == null)
					{
						_headNode = node;
					}
				}
				_tailNode = node;
				_length = array.length;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return _length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItem(item:*):int
		{
			return this.addItemAt(item, this.length);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addItemAt(item:*, index:int):int
		{
			if(index < 0 || index >= this.length)
			{
				index = this.length;
			}
			var node:ListNode = new ListNode(item);
			if(_headNode == null)
			{
				_headNode = node;
				_tailNode = node;
			}
			else if(index == 0)
			{
				node.nextNode = _headNode;
				_headNode.prevNode = node;
				_headNode = node;
			}
			else if(index == this.length)
			{
				node.prevNode = _tailNode;
				_tailNode.nextNode = node;
				_tailNode = node;
			}
			else
			{
				var prevNode:ListNode = this.getNodeAt(index - 1);
				var nextNode:ListNode = prevNode.nextNode;
				prevNode.nextNode = node;
				nextNode.prevNode = node;
			}
			_length++;
			return _length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addAll(list:IList):int
		{
			return this.addAllAt(list, this.length);
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
				index = this.length;
			}
			var array:Array = list.toArray();
			if(array == null || array.length == 0)
			{
				return this.length;
			}
			else if(array.length == 1)
			{
				return this.addItemAt(array[0], index);
			}
			else
			{
				var prevNode:ListNode;
				var nextNode:ListNode;
				var node:ListNode;
				var item:*;
				if(_headNode == null)
				{
					for each(item in array)
					{
						node = new ListNode(item, prevNode);
						if(prevNode != null)
						{
							prevNode.nextNode = node;
						}
						prevNode = node;
						if(_headNode == null)
						{
							_headNode = node;
						}
					}
					_tailNode = node;
				}
				else if(index == 0)
				{
					array.reverse();
					for each(item in array)
					{
						node = new ListNode(item, null, _headNode);
						_headNode = node;
					}
				}
				else if(index == this.length)
				{
					for each(item in array)
					{
						node = new ListNode(item, _tailNode);
						_tailNode = node;
					}
				}
				else
				{
					prevNode = this.getNodeAt(index - 1);
					nextNode = prevNode.nextNode;
					for each(item in array)
					{
						node = new ListNode(item, prevNode);
						prevNode = node;
					}
					prevNode.nextNode = nextNode;
				}
				_length += array.length;
				return _length;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function contains(item:*):Boolean
		{
			if(this.indexOf(item) == -1)
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
				if(this.indexOf(i.next()) == -1)
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
			var node:ListNode = this.getNodeAt(index);
			if(node == null)
			{
				return node;
			}
			return node.data;
		}
		
		/**
		 * 获取指定索引处的节点.
		 * @param index 指定的索引.
		 * @rreturn 位于该索引处的节点.
		 */
		protected function getNodeAt(index:int):ListNode
		{
			if(index < 0 || index >= this.length)
			{
				return null;
			}
			var node:ListNode;
			var i:int;
			if(index < this.length / 2)
			{
				node  = _headNode;
				for(i = 0; i < index; i++)
				{
					node = node.nextNode;
				}
			}
			else
			{
				node = _tailNode;
				for(i = this.length - 1; i > index; i--)
				{
					node = node.prevNode;
				}
			}
			return node;
		}
		
		/**
		 * @inheritDoc
		 */
		public function indexOf(item:*):int
		{
			var index:int = 0;
			for(var node:ListNode = _headNode; node != null; node = node.nextNode)
			{
				if(node.data === item)
				{
					return index;
				}
				index++;
			}
			return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function lastIndexOf(item:*):int
		{
			var index:int = this.length - 1;
			for(var node:ListNode = _tailNode; node != null; node = node.prevNode)
			{
				if(node.data === item)
				{
					return index;
				}
				index--;
			}
			return -1;
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
			var node:ListNode = this.getNodeAt(index);
			var old:* = node.data;
			node.data = item;
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
			var temp:Array = this.toArray().splice(startIndex, endIndex - startIndex + 1);
			return new LinkedList(temp);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItem(item:*):*
		{
			for(var node:ListNode = _headNode; node != null; node = node.nextNode)
			{
				if(node.data === item)
				{
					removeNode(node);
					return node.data;
				}
			}
			return null;
		}
		
		/**
		 * 移除指定的节点.
		 * @param node 要被移除的节点.
		 * @return 移除的节点.
		 */
		protected function removeNode(node:ListNode):ListNode
		{
			if(node == _headNode && node == _tailNode)
			{
				_headNode = null;
				_tailNode = null;
			}
			else if(node == _headNode)
			{
				_headNode = _headNode.nextNode;
				_headNode.prevNode = null;
			}
			else if(node == _tailNode)
			{
				_tailNode = _tailNode.nextNode;
				_tailNode.nextNode = null;
			}
			else
			{
				var prevNode:ListNode = node.prevNode;
				var nextNode:ListNode = node.nextNode;
				prevNode.nextNode = nextNode;
				nextNode.prevNode = prevNode;
			}
			_length--;
			return node;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:int):*
		{
			var node:ListNode = this.getNodeAt(index);
			if(node == null)
			{
				return null;
			}
			return this.removeNode(node).data;
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
		 * @inheritDoc
		 */
		public function clear():void
		{
			_headNode = null;
			_tailNode = null;
			_length = 0;
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
			var result:Array = new Array();
			for(var i:IIterator = this.iterator(); i.hasNext();)
			{
				var item:* = i.next();
				result.push(item);
			}
			return result;
		}
		
		/**
		 * 获取本对象的字符串描述.
		 * @return 本对象的字符串描述.
		 */
		public function toString():String
		{
			return "LinkedList: " + this.toArray().toString();
		}
		
		/**
		 * 从字节数组中读取该类.
		 * @param input 目标字节数组对象.
		 */
		public function readExternal(input:IDataInput):void
		{
			var array:Array = input.readObject() as Array;
			this.createFromArray(array);
		}
		
		/**
		 * 将该类序列化为字节数组.
		 * @param output 目标字节数组对象.
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(this.toArray());
		}
	}
}
