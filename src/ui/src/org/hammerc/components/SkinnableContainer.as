/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.ElementExistenceEvent;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.ElementExistenceEvent.ELEMENT_ADD
	 */
	[Event(name="elementAdd", type="org.hammerc.events.ElementExistenceEvent")]
	
	/**
	 * @eventType org.hammerc.events.ElementExistenceEvent.ELEMENT_REMOVE
	 */
	[Event(name="elementRemove", type="org.hammerc.events.ElementExistenceEvent")]
	
	/**
	 * <code>SkinnableContainer</code> 类实现了可设置外观的容器基类.
	 * @author wizardc
	 */
	public class SkinnableContainer extends SkinnableComponent implements IUIContainer
	{
		/**
		 * 皮肤子件, 内容容器.
		 */
		public var contentGroup:Group;
		
		/**
		 * 实体容器实例化之前缓存子对象的容器.
		 */
		hammerc_internal var _placeHolderGroup:Group;
		
		/**
		 * contentGroup 发生改变时传递的参数.
		 */
		private var _contentGroupProperties:Object = new Object();
		
		/**
		 * 创建一个 <code>SkinnableContainer</code> 对象.
		 */
		public function SkinnableContainer()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return SkinnableContainer;
		}
		
		/**
		 * 获取当前的实体容器.
		 */
		hammerc_internal function get currentContentGroup():Group
		{
			if(contentGroup == null)
			{
				if(_placeHolderGroup == null)
				{
					_placeHolderGroup = new Group();
					_placeHolderGroup.visible = false;
					this.addToDisplayList(_placeHolderGroup);
				}
				_placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
				_placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
				return _placeHolderGroup;
			}
			else
			{
				return contentGroup;
			}
		}
		
		/**
		 * 设置或获取此容器的布局对象.
		 */
		public function set layout(value:LayoutBase):void
		{
			if(contentGroup != null)
			{
				contentGroup.layout = value;
			}
			else
			{
				_contentGroupProperties.layout = value;
			}
		}
		public function get layout():LayoutBase
		{
			return contentGroup != null ? contentGroup.layout : _contentGroupProperties.layout;
		}
		
		/**
		 * 设置容器子对象数组. 数组包含要添加到容器的子项列表, 之前的已存在于容器中的子项列表被全部移除后添加列表里的每一项到容器.
		 * <p>设置该属性时会对您输入的数组进行一次浅复制操作, 所以您之后对该数组的操作不会影响到添加到容器的子项列表数量.</p>
		 */
		public function set elementsContent(value:Array):void
		{
			this.currentContentGroup.elementsContent = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numElements():int
		{
			return this.currentContentGroup.numElements;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementAt(index:int):IUIComponent
		{
			return this.currentContentGroup.getElementAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IUIComponent):IUIComponent
		{
			return this.currentContentGroup.addElement(element);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IUIComponent, index:int):IUIComponent
		{
			return this.currentContentGroup.addElementAt(element, index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IUIComponent):IUIComponent
		{
			return this.currentContentGroup.removeElement(element);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IUIComponent
		{
			return this.currentContentGroup.removeElementAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllElements():void
		{
			this.currentContentGroup.removeAllElements();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementIndex(element:IUIComponent):int
		{
			return this.currentContentGroup.getElementIndex(element);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IUIComponent, index:int):void
		{
			this.currentContentGroup.setElementIndex(element, index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function swapElements(element1:IUIComponent, element2:IUIComponent):void
		{
			this.currentContentGroup.swapElements(element1, element2);
		}
		
		/**
		 * @inheritDoc
		 */
		public function swapElementsAt(index1:int, index2:int):void
		{
			this.currentContentGroup.swapElementsAt(index1, index2);
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsElement(element:IUIComponent):Boolean
		{
			return this.currentContentGroup.containsElement(element);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == contentGroup)
			{
				if(_contentGroupProperties.layout !== undefined)
				{
					contentGroup.layout = _contentGroupProperties.layout;
					_contentGroupProperties = new Object();
				}
				if(_placeHolderGroup != null)
				{
					_placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
					_placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
					var sourceContent:Array = _placeHolderGroup.getElementsContent().concat();
					for(var i:int = _placeHolderGroup.numElements; i > 0; i--)
					{
						_placeHolderGroup.removeElementAt(0);
					}
					this.removeFromDisplayList(_placeHolderGroup);
					contentGroup.elementsContent = sourceContent;
					_placeHolderGroup = null;
				}
				contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
				contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == contentGroup)
			{
				contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
				contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
				_contentGroupProperties.layout = contentGroup.layout;
				contentGroup.layout = null;
				if(contentGroup.numElements > 0)
				{
					_placeHolderGroup = new Group();
					while(contentGroup.numElements > 0)
					{
						_placeHolderGroup.addElement(contentGroup.getElementAt(0));
					}
					_placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD, contentGroup_elementAddedHandler);
					_placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE, contentGroup_elementRemovedHandler);
				}
			}
		}
		
		hammerc_internal function contentGroup_elementAddedHandler(event:ElementExistenceEvent):void
		{
			event.element.ownerChanged(this);
			this.dispatchEvent(event);
		}
		
		hammerc_internal function contentGroup_elementRemovedHandler(event:ElementExistenceEvent):void
		{
			event.element.ownerChanged(null);
			this.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function createSkinParts():void
		{
			contentGroup = new Group();
			contentGroup.percentWidth = 100;
			contentGroup.percentHeight = 100;
			this.addToDisplayList(contentGroup);
			this.partAdded("contentGroup", contentGroup);
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function removeSkinParts():void
		{
			this.partRemoved("contentGroup", contentGroup);
			this.removeFromDisplayList(contentGroup);
			contentGroup = null;
		}
	}
}
