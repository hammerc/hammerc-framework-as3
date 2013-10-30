/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.hammerc.collections.CollectionKind;
	import org.hammerc.collections.ICollection;
	import org.hammerc.components.IItemRenderer;
	import org.hammerc.components.SkinnableDataContainer;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.CollectionEvent;
	import org.hammerc.events.IndexChangeEvent;
	import org.hammerc.events.ListEvent;
	import org.hammerc.events.RendererExistenceEvent;
	import org.hammerc.events.UIEvent;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.ListEvent.ITEM_ROLL_OUT
	 */
	[Event(name="itemRollOver", type="org.hammerc.events.ListEvent")]
	
	/**
	 * @eventType org.hammerc.events.ListEvent.ITEM_ROLL_OVER
	 */
	[Event(name="itemRollOut", type="org.hammerc.events.ListEvent")]
	
	/**
	 * @eventType org.hammerc.events.ListEvent.ITEM_CLICK
	 */
	[Event(name="itemClick", type="org.hammerc.events.ListEvent")]
	
	/**
	 * @eventType org.hammerc.events.IndexChangeEvent.CHANGE
	 */
	[Event(name="changing", type="org.hammerc.events.IndexChangeEvent")]
	
	/**
	 * @eventType org.hammerc.events.IndexChangeEvent.CHANGING
	 */
	[Event(name="change", type="org.hammerc.events.IndexChangeEvent")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.VALUE_COMMIT
	 */
	[Event(name="valueCommit", type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>ListBase</code> 类为支持选择内容的所有组件的基类.
	 * @author wizardc
	 */
	public class ListBase extends SkinnableDataContainer
	{
		/**
		 * 未选中任何项时的索引值.
		 */
		public static const NO_SELECTION:int = -1;
		
		/**
		 * 未设置缓存选中项的值.
		 */
		hammerc_internal static const NO_PROPOSED_SELECTION:int = -2;
		
		/**
		 * 自定义的选中项.
		 */
		hammerc_internal static var CUSTOM_SELECTED_ITEM:int = -3;
		
		private static const TYPE_MAP:Object = {rollOver:"itemRollOver", rollOut:"itemRollOut"};
		
		/**
		 * 正在进行所有数据源的刷新操作.
		 */
		hammerc_internal var _doingWholesaleChanges:Boolean = false;
		
		private var _dataProviderChanged:Boolean;
		
		private var _labelField:String = "label";
		private var _labelFunction:Function;
		private var _labelFieldOrFunctionChanged:Boolean;
		
		private var _requireSelection:Boolean = false;
		private var _requireSelectionChanged:Boolean = false;
		
		/**
		 * 在属性提交前缓存真实的选中项的值.
		 */
		hammerc_internal var _proposedSelectedIndex:int = NO_PROPOSED_SELECTION;
		
		private var _selectedIndex:int = NO_SELECTION;
		
		/**
		 * 是否允许自定义的选中项.
		 */
		hammerc_internal var _allowCustomSelectedItem:Boolean = false;
		
		/**
		 * 索引改变后是否需要抛出事件.
		 */
		private var _dispatchChangeAfterSelection:Boolean = false;
		
		/**
		 * 在属性提交前缓存真实选中项的数据源.
		 */
		hammerc_internal var _pendingSelectedItem:*;
		
		private var _selectedItem:*;
		
		private var _useVirtualLayout:Boolean = false;
		
		private var _selectedIndexAdjusted:Boolean = false;
		
		/**
		 * 创建一个 <code>ListBase</code> 对象.
		 */
		public function ListBase()
		{
			super();
			this.focusEnabled = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set dataProvider(value:ICollection):void
		{
			if(this.dataProvider != null)
			{
				this.dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler);
			}
			_dataProviderChanged = true;
			_doingWholesaleChanges = true;
			if(value != null)
			{
				value.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler, false, 0, true);
			}
			super.dataProvider = value;
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set layout(value:LayoutBase):void
		{
			if(value && this.useVirtualLayout)
			{
				value.useVirtualLayout = true;
			}
			super.layout = value;
		}
		
		/**
		 * 设置或获取数据项中用来显示标签文字的字段名称.
		 * <p>若设置了 <code>labelFunction</code>, 则设置此属性无效.</p>
		 */
		public function set labelField(value:String):void
		{
			if(value == _labelField)
			{
				return;
			}
			_labelField = value;
			_labelFieldOrFunctionChanged = true;
			this.invalidateProperties();
		}
		public function get labelField():String
		{
			return _labelField;
		}
		
		/**
		 * 设置或获取在每个项目上运行以确定其标签的函数.
		 * <p>示例: function <code>labelFunc(item:Object):String</code>.</p>
		 */
		public function set labelFunction(value:Function):void
		{
			if(value == _labelFunction)
			{
				return;
			}
			_labelFunction = value;
			_labelFieldOrFunctionChanged = true;
			this.invalidateProperties();
		}
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		
		/**
		 * 设置或获取是否始终在控件中选中数据项目.
		 */
		public function set requireSelection(value:Boolean):void
		{
			if(value == _requireSelection)
			{
				return;
			}
			_requireSelection = value;
			if(value)
			{
				_requireSelectionChanged = true;
				this.invalidateProperties();
			}
		}
		public function get requireSelection():Boolean
		{
			return _requireSelection;
		}
		
		/**
		 * 设置或获取选中的索引.
		 * <p>或者如果未选中项目, 则为 -1. 设置 <code>selectedIndex</code> 属性会取消选择当前选定的项目并选择指定索引位置的数据项目.<br/>
		 * 当用户通过与控件交互来更改 <code>selectedIndex</code> 属性时, 此控件将分派 <code>change</code> 和 <code>changing</code> 事件.<br/>
		 * 当以编程方式更改 <code>selectedIndex</code> 属性的值时, 此控件不分派 <code>change</code> 和 <code>changing</code> 事件.</p>
		 */
		public function set selectedIndex(value:int):void
		{
			this.setSelectedIndex(value, false);
		}
		public function get selectedIndex():int
		{
			if(_proposedSelectedIndex != NO_PROPOSED_SELECTION)
			{
				return _proposedSelectedIndex;
			}
			return _selectedIndex;
		}
		
		/**
		 * 设置选中项.
		 */
		hammerc_internal function setSelectedIndex(value:int, dispatchChangeEvent:Boolean = false):void
		{
			if(value == this.selectedIndex)
			{
				return;
			}
			if(dispatchChangeEvent)
			{
				_dispatchChangeAfterSelection = (_dispatchChangeAfterSelection || dispatchChangeEvent);
			}
			_proposedSelectedIndex = value;
			this.invalidateProperties();
		}
		
		/**
		 * 设置或获取当前已选中的项目.
		 * <p>设置此属性会取消选中当前选定的项目并选择新指定的项目.<br/>
		 * 当用户通过与控件交互来更改 <code>selectedItem</code> 属性时, 此控件将分派 <code>change</code> 和 <code>changing</code> 事件.<br/>
		 * 当以编程方式更改 <code>selectedItem</code> 属性的值时, 此控件不分派 <code>change</code> 和 <code>changing</code> 事件.</p>
		 */
		public function set selectedItem(value:*):void
		{
			this.setSelectedItem(value, false);
		}
		public function get selectedItem():*
		{
			if(_pendingSelectedItem !== undefined)
			{
				return _pendingSelectedItem;
			}
			if(_allowCustomSelectedItem && this.selectedIndex == CUSTOM_SELECTED_ITEM)
			{
				return _selectedItem;
			}
			if(this.selectedIndex == NO_SELECTION || this.dataProvider == null)
			{
				return undefined;
			}
			return this.dataProvider.length > this.selectedIndex ? this.dataProvider.getItemAt(this.selectedIndex) : undefined;
		}
		
		/**
		 * 设置选中项数据源.
		 */
		hammerc_internal function setSelectedItem(value:*, dispatchChangeEvent:Boolean = false):void
		{
			if(this.selectedItem === value)
			{
				return;
			}
			if(dispatchChangeEvent)
			{
				_dispatchChangeAfterSelection = (_dispatchChangeAfterSelection || dispatchChangeEvent);
			}
			_pendingSelectedItem = value;
			this.invalidateProperties();
		}
		
		/**
		 * 设置或获取是否使用虚拟布局.
		 */
		public function set useVirtualLayout(value:Boolean):void
		{
			if(value == this.useVirtualLayout)
			{
				return;
			}
			_useVirtualLayout = value;
			if(this.layout)
			{
				this.layout.useVirtualLayout = value;
			}
		}
		public function get useVirtualLayout():Boolean
		{
			return this.layout != null ? this.layout.useVirtualLayout : _useVirtualLayout;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_dataProviderChanged)
			{
				_dataProviderChanged = false;
				_doingWholesaleChanges = false;
				if(this.selectedIndex >= 0 && this.dataProvider && this.selectedIndex < this.dataProvider.length)
				{
					this.itemSelected(this.selectedIndex, true);
				}
				else if(this.requireSelection)
				{
					_proposedSelectedIndex = 0;
				}
				else
				{
					this.setSelectedIndex(-1, false);
				}
			}
			if(_requireSelectionChanged)
			{
				_requireSelectionChanged = false;
				if(this.requireSelection && this.selectedIndex == NO_SELECTION && this.dataProvider != null && this.dataProvider.length > 0)
				{
					_proposedSelectedIndex = 0;
				}
			}
			if(_pendingSelectedItem !== undefined)
			{
				if(this.dataProvider != null)
				{
					_proposedSelectedIndex = this.dataProvider.getItemIndex(_pendingSelectedItem);
				}
				else
				{
					_proposedSelectedIndex = NO_SELECTION;
				}
				if(_allowCustomSelectedItem && _proposedSelectedIndex == -1)
				{
					_proposedSelectedIndex = CUSTOM_SELECTED_ITEM;
					_selectedItem = _pendingSelectedItem;
				}
				_pendingSelectedItem = undefined;
			}
			var changedSelection:Boolean = false;
			if(_proposedSelectedIndex != NO_PROPOSED_SELECTION)
			{
				changedSelection = this.commitSelection();
			}
			if(_selectedIndexAdjusted)
			{
				_selectedIndexAdjusted = false;
				if(!changedSelection)
				{
					this.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
				}
			}
			if(_dispatchChangeAfterSelection)
			{
				_dispatchChangeAfterSelection = false;
			}
			if(_labelFieldOrFunctionChanged)
			{
				if(this.dataGroup != null)
				{
					var itemIndex:int;
					if(this.layout != null && this.layout.useVirtualLayout)
					{
						for each(itemIndex in this.dataGroup.getElementIndicesInView())
						{
							updateRendererLabelProperty(itemIndex);
						}
					}
					else
					{
						var n:int = dataGroup.numElements;
						for(itemIndex = 0; itemIndex < n; itemIndex++)
						{
							updateRendererLabelProperty(itemIndex);
						}
					}
				}
				_labelFieldOrFunctionChanged = false;
			}
		}
		
		private function updateRendererLabelProperty(itemIndex:int):void
		{
			var renderer:IItemRenderer = this.dataGroup.getElementAt(itemIndex) as IItemRenderer;
			if(renderer != null)
			{
				renderer.label = this.itemToLabel(renderer.data);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function itemToLabel(item:Object):String
		{
			if(_labelFunction != null)
			{
				return _labelFunction(item);
			}
			if(item is String)
			{
				return String(item);
			}
			if(item is XML)
			{
				try
				{
					if(item[labelField].length() != 0)
					{
						item = item[labelField];
					}
				}
				catch(error:Error)
				{
				}
			}
			else if(item is Object)
			{
				try
				{
					if(item[labelField] != null)
					{
						item = item[labelField];
					}
				}
				catch(error:Error)
				{
				}
			}
			if(item is String)
			{
				return String(item);
			}
			try
			{
				if(item !== null)
				{
					return item.toString();
				}
			}
			catch(error:Error)
			{
			}
			return " ";
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == dataGroup)
			{
				if(_useVirtualLayout && dataGroup.layout)
				{
					dataGroup.layout.useVirtualLayout = true;
				}
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, this.dataGroup_rendererAddHandler);
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE, this.dataGroup_rendererRemoveHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == dataGroup)
			{
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD, this.dataGroup_rendererAddHandler);
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE, this.dataGroup_rendererRemoveHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			this.itemSelected(itemIndex, this.isItemIndexSelected(itemIndex));
			return super.updateRenderer(renderer, itemIndex, data); 
		}
		
		/**
		 * 选中或取消选中项目时调用. 子类必须覆盖此方法才可设置选中项.
		 * @param index 已选中的项目索引.
		 * @param selected 是否选中.
		 */
		protected function itemSelected(index:int, selected:Boolean):void
		{
			if(dataGroup == null)
			{
				return;
			}
			var renderer:IItemRenderer = dataGroup.getElementAt(index) as IItemRenderer;
			if(renderer == null)
			{
				return;
			}
			renderer.selected = selected;
		}
		
		/**
		 * 返回指定索引是否等于当前选中索引.
		 */
		hammerc_internal function isItemIndexSelected(index:int):Boolean
		{
			return index == this.selectedIndex;
		}
		
		/**
		 * 提交选中项属性.
		 * @param dispatchChangedEvents 是否抛出事件.
		 * @return 是否成功提交, false 表示被取消.
		 */
		protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			var maxIndex:int = this.dataProvider ? this.dataProvider.length - 1 : -1;
			var oldSelectedIndex:int = _selectedIndex;
			var e:IndexChangeEvent;
			if(!_allowCustomSelectedItem || _proposedSelectedIndex != CUSTOM_SELECTED_ITEM)
			{
				if(_proposedSelectedIndex < NO_SELECTION)
				{
					_proposedSelectedIndex = NO_SELECTION;
				}
				if(_proposedSelectedIndex > maxIndex)
				{
					_proposedSelectedIndex = maxIndex;
				}
				if(this.requireSelection && _proposedSelectedIndex == NO_SELECTION && this.dataProvider != null && this.dataProvider.length > 0)
				{
					_proposedSelectedIndex = NO_PROPOSED_SELECTION;
					return false;
				}
			}
			var tmpProposedIndex:int = _proposedSelectedIndex;
			if(_dispatchChangeAfterSelection)
			{
				e = new IndexChangeEvent(IndexChangeEvent.CHANGING, false, true, _selectedIndex, _proposedSelectedIndex);
				if(!this.dispatchEvent(e))
				{
					this.itemSelected(_proposedSelectedIndex, false);
					_proposedSelectedIndex = NO_PROPOSED_SELECTION;
					return false;
				}
			}
			_selectedIndex = tmpProposedIndex;
			_proposedSelectedIndex = NO_PROPOSED_SELECTION;
			if(oldSelectedIndex != NO_SELECTION)
			{
				this.itemSelected(oldSelectedIndex, false);
			}
			if(_selectedIndex != NO_SELECTION)
			{
				this.itemSelected(_selectedIndex, true);
			}
			//子类若需要自身抛出 Change 事件, 而不是在此处抛出, 可以设置 dispatchChangedEvents 为 false
			if(dispatchChangedEvents)
			{
				if(_dispatchChangeAfterSelection)
				{
					e = new IndexChangeEvent(IndexChangeEvent.CHANGE, false, false, oldSelectedIndex, _selectedIndex);
					this.dispatchEvent(e);
					_dispatchChangeAfterSelection = false;
				}
				this.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			}
			return true;
		}
		
		/**
		 * 仅调整选中索引值而不更新选中项, 即在提交属性阶段 itemSelected 方法不会被调用, 也不会触发 changing 和 change 事件.
		 * @param newIndex 新索引.
		 * @param add 如果已将项目添加到组件, 则为 true, 如果已删除项目, 则为 false.
		 */		
		protected function adjustSelection(newIndex:int, add:Boolean = false):void
		{
			if(_proposedSelectedIndex != NO_PROPOSED_SELECTION)
			{
				_proposedSelectedIndex = newIndex;
			}
			else
			{
				_selectedIndex = newIndex;
			}
			_selectedIndexAdjusted = true;
			this.invalidateProperties();
		}
		
		/**
		 * 数据项添加.
		 * @param index 指定的索引.
		 */
		protected function itemAdded(index:int):void
		{
			if(_doingWholesaleChanges)
			{
				return;
			}
			if(this.selectedIndex == NO_SELECTION)
			{
				if(this.requireSelection)
				{
					this.adjustSelection(index, true);
				}
			}
			else if(index <= this.selectedIndex)
			{
				this.adjustSelection(this.selectedIndex + 1, true);
			}
		}
		
		/**
		 * 数据项移除.
		 * @param index 指定的索引.
		 */
		protected function itemRemoved(index:int):void
		{
			if(this.selectedIndex == NO_SELECTION || _doingWholesaleChanges)
			{
				return;
			}
			if(index == this.selectedIndex)
			{
				if(this.requireSelection && this.dataProvider != null && this.dataProvider.length > 0)
				{       
					if(index == 0)
					{
						_proposedSelectedIndex = 0;
						this.invalidateProperties();
					}
					else
					{
						this.setSelectedIndex(0, false);
					}
				}
				else
				{
					this.adjustSelection(-1, false);
				}
			}
			else if(index < this.selectedIndex)
			{
				this.adjustSelection(this.selectedIndex - 1, false);
			}
		}
		
		/**
		 * 项呈示器被添加.
		 * @param event 对应的事件.
		 */
		protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if(renderer == null)
			{
				return;
			}
			renderer.addEventListener(MouseEvent.ROLL_OVER, item_mouseEventHandler);
			renderer.addEventListener(MouseEvent.ROLL_OUT, item_mouseEventHandler);
		}
		
		/**
		 * 项呈示器被移除.
		 * @param event 对应的事件.
		 */
		protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if(renderer == null)
			{
				return;
			}
			renderer.removeEventListener(MouseEvent.ROLL_OVER, item_mouseEventHandler);
			renderer.removeEventListener(MouseEvent.ROLL_OUT, item_mouseEventHandler);
		}
		
		/**
		 * 项呈示器鼠标事件.
		 * @param event 对应的事件.
		 */
		private function item_mouseEventHandler(event:MouseEvent):void
		{
			var type:String = event.type;
			type = TYPE_MAP[type];
			if(this.hasEventListener(type))
			{
				var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
				this.dispatchListEvent(event, type, itemRenderer);
			}
		}
		
		/**
		 * 抛出列表事件.
		 * @param mouseEvent 相关联的鼠标事件.
		 * @param type 事件名称.
		 * @param itemRenderer 关联的条目渲染器实例.
		 */
		hammerc_internal function dispatchListEvent(mouseEvent:MouseEvent, type:String, itemRenderer:IItemRenderer):void
		{
			var itemIndex:int = -1;
			if(itemRenderer != null)
			{
				itemIndex = itemRenderer.itemIndex;
			}
			else
			{
				itemIndex = dataGroup.getElementIndex(mouseEvent.currentTarget as IUIComponent);
			}
			var listEvent:ListEvent = new ListEvent(type, false, false, mouseEvent.localX, mouseEvent.localY, mouseEvent.relatedObject, mouseEvent.ctrlKey, mouseEvent.altKey, mouseEvent.shiftKey, mouseEvent.buttonDown, mouseEvent.delta, itemIndex, this.dataProvider.getItemAt(itemIndex), itemRenderer);
			this.dispatchEvent(listEvent);
		}
		
		/**
		 * 数据源发生改变.
		 * @param event 对应的事件.
		 */
		protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{
			var items:Array = event.items;
			if(event.kind == CollectionKind.ADD)
			{
				var length:int = items.length;
				for(var i:int = 0; i < length; i++)
				{
					this.itemAdded(event.location + i);
				}
			}
			else if(event.kind == CollectionKind.REMOVE)
			{
				length = items.length;
				for(i = length-1; i >= 0; i--)
				{
					this.itemRemoved(event.location + i);
				}
			}
			else if(event.kind == CollectionKind.MOVE)
			{
				this.itemRemoved(event.oldLocation);
				this.itemAdded(event.location);
			}
			else if(event.kind == CollectionKind.RESET)
			{
				if(this.dataProvider.length == 0)
				{
					this.setSelectedIndex(NO_SELECTION, false);
				}
				else
				{
					_dataProviderChanged = true; 
					this.invalidateProperties(); 
				}
			}
			else if(event.kind == CollectionKind.REFRESH)
			{
				this.setSelectedIndex(NO_SELECTION, false);
			}
		}
	}
}
