/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.collections
{
	import flash.events.EventDispatcher;
	
	import org.hammerc.events.CollectionEvent;
	
	/**
	 * @eventType org.hammerc.events.CollectionEvent.COLLECTION_CHANGE
	 */
	[Event(name="collectionChange", type="org.hammerc.events.CollectionEvent")]
	
	/**
	 * <code>XMLCollection</code> 类为 XML 数据的集合类, 通常作为树形组件的数据源.
	 * @author wizardc
	 */
	public class XMLCollection extends EventDispatcher implements ITreeCollection
	{
		/**
		 * 记录数据源.
		 */
		protected var _source:XML;
		
		/**
		 * 记录可以显示的所有节点数组.
		 */
		protected var _nodeList:Array = new Array();
		
		/**
		 * 记录打开的父节点数组.
		 */
		protected var _openNodes:Array = new Array();
		
		/**
		 * 记录是否显示根节点.
		 */
		protected var _showRoot:Boolean = false;
		
		/**
		 * 创建一个 <code>XMLCollection</code> 对象.
		 * @param source 数据源.
		 * @param openNodes 打开的父节点数组.
		 */
		public function XMLCollection(source:XML = null, openNodes:Array = null)
		{
			if(openNodes != null)
			{
				_openNodes = openNodes.concat();
			}
			if(source != null)
			{
				_source = source;
				if(_showRoot)
				{
					_nodeList.push(_source);
				}
				this.addChildren(_source, _nodeList);
			}
		}
		
		/**
		 * 设置或获取数据源. 注意设置后会置空打开节点数组.
		 */
		public function set source(value:XML):void
		{
			if(_source != value)
			{
				_source = value;
				_nodeList = new Array();
				_openNodes = new Array();
				if(_source != null)
				{
					if(_showRoot)
					{
						_nodeList.push(_source);
					}
					this.addChildren(_source, _nodeList);
				}
				this.dispatchCollectEvent(CollectionKind.RESET);
			}
		}
		public function get source():XML
		{
			return _source;
		}
		
		/**
		 * 设置或获取打开的父节点数组.
		 */
		public function set openNodes(value:Array):void
		{
			_openNodes = value != null ? value.concat() : new Array();
			this.refresh();
		}
		public function get openNodes():Array
		{
			return _openNodes.concat();
		}
		
		/**
		 * 设置或获取是否显示根节点.
		 */
		public function set showRoot(value:Boolean):void
		{
			if(_showRoot != value)
			{
				_showRoot = value;
				if(_source != null)
				{
					if(_showRoot)
					{
						_nodeList.push(_source);
					}
					else
					{
						_nodeList.shift();
					}
				}
			}
		}
		public function get showRoot():Boolean
		{
			return _showRoot;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return _nodeList.length;
		}
		
		/**
		 * 添加所有子集到数组中.
		 * @param parent 要处理的对象.
		 * @param list 会被添加到的数组.
		 */
		protected function addChildren(parent:Object, list:Array):void
		{
			var children:XMLList = parent.children();
			for each(var child:XML in children)
			{
				list.push(child);
				if(_openNodes.indexOf(child) != -1)
				{
					addChildren(child, list);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:int):Object
		{
			return _nodeList[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			return _nodeList.indexOf(item);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasChildren(item:Object):Boolean
		{
			if(item is XML)
			{
				return XML(item).children().length() > 0;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isItemOpen(item:Object):Boolean
		{
			return _openNodes.indexOf(item) != -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function expandItem(item:Object, open:Boolean = true):void
		{
			if(item is XML)
			{
				if(open)
				{
					openNode(item as XML);
				}
				else
				{
					closeNode(item as XML);
				}
			}
		}
		
		/**
		 * 展开指定节点.
		 * @param item 要展开的节点.
		 */
		protected function openNode(item:XML):void
		{
			var index:int = _nodeList.indexOf(item);
			if(index != -1 && _openNodes.indexOf(item) == -1)
			{
				_openNodes.push(item);
				var list:Array = new Array();
				this.addChildren(item, list);
				var i:int = index;
				while(list.length != 0)
				{
					i++;
					var node:Object = list.shift();
					_nodeList.splice(i, 0, node);
					this.dispatchCollectEvent(CollectionKind.ADD, [node], null, i);
				}
				this.dispatchCollectEvent(CollectionKind.OPEN, [item], null, index, index);
			}
		}
		
		/**
		 * 关闭指定节点.
		 * @param item 要关闭的节点.
		 */
		protected function closeNode(item:XML):void
		{
			var index:int = _openNodes.indexOf(item);
			if(index != -1)
			{
				_openNodes.splice(index, 1);
				index = _nodeList.indexOf(item);
				if(index != -1)
				{
					var list:Array = new Array();
					this.addChildren(item, list);
					index++;
					while(list.length != 0)
					{
						var node:XML = _nodeList.splice(index,1)[0];
						this.dispatchCollectEvent(CollectionKind.REMOVE, [node], null, index);
						list.shift();
					}
					index--;
					this.dispatchCollectEvent(CollectionKind.CLOSE, [item], null, index, index);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDepth(item:Object):int
		{
			var depth:int = 0;
			if(item is XML)
			{
				var parent:XML = item.parent();
				while(parent)
				{
					depth++;
					parent = parent.parent();
				}
				if(depth > 0 && !_showRoot)
				{
					depth--;
				}
			}
			return depth;
		}
		
		/**
		 * 在对数据源进行排序或过滤操作后可以手动调用此方法刷新所有数据, 以更新视图.
		 */
		public function refresh():void
		{
			_nodeList = new Array();
			if(source != null)
			{
				_source = source;
				if(_showRoot)
				{
					_nodeList.push(_source);
				}
				this.addChildren(_source, _nodeList);
			}
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
	}
}
