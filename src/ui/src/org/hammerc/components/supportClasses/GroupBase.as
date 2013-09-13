/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.hammerc.core.ILayoutElement;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IViewport;
	import org.hammerc.core.UIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.PropertyChangeEvent;
	import org.hammerc.layouts.BasicLayout;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>GroupBase</code> 类实现了自动布局的容器基类.
	 * @author wizardc
	 */
	public class GroupBase extends UIComponent implements IViewport
	{
		private var _contentWidth:Number = 0;
		private var _contentHeight:Number = 0;
		
		/**
		 * 布局发生改变时传递的参数.
		 */
		private var _layoutProperties:Object;
		
		private var _layout:LayoutBase;
		
		/**
		 * 在更新显示列表时是否需要更新布局标志.
		 */
		hammerc_internal var _layoutInvalidateDisplayListFlag:Boolean = false;
		
		/**
		 * 在测量尺寸时是否需要测量布局的标志.
		 */
		hammerc_internal var _layoutInvalidateSizeFlag:Boolean = false;
		
		/**
		 * 创建一个 <code>GroupBase</code> 对象.
		 */
		public function GroupBase()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scrollRect(value:Rectangle):void
		{
			super.scrollRect = value;
			if(this.hasEventListener("scrollRectChange"))
			{
				this.dispatchEvent(new Event("scrollRectChange"));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		
		private function setContentWidth(value:Number):void
		{
			if(value != _contentWidth)
			{
				var oldValue:Number = _contentWidth;
				_contentWidth = value;
				this.dispatchPropertyChangeEvent("contentWidth", oldValue, value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		
		private function setContentHeight(value:Number):void
		{
			if(value != _contentHeight)
			{
				var oldValue:Number = _contentHeight;
				_contentHeight = value;
				this.dispatchPropertyChangeEvent("contentHeight", oldValue, value);
			}
		}
		
		/**
		 * 设置容器尺寸, 该方法由 <code>layout</code> 实例调用.
		 * @param width 要设置的宽度.
		 * @param height 要设置的高度.
		 */
		public function setContentSize(width:Number, height:Number):void
		{
			if((width == _contentWidth) && (height == _contentHeight))
			{
				return;
			}
			setContentWidth(width);
			setContentHeight(height);
		}
		
		/**
		 * 设置或获取此容器的布局对象.
		 */
		public function set layout(value:LayoutBase):void
		{
			if(_layout == value)
			{
				return;
			}
			if(_layout != null)
			{
				_layout.target = null;
				_layout.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, redispatchLayoutEvent);
				_layoutProperties = {"clipAndEnableScrolling":_layout.clipAndEnableScrolling};
			}
			_layout = value;
			if(_layout != null)
			{
				_layout.target = this;
				_layout.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, redispatchLayoutEvent);
				if(_layoutProperties != null)
				{
					if(_layoutProperties.clipAndEnableScrolling !== undefined)
					{
						value.clipAndEnableScrolling = _layoutProperties.clipAndEnableScrolling;
					}
					if(_layoutProperties.verticalScrollPosition !== undefined)
					{
						value.verticalScrollPosition = _layoutProperties.verticalScrollPosition;
					}
					if(_layoutProperties.horizontalScrollPosition !== undefined)
					{
						value.horizontalScrollPosition = _layoutProperties.horizontalScrollPosition;
					}
					_layoutProperties = null;
				}
			}
			this.invalidateSize();
			this.invalidateDisplayList();
			this.dispatchEvent(new Event("layoutChanged"));
		}
		public function get layout():LayoutBase
		{
			return _layout;
		}
		
		/**
		 * 抛出滚动条位置改变事件.
		 */
		private function redispatchLayoutEvent(event:Event):void
		{
			var propertyChangeEvent:PropertyChangeEvent = event as PropertyChangeEvent;
			if(propertyChangeEvent != null)
			{
				switch(propertyChangeEvent.property)
				{
					case "verticalScrollPosition":
					case "horizontalScrollPosition":
						this.dispatchEvent(event);
						break;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if(_layout == null)
			{
				this.layout = new BasicLayout();
			}
		}
		
		/**
		 * 设置或获取是否定将子代剪切到视区的边界.
		 */
		public function set clipAndEnableScrolling(value:Boolean):void
		{
			if(_layout != null)
			{
				_layout.clipAndEnableScrolling = value;
			}
			else if(_layoutProperties != null)
			{
				_layoutProperties.clipAndEnableScrolling = value;
			}
			else
			{
				_layoutProperties = {clipAndEnableScrolling:value};
			}
			this.invalidateSize();
		}
		public function get clipAndEnableScrolling():Boolean
		{
			if(_layout != null)
			{
				return _layout.clipAndEnableScrolling;
			}
			else if(_layoutProperties != null && _layoutProperties.clipAndEnableScrolling !== undefined)
			{
				return _layoutProperties.clipAndEnableScrolling;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
		{
			return (this.layout != null) ? this.layout.getHorizontalScrollPositionDelta(navigationUnit) : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			return (this.layout != null) ? this.layout.getVerticalScrollPositionDelta(navigationUnit) : 0;
		}
		
		/**
		 * 设置或获取可视区域水平方向起始点.
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(_layout != null)
			{
				_layout.horizontalScrollPosition = value;
			}
			else if(_layoutProperties != null)
			{
				_layoutProperties.horizontalScrollPosition = value;
			}
			else
			{
				_layoutProperties = {horizontalScrollPosition:value};
			}
		}
		public function get horizontalScrollPosition():Number
		{
			if(_layout != null)
			{
				return _layout.horizontalScrollPosition;
			}
			else if(_layoutProperties != null && _layoutProperties.horizontalScrollPosition !== undefined)
			{
				return _layoutProperties.horizontalScrollPosition;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 设置或获取可视区域竖直方向起始点.
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if(_layout != null)
			{
				_layout.verticalScrollPosition = value;
			}
			else if(_layoutProperties != null)
			{
				_layoutProperties.verticalScrollPosition = value;
			}
			else
			{
				_layoutProperties = {verticalScrollPosition:value};
			}
		}
		public function get verticalScrollPosition():Number
		{
			if(_layout != null)
			{
				return _layout.verticalScrollPosition;
			}
			else if(_layoutProperties != null && _layoutProperties.verticalScrollPosition !== undefined)
			{
				return _layoutProperties.verticalScrollPosition;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			if(_layout != null && _layoutInvalidateSizeFlag)
			{
				super.measure();
				_layout.measure();
			}
		}
		
		/**
		 * 标记需要更新显示列表但不需要更新布局.
		 */
		hammerc_internal function invalidateDisplayListExceptLayout():void
		{
			super.invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function invalidateDisplayList():void
		{
			super.invalidateDisplayList();
			_layoutInvalidateDisplayListFlag = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function childXYChanged():void
		{
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 * 标记需要更新显示列表但不需要更新布局.
		 */
		hammerc_internal function invalidateSizeExceptLayout():void
		{
			super.invalidateSize();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function invalidateSize():void
		{
			super.invalidateSize();
			_layoutInvalidateSizeFlag = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_layoutInvalidateDisplayListFlag && _layout != null)
			{
				_layoutInvalidateDisplayListFlag = false;
				_layout.updateDisplayList(unscaledWidth, unscaledHeight);
				_layout.updateScrollRect(unscaledWidth, unscaledHeight);
			}
		}
		
		/**
		 * 返回在容器可视区域内的布局元素索引列表, 此方法忽略不是布局元素的普通的显示对象.
		 * @return 在容器可视区域内的布局元素索引列表.
		 */
		public function getElementIndicesInView():Vector.<int>
		{
			var visibleIndices:Vector.<int> = new Vector.<int>();
			var index:int;
			if(scrollRect == null)
			{
				for(index = 0; index < numChildren; index++)
				{
					visibleIndices.push(index);
				}
			}
			else
			{
				for(index = 0; index < numChildren; index++)
				{
					var layoutElement:ILayoutElement = getChildAt(index) as ILayoutElement;
					if(layoutElement == null)
					{
						continue;
					}
					var eltR:Rectangle = new Rectangle();
					eltR.x = layoutElement.layoutBoundsX;
					eltR.y = layoutElement.layoutBoundsY;
					eltR.width = layoutElement.layoutBoundsWidth;
					eltR.height = layoutElement.layoutBoundsHeight;
					if(scrollRect.intersects(eltR))
					{
						visibleIndices.push(index);
					}
				}
			}
			return visibleIndices;
		}
		
		/**
		 * @private
		 */
		public function get numElements():int
		{
			return -1;
		}
		
		/**
		 * @private
		 */
		public function getElementAt(index:int):IUIComponent
		{
			return null;
		}
		
		/**
		 * @private
		 */
		public function getElementIndex(element:IUIComponent):int
		{
			return -1;
		}
		
		/**
		 * 在支持虚拟布局的容器中, 设置容器内可见的子元素索引范围. 此方法在不支持虚拟布局的容器中无效.
		 * 通常在即将连续调用 <code>getVirtualElementAt</code> 之前需要显式设置一次, 以便容器提前释放已经不可见的子元素.
		 * @param startIndex 可视元素起始索引.
		 * @param endIndex 可视元素结束索引.
		 */
		public function setVirtualElementIndicesInView(startIndex:int, endIndex:int):void
		{
		}
		
		/**
		 * 支持 <code>useVirtualLayout</code> 属性的布局类在 <code>updateDisplayList</code> 中使用此方法来获取"处于视图中"的布局元素.
		 * @param index 要检索的元素的索引.
		 */
		public function getVirtualElementAt(index:int):IUIComponent
		{
			return this.getElementAt(index);
		}
	}
}
