/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.layouts.supportClasses
{
	import flash.geom.Rectangle;
	
	import org.hammerc.components.supportClasses.GroupBase;
	import org.hammerc.core.NavigationUnit;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.OnDemandEventDispatcher;
	import org.hammerc.events.PropertyChangeEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>LayoutBase</code> 类为容器布局基类.
	 * @author wizardc
	 */
	public class LayoutBase extends OnDemandEventDispatcher
	{
		private var _target:GroupBase;
		
		private var _horizontalScrollPosition:Number = 0;
		private var _verticalScrollPosition:Number = 0;
		
		private var _clipAndEnableScrolling:Boolean = false;
		
		/**
		 * 创建一个 <code>LayoutBase</code> 对象.
		 */
		public function LayoutBase()
		{
			super(this);
		}
		
		/**
		 * 设置或获取目标容器.
		 */
		public function set target(value:GroupBase):void
		{
			if(_target != value)
			{
				_target = value;
			}
		}
		public function get target():GroupBase
		{
			return _target;
		}
		
		/**
		 * 设置或获取可视区域水平方向起始点.
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			if(value != _horizontalScrollPosition)
			{
				var oldValue:Number = _horizontalScrollPosition;
				_horizontalScrollPosition = value;
				this.scrollPositionChanged();
				this.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, value, oldValue, this, "horizontalScrollPosition"));
			}
		}
		public function get horizontalScrollPosition():Number
		{
			return _horizontalScrollPosition;
		}
		
		/**
		 * 设置或获取可视区域竖直方向起始点.
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			if(value != _verticalScrollPosition)
			{
				var oldValue:Number = _verticalScrollPosition;
				_verticalScrollPosition = value;
				this.scrollPositionChanged();
				this.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, value, oldValue, this, "verticalScrollPosition"));
			}
		}
		public function get verticalScrollPosition():Number
		{
			return _verticalScrollPosition;
		}
		
		/**
		 * 设置或获取是否定将子代剪切到视区的边界.
		 */
		public function set clipAndEnableScrolling(value:Boolean):void
		{
			if(value != _clipAndEnableScrolling)
			{
				_clipAndEnableScrolling = value;
				if(target != null)
				{
					updateScrollRect(target.width, target.height);
				}
			}
		}
		public function get clipAndEnableScrolling():Boolean
		{
			return _clipAndEnableScrolling;
		}
		
		/**
		 * 返回对水平滚动位置的更改以处理不同的滚动选项.
		 * 下列选项是由 NavigationUnit 类定义的: END, HOME, LEFT, PAGE_LEFT, PAGE_RIGHT 和 RIGHT.
		 * @param navigationUnit 采用以下值: 
		 * <li>
		 * <code>END</code>
		 * 返回滚动 delta, 它将使 scrollRect 与内容区域右对齐.
		 * </li>
		 * <li>
		 * <code>HOME</code>
		 * 返回滚动 delta, 它将使 scrollRect 与内容区域左对齐.
		 * </li>
		 * <li>
		 * <code>LEFT</code>
		 * 返回滚动 delta, 它将使 scrollRect 与跨越 scrollRect 的左边或在其左边左侧的第一个元素左对齐.
		 * </li>
		 * <li>
		 * <code>PAGE_LEFT</code>
		 * 返回滚动 delta, 它将使 scrollRect 与跨越 scrollRect 的左边或在其左边左侧的第一个元素右对齐.
		 * </li>
		 * <li>
		 * <code>PAGE_RIGHT</code>
		 * 返回滚动 delta, 它将使 scrollRect 与跨越 scrollRect 的右边或在其右边右侧的第一个元素左对齐.
		 * </li>
		 * <li>
		 * <code>RIGHT</code>
		 * 返回滚动 delta, 它将使 scrollRect 与跨越 scrollRect 的右边或在其右边右侧的第一个元素右对齐.
		 * </li>
		 * </ul>
		 * @return 对应的距离.
		 */
		public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
		{
			var g:GroupBase = target;
			if(g == null)
			{
				return 0;
			}
			var scrollRect:Rectangle = this.getScrollRect();
			if(scrollRect == null)
			{
				return 0;
			}
			if((scrollRect.x == 0) && (scrollRect.width >= g.contentWidth))
			{
				return 0;
			}
			var maxDelta:Number = g.contentWidth - scrollRect.right;
			var minDelta:Number = -scrollRect.left;
			var getElementBounds:Rectangle;
			switch(navigationUnit)
			{
				case NavigationUnit.LEFT:
				case NavigationUnit.PAGE_LEFT:
					getElementBounds = this.getElementBoundsLeftOfScrollRect(scrollRect);
					break;
				case NavigationUnit.RIGHT:
				case NavigationUnit.PAGE_RIGHT:
					getElementBounds = this.getElementBoundsRightOfScrollRect(scrollRect);
					break;
				case NavigationUnit.HOME:
					return minDelta;
				case NavigationUnit.END:
					return maxDelta;
				default:
					return 0;
			}
			if(getElementBounds == null)
			{
				return 0;
			}
			var delta:Number = 0;
			switch(navigationUnit)
			{
				case NavigationUnit.LEFT:
					delta = Math.max(getElementBounds.left - scrollRect.left, -scrollRect.width);
					break;
				case NavigationUnit.RIGHT:
					delta = Math.min(getElementBounds.right - scrollRect.right, scrollRect.width);
					break;
				case NavigationUnit.PAGE_LEFT:
					delta = getElementBounds.right - scrollRect.right;
					if(delta >= 0)
					{
						delta = Math.max(getElementBounds.left - scrollRect.left, -scrollRect.width);
					}
					break;
				case NavigationUnit.PAGE_RIGHT:
					delta = getElementBounds.left - scrollRect.left;
					if(delta <= 0)
					{
						delta = Math.min(getElementBounds.right - scrollRect.right, scrollRect.width);
					}
					break;
			}
			return Math.min(maxDelta, Math.max(minDelta, delta));
		}
		
		/**
		 * 返回对垂直滚动位置的更改以处理不同的滚动选项.
		 * 下列选项是由 NavigationUnit 类定义的: DOWN, END, HOME, PAGE_DOWN, PAGE_UP 和 UP.
		 * @param navigationUnit 采用以下值: 
		 * <ul>
		 * <li>
		 * <code>DOWN</code>
		 * 返回滚动 delta, 它将使 scrollRect 与跨越 scrollRect 的底边或在其底边之下的第一个元素底对齐.
		 * </li>
		 * <li>
		 * <code>END</code>
		 * 返回滚动 delta, 它将使 scrollRect 与内容区域底对齐.
		 * </li>
		 * <li>
		 * <code>HOME</code>
		 * 返回滚动 delta, 它将使 scrollRect 与内容区域顶对齐.
		 * </li>
		 * <li>
		 * <code>PAGE_DOWN</code>
		 * 返回滚动 delta, 它将使 scrollRect 与跨越 scrollRect 的底边或在其底边之下的第一个元素顶对齐.
		 * </li>
		 * <code>PAGE_UP</code>
		 * <li>
		 * 返回滚动 delta, 它将使 scrollRect 与跨越 scrollRect 的顶边或在其顶边之上的第一个元素底对齐.
		 * </li>
		 * <li>
		 * <code>UP</code>
		 * 返回滚动 delta, 它将使 scrollRect 与跨越 scrollRect 的顶边或在其顶边之上的第一个元素顶对齐.
		 * </li>
		 * </ul>
		 * @return 对应的距离.
		 */
		public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			var g:GroupBase = target;
			if(g == null)
			{
				return 0;
			}
			var scrollRect:Rectangle = this.getScrollRect();
			if(scrollRect == null)
			{
				return 0;
			}
			if((scrollRect.y == 0) && (scrollRect.height >= g.contentHeight))
			{
				return 0;
			}
			var maxDelta:Number = g.contentHeight - scrollRect.bottom;
			var minDelta:Number = -scrollRect.top;
			var getElementBounds:Rectangle;
			switch(navigationUnit)
			{
				case NavigationUnit.UP:
				case NavigationUnit.PAGE_UP:
					getElementBounds = getElementBoundsAboveScrollRect(scrollRect);
					break;
				case NavigationUnit.DOWN:
				case NavigationUnit.PAGE_DOWN:
					getElementBounds = getElementBoundsBelowScrollRect(scrollRect);
					break;
				case NavigationUnit.HOME:
					return minDelta;
				case NavigationUnit.END:
					return maxDelta;
				default:
					return 0;
			}
			if(getElementBounds == null)
			{
				return 0;
			}
			var delta:Number = 0;
			switch(navigationUnit)
			{
				case NavigationUnit.UP:
					delta = Math.max(getElementBounds.top - scrollRect.top, -scrollRect.height);
					break;
				case NavigationUnit.DOWN:
					delta = Math.min(getElementBounds.bottom - scrollRect.bottom, scrollRect.height);
					break;
				case NavigationUnit.PAGE_UP:
					delta = getElementBounds.bottom - scrollRect.bottom;
					if(delta >= 0)
					{
						delta = Math.max(getElementBounds.top - scrollRect.top, -scrollRect.height);
					}
					break;
				case NavigationUnit.PAGE_DOWN:
					delta = getElementBounds.top - scrollRect.top;
					if(delta <= 0)
					{
						delta = Math.min(getElementBounds.bottom - scrollRect.bottom, scrollRect.height);
					}
					break;
			}
			return Math.min(maxDelta, Math.max(minDelta, delta));
		}
		
		/**
		 * 返回布局坐标中目标的滚动矩形的界限.
		 * @return 布局坐标中目标的滚动矩形的界限.
		 */
		protected function getScrollRect():Rectangle
		{
			var g:GroupBase = target;
			if(g != null && g.clipAndEnableScrolling != null)
			{
				var vsp:Number = g.verticalScrollPosition;
				var hsp:Number = g.horizontalScrollPosition;
				return new Rectangle(hsp, vsp, g.width, g.height);
			}
			return null;
		}
		
		/**
		 * 返回跨越 <code>scrollRect</code> 的左边或在其左边左侧的第一个布局元素的界限.
		 * @param scrollRect 指定的滚动区域.
		 * @return 第一个布局元素的界限.
		 */
		protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.left = scrollRect.left - 1;
			bounds.right = scrollRect.left; 
			return bounds;
		}
		
		/**
		 * 返回跨越 <code>scrollRect</code> 的右边或在其右边右侧的第一个布局元素的界限.
		 * @param scrollRect 指定的滚动区域.
		 * @return 第一个布局元素的界限.
		 */
		protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.left = scrollRect.right;
			bounds.right = scrollRect.right + 1;
			return bounds;
		}
		
		/**
		 * 返回跨越 scrollRect 的顶边或在其顶边之上的第一个布局元素的界限.
		 * @param scrollRect 指定的滚动区域.
		 * @return 第一个布局元素的界限.
		 */
		protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.top = scrollRect.top - 1;
			bounds.bottom = scrollRect.top;
			return bounds;
		}
		
		/**
		 * 返回跨越 scrollRect 的底边或在其底边之下的第一个布局元素的界限.
		 * @param scrollRect 指定的滚动区域.
		 * @return 第一个布局元素的界限.
		 */
		protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
		{
			var bounds:Rectangle = new Rectangle();
			bounds.top = scrollRect.bottom;
			bounds.bottom = scrollRect.bottom + 1;
			return bounds;
		}
		
		/**
		 * 滚动条位置改变.
		 */
		protected function scrollPositionChanged():void
		{
			if(target != null)
			{
				this.updateScrollRect(target.width, target.height);
				target.invalidateDisplayListExceptLayout();
			}
		}
		
		/**
		 * 更新可视区域.
		 * @param w 宽度.
		 * @param h 高度.
		 */
		public function updateScrollRect(w:Number, h:Number):void
		{
			if(target != null)
			{
				if(_clipAndEnableScrolling)
				{
					target.scrollRect = new Rectangle(_horizontalScrollPosition, _verticalScrollPosition, w, h);
				}
				else
				{
					target.scrollRect = null;
				}
			}
		}
		
		/**
		 * 测量组件尺寸大小.
		 */
		public function measure():void
		{
		}
		
		/**
		 * 更新显示列表.
		 * @param width 组件的宽度.
		 * @param height 组件的高度.
		 */
		public function updateDisplayList(width:Number, height:Number):void
		{
		}
	}
}
