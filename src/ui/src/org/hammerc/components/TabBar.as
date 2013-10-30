/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.hammerc.collections.ICollection;
	import org.hammerc.components.supportClasses.ListBase;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.IndexChangeEvent;
	import org.hammerc.events.ListEvent;
	import org.hammerc.events.RendererExistenceEvent;
	import org.hammerc.layouts.HorizontalAlign;
	import org.hammerc.layouts.HorizontalLayout;
	import org.hammerc.layouts.VerticalAlign;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TabBar</code> 类为选项卡组件.
	 * @author wizardc
	 */
	public class TabBar extends ListBase
	{
		private var _requireSelectionChanged:Boolean;
		
		/**
		 * 创建一个 <code>TabBar</code> 对象.
		 */
		public function TabBar()
		{
			super();
			this.tabChildren = false;
			this.tabEnabled = true;
			this.requireSelection = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TabBar;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set requireSelection(value:Boolean):void
		{
			if(value == this.requireSelection)
			{
				return;
			}
			super.requireSelection = value;
			_requireSelectionChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * 设置或获取列表数据源.
		 * <p>可以直接将一个 <code>ViewStack</code> 对象作为 <code>dataProvider</code> 赋值.</p>
		 */
		override public function set dataProvider(value:ICollection):void
		{
			if(this.dataProvider is ViewStack)
			{
				this.dataProvider.removeEventListener("IndexChanged", onViewStackIndexChange);
				this.removeEventListener(IndexChangeEvent.CHANGE, onIndexChanged);
			}
			if(value is ViewStack)
			{
				value.addEventListener("IndexChanged", onViewStackIndexChange);
				this.addEventListener(IndexChangeEvent.CHANGE, onIndexChanged);
			}
			super.dataProvider = value;
		}
		override public function get dataProvider():ICollection
		{
			return super.dataProvider;
		}
		
		/**
		 * 鼠标点击的选中项改变.
		 */
		private function onIndexChanged(event:IndexChangeEvent):void
		{
			ViewStack(this.dataProvider).setSelectedIndex(event.newIndex, false);
		}
		
		/**
		 * ViewStack 选中项发生改变.
		 */
		private function onViewStackIndexChange(event:Event):void
		{
			this.setSelectedIndex(ViewStack(this.dataProvider).selectedIndex, false);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_requireSelectionChanged && dataGroup != null)
			{
				_requireSelectionChanged = false;
				const n:int = dataGroup.numElements;
				for(var i:int = 0; i < n; i++)
				{
					var renderer:TabBarButton = dataGroup.getElementAt(i) as TabBarButton;
					if(renderer != null)
					{
						renderer.allowDeselection = !this.requireSelection;
					}
				}
			}
		}
		
		/**
		 * 根据索引获取对应的 ItemRender.
		 */
		private function getItemRenderer(index:int):IUIComponent
		{
			if(dataGroup == null || (index < 0) || (index >= dataGroup.numElements))
			{
				return null;
			}
			return dataGroup.getElementAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function itemSelected(index:int, selected:Boolean):void
		{
			super.itemSelected(index, selected);
			const renderer:IItemRenderer = getItemRenderer(index) as IItemRenderer;
			if(renderer != null)
			{
				renderer.selected = selected;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			const renderer:IItemRenderer = event.renderer;
			if(renderer != null)
			{
				renderer.addEventListener(MouseEvent.CLICK, item_clickHandler);
				if(renderer is TabBarButton)
				{
					TabBarButton(renderer).allowDeselection = !this.requireSelection;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{   
			super.dataGroup_rendererRemoveHandler(event);
			const renderer:IItemRenderer = event.renderer;
			if(renderer != null)
			{
				renderer.removeEventListener(MouseEvent.CLICK, item_clickHandler);
			}
		}
		
		/**
		 * 鼠标在条目上按下.
		 */
		private function item_clickHandler(event:MouseEvent):void
		{
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
			if(newIndex == this.selectedIndex)
			{
				if(!this.requireSelection)
				{
					this.setSelectedIndex(NO_SELECTION, true);
				}
			}
			else
			{
				this.setSelectedIndex(newIndex, true);
			}
			this.dispatchListEvent(event, ListEvent.ITEM_CLICK, itemRenderer);
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function createSkinParts():void
		{
			dataGroup = new DataGroup();
			dataGroup.percentHeight = dataGroup.percentWidth = 100;
			dataGroup.clipAndEnableScrolling = true;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = -1;
			layout.horizontalAlign = HorizontalAlign.JUSTIFY;
			layout.verticalAlign = VerticalAlign.CONTENT_JUSTIFY;
			dataGroup.layout = layout;
			this.addToDisplayList(dataGroup);
			this.partAdded("dataGroup", dataGroup);
		}
	}
}
