// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.layouts
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.hammerc.core.ILayoutElement;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.layouts.supportClasses.LayoutBase;
	
	/**
	 * <code>VerticalLayout</code> 类定义了垂直布局.
	 * @author wizardc
	 */
	public class VerticalLayout extends LayoutBase
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
		
		private var _gap:Number = 6;
		
		private var _padding:Number = 0;
		private var _paddingLeft:Number = NaN;
		private var _paddingRight:Number = NaN;
		private var _paddingTop:Number = NaN;
		private var _paddingBottom:Number = NaN;
		
		/**
		 * 子对象最大宽度.
		 */
		private var _maxElementWidth:Number = 0;
		
		/**
		 * 虚拟布局使用的子对象尺寸缓存.
		 */
		private var _elementSizeTable:Array = [];
		
		/**
		 * 虚拟布局使用的当前视图中的第一个元素索引.
		 */
		private var _startIndex:int = -1;
		
		/**
		 * 虚拟布局使用的当前视图中的最后一个元素的索引.
		 */
		private var _endIndex:int = -1;
		
		/**
		 * 视图的第一个和最后一个元素的索引值已经计算好的标志.
		 */
		private var _indexInViewCalculated:Boolean = false;
		
		/**
		 * 创建一个 <code>VerticalLayout</code> 对象.
		 */
		public function VerticalLayout()
		{
			super();
		}
		
		/**
		 * 设置或获取布局元素的水平对齐策略.
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
		 * 注意：设置 JUSTIFY 和 CONTENT_JUSTIFY 无效.
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
		public function set gap(value:Number):void
		{
			value = isNaN(value) ? 0 : value;
			if(_gap != value)
			{
				_gap = value;
				invalidateTargetSizeAndDisplayList();
				if(this.hasEventListener("gapChanged"))
				{
					this.dispatchEvent(new Event("gapChanged"));
				}
			}
		}
		public function get gap():Number
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
			if(this.useVirtualLayout)
			{
				measureVirtual();
			}
			else
			{
				measureReal();
			}
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
				measuredHeight += preferredHeight;
				measuredWidth = Math.max(measuredWidth, preferredWidth);
			}
			measuredHeight += (numElements - 1) * _gap;
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
		 * 测量使用虚拟布局的尺寸.
		 */
		private function measureVirtual():void
		{
			var numElements:int = target.numElements;
			var typicalHeight:Number = this.typicalLayoutRect ? this.typicalLayoutRect.height : 22;
			var typicalWidth:Number = this.typicalLayoutRect ? this.typicalLayoutRect.width : 71;
			var measuredWidth:Number = Math.max(_maxElementWidth, typicalWidth);
			var measuredHeight:Number = getElementTotalSize();
			var visibleIndices:Vector.<int> = target.getElementIndicesInView();
			for each(var i:int in visibleIndices)
			{
				var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
				if(layoutElement == null || !layoutElement.includeInLayout)
				{
					continue;
				}
				var preferredWidth:Number = layoutElement.preferredWidth;
				var preferredHeight:Number = layoutElement.preferredHeight;
				measuredHeight += preferredHeight;
				measuredHeight -= isNaN(_elementSizeTable[i]) ? typicalHeight : _elementSizeTable[i];
				measuredWidth = Math.max(measuredWidth, preferredWidth);
			}
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
			if(this.useVirtualLayout)
			{
				updateDisplayListVirtual(width, height);
			}
			else
			{
				updateDisplayListReal(width, height);
			}
		}
		
		/**
		 * 更新使用真实布局的显示列表.
		 */
		private function updateDisplayListReal(width:Number,height:Number):void
		{
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var paddingR:Number = isNaN(_paddingRight) ? padding : _paddingRight;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			var targetWidth:Number = Math.max(0, width - paddingL - paddingR);
			var targetHeight:Number = Math.max(0, height - paddingT - paddingB);
			var justify:Boolean = _horizontalAlign == HorizontalAlign.JUSTIFY || _horizontalAlign == HorizontalAlign.CONTENT_JUSTIFY;
			var hAlign:Number = 0;
			if(!justify)
			{
				if(_horizontalAlign == HorizontalAlign.CENTER)
				{
					hAlign = 0.5;
				}
				else if(_horizontalAlign == HorizontalAlign.RIGHT)
				{
					hAlign = 1;
				}
			}
			var count:int = target.numElements;
			var numElements:int = count;
			var x:Number = paddingL;
			var y:Number = paddingT;
			var i:int;
			var layoutElement:ILayoutElement;
			var excessHeight:Number = targetHeight;
			var totalPercentHeight:Number = 0;
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
				if(!isNaN(layoutElement.percentHeight))
				{
					totalPercentHeight += layoutElement.percentHeight;
					childInfo = new ChildInfo();
					childInfo.layoutElement = layoutElement;
					childInfo.percent = layoutElement.percentHeight;
					childInfo.min = layoutElement.minHeight;
					childInfo.max = layoutElement.maxHeight;
					childInfoArray.push(childInfo);
				}
				else
				{
					_maxElementWidth = Math.max(_maxElementWidth, layoutElement.preferredWidth);
					excessHeight -= layoutElement.layoutBoundsHeight;
				}
			}
			excessHeight -= (numElements - 1) * _gap;
			excessHeight = excessHeight > 0 ? excessHeight : 0;
			var heightDic:Dictionary = new Dictionary();
			if(totalPercentHeight > 0)
			{
				flexChildrenProportionally(targetHeight, excessHeight, totalPercentHeight, childInfoArray);
				var roundOff:Number = 0;
				for each(childInfo in childInfoArray)
				{
					var childSize:int = Math.round(childInfo.size + roundOff);
					roundOff += childInfo.size - childSize;
					heightDic[childInfo.layoutElement] = childSize;
					excessHeight -= childSize;
				}
			}
			excessHeight = excessHeight > 0 ? excessHeight : 0;
			if(_verticalAlign == VerticalAlign.MIDDLE)
			{
				y = paddingT + excessHeight * 0.5;
			}
			else if(_verticalAlign == VerticalAlign.BOTTOM)
			{
				y = paddingT + excessHeight;
			}
			var maxX:Number = paddingL;
			var maxY:Number = paddingT;
			var dx:Number = 0;
			var dy:Number = 0;
			var justifyWidth:Number = Math.ceil(targetWidth);
			if(_horizontalAlign == HorizontalAlign.CONTENT_JUSTIFY)
			{
				justifyWidth = Math.ceil(Math.max(targetWidth, _maxElementWidth));
			}
			for(i = 0; i < count; i++)
			{
				var exceesWidth:Number = 0;
				layoutElement = target.getElementAt(i) as ILayoutElement;
				if(layoutElement == null || !layoutElement.includeInLayout)
				{
					continue;
				}
				if(justify)
				{
					x = paddingL;
					layoutElement.setLayoutBoundsSize(justifyWidth, heightDic[layoutElement]);
				}
				else
				{
					var layoutElementWidth:Number = NaN;
					if(!isNaN(layoutElement.percentWidth))
					{
						var percent:Number = Math.min(100, layoutElement.percentWidth);
						layoutElementWidth = Math.round(targetWidth * percent * 0.01);
					}
					layoutElement.setLayoutBoundsSize(layoutElementWidth, heightDic[layoutElement]);
					exceesWidth = (targetWidth - layoutElement.layoutBoundsWidth) * hAlign;
					exceesWidth = exceesWidth > 0 ? exceesWidth : 0;
					x = paddingL + exceesWidth;
				}
				layoutElement.setLayoutBoundsPosition(Math.round(x), Math.round(y));
				dx = Math.ceil(layoutElement.layoutBoundsWidth);
				dy = Math.ceil(layoutElement.layoutBoundsHeight);
				maxX = Math.max(maxX, x + dx);
				maxY = Math.max(maxY, y + dy);
				y += dy + _gap;
			}
			target.setContentSize(Math.ceil(maxX + paddingR), Math.ceil(maxY + paddingB));
		}
		
		/**
		 * 更新使用虚拟布局的显示列表.
		 */
		private function updateDisplayListVirtual(width:Number, height:Number):void
		{
			if(_indexInViewCalculated)
			{
				_indexInViewCalculated = false;
			}
			else
			{
				getIndexInView();
			}
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingL:Number = isNaN(_paddingLeft) ? padding : _paddingLeft;
			var paddingR:Number = isNaN(_paddingRight) ? padding : _paddingRight;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			var contentHeight:Number;
			var numElements:int = target.numElements;
			if(_startIndex == -1 || _endIndex == -1)
			{
				contentHeight = getStartPosition(numElements) - _gap + paddingB;
				target.setContentSize(target.contentWidth, Math.ceil(contentHeight));
				return;
			}
			target.setVirtualElementIndicesInView(_startIndex, _endIndex);
			//获取水平布局参数
			var justify:Boolean = _horizontalAlign == HorizontalAlign.JUSTIFY || _horizontalAlign == HorizontalAlign.CONTENT_JUSTIFY;
			var contentJustify:Boolean = _horizontalAlign == HorizontalAlign.CONTENT_JUSTIFY;
			var hAlign:Number = 0;
			if(!justify)
			{
				if(_horizontalAlign == HorizontalAlign.CENTER)
				{
					hAlign = 0.5;
				}
				else if(_horizontalAlign == HorizontalAlign.RIGHT)
				{
					hAlign = 1;
				}
			}
			var targetWidth:Number = Math.max(0, width - paddingL - paddingR);
			var justifyWidth:Number = Math.ceil(targetWidth);
			var layoutElement:ILayoutElement;
			var typicalHeight:Number = this.typicalLayoutRect ? this.typicalLayoutRect.height : 22;
			var typicalWidth:Number = this.typicalLayoutRect ? this.typicalLayoutRect.width : 71;
			var oldMaxW:Number = Math.max(typicalWidth, _maxElementWidth);
			if(contentJustify)
			{
				for(var index:int = _startIndex; index <= _endIndex; index++)
				{
					layoutElement = target.getVirtualElementAt(index) as ILayoutElement;
					if (!layoutElement || !layoutElement.includeInLayout)
					{
						continue;
					}
					_maxElementWidth = Math.max(_maxElementWidth, layoutElement.preferredWidth);
				}
				justifyWidth = Math.ceil(Math.max(targetWidth, _maxElementWidth));
			}
			var x:Number = 0;
			var y:Number = 0;
			var contentWidth:Number = 0;
			var oldElementSize:Number;
			var needInvalidateSize:Boolean = false;
			//对可见区域进行布局
			for(var i:int = _startIndex; i <= _endIndex; i++)
			{
				var exceesWidth:Number = 0;
				layoutElement = target.getVirtualElementAt(i) as ILayoutElement;
				if (!layoutElement)
				{
					continue;
				}
				else if(!layoutElement.includeInLayout)
				{
					_elementSizeTable[i] = 0;
					continue;
				}
				if(justify)
				{
					x = paddingL;
					layoutElement.setLayoutBoundsSize(justifyWidth, NaN);
				}
				else
				{
					exceesWidth = (targetWidth - layoutElement.layoutBoundsWidth) * hAlign;
					exceesWidth = exceesWidth > 0 ? exceesWidth : 0;
					x = paddingL + exceesWidth;
				}
				if(!contentJustify)
				{
					_maxElementWidth = Math.max(_maxElementWidth, layoutElement.preferredWidth);
				}
				contentWidth = Math.max(contentWidth, layoutElement.layoutBoundsWidth);
				if(!needInvalidateSize)
				{
					oldElementSize = isNaN(_elementSizeTable[i]) ? typicalHeight : _elementSizeTable[i];
					if(oldElementSize != layoutElement.layoutBoundsHeight)
					{
						needInvalidateSize = true;
					}
				}
				if(i == 0 && _elementSizeTable.length > 0 && _elementSizeTable[i] != layoutElement.layoutBoundsHeight)
				{
					this.typicalLayoutRect = null;
				}
				_elementSizeTable[i] = layoutElement.layoutBoundsHeight;
				y = getStartPosition(i);
				layoutElement.setLayoutBoundsPosition(Math.round(x), Math.round(y));
			}
			contentWidth += paddingL + paddingR;
			contentHeight = getStartPosition(numElements) - _gap + paddingB;
			target.setContentSize(Math.ceil(contentWidth), Math.ceil(contentHeight));
			if(needInvalidateSize || oldMaxW < _maxElementWidth)
			{
				target.invalidateSize();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if(target == null)
			{
				return rect;
			}
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			var firstIndex:int = findIndexAt(scrollRect.top, 0, target.numElements - 1);
			if(firstIndex == -1)
			{
				if(scrollRect.top > target.contentHeight - paddingB)
				{
					rect.top = target.contentHeight - paddingB;
					rect.bottom = target.contentHeight;
				}
				else
				{
					rect.top = 0;
					rect.bottom = paddingT;
				}
				return rect;
			}
			rect.top = getStartPosition(firstIndex);
			rect.bottom = getElementSize(firstIndex) + rect.top;
			if(rect.top == scrollRect.top)
			{
				firstIndex--;
				if(firstIndex != -1)
				{
					rect.top = getStartPosition(firstIndex);
					rect.bottom = getElementSize(firstIndex) + rect.top;
				}
				else
				{
					rect.top = 0;
					rect.bottom = paddingT;
				}
			}
			return rect;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
		{
			var rect:Rectangle = new Rectangle;
			if(target == null)
			{
				return rect;
			}
			var numElements:int = target.numElements;
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			var lastIndex:int = findIndexAt(scrollRect.bottom, 0, numElements - 1);
			if(lastIndex == -1)
			{
				if(scrollRect.right < paddingT)
				{
					rect.top = 0;
					rect.bottom = paddingT;
				}
				else
				{
					rect.top = target.contentHeight - paddingB;
					rect.bottom = target.contentHeight;
				}
				return rect;
			}
			rect.top = getStartPosition(lastIndex);
			rect.bottom = getElementSize(lastIndex) + rect.top;
			if(rect.bottom <= scrollRect.bottom)
			{
				lastIndex++;
				if(lastIndex < numElements)
				{
					rect.top = getStartPosition(lastIndex);
					rect.bottom = getElementSize(lastIndex) + rect.top;
				}
				else
				{
					rect.top = target.contentHeight - paddingB;
					rect.bottom = target.contentHeight;
				}
			}
			return rect;
		}
		
		/**
		 * 折半查找法寻找指定位置的显示对象索引.
		 */
		private function findIndexAt(y:Number, i0:int, i1:int):int
		{
			var index:int = (i0 + i1) / 2;
			var elementY:Number = getStartPosition(index);
			var elementHeight:Number = getElementSize(index);
			if((y >= elementY) && (y < elementY + elementHeight + gap))
			{
				return index;
			}
			else if(i0 == i1)
			{
				return -1;
			}
			else if(y < elementY)
			{
				return findIndexAt(y, i0, Math.max(i0, index - 1));
			}
			else
			{
				return findIndexAt(y, Math.min(index + 1, i1), i1);
			}
		}
		
		/**
		 * 获取指定索引的起始位置.
		 */
		private function getStartPosition(index:int):Number
		{
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			if(!this.useVirtualLayout)
			{
				var element:IUIComponent;
				if(target != null)
				{
					element =  target.getElementAt(index);
				}
				return element ? element.y : paddingT;
			}
			var typicalHeight:Number = this.typicalLayoutRect ? this.typicalLayoutRect.height : 22;
			var startPos:Number = paddingT;
			for(var i:int = 0; i < index; i++)
			{
				var eltHeight:Number = _elementSizeTable[i];
				if(isNaN(eltHeight))
				{
					eltHeight = typicalHeight;
				}
				startPos += eltHeight+gap;
			}
			return startPos;
		}
		
		/**
		 * 获取指定索引的元素尺寸.
		 */
		private function getElementSize(index:int):Number
		{
			if(this.useVirtualLayout)
			{
				var size:Number = _elementSizeTable[index];
				if(isNaN(size))
				{
					size = this.typicalLayoutRect ? this.typicalLayoutRect.height : 22;
				}
				return size;
			}
			if(target != null)
			{
				return target.getElementAt(index).height;
			}
			return 0;
		}
		
		/**
		 * 获取缓存的子对象尺寸总和.
		 */
		private function getElementTotalSize():Number
		{
			var typicalHeight:Number = this.typicalLayoutRect ? this.typicalLayoutRect.height : 22;
			var totalSize:Number = 0;
			var length:int = target.numElements;
			for(var i:int = 0; i < length; i++)
			{
				var eltHeight:Number = _elementSizeTable[i];
				if(isNaN(eltHeight))
				{
					eltHeight = typicalHeight;
				}
				totalSize += eltHeight+gap;
			}
			totalSize -= gap;
			return totalSize;
		}
		
		/**
		 * 获取视图中第一个和最后一个元素的索引, 返回是否发生改变.
		 */
		private function getIndexInView():Boolean
		{
			if(!target || target.numElements == 0)
			{
				_startIndex = _endIndex = -1;
				return false;
			}
			if(isNaN(target.width) || target.width == 0 || isNaN(target.height) || target.height == 0)
			{
				_startIndex = _endIndex = -1;
				return false;
			}
			var padding:Number = isNaN(_padding) ? 0 : _padding;
			var paddingT:Number = isNaN(_paddingTop) ? padding : _paddingTop;
			var paddingB:Number = isNaN(_paddingBottom) ? padding : _paddingBottom;
			var numElements:int = target.numElements;
			var contentHeight:Number = getStartPosition(numElements - 1) + _elementSizeTable[numElements - 1] + paddingB;			
			var minVisibleY:Number = target.verticalScrollPosition;
			if(minVisibleY > contentHeight - paddingB)
			{
				_startIndex = -1;
				_endIndex = -1;
				return false;
			}
			var maxVisibleY:Number = target.verticalScrollPosition + target.height;
			if(maxVisibleY < paddingT)
			{
				_startIndex = -1;
				_endIndex = -1;
				return false;
			}
			var oldStartIndex:int = _startIndex;
			var oldEndIndex:int = _endIndex;
			_startIndex = findIndexAt(minVisibleY, 0, numElements - 1);
			if(_startIndex == -1)
			{
				_startIndex = 0;
			}
			_endIndex = findIndexAt(maxVisibleY, 0, numElements - 1);
			if(_endIndex == -1)
			{
				_endIndex = numElements - 1;
			}
			return oldStartIndex != _startIndex || oldEndIndex != _endIndex;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function scrollPositionChanged():void
		{
			super.scrollPositionChanged();
			if(this.useVirtualLayout)
			{
				var changed:Boolean = getIndexInView();
				if(changed)
				{
					_indexInViewCalculated = true;
					target.invalidateDisplayList();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function elementAdded(index:int):void
		{
			super.elementAdded(index);
			var typicalHeight:Number = this.typicalLayoutRect ? this.typicalLayoutRect.height : 22;
			_elementSizeTable.splice(index, 0, typicalHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function elementRemoved(index:int):void
		{
			super.elementRemoved(index);
			_elementSizeTable.splice(index, 1);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clearVirtualLayoutCache():void
		{
			super.clearVirtualLayoutCache();
			_elementSizeTable = [];
			_maxElementWidth = 0;
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
