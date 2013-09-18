/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.hammerc.components.supportClasses.GroupBase;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.DragEvent;
	import org.hammerc.events.ElementExistenceEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>Group</code> 类实现了框架的容器, 屏蔽了原生子对象管理 API.
	 * @author wizardc
	 */
	public class Group extends GroupBase implements IUIContainer
	{
		private var _hasMouseListeners:Boolean = false;
		
		/**
		 * 鼠标事件的监听个数.
		 */
		private var _mouseEventReferenceCount:int;
		
		private var _mouseEnabledWhereTransparent:Boolean = true;
		
		/**
		 * createChildren 方法已经执行过的标志.
		 */
		private var _createChildrenCalled:Boolean = false;
		
		/**
		 * elementsContent 改变标志.
		 */
		private  var _elementsContentChanged:Boolean = false;
		
		private var _elementsContent:Array = [];
		
		/**
		 * 创建一个 <code>Group</code> 对象.
		 */
		public function Group()
		{
			super();
		}
		
		/**
		 * 是否添加过鼠标事件监听.
		 */
		private function set hasMouseListeners(value:Boolean):void
		{
			if(_mouseEnabledWhereTransparent)
			{
				this.invalidateDisplayListExceptLayout();
			}
			_hasMouseListeners = value;
		}
		
		/**
		 * 设置或获取是否允许透明区域也响应鼠标事件, 默认 true.
		 */
		public function set mouseEnabledWhereTransparent(value:Boolean):void
		{
			if(value != _mouseEnabledWhereTransparent)
			{
				_mouseEnabledWhereTransparent = value;
				if(_hasMouseListeners)
				{
					this.invalidateDisplayListExceptLayout();
				}
			}
		}
		public function get mouseEnabledWhereTransparent():Boolean
		{
			return _mouseEnabledWhereTransparent;
		}
		
		/**
		 * 返回子元素列表.
		 */
		hammerc_internal function getElementsContent():Array
		{
			return _elementsContent;
		}
		
		/**
		 * 设置容器子对象数组. 数组包含要添加到容器的子项列表, 之前的已存在于容器中的子项列表被全部移除后添加列表里的每一项到容器.
		 * <p>设置该属性时会对您输入的数组进行一次浅复制操作, 所以您之后对该数组的操作不会影响到添加到容器的子项列表数量.</p>
		 */
		public function set elementsContent(value:Array):void
		{
			if(value == null)
			{
				value = [];
			}
			if(value == _elementsContent)
			{
				return;
			}
			if(_createChildrenCalled)
			{
				setElementsContent(value);
			}
			else
			{
				_elementsContentChanged = true;
				for(var i:int = _elementsContent.length - 1; i >= 0; i--)
				{
					this.elementRemoved(_elementsContent[i], i);
				}
				_elementsContent = value;
			}
		}
		
		/**
		 * 设置容器子对象列表.
		 */
		private function setElementsContent(value:Array):void
		{
			var i:int;
			for(i = _elementsContent.length - 1; i >= 0; i--)
			{
				this.elementRemoved(_elementsContent[i], i);
			}
			_elementsContent = value.concat();
			var n:int = _elementsContent.length;
			for(i = 0; i < n; i++)
			{   
				var elt:IUIComponent = _elementsContent[i];
				if(elt.parent is IUIContainer)
				{
					IUIContainer(elt.parent).removeElement(elt);
				}
				this.elementAdded(elt, i);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get numElements():int
		{
			return _elementsContent.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			_createChildrenCalled = true;
			if(_elementsContentChanged)
			{
				_elementsContentChanged = false;
				setElementsContent(_elementsContent);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			drawBackground();
		}
		
		/**
		 * 绘制鼠标点击区域.
		 */
		private function drawBackground():void
		{
			if(!_mouseEnabledWhereTransparent || !_hasMouseListeners)
			{
				return;
			}
			this.graphics.clear();
			if(this.width == 0 || this.height == 0)
			{
				return;
			}
			this.graphics.beginFill(0xffffff, 0);
			if(this.layout != null && this.layout.clipAndEnableScrolling)
			{
				this.graphics.drawRect(this.layout.horizontalScrollPosition, this.layout.verticalScrollPosition, this.width, this.height);
			}
			else
			{
				const tileSize:int = 4096;
				for(var x:int = 0; x < this.width; x += tileSize)
				{
					for(var y:int = 0; y < this.height; y += tileSize)
					{
						var tileWidth:int = Math.min(width - x, tileSize);
						var tileHeight:int = Math.min(height - y, tileSize);
						this.graphics.drawRect(x, y, tileWidth, tileHeight);
					}
				}
			}
			this.graphics.endFill();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			switch(type)
			{
				case MouseEvent.CLICK:
				case MouseEvent.DOUBLE_CLICK:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_MOVE:
				case MouseEvent.MOUSE_OVER:
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.ROLL_OUT:
				case MouseEvent.ROLL_OVER:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_WHEEL:
				case DragEvent.DRAG_ENTER:
				case DragEvent.DRAG_DROP:
				case DragEvent.DRAG_EXIT:
					if(++_mouseEventReferenceCount > 0)
					{
						hasMouseListeners = true;
					}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
			switch(type)
			{
				case MouseEvent.CLICK:
				case MouseEvent.DOUBLE_CLICK:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_MOVE:
				case MouseEvent.MOUSE_OVER:
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.ROLL_OUT:
				case MouseEvent.ROLL_OVER:
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_WHEEL:
					if(--_mouseEventReferenceCount == 0)
					{
						hasMouseListeners = false;
					}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementAt(index:int):IUIComponent
		{
			checkForRangeError(index);
			return _elementsContent[index];
		}
		
		private function checkForRangeError(index:int, addingElement:Boolean = false):void
		{
			var maxIndex:int = _elementsContent.length - 1;
			if(addingElement)
			{
				maxIndex++;
			}
			if(index < 0 || index > maxIndex)
			{
				throw new RangeError("索引:\""+index+"\"超出可视元素索引范围！");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IUIComponent):IUIComponent
		{
			var index:int = this.numElements;
			if(element.parent == this)
			{
				index = numElements-1;
			}
			return this.addElementAt(element, index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IUIComponent, index:int):IUIComponent
		{
			if(element == this)
			{
				return element;
			}
			checkForRangeError(index, true);
			var host:DisplayObject = element.parent;
			if(host == this)
			{
				this.setElementIndex(element, index);
				return element;
			}
			else if(host is IUIContainer)
			{
				IUIContainer(host).removeElement(element);
			}
			else if(element.owner is IUIContainer)
			{
				IUIContainer(element.owner).removeElement(element);
			}
			_elementsContent.splice(index, 0, element);
			if(!_elementsContentChanged)
			{
				this.elementAdded(element, index);
			}
			return element;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IUIComponent):IUIComponent
		{
			return this.removeElementAt(getElementIndex(element));
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IUIComponent
		{
			checkForRangeError(index);
			var element:IUIComponent = _elementsContent[index];
			if(!_elementsContentChanged)
			{
				this.elementRemoved(element, index);
			}
			_elementsContent.splice(index, 1);
			return element;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllElements():void
		{
			for (var i:int = this.numElements - 1; i >= 0; i--)
			{
				this.removeElementAt(i);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getElementIndex(element:IUIComponent):int
		{
			return _elementsContent.indexOf(element);
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsElement(element:IUIComponent):Boolean
		{
			while(element != null)
			{
				if(element == this)
				{
					return true;
				}
				if(element.parent is IUIComponent)
				{
					element = IUIComponent(element.parent);
				}
				else
				{
					return false;
				}
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IUIComponent, index:int):void
		{
			checkForRangeError(index);
			var oldIndex:int = getElementIndex(element);
			if(oldIndex == -1 || oldIndex == index)
			{
				return;
			}
			if(!_elementsContentChanged)
			{
				this.elementRemoved(element, oldIndex, false);
			}
			_elementsContent.splice(oldIndex, 1);
			_elementsContent.splice(index, 0, element);
			if(!_elementsContentChanged)
			{
				this.elementAdded(element, index, false);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function swapElements(element1:IUIComponent, element2:IUIComponent):void
		{
			this.swapElementsAt(this.getElementIndex(element1), this.getElementIndex(element2));
		}
		
		/**
		 * @inheritDoc
		 */
		public function swapElementsAt(index1:int, index2:int):void
		{
			checkForRangeError(index1);
			checkForRangeError(index2);
			if(index1 > index2)
			{
				var temp:int = index2;
				index2 = index1;
				index1 = temp;
			}
			else if(index1 == index2)
			{
				return;
			}
			var element1:IUIComponent = _elementsContent[index1];
			var element2:IUIComponent = _elementsContent[index2];
			if(!_elementsContentChanged)
			{
				this.elementRemoved(element1, index1, false);
				this.elementRemoved(element2, index2, false);
			}
			_elementsContent.splice(index2, 1);
			_elementsContent.splice(index1, 1);
			_elementsContent.splice(index1, 0, element2);
			_elementsContent.splice(index2, 0, element1);
			if(!_elementsContentChanged)
			{
				this.elementAdded(element2, index1, false);
				this.elementAdded(element1, index2, false);
			}
		}
		
		/**
		 * 添加一个显示元素到容器.
		 * @param element 要添加的显示元素.
		 * @param index 要添加的深度索引.
		 * @param notifyListeners 是否要播放事件.
		 */
		hammerc_internal function elementAdded(element:IUIComponent, index:int, notifyListeners:Boolean = true):void
		{
			if(element is DisplayObject)
			{
				this.addToDisplayList(DisplayObject(element), index);
			}
			if(notifyListeners)
			{
				if(this.hasEventListener(ElementExistenceEvent.ELEMENT_ADD))
				{
					this.dispatchEvent(new ElementExistenceEvent(ElementExistenceEvent.ELEMENT_ADD, element, index));
				}
			}
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 * 从容器移除一个显示元素.
		 * @param element 要移除的显示元素.
		 * @param index 要移除的深度索引.
		 * @param notifyListeners 是否要播放事件.
		 */
		hammerc_internal function elementRemoved(element:IUIComponent, index:int, notifyListeners:Boolean = true):void
		{
			if(notifyListeners)
			{
				if(this.hasEventListener(ElementExistenceEvent.ELEMENT_REMOVE))
				{
					this.dispatchEvent(new ElementExistenceEvent(ElementExistenceEvent.ELEMENT_REMOVE, element, index));
				}
			}
			var childDO:DisplayObject = element as DisplayObject;
			if(childDO && childDO.parent == this)
			{
				super.removeChild(childDO);
			}
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 * 添加对象到显示列表.
		 * @param child 要添加的显示对象.
		 * @param index 要添加的深度索引.
		 */
		final hammerc_internal function addToDisplayList(child:DisplayObject, index:int = -1):void
		{
			if(child.parent == this)
			{
				super.setChildIndex(child, index != -1 ? index : super.numChildren - 1);
			}
			else
			{
				super.addChildAt(child, index != -1 ? index : super.numChildren);
			}
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
