/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.hammerc.collections.CollectionKind;
	import org.hammerc.collections.ICollection;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IViewStack;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.CollectionEvent;
	import org.hammerc.events.ElementExistenceEvent;
	import org.hammerc.events.UIEvent;
	import org.hammerc.layouts.BasicLayout;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.CollectionEvent.COLLECTION_CHANGE
	 */
	[Event(name="collectionChange", type="org.hammerc.events.CollectionEvent")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.VALUE_COMMIT
	 */
	[Event(name="valueCommit", type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>ViewStack</code> 类实现了层级堆叠容器, 一次只显示一个子对象.
	 * @author wizardc
	 */
	public class ViewStack extends Group implements IViewStack, ICollection
	{
		/**
		 * 未设置缓存选中项的值.
		 */
		hammerc_internal static const NO_PROPOSED_SELECTION:int = -2;
		
		private var _createAllChildren:Boolean = false;
		
		private var _selectedChild:IUIComponent;
		
		/**
		 * 在属性提交前缓存选中项索引.
		 */
		private var _proposedSelectedIndex:int = NO_PROPOSED_SELECTION;
		
		hammerc_internal var _selectedIndex:int = -1;
		
		private var _notifyTabBar:Boolean = false;
		
		/**
		 * 子项显示列表顺序发生改变.
		 */
		private var _childOrderingChanged:Boolean = false;
		
		/**
		 * 创建一个 <code>ViewStack</code> 对象.
		 */
		public function ViewStack()
		{
			super();
			super.layout = new BasicLayout();
		}
		
		/**
		 * 布局对象限制为 <code>BasicLayout</code>.
		 */
		override public function set layout(value:LayoutBase):void
		{
		}
		
		/**
		 * 设置或获取是否立即初始化化所有子项.
		 * <p>false 表示当子项第一次被显示时再初始化它. 默认值 false.</p>
		 */
		public function set createAllChildren(value:Boolean):void
		{
			if(_createAllChildren == value)
			{
				return;
			}
			_createAllChildren = value;
			if(_createAllChildren)
			{
				var elements:Array = this.getElementsContent();
				for each(var element:IUIComponent in elements)
				{
					if(element is DisplayObject && element.parent != this)
					{
						_childOrderingChanged = true;
						this.addToDisplayList(DisplayObject(element));
					}
				}
				if(_childOrderingChanged)
				{
					this.invalidateProperties();
				}
			}
		}
		public function get createAllChildren():Boolean
		{
			return _createAllChildren;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedChild(value:IUIComponent):void
		{
			var index:int = this.getElementIndex(value);
			if(index >= 0 && index < this.numElements)
			{
				this.setSelectedIndex(index);
			}
		}
		public function get selectedChild():IUIComponent
		{
			var index:int = this.selectedIndex;
			if(index >= 0 && index < this.numElements)
			{
				return this.getElementAt(index);
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectedIndex(value:int):void
		{
			this.setSelectedIndex(value);
		}
		public function get selectedIndex():int
		{
			return _proposedSelectedIndex != NO_PROPOSED_SELECTION ? _proposedSelectedIndex : _selectedIndex;
		}
		
		/**
		 * 设置选中项索引.
		 * @param value 选中项索引.
		 * @param notifyListeners 是否播放事件.
		 */
		hammerc_internal function setSelectedIndex(value:int, notifyListeners:Boolean = true):void
		{
			if(value == this.selectedIndex)
			{
				return;
			}
			_proposedSelectedIndex = value;
			this.invalidateProperties();
			this.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			_notifyTabBar = _notifyTabBar || notifyListeners;
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function elementAdded(element:IUIComponent, index:int, notifyListeners:Boolean = true):void
		{
			if(_createAllChildren)
			{
				if(element is DisplayObject)
				{
					this.addToDisplayList(DisplayObject(element), index);
				}
			}
			if(notifyListeners)
			{
				if(this.hasEventListener(ElementExistenceEvent.ELEMENT_ADD))
				{
					this.dispatchEvent(new ElementExistenceEvent(ElementExistenceEvent.ELEMENT_ADD, element, index));
				}
			}
			element.visible = false;
			element.includeInLayout = false;
			if(this.selectedIndex == -1)
			{
				this.setSelectedIndex(index, false);
			}
			else if(index <= this.selectedIndex)
			{
				this.setSelectedIndex(selectedIndex + 1);
			}
			this.dispatchCoEvent(CollectionKind.ADD, [element.name], null, index);
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function elementRemoved(element:IUIComponent, index:int, notifyListeners:Boolean = true):void
		{
			super.elementRemoved(element, index, notifyListeners);
			element.visible = true;
			element.includeInLayout = true;
			if(index == this.selectedIndex)
			{
				if(this.numElements > 0)
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
					this.setSelectedIndex(-1);
				}
			}
			else if(index < this.selectedIndex)
			{
				this.setSelectedIndex(this.selectedIndex - 1);
			}
			this.dispatchCoEvent(CollectionKind.REMOVE, [element.name], null, index);
		}
		
		private function dispatchCoEvent(kind:String = null, items:Array = null, oldItems:Array = null, location:int = -1, oldLocation:int = -1):void
		{
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, kind, items, oldItems, location, oldLocation);
			this.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return this.numElements;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:int):Object
		{
			var element:IUIComponent = this.getElementAt(index);
			if(element != null)
			{
				return element.name;
			}
			return "";
		}
		
		/**
		 * @inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			var list:Array = this.getElementsContent();
			var length:int = list.length;
			for(var i:int = 0; i < length; i++)
			{
				if(list[i].name === item)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_proposedSelectedIndex != NO_PROPOSED_SELECTION)
			{
				commitSelection(_proposedSelectedIndex);
				_proposedSelectedIndex = NO_PROPOSED_SELECTION;
			}
			if(_childOrderingChanged)
			{
				_childOrderingChanged = false;
				var elements:Array = this.getElementsContent();
				for each(var element:IUIComponent in elements)
				{
					if(element is DisplayObject && element.parent == this)
					{
						this.addToDisplayList(DisplayObject(element));
					}
				}
			}
			if(_notifyTabBar)
			{
				_notifyTabBar = true;
				//通知 TabBar 自己的选中项发生改变
				this.dispatchEvent(new Event("IndexChanged"));
			}
		}
		
		private function commitSelection(newIndex:int):void
		{
			var oldIndex:int = _selectedIndex;
			if(newIndex >= 0 && newIndex < this.numElements)
			{
				_selectedIndex = newIndex;
				if(_selectedChild && _selectedChild.parent == this)
				{
					_selectedChild.visible = false;
					_selectedChild.includeInLayout = false;
				}
				_selectedChild = this.getElementAt(_selectedIndex);
				_selectedChild.visible = true;
				_selectedChild.includeInLayout = true;
				if(_selectedChild.parent != this && _selectedChild is DisplayObject)
				{
					this.addToDisplayList(DisplayObject(_selectedChild));
					if(!_childOrderingChanged)
					{
						_childOrderingChanged = true;
					}
				}
			}
			else
			{
				_selectedChild = null;
				_selectedIndex = -1;
			}
			this.invalidateSize();
			this.invalidateDisplayList();
		}
	}
}
