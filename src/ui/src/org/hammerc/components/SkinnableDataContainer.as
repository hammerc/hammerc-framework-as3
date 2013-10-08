/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import org.hammerc.collections.ICollection;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.RendererExistenceEvent;
	import org.hammerc.layouts.HorizontalAlign;
	import org.hammerc.layouts.VerticalLayout;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
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
	 * <code>SkinnableDataContainer</code> 类实现了可设置外观的数据项目显示容器类.
	 * @author wizardc
	 */
	public class SkinnableDataContainer extends SkinnableComponent implements IItemRendererOwner
	{
		/**
		 * 皮肤子件, 内容容器.
		 */
		public var dataGroup:DataGroup;
		
		/**
		 * dataGroup 发生改变时传递的参数.
		 */
		private var _dataGroupProperties:Object = {};
		
		/**
		 * 创建一个 <code>SkinnableDataContainer</code> 对象.
		 */
		public function SkinnableDataContainer()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return SkinnableDataContainer;
		}
		
		/**
		 * 设置或获取列表数据源.
		 */
		public function set dataProvider(value:ICollection):void
		{
			if(dataGroup == null)
			{
				_dataGroupProperties.dataProvider = value;
			}
			else
			{
				dataGroup.dataProvider = value;
				_dataGroupProperties.dataProvider = true;
			}
		}
		public function get dataProvider():ICollection
		{
			return dataGroup != null ? dataGroup.dataProvider : _dataGroupProperties.dataProvider;
		}
		
		/**
		 * 设置或获取用于数据项目的项呈示器.
		 * <p>该类必须实现 <code>IItemRenderer</code> 接口.</p>
		 * <p>rendererClass 获取顺序: itemRendererFunction->itemRenderer->默认 itemRenerer.</p>
		 */
		public function set itemRenderer(value:Class):void
		{
			if(dataGroup == null)
			{
				_dataGroupProperties.itemRenderer = value;
			}
			else
			{
				dataGroup.itemRenderer = value;
				_dataGroupProperties.itemRenderer = true;
			}
		}
		public function get itemRenderer():Class
		{
			return dataGroup != null ? dataGroup.itemRenderer : _dataGroupProperties.itemRenderer;
		}
		
		/**
		 * 设置或获取为某个特定项目返回一个项呈示器的方法.
		 * <p>rendererClass 获取顺序: itemRendererFunction->itemRenderer->默认 itemRenerer.</p>
		 * <p>应该定义一个与此示例函数类似的呈示器函数:<br/>
		 * function myItemRendererFunction(item:Object):Class</p>
		 */
		public function set itemRendererFunction(value:Function):void
		{
			if(dataGroup == null)
			{
				_dataGroupProperties.itemRendererFunction = value;
			}
			else
			{
				dataGroup.itemRendererFunction = value;
				_dataGroupProperties.itemRendererFunction = true;
			}
		}
		public function get itemRendererFunction():Function
		{
			return dataGroup != null ? dataGroup.itemRendererFunction : _dataGroupProperties.itemRendererFunction;
		}
		
		/**
		 * 设置或获取项渲染器的默认皮肤标识符.
		 * <p>在实例化 itemRenderer 时, 若其内部没有设置过 skinName, 则将此属性的值赋值给它的 skinName.</p>
		 * <p>注意: 若 itemRenderer 不是 <code>ISkinnableClient</code>, 则此属性无效.</p>
		 */
		public function set itemRendererSkinName(value:Object):void
		{
			if(dataGroup == null)
			{
				_dataGroupProperties.itemRendererSkinName = value;
			}
			else
			{
				dataGroup.itemRendererSkinName = value;
				_dataGroupProperties.itemRendererSkinName = true;
			}
		}
		public function get itemRendererSkinName():Object
		{
			return dataGroup != null ? dataGroup.itemRendererSkinName : _dataGroupProperties.itemRendererSkinName;
		}
		
		/**
		 * 设置或获取此容器的布局对象.
		 */
		public function set layout(value:LayoutBase):void
		{
			if(dataGroup == null)
			{
				_dataGroupProperties.layout = value;
			}
			else
			{
				dataGroup.layout = value;
				_dataGroupProperties.layout = true;
			}
		}
		public function get layout():LayoutBase
		{
			return dataGroup != null ? dataGroup.layout : _dataGroupProperties.layout;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == dataGroup)
			{
				var newDataGroupProperties:Object = {};
				if(_dataGroupProperties.layout !== undefined)
				{
					dataGroup.layout = _dataGroupProperties.layout;
					newDataGroupProperties.layout = true;
				}
				if(_dataGroupProperties.dataProvider !== undefined)
				{
					dataGroup.dataProvider = _dataGroupProperties.dataProvider;
					newDataGroupProperties.dataProvider = true;
				}
				if(_dataGroupProperties.itemRenderer !== undefined)
				{
					dataGroup.itemRenderer = _dataGroupProperties.itemRenderer;
					newDataGroupProperties.itemRenderer = true;
				}
				if(_dataGroupProperties.itemRendererSkinName !== undefined)
				{
					dataGroup.itemRendererSkinName = _dataGroupProperties.itemRendererSkinName;
					newDataGroupProperties.itemRendererSkinName = true;
				}
				if(_dataGroupProperties.itemRendererFunction !== undefined)
				{
					dataGroup.itemRendererFunction = _dataGroupProperties.itemRendererFunction;
					newDataGroupProperties.itemRendererFunction = true;
				}
				dataGroup.rendererOwner = this;
				_dataGroupProperties = newDataGroupProperties;
				if(hasEventListener(RendererExistenceEvent.RENDERER_ADD))
				{
					dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				}
				if(hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
				{
					dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				}
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
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				var newDataGroupProperties:Object = {};
				if(_dataGroupProperties.layout != null)
				{
					newDataGroupProperties.layout = dataGroup.layout;
				}
				if(_dataGroupProperties.dataProvider != null)
				{
					newDataGroupProperties.dataProvider = dataGroup.dataProvider;
				}
				if(_dataGroupProperties.itemRenderer != null)
				{
					newDataGroupProperties.itemRenderer = dataGroup.itemRenderer;
				}
				if(_dataGroupProperties.itemRendererSkinName != null)
				{
					newDataGroupProperties.itemRendererSkinName = dataGroup.itemRendererSkinName;
				}
				if(_dataGroupProperties.itemRendererFunction != null)
				{
					newDataGroupProperties.itemRendererFunction = dataGroup.itemRendererFunction;
				}
				_dataGroupProperties = newDataGroupProperties;
				dataGroup.rendererOwner = null;
				dataGroup.dataProvider = null;
				dataGroup.layout = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if(type == RendererExistenceEvent.RENDERER_ADD && dataGroup != null)
			{
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
			}
			if(type == RendererExistenceEvent.RENDERER_REMOVE && dataGroup != null)
			{
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
			if(type == RendererExistenceEvent.RENDERER_ADD && dataGroup != null)
			{
				if(!this.hasEventListener(RendererExistenceEvent.RENDERER_ADD))
				{
					dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				}
			}
			if(type == RendererExistenceEvent.RENDERER_REMOVE && dataGroup != null)
			{
				if(!this.hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
				{
					dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function createSkinParts():void
		{
			dataGroup = new DataGroup();
			dataGroup.percentHeight = dataGroup.percentWidth = 100;
			dataGroup.clipAndEnableScrolling = true;
			var layout:VerticalLayout = new VerticalLayout();
			dataGroup.layout = layout;
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
			this.addToDisplayList(dataGroup);
			this.partAdded("dataGroup", dataGroup);
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function removeSkinParts():void
		{
			if(dataGroup == null)
			{
				return;
			}
			this.partRemoved("dataGroup", dataGroup);
			this.removeFromDisplayList(dataGroup);
			dataGroup = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateRenderer(renderer:IItemRenderer, itemIndex:int, data:Object):IItemRenderer
		{
			if(renderer is IUIComponent)
			{
				(renderer as IUIComponent).ownerChanged(this);
			}
			renderer.itemIndex = itemIndex;
			renderer.data = data;
			return renderer;
		}
	}
}
