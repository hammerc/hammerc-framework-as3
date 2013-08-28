/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.hammerc_internal;
	
	/**
	 * <code>SystemContainer</code> 类定义了虚拟的子容器, 用于分层.
	 * @author wizardc
	 */
	public class SystemContainer implements IUIContainer
	{
		private var _owner:ISystemManager;
		private var _lowerBoundReference:QName;
		private var _upperBoundReference:QName;
		
		private var raw_getElementAt:QName = new QName(hammerc_internal, "raw_getElementAt");
		private var raw_addElementAt:QName = new QName(hammerc_internal, "raw_addElementAt");
		private var raw_getElementIndex:QName = new QName(hammerc_internal, "raw_getElementIndex");
		private var raw_removeElement:QName = new QName(hammerc_internal, "raw_removeElement");
		private var raw_removeElementAt:QName = new QName(hammerc_internal, "raw_removeElementAt");
		private var raw_setElementIndex:QName = new QName(hammerc_internal, "raw_setElementIndex");
		private var raw_containsElement:QName = new QName(hammerc_internal, "raw_containsElement");
		
		/**
		 * 创建一个 <code>SystemContainer</code> 对象.
		 * @param owner 实体容器.
		 * @param lowerBoundReference 容器下边界属性.
		 * @param upperBoundReference 容器上边界属性.
		 */
		public function SystemContainer(owner:ISystemManager, lowerBoundReference:QName, upperBoundReference:QName)
		{
			_owner = owner;
			_lowerBoundReference = lowerBoundReference;
			_upperBoundReference = upperBoundReference;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numElements():int
		{
			return _owner[_upperBoundReference] - _owner[_lowerBoundReference];
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementAt(index:int):IUIComponent
		{
			var uiComponent:IUIComponent = _owner[raw_getElementAt](_owner[_lowerBoundReference] + index);
			return uiComponent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IUIComponent):IUIComponent
		{
			var index:int = _owner[_upperBoundReference];
			if(element.parent == _owner)
			{
				index--;
			}
			_owner[_upperBoundReference]++;
			_owner[raw_addElementAt](element, index);
			element.ownerChanged(this);
			return element;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IUIComponent, index:int):IUIComponent
		{
			_owner[_upperBoundReference]++;
			_owner[raw_addElementAt](element, _owner[_lowerBoundReference] + index);
			element.ownerChanged(this);
			return element;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IUIComponent):IUIComponent
		{
			var index:int = _owner[raw_getElementIndex](element);
			if(_owner[_lowerBoundReference] <= index && index < _owner[_upperBoundReference])
			{
				_owner[raw_removeElement](element);
				_owner[_upperBoundReference]--;
			}
			element.ownerChanged(null);
			return element;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IUIComponent
		{
			index += _owner[_lowerBoundReference];
			var element:IUIComponent;
			if(_owner[_lowerBoundReference] <= index && index < _owner[_upperBoundReference])
			{
				element = _owner[raw_removeElementAt](index);
				_owner[_upperBoundReference]--;
			}
			element.ownerChanged(null);
			return element;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementIndex(element:IUIComponent):int
		{
			var index:int = _owner[raw_getElementIndex](element);
			index -= _owner[_lowerBoundReference];
			return index;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IUIComponent, index:int):void
		{
			_owner[raw_setElementIndex](element, _owner[_lowerBoundReference] + index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllElements():void
		{
			while(this.numElements != 0)
			{
				this.removeElementAt(0);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsElement(element:IUIComponent):Boolean
		{
			if(element != _owner && _owner[raw_containsElement](element))
			{
				while(element.parent != element)
				{
					element = element.parent as IUIComponent;
				}
				var childIndex:int = _owner[raw_getElementIndex](element);
				if (childIndex >= _owner[_lowerBoundReference] && childIndex < _owner[_upperBoundReference])
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 该方法已取消.
		 */
		public function swapElements(element1:IUIComponent, element2:IUIComponent):void
		{
			throw new Error("该方法已取消！");
		}
		
		/**
		 * 该方法已取消.
		 */
		public function swapElementsAt(index1:int, index2:int):void
		{
			throw new Error("该方法已取消！");
		}
	}
}
