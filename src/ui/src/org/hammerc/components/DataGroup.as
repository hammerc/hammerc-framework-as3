/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.hammerc.collections.CollectionKind;
	import org.hammerc.collections.ICollection;
	import org.hammerc.components.supportClasses.GroupBase;
	import org.hammerc.core.IInvalidating;
	import org.hammerc.core.ILayoutElement;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.CollectionEvent;
	import org.hammerc.events.RendererExistenceEvent;
	import org.hammerc.layouts.HorizontalAlign;
	import org.hammerc.layouts.VerticalLayout;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	import org.hammerc.skins.ISkinnableClient;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.RendererExistenceEvent.RENDERER_ADD
	 */
	[Event(name="rendererAdd", type="org.hammerc.events.RendererExistenceEvent")]
	
	/**
	 * @eventType org.hammerc.events.RendererExistenceEvent.RENDERER_REMOVE
	 */
	[Event(name="rendererRemove", type="org.hammerc.events.RendererExistenceEvent")]
	
	/**
	 * <code>DataGroup</code> 类为数据项目的显示容器类.
	 * @author wizardc
	 */
	public class DataGroup extends GroupBase
	{
		private var _rendererOwner:IItemRendererOwner;
		
		private var _useVirtualLayoutChanged:Boolean = false;
		
		/**
		 * 存储当前可见的项呈示器索引列表.
		 */
		private var _virtualRendererIndices:Vector.<int>;
		
		private var _rendererToClassMap:Dictionary = new Dictionary(true);
		private var _freeRenderers:Dictionary = new Dictionary();
		
		/**
		 * 是否创建了新的项呈示器标志.
		 */
		private var _createNewRendererFlag:Boolean = false;
		
		private var _cleanTimer:Timer;
		
		private var _dataProviderChanged:Boolean = false;
		private var _dataProvider:ICollection;
		
		/**
		 * 对象池字典.
		 */
		private var _recyclerDic:Dictionary = new Dictionary();
		
		/**
		 * 项呈示器改变.
		 */
		private var _itemRendererChanged:Boolean;
		private var _itemRenderer:Class;
		
		private var _itemRendererSkinNameChange:Boolean = false;
		private var _itemRendererSkinName:Object;
		
		private var _itemRendererFunction:Function;
		
		/**
		 * 正在进行虚拟布局阶段.
		 */
		private var _virtualLayoutUnderway:Boolean = false;
		
		/**
		 * 用于测试默认大小的数据.
		 */
		private var _typicalItem:Object
		private var _typicalItemChanged:Boolean = false;
		
		/**
		 * 项呈示器的默认尺寸.
		 */
		private var _typicalLayoutRect:Rectangle;
		
		/**
		 * 索引到项呈示器的转换数组.
		 */
		private var _indexToRenderer:Array = [];
		
		/**
		 * 清理 freeRenderer 标志.
		 */
		private var _cleanFreeRenderer:Boolean = false;
		
		/**
		 * 正在更新数据项的标志.
		 */
		private var _renderersBeingUpdated:Boolean = false;
		
		/**
		 * 创建一个 <code>DataGroup</code> 对象.
		 */
		public function DataGroup()
		{
			super();
		}
		
		/**
		 * 设置或获取项呈示器的主机组件.
		 */
		hammerc_internal function set rendererOwner(value:IItemRendererOwner):void
		{
			_rendererOwner = value;
		}
		hammerc_internal function get rendererOwner():IItemRendererOwner
		{
			return _rendererOwner;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set layout(value:LayoutBase):void
		{
			if(value == this.layout)
			{
				return;
			}
			if(this.layout != null)
			{
				this.layout.typicalLayoutRect = null;
				this.layout.removeEventListener("useVirtualLayoutChanged", layout_useVirtualLayoutChangedHandler);
			}
			if(this.layout != null && value != null && (this.layout.useVirtualLayout != value.useVirtualLayout))
			{
				changeUseVirtualLayout();
			}
			super.layout = value;
			if(value != null)
			{
				value.typicalLayoutRect = _typicalLayoutRect;
				value.addEventListener("useVirtualLayoutChanged", layout_useVirtualLayoutChangedHandler);
			}
		}
		
		private function layout_useVirtualLayoutChangedHandler(event:Event):void
		{
			changeUseVirtualLayout();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setVirtualElementIndicesInView(startIndex:int, endIndex:int):void
		{
			if(this.layout == null || !this.layout.useVirtualLayout)
			{
				return;
			}
			_virtualRendererIndices = new Vector.<int>();
			for(var i:int = startIndex; i <= endIndex; i++)
			{
				_virtualRendererIndices.push(i);
			}
			for(var index:* in _indexToRenderer)
			{
				if(_virtualRendererIndices.indexOf(index) == -1)
				{
					freeRendererByIndex(index);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getVirtualElementAt(index:int):IUIComponent
		{
			if(index < 0 || index >= this.dataProvider.length)
			{
				return null;
			}
			var element:IUIComponent = _indexToRenderer[index];
			if(element == null)
			{
				var item:Object = this.dataProvider.getItemAt(index);
				var renderer:IItemRenderer = createVirtualRenderer(index);
				_indexToRenderer[index] = renderer;
				this.updateRenderer(renderer, index, item);
				if(_createNewRendererFlag)
				{
					if(renderer is IInvalidating)
					{
						(renderer as IInvalidating).validateNow();
					}
					_createNewRendererFlag = false;
					this.dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, item, index, renderer));
				}
				element = renderer as IUIComponent;
			}
			return element;
		}
		
		/**
		 * 释放指定索引处的项呈示器.
		 * @param index 指定索引.
		 */
		private function freeRendererByIndex(index:int):void
		{
			if(_indexToRenderer[index] == null)
			{
				return;
			}
			var renderer:IItemRenderer = _indexToRenderer[index] as IItemRenderer;
			delete _indexToRenderer[index];
			if(renderer != null && renderer is DisplayObject)
			{
				doFreeRenderer(renderer);
			}
		}
		
		/**
		 * 释放指定的项呈示器.
		 * @param renderer 指定的项呈示器.
		 */
		private function doFreeRenderer(renderer:IItemRenderer):void
		{
			var rendererClass:Class = _rendererToClassMap[renderer];
			if(_freeRenderers[rendererClass] == null)
			{
				_freeRenderers[rendererClass] = new Vector.<IItemRenderer>();
			}
			_freeRenderers[rendererClass].push(renderer);
			(renderer as DisplayObject).visible = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function invalidateSize():void
		{
			//虚拟布局时创建子项不需要重新验证
			if(!_createNewRendererFlag)
			{
				super.invalidateSize();
			}
		}
		
		/**
		 * 为指定索引创建虚拟的项呈示器.
		 * @param index 指定索引.
		 */
		private function createVirtualRenderer(index:int):IItemRenderer
		{
			var item:Object = this.dataProvider.getItemAt(index);
			var renderer:IItemRenderer;
			var rendererClass:Class = itemToRendererClass(item);
			if(_freeRenderers[rendererClass] != null && _freeRenderers[rendererClass].length > 0)
			{
				renderer = _freeRenderers[rendererClass].pop();
				(renderer as DisplayObject).visible = true;
				return renderer;
			}
			_createNewRendererFlag = true;
			return createOneRenderer(rendererClass);
		}
		
		/**
		 * 根据 rendererClass 创建一个 Renderer, 并添加到显示列表.
		 * @param rendererClass 项呈示器类.
		 */
		private function createOneRenderer(rendererClass:Class):IItemRenderer
		{
			var renderer:IItemRenderer;
			if(_recyclerDic[rendererClass] != null)
			{
				var hasExtra:Boolean = false;
				for(var key:* in _recyclerDic[rendererClass])
				{
					if(renderer == null)
					{
						renderer = key as IItemRenderer;
					}
					else
					{
						hasExtra = true;
						break;
					}
				}
				delete _recyclerDic[rendererClass][renderer];
				if(!hasExtra)
				{
					delete _recyclerDic[rendererClass];
				}
			}
			if(renderer == null)
			{
				renderer = new rendererClass() as IItemRenderer;
				_rendererToClassMap[renderer] = rendererClass;
			}
			if(renderer == null || !(renderer is DisplayObject))
			{
				return null;
			}
			if(_itemRendererSkinName != null)
			{
				setItemRenderSkinName(renderer);
			}
			super.addChild(renderer as DisplayObject);
			renderer.setLayoutBoundsSize(NaN, NaN);
			return renderer;
		}
		
		/**
		 * 设置项呈示器的默认皮肤.
		 * @param renderer 项呈示器.
		 */
		private function setItemRenderSkinName(renderer:IItemRenderer):void
		{
			if(renderer == null)
			{
				return;
			}
			var comp:SkinnableComponent = renderer as SkinnableComponent;
			if(comp != null)
			{
				if(!comp._skinNameExplicitlySet)
				{
					comp.skinName = _itemRendererSkinName;
				}
			}
			else
			{
				var client:ISkinnableClient = renderer as ISkinnableClient;
				if(client != null && !client.skinName)
				{
					client.skinName = _itemRendererSkinName;
				}
			}
		}
		
		/**
		 * 虚拟布局结束清理不可见的项呈示器.
		 */
		private function finishVirtualLayout():void
		{
			if(!_virtualLayoutUnderway)
			{
				return;
			}
			_virtualLayoutUnderway = false;
			var found:Boolean = false;
			for(var clazz:* in _freeRenderers)
			{
				if(_freeRenderers[clazz].length > 0)
				{
					found = true;
					break;
				}
			}
			if(!found)
			{
				return;
			}
			if(_cleanTimer == null)
			{
				_cleanTimer = new Timer(3000, 1);
				_cleanTimer.addEventListener(TimerEvent.TIMER, cleanAllFreeRenderer);
			}
			//为了提高持续滚动过程中的性能, 防止反复地添加移除子项, 这里不直接清理而是延迟后在滚动停止时清理一次
			_cleanTimer.reset();
			_cleanTimer.start();
		}
		
		private function cleanAllFreeRenderer(event:TimerEvent = null):void
		{
			var renderer:IItemRenderer;
			for each(var list:Vector.<IItemRenderer> in _freeRenderers)
			{
				for each(renderer in list)
				{
					DisplayObject(renderer).visible = true;
					recycle(renderer);
				}
			}
			_freeRenderers = new Dictionary();
			_cleanFreeRenderer = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementIndicesInView():Vector.<int>
		{
			if(layout != null && layout.useVirtualLayout)
			{
				return _virtualRendererIndices ? _virtualRendererIndices : new Vector.<int>(0);
			}
			return super.getElementIndicesInView();
		}
		
		/**
		 * 更改是否使用虚拟布局.
		 */
		private function changeUseVirtualLayout():void
		{
			_useVirtualLayoutChanged = true;
			_cleanFreeRenderer = true;
			removeDataProviderListener();
			this.invalidateProperties();
		}
		
		/**
		 * 设置或获取列表数据源.
		 */
		public function set dataProvider(value:ICollection):void
		{
			if(_dataProvider == value)
			{
				return;
			}
			removeDataProviderListener();
			_dataProvider = value;
			_dataProviderChanged = true;
			_cleanFreeRenderer = true;
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		public function get dataProvider():ICollection
		{
			return _dataProvider;
		}
		
		/**
		 * 移除数据源监听.
		 */
		private function removeDataProviderListener():void
		{
			if(_dataProvider != null)
			{
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
		}
		
		private function onCollectionChange(event:CollectionEvent):void
		{
			switch(event.kind)
			{
				case CollectionKind.ADD:
					itemAddedHandler(event.items, event.location);
					break;
				case CollectionKind.MOVE:
					itemMovedHandler(event.items[0], event.location, event.oldLocation);
					break;
				case CollectionKind.REMOVE:
					itemRemovedHandler(event.items, event.location);
					break;
				case CollectionKind.UPDATE:
					itemUpdatedHandler(event.items[0], event.location);
					break;
				case CollectionKind.REPLACE:
					itemRemoved(event.oldItems[0], event.location);
					itemAdded(event.items[0], event.location);
					break;
				case CollectionKind.RESET:
				case CollectionKind.REFRESH:
					if(this.layout != null && this.layout.useVirtualLayout)
					{
						for(var index:* in _indexToRenderer)
						{
							freeRendererByIndex(index);
						}
					}
					_dataProviderChanged = true;
					this.invalidateProperties();
					break;
			}
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		private function itemAddedHandler(items:Array, index:int):void
		{
			var length:int = items.length;
			for(var i:int = 0; i < length; i++)
			{
				itemAdded(items[i], index + i);
			}
			resetRenderersIndices();
		}
		
		private function itemMovedHandler(item:Object, location:int, oldLocation:int):void
		{
			itemRemoved(item, oldLocation);
			itemAdded(item, location);
			resetRenderersIndices();
		}
		
		private function itemRemovedHandler(items:Array, location:int):void
		{
			var length:int = items.length;
			for (var i:int = length - 1; i >= 0; i--)
			{
				itemRemoved(items[i], location + i);
			}
			resetRenderersIndices();
		}
		
		/**
		 * 添加一项.
		 * @param item 项目.
		 * @param index 索引.
		 */
		private function itemAdded(item:Object, index:int):void
		{
			if(this.layout != null)
			{
				this.layout.elementAdded(index);
			}
			if(this.layout != null && this.layout.useVirtualLayout)
			{
				if(_virtualRendererIndices)
				{
					const virtualRendererIndicesLength:int = _virtualRendererIndices.length;
					for(var i:int = 0; i < virtualRendererIndicesLength; i++)
					{
						const vrIndex:int = _virtualRendererIndices[i];
						if(vrIndex >= index)
						{
							_virtualRendererIndices[i] = vrIndex + 1;
						}
					}
					_indexToRenderer.splice(index, 0, null);
				}
				return;
			}
			var rendererClass:Class = itemToRendererClass(item);
			var renderer:IItemRenderer = createOneRenderer(rendererClass);
			_indexToRenderer.splice(index, 0, renderer);
			if(renderer == null)
			{
				return;
			}
			this.updateRenderer(renderer, index, item);
			this.dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, item, index, renderer));
		}
		
		/**
		 * 移除一项.
		 * @param item 项目.
		 * @param index 索引.
		 */
		private function itemRemoved(item:Object, index:int):void
		{
			if(this.layout != null)
			{
				this.layout.elementRemoved(index);
			}
			if(_virtualRendererIndices != null && (_virtualRendererIndices.length > 0))
			{
				var vrItemIndex:int = -1;
				const virtualRendererIndicesLength:int = _virtualRendererIndices.length;
				for(var i:int = 0; i < virtualRendererIndicesLength; i++)
				{
					const vrIndex:int = _virtualRendererIndices[i];
					if(vrIndex == index)
					{
						vrItemIndex = i;
					}
					else if(vrIndex > index)
					{
						_virtualRendererIndices[i] = vrIndex - 1;
					}
				}
				if(vrItemIndex != -1)
				{
					_virtualRendererIndices.splice(vrItemIndex, 1);
				}
			}
			const oldRenderer:IItemRenderer = _indexToRenderer[index];
			if(_indexToRenderer.length > index)
			{
				_indexToRenderer.splice(index, 1);
			}
			this.dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE, item, index, oldRenderer));
			if(oldRenderer != null && oldRenderer is DisplayObject)
			{
				recycle(oldRenderer);
				this.dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE, oldRenderer.data, oldRenderer.itemIndex, oldRenderer));
			}
		}
		
		/**
		 * 回收一个 ItemRenderer 实例.
		 * @param renderer ItemRenderer 实例.
		 */
		private function recycle(renderer:IItemRenderer):void
		{
			super.removeChild(renderer as DisplayObject);
			if(renderer is IUIComponent)
			{
				(renderer as IUIComponent).ownerChanged(null);
			}
			var rendererClass:Class = _rendererToClassMap[renderer];
			if(_recyclerDic[rendererClass] == null)
			{
				_recyclerDic[rendererClass] = new Dictionary(true);
			}
			_recyclerDic[rendererClass][renderer] = null;
		}
		
		/**
		 * 更新当前所有项的索引.
		 */
		private function resetRenderersIndices():void
		{
			if(_indexToRenderer.length == 0)
			{
				return;
			}
			if(this.layout != null && this.layout.useVirtualLayout)
			{
				for each(var index:int in _virtualRendererIndices)
				{
					resetRendererItemIndex(index);
				}
			}
			else
			{
				const indexToRendererLength:int = _indexToRenderer.length;
				for(index = 0; index < indexToRendererLength; index++)
				{
					resetRendererItemIndex(index);
				}
			}
		}
		
		private function itemUpdatedHandler(item:Object, location:int):void
		{
			//防止无限循环
			if(_renderersBeingUpdated)
			{
				return;
			}
			var renderer:IItemRenderer = _indexToRenderer[location];
			if(renderer != null)
			{
				updateRenderer(renderer, location, item);
			}
		}
		
		/**
		 * 调整指定项呈示器的索引值.
		 */
		private function resetRendererItemIndex(index:int):void
		{
			var renderer:IItemRenderer = _indexToRenderer[index] as IItemRenderer;
			if(renderer != null)
			{
				renderer.itemIndex = index;
			}
		}
		
		/**
		 * 设置或获取用于数据项目的项呈示器.
		 * <p>该类必须实现 <code>IItemRenderer</code> 接口.</p>
		 * <p>rendererClass 获取顺序: itemRendererFunction->itemRenderer->默认 itemRenerer.</p>
		 */
		public function set itemRenderer(value:Class):void
		{
			if(_itemRenderer == value)
			{
				return;
			}
			_itemRenderer = value;
			_itemRendererChanged = true;
			_typicalItemChanged = true;
			_cleanFreeRenderer = true;
			removeDataProviderListener();
			this.invalidateProperties();
		}
		public function get itemRenderer():Class
		{
			return _itemRenderer;
		}
		
		/**
		 * 设置或获取为某个特定项目返回一个项呈示器的方法.
		 * <p>rendererClass 获取顺序: itemRendererFunction->itemRenderer->默认 itemRenerer.</p>
		 * <p>应该定义一个与此示例函数类似的呈示器函数:<br/>
		 * function myItemRendererFunction(item:Object):Class</p>
		 */
		public function set itemRendererFunction(value:Function):void
		{
			if(_itemRendererFunction == value)
			{
				return;
			}
			_itemRendererFunction = value;
			_itemRendererChanged = true;
			_typicalItemChanged = true;
			removeDataProviderListener();
			this.invalidateProperties();
		}
		public function get itemRendererFunction():Function
		{
			return _itemRendererFunction;
		}
		
		/**
		 * 设置或获取项渲染器的默认皮肤标识符.
		 * <p>在实例化 itemRenderer 时, 若其内部没有设置过 skinName, 则将此属性的值赋值给它的 skinName.</p>
		 * <p>注意: 若 itemRenderer 不是 <code>ISkinnableClient</code>, 则此属性无效.</p>
		 */
		public function set itemRendererSkinName(value:Object):void
		{
			if(_itemRendererSkinName == value)
			{
				return;
			}
			_itemRendererSkinName = value;
			if(_itemRendererSkinName != null && this.initialized)
			{
				_itemRendererSkinNameChange = true;
				this.invalidateProperties();
			}
		}
		public function get itemRendererSkinName():Object
		{
			return _itemRendererSkinName;
		}
		
		/**
		 * 为特定的数据项返回项呈示器类定义.
		 * @param item 数据项.
		 * @return 项呈示器类定义.
		 */
		private function itemToRendererClass(item:Object):Class
		{
			var rendererClass:Class;
			if(_itemRendererFunction != null)
			{
				rendererClass = _itemRendererFunction(item);
				if(rendererClass == null)
				{
					rendererClass = _itemRenderer;
				}
			}
			else
			{
				rendererClass = _itemRenderer;
			}
			return rendererClass ? rendererClass : ItemRenderer;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(this.layout == null)
			{
				var _layout:VerticalLayout = new VerticalLayout();
				_layout.gap = 0;
				_layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
				this.layout = _layout;
			}
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if(_itemRendererChanged || _dataProviderChanged || _useVirtualLayoutChanged)
			{
				removeAllRenderers();
				if(this.layout != null)
				{
					this.layout.clearVirtualLayoutCache();
				}
				setTypicalLayoutRect(null);
				_useVirtualLayoutChanged = false;
				_itemRendererChanged = false;
				if(_dataProvider != null)
				{
					_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
				}
				if(this.layout != null && this.layout.useVirtualLayout)
				{
					this.invalidateSize();
					this.invalidateDisplayList();
				}
				else
				{
					createRenderers();
				}
				if(_dataProviderChanged)
				{
					_dataProviderChanged = false;
					verticalScrollPosition = horizontalScrollPosition = 0;
				}
			}
			super.commitProperties();
			if(_typicalItemChanged)
			{
				_typicalItemChanged = false;
				if(_dataProvider != null && _dataProvider.length > 0)
				{
					_typicalItem = _dataProvider.getItemAt(0);
					measureRendererSize();
				}
			}
			if(_itemRendererSkinNameChange)
			{
				_itemRendererSkinNameChange = false;
				var length:int = _indexToRenderer.length;
				var client:ISkinnableClient;
				var comp:SkinnableComponent;
				for(var i:int = 0; i < length; i++)
				{
					setItemRenderSkinName(_indexToRenderer[i]);
				}
				for(var clazz:* in _freeRenderers)
				{
					var list:Vector.<IItemRenderer> = _freeRenderers[clazz];
					if(list != null)
					{
						length = list.length;
						for(i = 0; i < length; i++)
						{
							setItemRenderSkinName(list[i]);
						}
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			if(this.layout != null && this.layout.useVirtualLayout)
			{
				ensureTypicalLayoutElement();
			}
			super.measure();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(_layoutInvalidateDisplayListFlag && this.layout != null && this.layout.useVirtualLayout)
			{
				_virtualLayoutUnderway = true;
				ensureTypicalLayoutElement();
			}
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_virtualLayoutUnderway)
			{
				finishVirtualLayout();
			}
		}
		
		/**
		 * 确保测量过默认条目大小.
		 */
		private function ensureTypicalLayoutElement():void
		{
			if(this.layout.typicalLayoutRect)
			{
				return;
			}
			if(_dataProvider != null && _dataProvider.length > 0)
			{
				_typicalItem = _dataProvider.getItemAt(0);
				measureRendererSize();
			}
		}
		
		/**
		 * 测量项呈示器默认尺寸.
		 */
		private function measureRendererSize():void
		{
			if(_typicalItem == null)
			{
				setTypicalLayoutRect(null);
				return;
			}
			var rendererClass:Class = itemToRendererClass(_typicalItem);
			var typicalRenderer:IItemRenderer = createOneRenderer(rendererClass);
			if(typicalRenderer == null)
			{
				setTypicalLayoutRect(null);
				return;
			}
			_createNewRendererFlag = true;
			this.updateRenderer(typicalRenderer, 0, _typicalItem);
			if(typicalRenderer is IInvalidating)
			{
				(typicalRenderer as IInvalidating).validateNow();
			}
			var rect:Rectangle = new Rectangle(0, 0, typicalRenderer.preferredWidth, typicalRenderer.preferredHeight);
			recycle(typicalRenderer);
			setTypicalLayoutRect(rect);
			_createNewRendererFlag = false;
		}
		
		/**
		 * 设置项目默认大小.
		 * @param rect 尺寸.
		 */
		private function setTypicalLayoutRect(rect:Rectangle):void
		{
			_typicalLayoutRect = rect;
			if(this.layout != null)
			{
				this.layout.typicalLayoutRect = rect;
			}
		}
		
		/**
		 * 移除所有项呈示器.
		 */
		private function removeAllRenderers():void
		{
			var length:int = _indexToRenderer.length;
			var renderer:IItemRenderer;
			for(var i:int = 0; i < length; i++)
			{
				renderer = _indexToRenderer[i];
				if(renderer != null)
				{
					recycle(renderer);
					this.dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_REMOVE, renderer.data, renderer.itemIndex, renderer));
				}
			}
			_indexToRenderer = [];
			_virtualRendererIndices = null;
			if(!_cleanFreeRenderer)
			{
				return;
			}
			cleanAllFreeRenderer();
		}
		
		/**
		 * 为数据项创建项呈示器.
		 */
		private function createRenderers():void
		{
			if(_dataProvider == null)
			{
				return;
			}
			var index:int = 0;
			var length:int = _dataProvider.length;
			for(var i:int = 0; i < length; i++)
			{
				var item:Object = _dataProvider.getItemAt(i);
				var rendererClass:Class = itemToRendererClass(item);
				var renderer:IItemRenderer = createOneRenderer(rendererClass);
				if(renderer == null)
				{
					continue;
				}
				_indexToRenderer[index] = renderer;
				this.updateRenderer(renderer, index, item);
				this.dispatchEvent(new RendererExistenceEvent(RendererExistenceEvent.RENDERER_ADD, item, index, renderer));
				index++;
			}
		}
		
		/**
		 * 更新项呈示器数据.
		 * @param renderer 项呈示器.
		 * @param itemIndex 项目索引.
		 * @param data 项数据.
		 * @return 项呈示器.
		 */
		protected function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			_renderersBeingUpdated = true;
			if(_rendererOwner != null)
			{
				renderer = _rendererOwner.updateRenderer(renderer, itemIndex, data);
			}
			else 
			{
				if(renderer is IUIComponent)
				{
					(renderer as IUIComponent).ownerChanged(this);
				}
				renderer.itemIndex = itemIndex;
				renderer.label = this.itemToLabel(data);
				renderer.data = data;
			}
			_renderersBeingUpdated = false;
			return renderer;
		}
		
		/**
		 * 返回可在项呈示器中显示的字符串.
		 * @param item 项数据.
		 * @return 在项呈示器中显示的字符串.
		 */
		public function itemToLabel(item:Object):String
		{
			if(item != null)
			{
				return item.toString();
			}
			return " ";
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementAt(index:int):IUIComponent
		{
			return _indexToRenderer[index];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementIndex(element:IUIComponent):int
		{
			if(element == null)
			{
				return -1;
			}
			return _indexToRenderer.indexOf(element);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get numElements():int
		{
			if(_dataProvider == null)
			{
				return 0;
			}
			return _dataProvider.length;
		}
		
		[Deprecated]
		override public function addChild(child:DisplayObject):DisplayObject
		{
			throw new Error("addChild()在此组件中不可用，若此组件为容器类，请使用addElement()代替！");
		}
		
		[Deprecated]
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw new Error("addChildAt()在此组件中不可用，若此组件为容器类，请使用addElementAt()代替！");
		}
		
		[Deprecated]
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw new Error("removeChild()在此组件中不可用，若此组件为容器类，请使用removeElement()代替！");
		}
		
		[Deprecated]
		override public function removeChildAt(index:int):DisplayObject
		{
			throw new Error("removeChildAt()在此组件中不可用，若此组件为容器类，请使用removeElementAt()代替！");
		}
		
		[Deprecated]
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			throw new Error("setChildIndex()在此组件中不可用，若此组件为容器类，请使用setElementIndex()代替！");
		}
		
		[Deprecated]
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			throw new Error("swapChildren()在此组件中不可用，若此组件为容器类，请使用swapElements()代替！");
		}
		
		[Deprecated]
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			throw new Error("swapChildrenAt()在此组件中不可用，若此组件为容器类，请使用swapElementsAt()代替！");
		}
	}
}
