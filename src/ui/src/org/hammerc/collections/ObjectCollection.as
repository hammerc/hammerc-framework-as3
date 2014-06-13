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
	 * <code>ObjectCollection</code> 类为哈希数据的集合类, 通常作为树形组件的数据源.
	 * <p>相对于 <code>XMLCollection</code> 类, 本对象可以附带任意对象而不仅仅是字符串.</p>
	 * @author wizardc
	 */
	public class ObjectCollection extends EventDispatcher implements ITreeCollection
	{
		/**
		 * 给 parent 的子项以及子孙项赋值父级引用.
		 * @param parent 要遍历子项的 parent 对象.
		 * @param childrenKey 要从 parent 中获取子项列表的属性名, 属性值为一个数组 或 Vector.
		 * @param parentKey 要给子项赋值父级引用的属性名.
		 */
		public static function assignParent(parent:Object, childrenKey:String = "children", parentKey:String = "parent"):void
		{
			if(!parent.hasOwnProperty(childrenKey))
			{
				return;
			}
			for each(var child:Object in parent[childrenKey])
			{
				try
				{
					child[parentKey] = parent;
				}
				catch(error:Error)
				{
				}
				assignParent(child, childrenKey, parentKey);
			}
		}
		
		/**
		 * 记录子集的键名.
		 */
		protected var _childrenKey:String;
		
		/**
		 * 记录父集的键名.
		 */
		protected var _parentKey:String;
		
		/**
		 * 记录数据源.
		 */
		protected var _source:Object;
		
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
		 * 创建一个 <code>ObjectCollection</code> 对象.
		 * @param childrenKey 子集的键名.
		 * @param parentKey 父集的键名.
		 */
		public function ObjectCollection(childrenKey:String = "children", parentKey:String = "parent")
		{
			_childrenKey = childrenKey;
			_parentKey = parentKey;
		}
		
		/**
		 * 设置或获取数据源. 注意设置后会置空打开节点数组.
		 */
		public function set source(value:Object):void
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
					else
					{
						_openNodes = [_source];
						this.addChildren(_source, _nodeList);
					}
				}
				this.dispatchCollectEvent(CollectionKind.RESET);
			}
		}
		public function get source():Object
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
						_nodeList.splice(0, 0, _source);
					}
					else
					{
						_nodeList.shift();
						if(_openNodes.indexOf(_source) == -1)
						{
							_openNodes.push(_source);
						}
					}
					this.refresh();
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
			if(parent.hasOwnProperty(_childrenKey) && _openNodes.indexOf(parent) != -1)
			{
				for each(var child:Object in parent[_childrenKey])
				{
					list.push(child);
					this.addChildren(child, list);
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
			if(item.hasOwnProperty(_childrenKey))
			{
				return item[_childrenKey].length > 0;
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
			if(open)
			{
				this.openNode(item);
			}
			else
			{
				this.closeNode(item);
			}
		}
		
		/**
		 * 展开指定节点.
		 * @param item 要展开的节点.
		 */
		protected function openNode(item:Object):void
		{
			if(_openNodes.indexOf(item) == -1)
			{
				_openNodes.push(item);
				var index:int = _nodeList.indexOf(item);
				if(index != -1)
				{
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
		}
		
		/**
		 * 关闭指定节点.
		 * @param item 要关闭的节点.
		 */
		protected function closeNode(item:Object):void
		{
			var index:int = _openNodes.indexOf(item);
			if(index != -1)
			{
				var list:Array = new Array();
				this.addChildren(item, list);
				_openNodes.splice(index, 1);
				index = _nodeList.indexOf(item);
				if(index != -1)
				{
					index++;
					while(list.length != 0)
					{
						var node:Object = _nodeList.splice(index,1)[0];
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
			var parent:Object = item[_parentKey];
			while(parent)
			{
				depth++;
				parent = parent[_parentKey];
			}
			if(depth > 0 && !_showRoot)
			{
				depth--;
			}
			return depth;
		}
		
		/**
		 * 删除指定节点.
		 * @param item 要删除的节点.
		 */
		public function removeItem(item:Object):void
		{
			if(this.isItemOpen(item))
			{
				this.closeNode(item);
			}
			if(item == null)
			{
				return;
			}
			var parent:Object = item[_parentKey];
			if(parent == null)
			{
				return;
			}
			var list:Array = parent[_childrenKey];
			if(list == null)
			{
				return;
			}
			var index:int = list.indexOf(item);
			if(index != -1)
			{
				list.splice(index, 1);
			}
			item[_parentKey] = null;
			index = _nodeList.indexOf(item);
			if(index != -1)
			{
				_nodeList.splice(index, 1);
				this.dispatchCollectEvent(CollectionKind.REMOVE, [item], null, index);
			}
		}
		
		/**
		 * 通知视图, 某个项目的属性已更新.
		 * @param item 更新的节点.
		 */
		public function itemUpdated(item:Object):void
		{
			var index:int = getItemIndex(item);
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
	}
}
