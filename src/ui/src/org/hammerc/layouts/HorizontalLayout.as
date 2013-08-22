/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.layouts
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.hammerc.core.ILayoutElement;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
	/**
	 * <code>HorizontalLayout</code> 类定义了水平布局.
	 * @author wizardc
	 */
	public class HorizontalLayout extends LayoutBase
	{
		/**
		 * 为每个可变尺寸的子项分配空白区域.
		 */
		private static function flexChildrenProportionally(spaceForChildren:Number, spaceToDistribute:Number, totalPercent:Number, childInfoArray:Array):void
		{
			var numChildren:int = childInfoArray.length;
			var done:Boolean;
			do
			{
				done = true;
				var unused:Number = spaceToDistribute - (spaceForChildren * totalPercent / 100);
				if(unused > 0)
				{
					spaceToDistribute -= unused;
				}
				else
				{
					unused = 0;
				}
				var spacePerPercent:Number = spaceToDistribute / totalPercent;
				for(var i:int = 0; i < numChildren; i++)
				{
					var childInfo:ChildInfo = childInfoArray[i];
					var size:Number = childInfo.percent * spacePerPercent;
					if(size < childInfo.min)
					{
						var min:Number = childInfo.min;
						childInfo.size = min;
						childInfoArray[i] = childInfoArray[--numChildren];
						childInfoArray[numChildren] = childInfo;
						totalPercent -= childInfo.percent;
						if(unused >= min)
						{
							unused -= min;
						}
						else
						{
							spaceToDistribute -= min - unused;
							unused = 0;
						}
						done = false;
						break;
					}
					else if(size > childInfo.max)
					{
						var max:Number = childInfo.max;
						childInfo.size = max;
						childInfoArray[i] = childInfoArray[--numChildren];
						childInfoArray[numChildren] = childInfo;
						totalPercent -= childInfo.percent;
						if(unused >= max)
						{
							unused -= max;
						}
						else
						{
							spaceToDistribute -= max - unused;
							unused = 0;
						}
						done = false;
						break;
					}
					else
					{
						childInfo.size = size;
					}
				}
			}
			while(!done);
		}
		
		private var _horizontalAlign:String = HorizontalAlign.LEFT;
		private var _verticalAlign:String = VerticalAlign.TOP;
		
		private var _gap:int = 6;
		
		private var _padding:Number = 0;
		private var _paddingLeft:Number = NaN;
		private var _paddingRight:Number = NaN;
		private var _paddingTop:Number = NaN;
		private var _paddingBottom:Number = NaN;
		
		/**
		 * 子对象最大高度.
		 */
		private var maxElementHeight:Number = 0;
		
		/**
		 * 创建一个 <code>HorizontalLayout</code> 对象.
		 */
		public function HorizontalLayout()
		{
			super();
		}
		
		/**
		 * 设置或获取布局元素的水平对齐策略.
		 * 注意：设置 JUSTIFY 和 CONTENT_JUSTIFY 无效.
		 */
		public function set horizontalAlign(value:String):void
		{
			if(_horizontalAlign != value)
			{
				_horizontalAlign = value;
				if(target)
				{
					target.invalidateDisplayList();
				}
			}
		}
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		/**
		 * 设置或获取布局元素的竖直对齐策略.
		 */
		public function set verticalAlign(value:String):void
		{
			if(_verticalAlign != value)
			{
				_verticalAlign = value;
				if(target)
				{
					target.invalidateDisplayList();
				}
			}
		}
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		/**
		 * 设置或获取布局元素之间的水平空间 (以像素为单位).
		 */
		public function set gap(value:int):void
		{
			if(_gap != value)
			{
				_gap = value;
				invalidateTargetSizeAndDisplayList();
				if(hasEventListener("gapChanged"))
				{
					dispatchEvent(new Event("gapChanged"));
				}
			}
		}
		public function get gap():int
		{
			return _gap;
		}
		
		/**
		 * 设置或获取四个边缘的共同内边距. 若单独设置了任一边缘的内边距, 则该边缘的内边距以单独设置的值为准.
		 * 此属性主要用于快速设置多个边缘的相同内边距.
		 */
		public function set padding(value:Number):void
		{
			if(_padding != value)
			{
				_padding = value;
				invalidateTargetSizeAndDisplayList();
			}
		}
		public function get padding():Number
		{
			return _padding;
		}
		
		/**
		 * 设置或获取容器的左边缘与布局元素的左边缘之间的最少像素数. 若为 NaN 将使用 <code>padding</code> 的值.
		 */
		public function set paddingLeft(value:Number):void
		{
			if(_paddingLeft != value)
			{
				_paddingLeft = value;
				invalidateTargetSizeAndDisplayList();
			}
		}
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		/**
		 * 设置或获取容器的右边缘与布局元素的右边缘之间的最少像素数. 若为 NaN 将使用 <code>padding</code> 的值.
		 */
		public function set paddingRight(value:Number):void
		{
			if(_paddingRight != value)
			{
				_paddingRight = value;
				invalidateTargetSizeAndDisplayList();
			}
		}
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		/**
		 * 设置或获取容器的顶边缘与第一个布局元素的顶边缘之间的像素数. 若为 NaN 将使用 <code>padding</code> 的值.
		 */
		public function set paddingTop(value:Number):void
		{
			if(_paddingTop != value)
			{
				_paddingTop = value;
				invalidateTargetSizeAndDisplayList();
			}
		}
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		/**
		 * 设置或获取容器的底边缘与最后一个布局元素的底边缘之间的像素数. 若为 NaN 将使用 <code>padding</code> 的值.
		 */
		public function set paddingBottom(value:Number):void
		{
			if(_paddingBottom != value)
			{
				_paddingBottom = value;
				invalidateTargetSizeAndDisplayList();
			}
		}
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		/**
		 * 标记目标容器的尺寸和显示列表失效.
		 */
		private function invalidateTargetSizeAndDisplayList():void
		{
			if(target != null)
			{
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function measure():void
		{
			super.measure();
			if(target == null)
			{
				return;
			}
			measureReal();
		}
		
		/**
		 * 测量使用真实布局的尺寸.
		 */
		private function measureReal():void
		{
			var count:int = target.numElements;
			var numElements:int = count;
			var measuredWidth:Number = 0;
			var measuredHeight:Number = 0;
			for(var i:int = 0; i < count; i++)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if(layoutElement == null || !layoutElement.includeInLayout)
				{
					numElements--;
					continue;
				}
				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				measuredWidth += preferredWidth;
				measuredHeight = Math.max(measuredHeight, preferredHeight);
			}
			measuredWidth += (numElements - 1) * _gap;
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var paddingR:Number = isNaN(_paddingRight) ? padding : _paddingRight;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			var hPadding:Number = paddingL + paddingR;
			var vPadding:Number = paddingT + paddingB;
			target.measuredWidth = Math.ceil(measuredWidth + hPadding);
			target.measuredHeight = Math.ceil(measuredHeight + vPadding);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			if(target == null)
			{
				return;
			}
			updateDisplayListReal(width, height);
		}
		
		/**
		 * 更新使用真实布局的显示列表.
		 */
		private function updateDisplayListReal(width:Number, height:Number):void
		{
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var paddingR:Number = isNaN(_paddingRight) ? padding : _paddingRight;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			var targetWidth:Number = Math.max(0, width - paddingL - paddingR);
			var targetHeight:Number = Math.max(0, height - paddingT - paddingB);
			var justify:Boolean = _verticalAlign == VerticalAlign.JUSTIFY || _verticalAlign == VerticalAlign.CONTENT_JUSTIFY;
			var vAlign:Number = 0;
			if(!justify)
			{
				if(_verticalAlign == VerticalAlign.MIDDLE)
				{
					vAlign = 0.5;
				}
				else if(_verticalAlign == VerticalAlign.BOTTOM)
				{
					vAlign = 1;
				}
			}
			var count:int = target.numElements;
			var numElements:int = count;
			var x:Number = paddingL;
			var y:Number = paddingT;
			var i:int;
			var layoutElement:ILayoutElement;
			var excessWidth:Number = targetWidth;
			var totalPercentWidth:Number = 0;
			var childInfoArray:Array = [];
			var childInfo:ChildInfo;
			for(i = 0; i < count; i++)
			{
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if(layoutElement == null || !layoutElement.includeInLayout)
				{
					numElements--;
					continue;
				}
				if(!isNaN(layoutElement.percentWidth))
				{
					totalPercentWidth += layoutElement.percentWidth;
					childInfo = new ChildInfo();
					childInfo.layoutElement = layoutElement;
					childInfo.percent = layoutElement.percentWidth;
					childInfo.min = layoutElement.minWidth
					childInfo.max = layoutElement.maxWidth;
					childInfoArray.push(childInfo);
				}
				else
				{
					maxElementHeight = Math.max(maxElementHeight, layoutElement.preferredHeight);
					excessWidth -= layoutElement.layoutBoundsWidth;
				}
			}
			excessWidth -= (numElements - 1) * _gap;
			excessWidth = excessWidth > 0 ? excessWidth : 0;
			var widthDic:Dictionary = new Dictionary();
			if(totalPercentWidth > 0)
			{
				flexChildrenProportionally(targetWidth, excessWidth, totalPercentWidth, childInfoArray);
				var roundOff:Number = 0;
				for each(childInfo in childInfoArray)
				{
					var childSize:int = Math.round(childInfo.size + roundOff);
					roundOff += childInfo.size - childSize;
					widthDic[childInfo.layoutElement] = childSize;
					excessWidth -= childSize;
				}
			}
			excessWidth = excessWidth > 0 ? excessWidth : 0;
			if(_horizontalAlign == HorizontalAlign.CENTER)
			{
				x = paddingL + Math.round(excessWidth * 0.5);
			}
			else if(_horizontalAlign == HorizontalAlign.RIGHT)
			{
				x = paddingL + Math.round(excessWidth);
			}
			var maxX:Number = paddingL;
			var maxY:Number = paddingT;
			var dx:Number = 0;
			var dy:Number = 0;
			var justifyHeight:Number = Math.ceil(targetHeight);
			if(_verticalAlign == VerticalAlign.CONTENT_JUSTIFY)
			{
				justifyHeight = Math.ceil(Math.max(targetHeight, maxElementHeight));
			}
			for(i = 0; i < count; i++)
			{
				var exceesHeight:Number = 0;
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if(layoutElement == null || !layoutElement.includeInLayout)
				{
					continue;
				}
				if(justify)
				{
					y = paddingT;
					layoutElement.setLayoutBoundsSize(widthDic[layoutElement], justifyHeight);
				}
				else
				{
					var layoutElementHeight:Number = NaN;
					if(!isNaN(layoutElement.percentHeight))
					{
						var percent:Number = Math.min(100, layoutElement.percentHeight);
						layoutElementHeight = Math.round(targetHeight * percent * 0.01);
					}
					layoutElement.setLayoutBoundsSize(widthDic[layoutElement], layoutElementHeight);
					exceesHeight = (targetHeight - layoutElement.layoutBoundsHeight) * vAlign;
					exceesHeight = exceesHeight > 0 ? exceesHeight : 0;
					y = paddingT + Math.round(exceesHeight);
				}
				layoutElement.setLayoutBoundsPosition(Math.round(x), Math.round(y));
				dx = Math.ceil(layoutElement.layoutBoundsWidth);
				dy = Math.ceil(layoutElement.layoutBoundsHeight);
				maxX = Math.max(maxX, x + dx);
				maxY = Math.max(maxY, y + dy);
				x += dx + _gap;
			}
			target.setContentSize(Math.ceil(maxX + paddingR), Math.ceil(maxY + paddingB));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			if(target == null)
			{
				return rect;
			}
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var paddingR:Number = isNaN(_paddingRight) ? padding : _paddingRight;
			var firstIndex:int = findIndexAt(scrollRect.left, 0, target.numElements - 1);
			if(firstIndex == -1)
			{
				if(scrollRect.left > target.contentWidth - paddingR)
				{
					rect.left = target.contentWidth - paddingR;
					rect.right = target.contentWidth;
				}
				else
				{
					rect.left = 0;
					rect.right = paddingL;
				}
				return rect;
			}
			rect.left = getStartPosition(firstIndex);
			rect.right = getElementSize(firstIndex) + rect.left;
			if(rect.left == scrollRect.left)
			{
				firstIndex--;
				if(firstIndex != -1)
				{
					rect.left = getStartPosition(firstIndex);
					rect.right = getElementSize(firstIndex) + rect.left;
				}
				else
				{
					rect.left = 0;
					rect.right = paddingL;
				}
			}
			return rect;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if(target == null)
			{
				return rect;
			}
			var numElements:int = target.numElements;
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var paddingR:Number = isNaN(_paddingRight) ? padding : _paddingRight;
			var lastIndex:int = findIndexAt(scrollRect.right, 0, numElements - 1);
			if(lastIndex == -1)
			{
				if(scrollRect.right < paddingL)
				{
					rect.left = 0;
					rect.right = paddingL;
				}
				else
				{
					rect.left = target.contentWidth - paddingR;
					rect.right = target.contentWidth;
				}
				return rect;
			}
			rect.left = getStartPosition(lastIndex);
			rect.right = getElementSize(lastIndex) + rect.left;
			if(rect.right <= scrollRect.right)
			{
				lastIndex++;
				if(lastIndex < numElements)
				{
					rect.left = getStartPosition(lastIndex);
					rect.right = getElementSize(lastIndex) + rect.left;
				}
				else
				{
					rect.left = target.contentWidth - paddingR;
					rect.right = target.contentWidth;
				}
			}
			return rect;
		}
		
		/**
		 * 折半查找法寻找指定位置的显示对象索引.
		 */
		private function findIndexAt(x:Number, i0:int, i1:int):int
		{
			var index:int = (i0 + i1) / 2;
			var elementX:Number = getStartPosition(index);
			var elementWidth:Number = getElementSize(index);
			if((x >= elementX) && (x < elementX + elementWidth + gap))
			{
				return index;
			}
			else if(i0 == i1)
			{
				return -1;
			}
			else if(x < elementX)
			{
				return findIndexAt(x, i0, Math.max(i0, index-1));
			}
			else 
			{
				return findIndexAt(x, Math.min(index+1, i1), i1);
			}
		}
		
		/**
		 * 获取指定索引的起始位置.
		 */
		private function getStartPosition(index:int):Number
		{
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var element:IUIComponent;
			if(target != null)
			{
				element = target.getElementAt(index);
			}
			return element ? element.x : paddingL;
		}
		
		/**
		 * 获取指定索引的元素尺寸.
		 */
		private function getElementSize(index:int):Number
		{
			if(target != null)
			{
				return target.getElementAt(index).width;
			}
			return 0;
		}
	}
}

import org.hammerc.core.ILayoutElement;

/**
 * <code>ChildInfo</code> 类记录一个子对象的信息.
 * @author wizardc
 */
class ChildInfo
{
	/**
	 * 需要布局的子对象.
	 */
	public var layoutElement:ILayoutElement;
	
	/**
	 * 尺寸.
	 */
	public var size:Number = 0;
	
	/**
	 * 百分比.
	 */
	public var percent:Number;
	
	/**
	 * 最小尺寸.
	 */
	public var min:Number;
	
	/**
	 * 最大尺寸.
	 */
	public var max:Number;
	
	/**
	 * 创建一个 <code>ChildInfo</code> 对象.
	 */
	public function ChildInfo()
	{
		super();
	}
}
