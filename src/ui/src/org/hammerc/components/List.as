/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.hammerc.components.supportClasses.ListBase;
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.IndexChangeEvent;
	import org.hammerc.events.ListEvent;
	import org.hammerc.events.RendererExistenceEvent;
	import org.hammerc.events.UIEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>List</code> 类实现了列表组件.
	 * @author wizardc
	 */
	public class List extends ListBase
	{
		/**
		 * 是否捕获 ItemRenderer 以便在 MouseUp 时抛出 ItemClick 事件.
		 */
		hammerc_internal var _captureItemRenderer:Boolean = true;
		
		private var _mouseDownItemRenderer:IItemRenderer;
		
		private var _allowMultipleSelection:Boolean = false;
		
		private var _selectedIndices:Vector.<int> = new Vector.<int>();
		
		private var _proposedSelectedIndices:Vector.<int>;
		
		/**
		 * 创建一个 <code>List</code> 对象.
		 */
		public function List()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return List;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "List";
		}
		
		/**
		 * 设置或获取是否允许同时选中多项.
		 */
		public function set allowMultipleSelection(value:Boolean):void
		{
			_allowMultipleSelection = value;
		}
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(this.itemRenderer == null)
			{
				this.itemRenderer = ItemRenderer;
			}
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if(renderer == null)
			{
				return;
			}
			renderer.addEventListener(MouseEvent.MOUSE_DOWN, this.item_mouseDownHandler);
			renderer.addEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererRemoveHandler(event);
			var renderer:DisplayObject = event.renderer as DisplayObject;
			if(renderer == null)
			{
				return;
			}
			renderer.removeEventListener(MouseEvent.MOUSE_DOWN, this.item_mouseDownHandler);
			renderer.removeEventListener(MouseEvent.MOUSE_UP, item_mouseUpHandler);
		}
		
		/**
		 * 鼠标在项呈示器上按下.
		 */
		protected function item_mouseDownHandler(event:MouseEvent):void
		{
			if(event.isDefaultPrevented())
			{
				return;
			}
			var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
			var newIndex:int;
			if(itemRenderer != null)
			{
				newIndex = itemRenderer.itemIndex;
			}
			else
			{
				newIndex = dataGroup.getElementIndex(event.currentTarget as IUIComponent);
			}
			if(_allowMultipleSelection)
			{
				this.setSelectedIndices(calculateSelectedIndices(newIndex, event.shiftKey, event.ctrlKey), true);
			}
			else
			{
				this.setSelectedIndex(newIndex, true);
			}
			if(!_captureItemRenderer)
			{
				return;
			}
			_mouseDownItemRenderer = itemRenderer;
			HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
			HammercGlobals.stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler, false, 0, true);
		}
		
		/**
		 * 鼠标在项呈示器上弹起, 抛出 ItemClick 事件.
		 */
		private function item_mouseUpHandler(event:MouseEvent):void
		{
			var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
			if(itemRenderer != _mouseDownItemRenderer)
			{
				return;
			}
			this.dispatchListEvent(event, ListEvent.ITEM_CLICK, itemRenderer);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get selectedIndex():int
		{
			if(_proposedSelectedIndices)
			{
				if(_proposedSelectedIndices.length > 0)
				{
					return _proposedSelectedIndices[0];
				}
				return -1;
			}
			return super.selectedIndex;
		}
		
		/**
		 * 鼠标在舞台上弹起.
		 */
		private function stage_mouseUpHandler(event:Event):void
		{
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler);
			_mouseDownItemRenderer = null;
		}
		
		/**
		 * 设置或获取当前选中的一个或多个项目的索引列表.
		 */
		public function set selectedIndices(value:Vector.<int>):void
		{
			this.setSelectedIndices(value, false);
		}
		public function get selectedIndices():Vector.<int>
		{
			if(_proposedSelectedIndices != null)
			{
				return _proposedSelectedIndices;
			}
			return _selectedIndices;
		}
		
		/**
		 * 设置或获取当前选中的一个或多个项目的数据源列表.
		 */
		public function set selectedItems(value:Vector.<Object>):void
		{
			var indices:Vector.<int> = new Vector.<int>();
			if(value != null)
			{
				var count:int = value.length;
				for(var i:int = 0; i < count; i++)
				{
					var index:int = this.dataProvider.getItemIndex(value[i]);
					if(index != -1)
					{
						indices.splice(0, 0, index);
					}
					if(index == -1)
					{
						indices = new Vector.<int>();
						break;
					}
				}
			}
			this.setSelectedIndices(indices, false);
		}
		public function get selectedItems():Vector.<Object>
		{
			var result:Vector.<Object> = new Vector.<Object>();
			var list:Vector.<int> = this.selectedIndices;
			if(list != null)
			{
				var count:int = list.length;
				for(var i:int = 0; i < count; i++)
				{
					result[i] = this.dataProvider.getItemAt(list[i]);
				}
			}
			return result;
		}
		
		/**
		 * 设置多个选中项.
		 */
		hammerc_internal function setSelectedIndices(value:Vector.<int>, dispatchChangeEvent:Boolean = false):void
		{
			if(dispatchChangeEvent)
			{
				_dispatchChangeAfterSelection = (_dispatchChangeAfterSelection || dispatchChangeEvent);
			}
			if(value != null)
			{
				_proposedSelectedIndices = value;
			}
			else
			{
				_proposedSelectedIndices = new Vector.<int>();
			}
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_proposedSelectedIndices != null)
			{
				commitSelection();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			var oldSelectedIndex:Number = _selectedIndex;
			if(_proposedSelectedIndices != null)
			{
				_proposedSelectedIndices = _proposedSelectedIndices.filter(isValidIndex);
				if(!allowMultipleSelection && _proposedSelectedIndices.length > 0)
				{
					var temp:Vector.<int> = new Vector.<int>();
					temp.push(_proposedSelectedIndices[0]);
					_proposedSelectedIndices = temp;
				}
				if(_proposedSelectedIndices.length > 0)
				{
					_proposedSelectedIndex = _proposedSelectedIndices[0];
				}
				else
				{
					_proposedSelectedIndex = -1;
				}
			}
			var retVal:Boolean = super.commitSelection(false);
			if(!retVal)
			{
				_proposedSelectedIndices = null;
				return false;
			}
			if(this.selectedIndex > NO_SELECTION)
			{
				if(_proposedSelectedIndices != null)
				{
					if(_proposedSelectedIndices.indexOf(this.selectedIndex) == -1)
					{
						_proposedSelectedIndices.push(this.selectedIndex);
					}
				}
				else
				{
					_proposedSelectedIndices = new <int>[this.selectedIndex];
				}
			}
			if(_proposedSelectedIndices != null)
			{
				if(_proposedSelectedIndices.indexOf(oldSelectedIndex) != -1)
				{
					this.itemSelected(oldSelectedIndex, true);
				}
				this.commitMultipleSelection();
			}
			if(dispatchChangedEvents && retVal)
			{
				var e:IndexChangeEvent;
				if(_dispatchChangeAfterSelection)
				{
					e = new IndexChangeEvent(IndexChangeEvent.CHANGE, false, false, oldSelectedIndex, _selectedIndex);
					this.dispatchEvent(e);
					_dispatchChangeAfterSelection = false;
				}
				this.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			}
			return retVal;
		}
		
		/**
		 * 是否是有效的索引.
		 */
		private function isValidIndex(item:int, index:int, v:Vector.<int>):Boolean
		{
			return this.dataProvider && (item >= 0) && (item < this.dataProvider.length);
		}
		
		/**
		 * 提交多项选中项属性.
		 */
		protected function commitMultipleSelection():void
		{
			var removedItems:Vector.<int> = new Vector.<int>();
			var addedItems:Vector.<int> = new Vector.<int>();
			var i:int;
			var count:int;
			if(_selectedIndices.length > 0 && _proposedSelectedIndices.length > 0)
			{
				count = _proposedSelectedIndices.length;
				for(i = 0; i < count; i++)
				{
					if(_selectedIndices.indexOf(_proposedSelectedIndices[i]) == -1)
					{
						addedItems.push(_proposedSelectedIndices[i]);
					}
				}
				count = _selectedIndices.length;
				for(i = 0; i < count; i++)
				{
					if(_proposedSelectedIndices.indexOf(_selectedIndices[i]) == -1)
					{
						removedItems.push(_selectedIndices[i]);
					}
				}
			}
			else if(_selectedIndices.length > 0)
			{
				removedItems = _selectedIndices;
			}
			else if(_proposedSelectedIndices.length > 0)
			{
				addedItems = _proposedSelectedIndices;
			}
			_selectedIndices = _proposedSelectedIndices;
			if(removedItems.length > 0)
			{
				count = removedItems.length;
				for(i = 0; i < count; i++)
				{
					itemSelected(removedItems[i], false);
				}
			}
			if(addedItems.length > 0)
			{
				count = addedItems.length;
				for(i = 0; i < count; i++)
				{
					itemSelected(addedItems[i], true);
				}
			}
			_proposedSelectedIndices = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function isItemIndexSelected(index:int):Boolean
		{
			if(_allowMultipleSelection)
			{
				return _selectedIndices.indexOf(index) != -1;
			}
			return super.isItemIndexSelected(index);
		}
		
		/**
		 * 计算当前的选中项列表.
		 */
		private function calculateSelectedIndices(index:int, shiftKey:Boolean, ctrlKey:Boolean):Vector.<int>
		{
			var i:int; 
			var interval:Vector.<int> = new Vector.<int>();
			if(!shiftKey)
			{
				if(ctrlKey)
				{
					if(_selectedIndices.length > 0)
					{
						if(_selectedIndices.length == 1 && (_selectedIndices[0] == index))
						{
							if(!this.requireSelection)
							{
								return interval;
							}
							interval.splice(0, 0, _selectedIndices[0]);
							return interval;
						}
						else
						{
							var found:Boolean = false;
							for(i = 0; i < _selectedIndices.length; i++)
							{
								if(_selectedIndices[i] == index)
								{
									found = true;
								}
								else if(_selectedIndices[i] != index)
								{
									interval.splice(0, 0, _selectedIndices[i]);
								}
							}
							if(!found)
							{
								interval.splice(0, 0, index);
							}
							return interval;
						}
					}
					else
					{
						interval.splice(0, 0, index);
						return interval;
					}
				}
				else
				{
					interval.splice(0, 0, index);
					return interval;
				}
			}
			else
			{
				var start:int = _selectedIndices.length > 0 ? _selectedIndices[_selectedIndices.length - 1] : 0;
				var end:int = index;
				if(start < end)
				{
					for(i = start; i <= end; i++)
					{
						interval.splice(0, 0, i);
					}
				}
				else
				{
					for(i = start; i >= end; i--)
					{
						interval.splice(0, 0, i);
					}
				}
				return interval;
			}
		}
	}
}
