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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import org.hammerc.events.CollectionEvent;
	
	/**
	 * @eventType org.hammerc.events.CollectionEvent.COLLECTION_CHANGE
	 */
	[Event(name="collectionChange", type="org.hammerc.events.CollectionEvent")]
	
	/**
	 * <code>ArrayCollection</code> 类为数组的集合类.
	 * <p>通常作为集合组件的数据源, 能在数据源发生改变的时候主动通知视图刷新变更的数据项. 可以直接对其使用 for in, for each in 或 [i] 标方法遍历数据.</p>
	 * @author wizardc
	 */
	public class ArrayCollection extends Proxy implements ICollection
	{
		private var _eventDispatcher:EventDispatcher;
		
		/**
		 * 记录数据源.
		 */
		protected var _source:Array;
		
		/**
		 * 创建一个 <code>ArrayCollection</code> 对象.
		 * @param source 数据源.
		 */
		public function ArrayCollection(source:Array = null)
		{
			_eventDispatcher = new EventDispatcher(this);
			if(source != null)
			{
				_source = source;
			}
			else
			{
				_source = new Array();
			}
		}
		
		/**
		 * 设置或获取数据源.
		 */
		public function set source(value:Array):void
		{
			if(_source != value)
			{
				if(value == null)
				{
					value = new Array();
				}
				_source = value;
				this.dispatchCollectEvent(CollectionKind.RESET);
			}
		}
		public function get source():Array
		{
			return _source;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return _source.length;
		}
		
		/**
		 * 判断集合是否包含指定的元素.
		 * @param item 用于判断的元素.
		 * @return 如果该集合包含指定的元素则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function contains(item:Object):Boolean
		{
			return this.getItemIndex(item) != -1;
		}
		
		/**
		 * 在集合尾部添加一个元素.
		 * @param item 要添加的元素.
		 */
		public function addItem(item:Object):void
		{
			_source.push(item);
			this.dispatchCollectEvent(CollectionKind.ADD, [item], null, _source.length - 1);
		}
		
		/**
		 * 在集合指定的索引处添加一个元素.
		 * @param item 要添加的元素.
		 * @param index 指定的索引.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			checkIndex(index, true);
			_source.splice(index, 0, item);
			this.dispatchCollectEvent(CollectionKind.ADD, [item], null, index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:int):Object
		{
			return _source[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			return _source.indexOf(item);
		}
		
		/**
		 * 移除掉指定索引处的元素.
		 * @param index 要移除的元素的索引.
		 * @return 被移除的元素.
		 */
		public function removeItemAt(index:int):Object
		{
			checkIndex(index);
			var item:Object = _source.splice(index, 1)[0];
			this.dispatchCollectEvent(CollectionKind.REMOVE, [item], null, index);
			return item;
		}
		
		/**
		 * 从集合中移除所有元素.
		 */
		public function removeAll():void
		{
			var items:Array = _source.concat();
			_source.length = 0;
			this.dispatchCollectEvent(CollectionKind.REMOVE, items, null, 0);
		}
		
		/**
		 * 用指定的元素替换指定索引上的元素.
		 * @param item 用于替换的元素.
		 * @param index 要被替换的元素的索引.
		 * @return 被替换的元素.
		 */
		public function replaceItemAt(item:Object, index:int):Object
		{
			checkIndex(index);
			var oldItem:Object = _source.splice(index, 1, item)[0];
			this.dispatchCollectEvent(CollectionKind.REPLACE, [item], [oldItem], index);
			return oldItem;
		}
		
		/**
		 * 替换所有元素, 和直接设置 <code>source</code> 不同的是, 它不会导致目标视图重置滚动位置.
		 */
		public function replaceAll(newSource:Array):void
		{
			if(newSource == null)
			{
				newSource = new Array();
			}
			var newLength:int = newSource.length;
			var oldLength:int = _source.length;
			for(var i:int = oldLength - 1; i >= newLength; i--)
			{
				this.removeItemAt(i);
			}
			for(i = 0; i < newLength; i++)
			{
				if(i >= oldLength)
				{
					this.addItem(newSource[i]);
				}
				else
				{
					this.replaceItemAt(newSource[i], i);
				}
			}
			_source = newSource;
		}
		
		/**
		 * 交换两个索引上的元素.
		 * @param index1 第一个元素的索引.
		 * @param index2 第二个元素的索引.
		 */
		public function moveItemAt(index1:int,index2:int):void
		{
			this.checkIndex(index1);
			this.checkIndex(index2);
			var item:Object = _source[index1];
			_source[index1] = _source[index2];
			_source[index2] = item;
			this.dispatchCollectEvent(CollectionKind.MOVE, [item], null, index2, index1);
		}
		
		/**
		 * 通知列表指定的项目本身已经更新.
		 * @param item 更新的元素.
		 */
		public function itemUpdated(item:Object):void
		{
			var index:int = this.getItemIndex(item);
			if(index != -1)
			{
				this.dispatchCollectEvent(CollectionKind.UPDATE, [item], null, index);
			}
		}
		
		/**
		 * 在对数据源进行排序或过滤操作后可以手动调用此方法刷新所有数据, 以更新视图.
		 */
		public function refresh():void
		{
			this.dispatchCollectEvent(CollectionKind.REFRESH);
		}
		
		/**
		 * 发送集合相关的事件.
		 * @param kind 列表元素改变的类型.
		 * @param items 受事件影响的元素的列表.
		 * @param oldItems 替换前的元素的列表.
		 * @param location 指定 <code>items</code> 属性中指定的元素集合中第一个元素的索引.
		 * @param oldLocation 指定 <code>items</code> 属性中指定的元素集合中第一个元素原来的索引.
		 */
		protected function dispatchCollectEvent(kind:String, items:Array = null, oldItems:Array = null, location:int = -1, oldLocation:int = -1):void
		{
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, kind, items, oldItems, location, oldLocation);
			this.dispatchEvent(event);
		}
		
		/**
		 * 检测索引是否超出范围.
		 * @param index 要检测的索引.
		 * @param add 是否为添加元素的情况.
		 * @throws Error 索引超出范围时会抛出该异常.
		 */
		protected function checkIndex(index:int, add:Boolean = false):void
		{
			var overstep:Boolean = add ? (index > _source.length) : (index >= _source.length);
			if(index < 0 || overstep)
			{
				throw new Error("索引: " + index + "超出可用范围!");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var index:int = convertToIndex(name);
			return this.getItemAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var index:int = convertToIndex(name);
			this.replaceItemAt(value, index);
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			var index:int = convertToIndex(name);
			return index >= 0 && index < this.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextNameIndex(index:int):int
		{
			return index < this.length ? index + 1 : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextName(index:int):String
		{
			return (index - 1).toString();
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function nextValue(index:int):*
		{
			return this.getItemAt(index - 1);
		}
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function callProperty(name:*, ... rest):*
		{
			return null;
		}
		
		private function convertToIndex(name:*):int
		{
			if(name is QName)
			{
				name = (name as QName).localName;
			}
			var index:int = -1;
			try
			{
				var number:Number = parseInt(String(name));
				if(!isNaN(number))
				{
					index = int(number);
				}
			}
			catch(error:Error)
			{
			}
			return index;
		}
	}
}
