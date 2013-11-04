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
	import org.hammerc.events.ListEvent;
	import org.hammerc.events.RendererExistenceEvent;
	
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
			this.setSelectedIndex(newIndex, true);
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
		 * 鼠标在舞台上弹起.
		 */
		private function stage_mouseUpHandler(event:Event):void
		{
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler);
			_mouseDownItemRenderer = null;
		}
	}
}
