// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.tools.packer
{
	/**
	 * <code>BinaryTreeBin</code> 类实现了单个图集的添加逻辑.
	 * @author wizardc
	 */
	public class BinaryTreeBin
	{
		private var _maxWidth:int;
		private var _maxHeight:int;
		private var _padding:int;
		private var _smart:Boolean;
		private var _pot:Boolean;
		private var _square:Boolean;
		
		private var _width:int;
		private var _height:int;
		
		private var _freeRects:Array;
		private var _rects:Array;
		
		private var _verticalExpand:Boolean;
		
		/**
		 * 创建一个 <code>BinaryTreeBin</code> 对象.
		 * @param maxWidth 图集最大宽度.
		 * @param maxHeight 图集最大高度.
		 * @param padding 图集间隔.
		 * @param smart 是否尽可能的使图集尺寸最小.
		 * @param pot 输出的图集是否为 2 的 n 次方.
		 * @param square 输出的图集是否为正方形.
		 */
		public function BinaryTreeBin(maxWidth:int, maxHeight:int, padding:int, smart:Boolean, pot:Boolean, square:Boolean)
		{
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			_padding = padding;
			_smart = smart;
			_pot = pot;
			_square = square;
			_width = 0;
			_height = 0;
			_freeRects = [{ x: 0, y: 0, width: maxWidth + _padding, height: maxHeight + _padding}];
			_rects = [];
			_verticalExpand = false;
		}
		
		/**
		 * 获取最大的宽度.
		 */
		public function get maxWidth():int
		{
			return _maxWidth;
		}
		
		/**
		 * 获取最大的高度.
		 */
		public function get maxHeight():int
		{
			return _maxHeight;
		}
		
		/**
		 * 获取当前图集内容的宽度.
		 */
		public function get width():int
		{
			if(!_pot)
			{
				return _width;
			}
			//修正尺寸过大的bug
			var width:int = 0;
			for(var i:int = 0; i < _rects.length; i++)
			{
				var rect:Object = _rects[i];
				var w:int = rect.x + rect.width + _padding;
				if(w > width)
				{
					width = w;
				}
			}
			return getPot(width);
		}
		
		/**
		 * 获取当前图集内容的高度.
		 */
		public function get height():int
		{
			if(!_pot)
			{
				return _height;
			}
			//修正尺寸过大的bug
			var height:int = 0;
			for(var i:int = 0; i < _rects.length; i++)
			{
				var rect:Object = _rects[i];
				var h:int = rect.y + rect.height + _padding;
				if(h > height)
				{
					height = h;
				}
			}
			return getPot(height);
		}
		
		/**
		 * 获取未使用的区域列表.
		 */
		public function get freeRects():Array
		{
			return _freeRects;
		}
		
		/**
		 * 获取已经包含图片区域的区域列表.
		 */
		public function get rects():Array
		{
			return _rects;
		}
		
		/**
		 * 添加一个图片区域.
		 * @param width 宽度.
		 * @param height 高度.
		 * @param data 自定义数据.
		 * @return 图片添加到图集中的区域.
		 */
		public function add(width:int, height:int, data:Object):Object
		{
			var node:Object = findNode(width + _padding, height + _padding);
			if(node)
			{
				updateBinSize(node);
				var numRectToProcess:int = _freeRects.length;
				var i:int = 0;
				while(i < numRectToProcess)
				{
					if(splitNode(_freeRects[i], node))
					{
						_freeRects.splice(i, 1);
						numRectToProcess--;
						i--;
					}
					i++;
				}
				pruneFreeList();
				_verticalExpand = _width > _height ? true : false;
				var rect:Object = {width:width, height:height, x:node.x, y:node.y, data:data};
				_rects.push(rect);
				return rect;
			}
			else if(!_verticalExpand)
			{
				if(updateBinSize({
						x: _width + _padding,
						y: 0,
						width: width + _padding,
						height: height + _padding
					}) || updateBinSize({
						x: 0,
						y: _height + _padding,
						width: width + _padding,
						height: height + _padding
					}))
				{
					return add(width, height, data);
				}
			}
			else
			{
				if(updateBinSize({
						x: 0,
						y: _height + _padding,
						width: width + _padding,
						height: height + _padding
					}) || updateBinSize({
						x: _width + _padding,
						y: 0,
						width: width + _padding,
						height: height + _padding
					}))
				{
					return add(width, height, data);
				}
			}
			return null;
		}
		
		private function findNode(width:int, height:int):Object
		{
			var score:int = int.MAX_VALUE;
			var areaFit:int, r:Object, bestNode:Object;
			for(var i:int = 0; i < _freeRects.length; i++)
			{
				r = _freeRects[i];
				if(r.width >= width && r.height >= height)
				{
					areaFit = r.width * r.height - width * height;
					if(areaFit < score)
					{
						bestNode = {};
						bestNode.x = r.x;
						bestNode.y = r.y;
						bestNode.width = width;
						bestNode.height = height;
						score = areaFit;
					}
				}
			}
			return bestNode;
		}
		
		private function splitNode(freeRect:Object, usedNode:Object):Boolean
		{
			if(usedNode.x >= freeRect.x + freeRect.width ||
				usedNode.x + usedNode.width <= freeRect.x ||
				usedNode.y >= freeRect.y + freeRect.height ||
				usedNode.y + usedNode.height <= freeRect.y)
			{
				return false;
			}
			var newNode:Object;
			if(usedNode.x < freeRect.x + freeRect.width &&
				usedNode.x + usedNode.width > freeRect.x)
			{
				if(usedNode.y > freeRect.y && usedNode.y < freeRect.y + freeRect.height)
				{
					newNode = {};
					newNode.x = freeRect.x;
					newNode.y = freeRect.y;
					newNode.width = freeRect.width;
					newNode.height = usedNode.y - freeRect.y;
					_freeRects.push(newNode);
				}
				if(usedNode.y + usedNode.height < freeRect.y + freeRect.height)
				{
					newNode = {};
					newNode.x = freeRect.x;
					newNode.width = freeRect.width;
					newNode.y = usedNode.y + usedNode.height;
					newNode.height = freeRect.y + freeRect.height - (usedNode.y + usedNode.height);
					_freeRects.push(newNode);
				}
			}
			if(usedNode.y < freeRect.y + freeRect.height &&
				usedNode.y + usedNode.height > freeRect.y)
			{
				if(usedNode.x > freeRect.x && usedNode.x < freeRect.x + freeRect.width)
				{
					newNode = {};
					newNode.x = freeRect.x;
					newNode.y = freeRect.y;
					newNode.height = freeRect.height;
					newNode.width = usedNode.x - freeRect.x;
					_freeRects.push(newNode);
				}
				if(usedNode.x + usedNode.width < freeRect.x + freeRect.width)
				{
					newNode = {};
					newNode.y = freeRect.y;
					newNode.height = freeRect.height;
					newNode.x = usedNode.x + usedNode.width;
					newNode.width = freeRect.x + freeRect.width - (usedNode.x + usedNode.width);
					_freeRects.push(newNode);
				}
			}
			return true;
		}
		
		private function pruneFreeList():void
		{
			var i:int = 0;
			var j:int = 0;
			var len:int = _freeRects.length;
			while(i < len)
			{
				j = i + 1;
				var tmpRect1:Object = _freeRects[i];
				while(j < len)
				{
					var tmpRect2:Object = _freeRects[j];
					if(isContained(tmpRect1, tmpRect2))
					{
						_freeRects.splice(i, 1);
						i--;
						len--;
						break;
					}
					if(isContained(tmpRect2, tmpRect1))
					{
						_freeRects.splice(j, 1);
						j--;
						len--;
					}
					j++;
				}
				i++;
			}
		}
		
		private function updateBinSize(node:Object):Boolean
		{
			if(!_smart)
			{
				return false;
			}
			if(isContained(node, {x:0, y:0, width:_width, height:_height}))
			{
				return false;
			}
			var tmpWidth:int = Math.max(_width, node.x + node.width - _padding);
			var tmpHeight:int = Math.max(_height, node.y + node.height - _padding);
			if(_pot)
			{
				tmpWidth = getPot(tmpWidth);
				tmpHeight = getPot(tmpHeight);
			}
			if(_square)
			{
				tmpWidth = tmpHeight = Math.max(tmpWidth , tmpHeight);
			}
			if(tmpWidth > _maxWidth + _padding || tmpHeight > _maxHeight + _padding)
			{
				return false;
			}
			expandFreeRects(tmpWidth + _padding, tmpHeight + _padding);
			_width = tmpWidth;
			_height = tmpHeight;
			return true;
		}
		
		private function getPot(num:int):int
		{
			var i:int = 2;
			while(i < num)
			{
				i *= 2;
			}
			return i;
		}
		
		private function isContained(a:Object, b:Object):Boolean
		{
			return a.x >= b.x && a.y >= b.y	&& a.x + a.width <= b.x + b.width && a.y + a.height <= b.y + b.height;
		}
		
		private function expandFreeRects(width:int, height:int):void
		{
			_freeRects.forEach(function(freeRect:Object, index:int, array:Array):void
				{
					if(freeRect.x + freeRect.width >= Math.min(_width + _padding, width))
					{
						freeRect.width = width - freeRect.x;
					}
					if(freeRect.y + freeRect.height >= Math.min(_height + _padding, height))
					{
						freeRect.height = height - freeRect.y;
					}
				});
			_freeRects.push({
					x: _width + _padding,
					y: 0,
					width: width - _width - _padding,
					height: height
				});
			_freeRects.push({
					x: 0,
					y: _height + _padding,
					width: width,
					height: height - _height - _padding
				});
			var len:int = _freeRects.length;
			var i:int = 0;
			while(i < len)
			{
				if(_freeRects[i].width <= 0 || _freeRects[i].height <= 0)
				{
					_freeRects.splice(i, 1);
					len--;
					i--;
				}
				i++;
			}
			pruneFreeList();
		}
	}
}
