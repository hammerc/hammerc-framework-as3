/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import org.hammerc.collections.CollectionKind;
	import org.hammerc.collections.ITreeCollection;
	import org.hammerc.events.CollectionEvent;
	import org.hammerc.events.RendererExistenceEvent;
	import org.hammerc.events.TreeEvent;
	
	/**
	 * @eventType org.hammerc.events.TreeEvent.ITEM_OPENING
	 */
	[Event(name="itemOpening", type="org.hammerc.events.TreeEvent")]
	
	/**
	 * @eventType org.hammerc.events.TreeEvent.ITEM_OPEN
	 */
	[Event(name="itemOpen", type="org.hammerc.events.TreeEvent")]
	
	/**
	 * @eventType org.hammerc.events.TreeEvent.ITEM_CLOSE
	 */
	[Event(name="itemClose", type="org.hammerc.events.TreeEvent")]
	
	/**
	 * <code>Tree</code> 类实现了树形组件.
	 * @author wizardc
	 */
	public class Tree extends List
	{
		private var _iconField:String;
		private var _iconFunction:Function;
		private var _iconFieldOrFunctionChanged:Boolean = false;
		
		/**
		 * 创建一个 <code>Tree</code> 对象.
		 */
		public function Tree()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Tree;
		}
		
		/**
		 * 设置或获取数据项中用来确定图标 <code>skinName</code> 属性值的字段名称.
		 * <p>若设置了 <code>iconFunction</code>, 则设置此属性无效.</p>
		 */
		public function set iconField(value:String):void
		{
			if(_iconField == value)
			{
				return;
			}
			_iconField = value;
			_iconFieldOrFunctionChanged = true;
			this.invalidateProperties();
		}
		public function get iconField():String
		{
			return _iconField;
		}
		
		/**
		 * 设置或获取每个数据项目上运行以确定其图标的 <code>skinName</code> 值.
		 * <p>示例: <code>iconFunction(item:Object):Object</code></p>
		 */
		public function set iconFunction(value:Function):void
		{
			if(_iconFunction == value)
			{
				return;
			}
			_iconFunction = value;
			_iconFieldOrFunctionChanged = true;
			this.invalidateProperties();
		}
		public function get iconFunction():Function
		{
			return _iconFunction;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(this.itemRenderer == null)
			{
				this.itemRenderer = TreeItemRenderer;
			}
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			if(renderer is ITreeItemRenderer && this.dataProvider is ITreeCollection)
			{
				var treeCollection:ITreeCollection = this.dataProvider as ITreeCollection;
				var treeRenderer:ITreeItemRenderer = renderer as ITreeItemRenderer;
				treeRenderer.hasChildren = treeCollection.hasChildren(data);
				treeRenderer.opened = treeCollection.isItemOpen(data);
				treeRenderer.depth = treeCollection.getDepth(data);
				treeRenderer.iconSkinName = this.itemToIcon(data);
			}
			return super.updateRenderer(renderer, itemIndex, data);
		}
		
		/**
		 * 根据数据项返回项呈示器中图标的 <code>skinName</code> 属性值.
		 * @param data 数据项.
		 * @return 项呈示器中图标的 <code>skinName</code> 属性值.
		 */
		public function itemToIcon(data:Object):Object
		{
			if(data == null)
			{
				return null;
			}
			if(_iconFunction != null)
			{
				return _iconFunction(data);
			}
			var skinName:Object;
			if(data is XML)
			{
				try
				{
					if(data[iconField].length() != 0)
					{
						skinName = String(data[iconField]);
					}
				}
				catch(error:Error)
				{
				}
			}
			else if(data is Object)
			{
				try
				{
					if(data[iconField] != null)
					{
						skinName = data[iconField];
					}
				}
				catch(error:Error)
				{
				}
			}
			return skinName;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			if(event.renderer is TreeItemRenderer)
			{
				event.renderer.addEventListener(TreeEvent.ITEM_OPENING, onItemOpening);
			}
		}
		
		/**
		 * 节点即将打开.
		 */
		private function onItemOpening(event:TreeEvent):void
		{
			var renderer:TreeItemRenderer = event.itemRenderer;
			var item:Object = event.item;
			if(renderer == null || !(dataProvider is ITreeCollection))
			{
				return;
			}
			if(this.dispatchEvent(event))
			{
				var opend:Boolean = !renderer.opened;
				ITreeCollection(this.dataProvider).expandItem(item, opend);
				var type:String = opend ? TreeEvent.ITEM_OPEN : TreeEvent.ITEM_CLOSE;
				var evt:TreeEvent = new TreeEvent(type, false, false, renderer.itemIndex, item, renderer);
				this.dispatchEvent(evt);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererRemoveHandler(event);
			if(event.renderer is TreeItemRenderer)
			{
				event.renderer.removeEventListener(TreeEvent.ITEM_OPENING, onItemOpening);
			}
		}
		
		/**
		 * 打开或关闭一个节点. 注意, 此操作不会抛出 open 或 close 事件.
		 * @param item 要打开或关闭的节点.
		 * @param open true 表示打开节点, 反之关闭.
		 */
		public function expandItem(item:Object, open:Boolean = true):void
		{
			if(!(this.dataProvider is ITreeCollection))
			{
				return;
			}
			ITreeCollection(this.dataProvider).expandItem(item, open);
		}
		
		/**
		 * 指定的节点是否打开.
		 */
		public function isItemOpen(item:Object):Boolean
		{
			if(!(this.dataProvider is ITreeCollection))
			{
				return false;
			}
			return ITreeCollection(this.dataProvider).isItemOpen(item);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{       
			super.dataProvider_collectionChangeHandler(event);
			if(event.kind == CollectionKind.OPEN || event.kind == CollectionKind.CLOSE)
			{
				var renderer:TreeItemRenderer = this.dataGroup ? this.dataGroup.getElementAt(event.location) as TreeItemRenderer : null;
				if(renderer != null)
				{
					this.updateRenderer(renderer, event.location, event.items[0]);
					if(event.kind == CollectionKind.CLOSE && this.layout != null && this.layout.useVirtualLayout)
					{
						this.layout.clearVirtualLayoutCache();
						this.invalidateSize();
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_iconFieldOrFunctionChanged)
			{
				if(this.dataGroup != null)
				{
					var itemIndex:int;
					if(this.layout && this.layout.useVirtualLayout)
					{
						for each(itemIndex in this.dataGroup.getElementIndicesInView())
						{
							updateRendererIconProperty(itemIndex);
						}
					}
					else
					{
						var n:int = this.dataGroup.numElements;
						for(itemIndex = 0; itemIndex < n; itemIndex++)
						{
							updateRendererIconProperty(itemIndex);
						}
					}
				}
				_iconFieldOrFunctionChanged = false;
			}
		}
		
		/**
		 * 更新指定索引项的图标.
		 */
		private function updateRendererIconProperty(itemIndex:int):void
		{
			var renderer:TreeItemRenderer = this.dataGroup.getElementAt(itemIndex) as TreeItemRenderer; 
			if(renderer != null)
			{
				renderer.iconSkinName = this.itemToIcon(renderer.data);
			}
		}
	}
}
