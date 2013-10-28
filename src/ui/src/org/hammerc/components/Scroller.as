/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.hammerc.components.supportClasses.ScrollerLayout;
	import org.hammerc.core.IInvalidating;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.IViewport;
	import org.hammerc.core.NavigationUnit;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.PropertyChangeEvent;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>Scroller</code> 类实现了滚动条组件.
	 * @author wizardc
	 */
	public class Scroller extends SkinnableComponent implements IUIContainer
	{
		/**
		 * 皮肤子件, 水平滚动条.
		 */
		public var horizontalScrollBar:HScrollBar;
		
		/**
		 * 皮肤子件, 垂直滚动条.
		 */
		public var verticalScrollBar:VScrollBar;
		
		private var _layout:LayoutBase;
		
		private var _contentGroup:Group;
		
		private var _verticalScrollPolicy:String = "auto";
		private var _horizontalScrollPolicy:String = "auto";
		
		private var _viewport:IViewport;
		
		private var _minViewportInset:Number = 0;
		
		private var _measuredSizeIncludesScrollBars:Boolean = true;
		
		/**
		 * 创建一个 <code>Scroller</code> 对象.
		 */
		public function Scroller()
		{
			super();
			this.focusEnabled = true;
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
			_layout = value;
			if(_contentGroup != null)
			{
				_contentGroup.layout = _layout;
			}
		}
		public function get layout():LayoutBase
		{
			return _layout;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Scroller;
		}
		
		/**
		 * 设置或获取垂直滚动条显示策略.
		 */
		public function set verticalScrollPolicy(value:String):void
		{
			if(_verticalScrollPolicy == value)
			{
				return;
			}
			_verticalScrollPolicy = value;
			invalidateSkin();
		}
		public function get verticalScrollPolicy():String
		{
			return _verticalScrollPolicy;
		}
		
		/**
		 * 设置或获取水平滚动条显示策略.
		 */
		public function set horizontalScrollPolicy(value:String):void
		{
			if(_horizontalScrollPolicy == value)
			{
				return;
			}
			_horizontalScrollPolicy = value;
			invalidateSkin();
		}
		public function get horizontalScrollPolicy():String
		{
			return _horizontalScrollPolicy;
		}
		
		/**
		 * 设置或获取要滚动的视域组件.
		 */
		public function set viewport(value:IViewport):void
		{
			if(value == _viewport)
			{
				return;
			}
			uninstallViewport();
			_viewport = value;
			installViewport();
			this.dispatchEvent(new Event("viewportChanged"));
		}
		public function get viewport():IViewport
		{
			return _viewport;
		}
		
		/**
		 * 设置或获取四个边与视域组件的最小间隔距离.
		 * <p>如果滚动条都不可见, 则四个边的间隔为此属性的值.<br/>
		 * 如果滚动条可见, 则取滚动条的宽度和此属性的值的较大值.</p>
		 */
		public function set minViewportInset(value:Number):void
		{
			if(value == _minViewportInset)
			{
				return;
			}
			_minViewportInset = value;
			invalidateSkin();
		}
		public function get minViewportInset():Number
		{
			return _minViewportInset;
		}
		
		/**
		 * 设置或获取 <code>Scroller</code> 的测量大小是否会加上滚动条所占的空间, 否则 <code>Scroller</code> 的测量大小仅取决于其视域组件的尺寸.
		 */
		public function set measuredSizeIncludesScrollBars(value:Boolean):void
		{
			if(value == _measuredSizeIncludesScrollBars)
			{
				return;
			}
			_measuredSizeIncludesScrollBars = value;
			invalidateSkin();
		}
		public function get measuredSizeIncludesScrollBars():Boolean
		{
			return _measuredSizeIncludesScrollBars;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numElements():int
		{
			return this.viewport != null ? 1 : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			_contentGroup = new Group();
			if(_layout == null)
			{
				_layout = new ScrollerLayout();
			}
			_contentGroup.layout = _layout;
			this.addToDisplayList(_contentGroup);
			_contentGroup.addEventListener(MouseEvent.MOUSE_WHEEL, contentGroup_mouseWheelHandler);
			super.createChildren();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			this.measuredWidth = _contentGroup.preferredWidth;
			this.measuredHeight = _contentGroup.preferredHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			_contentGroup.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * 标记皮肤需要更新尺寸和布局.
		 */
		private function invalidateSkin():void
		{
			if(_contentGroup != null)
			{
				_contentGroup.invalidateSize();
				_contentGroup.invalidateDisplayList();
			}
		}
		
		/**
		 * 安装并初始化视域组件.
		 */
		private function installViewport():void
		{
			if(this.skin != null && this.viewport != null)
			{
				this.viewport.clipAndEnableScrolling = true;
				_contentGroup.addElementAt(this.viewport, 0);
				this.viewport.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
			}
			if(verticalScrollBar)
			{
				verticalScrollBar.viewport = this.viewport;
			}
			if(horizontalScrollBar)
			{
				horizontalScrollBar.viewport = this.viewport;
			}
		}
		
		/**
		 * 卸载视域组件.
		 */
		private function uninstallViewport():void
		{
			if(horizontalScrollBar)
			{
				horizontalScrollBar.viewport = null;
			}
			if(verticalScrollBar)
			{
				verticalScrollBar.viewport = null;
			}
			if(this.skin != null && this.viewport != null)
			{
				this.viewport.clipAndEnableScrolling = false;
				_contentGroup.removeElement(this.viewport);
				this.viewport.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, viewport_propertyChangeHandler);
			}
		}
		
		/**
		 * 视域组件的属性改变.
		 */
		private function viewport_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			switch(event.property)
			{
				case "contentWidth":
				case "contentHeight":
					invalidateSkin();
					break;
			}
		}
		
		/**
		 * 抛出索引越界异常.
		 */
		private function throwRangeError(index:int):void
		{
			throw new RangeError("索引:\"" + index + "\"超出可视元素索引范围");
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementAt(index:int):IUIComponent
		{
			if(this.viewport != null && index == 0)
			{
				return this.viewport;
			}
			else
			{
				throwRangeError(index);
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getElementIndex(element:IUIComponent):int
		{
			if(element != null && element == this.viewport)
			{
				return 0;
			}
			else
			{
				return -1;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsElement(element:IUIComponent):Boolean
		{
			if(element != null && element == this.viewport)
			{
				return true;
			}
			return false;
		}
		
		private function throwNotSupportedError():void
		{
			throw new Error("此方法在Scroller组件内不可用!");
		}
		
		/**
		 * @inheritDoc
		 */
		public function addElement(element:IUIComponent):IUIComponent
		{
			throwNotSupportedError();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addElementAt(element:IUIComponent, index:int):IUIComponent
		{
			throwNotSupportedError();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:IUIComponent):IUIComponent
		{
			throwNotSupportedError();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElementAt(index:int):IUIComponent
		{
			throwNotSupportedError();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllElements():void
		{
			throwNotSupportedError();
		}
		
		/**
		 * @inheritDoc
		 */
		public function setElementIndex(element:IUIComponent, index:int):void
		{
			throwNotSupportedError();
		}
		
		/**
		 * @inheritDoc
		 */
		public function swapElements(element1:IUIComponent, element2:IUIComponent):void
		{
			throwNotSupportedError();
		}
		
		/**
		 * @inheritDoc
		 */
		public function swapElementsAt(index1:int, index2:int):void
		{
			throwNotSupportedError();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function attachSkin(skin:Object):void
		{
			super.attachSkin(skin);
			installViewport();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function detachSkin(skin:Object):void
		{
			uninstallViewport();
			super.detachSkin(skin);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == verticalScrollBar)
			{
				verticalScrollBar.viewport = this.viewport;
				_contentGroup.addElement(verticalScrollBar);
			}
			else if(instance == horizontalScrollBar)
			{
				horizontalScrollBar.viewport = this.viewport;
				_contentGroup.addElement(horizontalScrollBar);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == verticalScrollBar)
			{
				verticalScrollBar.viewport = null;
				if(verticalScrollBar.parent == _contentGroup)
				{
					_contentGroup.removeElement(verticalScrollBar);
				}
			}
			else if(instance == horizontalScrollBar)
			{
				horizontalScrollBar.viewport = null;
				if(horizontalScrollBar.parent == _contentGroup)
				{
					_contentGroup.removeElement(horizontalScrollBar);
				}
			}
		}
		
		/**
		 * 皮肤上鼠标滚轮事件.
		 */
		private function contentGroup_mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = viewport;
			if(event.isDefaultPrevented() || vp == null || !vp.visible)
			{
				return;
			}
			var nSteps:uint = Math.abs(event.delta);
			var navigationUnit:uint;
			if(verticalScrollBar != null && verticalScrollBar.visible)
			{
				navigationUnit = (event.delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
				for(var vStep:int = 0; vStep < nSteps; vStep++)
				{
					var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
					if(!isNaN(vspDelta))
					{
						vp.verticalScrollPosition += vspDelta;
						if(vp is IInvalidating)
						{
							IInvalidating(vp).validateNow();
						}
					}
				}
				event.preventDefault();
			}
			else if(horizontalScrollBar != null && horizontalScrollBar.visible)
			{
				navigationUnit = (event.delta < 0) ? NavigationUnit.RIGHT : NavigationUnit.LEFT;
				for(var hStep:int = 0; hStep < nSteps; hStep++)
				{
					var hspDelta:Number = vp.getHorizontalScrollPositionDelta(navigationUnit);
					if(!isNaN(hspDelta))
					{
						vp.horizontalScrollPosition += hspDelta;
						if(vp is IInvalidating)
						{
							IInvalidating(vp).validateNow();
						}
					}
				}
				event.preventDefault();
			}
		}
	}
}
