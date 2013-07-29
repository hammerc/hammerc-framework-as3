/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.tools
{
	import flash.geom.Rectangle;
	
	/**
	 * <code>MaxRectsBinPack</code> 类实现 MaxRects 图片排列算法, 可以将多个大小不同的
	 * 图片尽量多的压入指定大小的整图中, 使用图片尺寸信息而非直接使用位图.
	 * <p>本类算法实现来自 <b>杜增强.COM</b> 地址: <a href="http://www.duzengqiang.com/blog/post/971.html">http://www.duzengqiang.com/blog/post/971.html</a>.</p>
	 * @author wizardc
	 */
	public class MaxRectsBinPack
	{
		private var _binWidth:int = 0;
		private var _binHeight:int = 0;
		private var _allowRotations:Boolean = false;
		
		private var _usedRectangles:Vector.<Rectangle>;
		private var _freeRectangles:Vector.<Rectangle>;
		
		private var _score1:int = 0;
		private var _score2:int = 0;
		private var _bestShortSideFit:int = 0;
		private var _bestLongSideFit:int = 0;
		
		/**
		 * 创建一个 <code>MaxRectsBinPack</code> 对象.
		 * @param width 要包含小图片的整图的宽度.
		 * @param height 要包含小图片的整图的高度.
		 * @param rotations 小图是否可以根据需要进行旋转.
		 * @param checkSize 是否检测整图的高度和宽度是否为 2 的 n 次方且 n 大于 0. 创建 3D 贴图材质时应该开启整图尺寸检测.
		 */
		public function MaxRectsBinPack(width:int, height:int, rotations:Boolean = true, checkSize:Boolean = true)
		{
			_usedRectangles = new Vector.<Rectangle>();
			_freeRectangles = new Vector.<Rectangle>();
			init(width, height, rotations, checkSize);
		}
		
		private function init(width:int, height:int, rotations:Boolean, checkSize:Boolean):void
		{
			if(checkSize)
			{
				if(count(width) % 1 != 0 || count(height) % 1 != 0)
				{
					throw new Error("高度和宽度必须为2的n次方, n大于0!");
				}
			}
			_binWidth = width;
			_binHeight = height;
			_allowRotations = rotations;
			var n:Rectangle = new Rectangle();
			n.x = 0;
			n.y = 0;
			n.width = width;
			n.height = height;
			_usedRectangles.length = 0;
			_freeRectangles.length = 0;
			_freeRectangles.push(n);
		}
		
		private function count(n:Number):Number
		{
			if(n >= 2)
			{
				return count(n / 2);
			}
			return n;
		}
		
		/**
		 * 获取要包含小图片的整图的宽度.
		 */
		public function get binWidth():int
		{
			return _binWidth;
		}
		
		/**
		 * 获取要包含小图片的整图的高度.
		 */
		public function get binHeight():int
		{
			return _binHeight;
		}
		
		/**
		 * 获取小图是否可以根据需要进行旋转.
		 */
		public function get allowRotations():Boolean
		{
			return _allowRotations;
		}
		
		/**
		 * 获取整图中已经使用的所有区域列表.
		 */
		public function get usedRectangles():Vector.<Rectangle>
		{
			return _usedRectangles.concat();
		}
		
		/**
		 * 获取整图中尚未使用的所有区域列表.
		 */
		public function get freeRectangles():Vector.<Rectangle>
		{
			return _freeRectangles.concat();
		}
		
		/**
		 * 添加一个小图到整图中, 使用图片尺寸信息而非直接使用位图.
		 * @param width 小图的宽度.
		 * @param height 小图的高度.
		 * @param method 添加时的位置选择方法.
		 * @return 小图片位于大于的位置及尺寸信息对象, 如果该对象的宽度和高度都为 0 则说明整图中没有足够的空间放置该小图.
		 * @see org.hammerc.marble.utils.FreeRectangleChoiceHeuristic
		 */
		public function insert(width:int, height:int, method:int = 0):Rectangle
		{
			var newNode:Rectangle  = new Rectangle();
			_score1 = 0;
			_score2 = 0;
			switch(method)
			{
				case FreeRectangleChoiceHeuristic.BEST_SHORT_SIDE_FIT:
					newNode = findPositionForNewNodeBestShortSideFit(width, height);
					break;
				case FreeRectangleChoiceHeuristic.BOTTOM_LEFT_RULE:
					newNode = findPositionForNewNodeBottomLeft(width, height, _score1, _score2);
					break;
				case FreeRectangleChoiceHeuristic.CONTACT_POINT_RULE:
					newNode = findPositionForNewNodeContactPoint(width, height, _score1);
					break;
				case FreeRectangleChoiceHeuristic.BEST_LONG_SIDE_FIT:
					newNode = findPositionForNewNodeBestLongSideFit(width, height, _score2, _score1);
					break;
				case FreeRectangleChoiceHeuristic.BEST_AREA_FIT:
					newNode = findPositionForNewNodeBestAreaFit(width, height, _score1, _score2);
					break;
			}
			if(newNode.height == 0)
			{
				return newNode;
			}
			placeRectangle(newNode);
			return newNode;
		}
		
		private function placeRectangle(node:Rectangle):void
		{
			var numRectanglesToProcess:int = _freeRectangles.length;
			for(var i:int = 0; i < numRectanglesToProcess; i++)
			{
				if(splitFreeNode(_freeRectangles[i], node))
				{
					_freeRectangles.splice(i, 1);
					--i;
					--numRectanglesToProcess;
				}
			}
			pruneFreeList();
			_usedRectangles.push(node);
		}
		
		private function findPositionForNewNodeBottomLeft(width:int, height:int, bestY:int, bestX:int):Rectangle
		{
			var bestNode:Rectangle = new Rectangle();
			bestY = int.MAX_VALUE;
			var rect:Rectangle;
			var topSideY:int;
			for(var i:int = 0; i < _freeRectangles.length; i++)
			{
				rect = _freeRectangles[i];
				if(rect.width >= width && rect.height >= height)
				{
					topSideY = rect.y + height;
					if(topSideY < bestY || (topSideY == bestY && rect.x < bestX))
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = width;
						bestNode.height = height;
						bestY = topSideY;
						bestX = rect.x;
					}
				}
				if(_allowRotations && rect.width >= height && rect.height >= width)
				{
					topSideY = rect.y + width;
					if (topSideY < bestY || (topSideY == bestY && rect.x < bestX))
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = height;
						bestNode.height = width;
						bestY = topSideY;
						bestX = rect.x;
					}
				}
			}
			return bestNode;
		}
		
		private function findPositionForNewNodeBestShortSideFit(width:int, height:int):Rectangle
		{
			var bestNode:Rectangle = new Rectangle();
			_bestShortSideFit = int.MAX_VALUE;
			_bestLongSideFit = _score2;
			var rect:Rectangle;
			var leftoverHoriz:int;
			var leftoverVert:int;
			var shortSideFit:int;
			var longSideFit:int;
			for(var i:int = 0; i < _freeRectangles.length; i++)
			{
				rect = _freeRectangles[i];
				if(rect.width >= width && rect.height >= height)
				{
					leftoverHoriz = Math.abs(rect.width - width);
					leftoverVert = Math.abs(rect.height - height);
					shortSideFit = Math.min(leftoverHoriz, leftoverVert);
					longSideFit = Math.max(leftoverHoriz, leftoverVert);
					if(shortSideFit < _bestShortSideFit || (shortSideFit == _bestShortSideFit && longSideFit < _bestLongSideFit))
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = width;
						bestNode.height = height;
						_bestShortSideFit = shortSideFit;
						_bestLongSideFit = longSideFit;
					}
				}
				var flippedLeftoverHoriz:int;
				var flippedLeftoverVert:int;
				var flippedShortSideFit:int;
				var flippedLongSideFit:int;
				if(_allowRotations && rect.width >= height && rect.height >= width)
				{
					flippedLeftoverHoriz = Math.abs(rect.width - height);
					flippedLeftoverVert = Math.abs(rect.height - width);
					flippedShortSideFit = Math.min(flippedLeftoverHoriz, flippedLeftoverVert);
					flippedLongSideFit = Math.max(flippedLeftoverHoriz, flippedLeftoverVert);
					if (flippedShortSideFit < _bestShortSideFit || (flippedShortSideFit == _bestShortSideFit && flippedLongSideFit < _bestLongSideFit))
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = height;
						bestNode.height = width;
						_bestShortSideFit = flippedShortSideFit;
						_bestLongSideFit = flippedLongSideFit;
					}
				}
			}
			return bestNode;
		}
		
		private function findPositionForNewNodeBestLongSideFit(width:int, height:int, bestShortSideFit:int, bestLongSideFit:int):Rectangle
		{
			var bestNode:Rectangle = new Rectangle();
			bestLongSideFit = int.MAX_VALUE;
			var rect:Rectangle;
			var leftoverHoriz:int;
			var leftoverVert:int;
			var shortSideFit:int;
			var longSideFit:int;
			for(var i:int = 0; i < _freeRectangles.length; i++)
			{
				rect = _freeRectangles[i];
				if(rect.width >= width && rect.height >= height)
				{
					leftoverHoriz = Math.abs(rect.width - width);
					leftoverVert = Math.abs(rect.height - height);
					shortSideFit = Math.min(leftoverHoriz, leftoverVert);
					longSideFit = Math.max(leftoverHoriz, leftoverVert);
					if(longSideFit < bestLongSideFit || (longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit))
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = width;
						bestNode.height = height;
						bestShortSideFit = shortSideFit;
						bestLongSideFit = longSideFit;
					}
				}
				if(_allowRotations && rect.width >= height && rect.height >= width)
				{
					leftoverHoriz = Math.abs(rect.width - height);
					leftoverVert = Math.abs(rect.height - width);
					shortSideFit = Math.min(leftoverHoriz, leftoverVert);
					longSideFit = Math.max(leftoverHoriz, leftoverVert);
					if(longSideFit < bestLongSideFit || (longSideFit == bestLongSideFit && shortSideFit < bestShortSideFit))
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = height;
						bestNode.height = width;
						bestShortSideFit = shortSideFit;
						bestLongSideFit = longSideFit;
					}
				}
			}
			return bestNode;
		}
		
		private function findPositionForNewNodeBestAreaFit(width:int, height:int, bestAreaFit:int, bestShortSideFit:int):Rectangle
		{
			var bestNode:Rectangle = new Rectangle();
			bestAreaFit = int.MAX_VALUE;
			var rect:Rectangle;
			var leftoverHoriz:int;
			var leftoverVert:int;
			var shortSideFit:int;
			var areaFit:int;
			for(var i:int = 0; i < _freeRectangles.length; i++)
			{
				rect = _freeRectangles[i];
				areaFit = rect.width * rect.height - width * height;
				if(rect.width >= width && rect.height >= height)
				{
					leftoverHoriz = Math.abs(rect.width - width);
					leftoverVert = Math.abs(rect.height - height);
					shortSideFit = Math.min(leftoverHoriz, leftoverVert);
					if(areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit))
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = width;
						bestNode.height = height;
						bestShortSideFit = shortSideFit;
						bestAreaFit = areaFit;
					}
				}
				if(_allowRotations && rect.width >= height && rect.height >= width)
				{
					leftoverHoriz = Math.abs(rect.width - height);
					leftoverVert = Math.abs(rect.height - width);
					shortSideFit = Math.min(leftoverHoriz, leftoverVert);
					if(areaFit < bestAreaFit || (areaFit == bestAreaFit && shortSideFit < bestShortSideFit))
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = height;
						bestNode.height = width;
						bestShortSideFit = shortSideFit;
						bestAreaFit = areaFit;
					}
				}
			}
			return bestNode;
		}
		
		private function commonIntervalLength(i1start:int, i1end:int, i2start:int, i2end:int):int
		{
			if(i1end < i2start || i2end < i1start)
			{
				return 0;
			}
			return Math.min(i1end, i2end) - Math.max(i1start, i2start);
		}
		
		private function contactPointScoreNode(x:int, y:int, width:int, height:int):int
		{
			var score:int = 0;
			if(x == 0 || x + width == _binWidth)
			{
				score += height;
			}
			if(y == 0 || y + height == _binHeight)
			{
				score += width;
			}
			var rect:Rectangle;
			for(var i:int = 0; i < _usedRectangles.length; i++)
			{
				rect = _usedRectangles[i];
				if(rect.x == x + width || rect.x + rect.width == x)
				{
					score += commonIntervalLength(rect.y, rect.y + rect.height, y, y + height);
				}
				if(rect.y == y + height || rect.y + rect.height == y)
				{
					score += commonIntervalLength(rect.x, rect.x + rect.width, x, x + width);
				}
			}
			return score;
		}
		
		private function findPositionForNewNodeContactPoint(width:int, height:int, bestContactScore:int):Rectangle
		{
			var bestNode:Rectangle = new Rectangle();
			bestContactScore = -1;
			var rect:Rectangle;
			var score:int;
			for(var i:int = 0; i < _freeRectangles.length; i++)
			{
				rect = _freeRectangles[i];
				if(rect.width >= width && rect.height >= height)
				{
					score = contactPointScoreNode(rect.x, rect.y, width, height);
					if(score > bestContactScore)
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = width;
						bestNode.height = height;
						bestContactScore = score;
					}
				}
				if(_allowRotations && rect.width >= height && rect.height >= width)
				{
					score = contactPointScoreNode(rect.x, rect.y, height, width);
					if(score > bestContactScore)
					{
						bestNode.x = rect.x;
						bestNode.y = rect.y;
						bestNode.width = height;
						bestNode.height = width;
						bestContactScore = score;
					}
				}
			}
			return bestNode;
		}
		
		private function splitFreeNode(freeNode:Rectangle, usedNode:Rectangle):Boolean
		{
			if(usedNode.x >= freeNode.x + freeNode.width || usedNode.x + usedNode.width <= freeNode.x || usedNode.y >= freeNode.y + freeNode.height || usedNode.y + usedNode.height <= freeNode.y)
			{
				return false;
			}
			var newNode:Rectangle;
			if(usedNode.x < freeNode.x + freeNode.width && usedNode.x + usedNode.width > freeNode.x)
			{
				if(usedNode.y > freeNode.y && usedNode.y < freeNode.y + freeNode.height)
				{
					newNode = freeNode.clone();
					newNode.height = usedNode.y - newNode.y;
					_freeRectangles.push(newNode);
				}
				if(usedNode.y + usedNode.height < freeNode.y + freeNode.height)
				{
					newNode = freeNode.clone();
					newNode.y = usedNode.y + usedNode.height;
					newNode.height = freeNode.y + freeNode.height - (usedNode.y + usedNode.height);
					_freeRectangles.push(newNode);
				}
			}
			if(usedNode.y < freeNode.y + freeNode.height && usedNode.y + usedNode.height > freeNode.y)
			{
				if(usedNode.x > freeNode.x && usedNode.x < freeNode.x + freeNode.width)
				{
					newNode = freeNode.clone();
					newNode.width = usedNode.x - newNode.x;
					_freeRectangles.push(newNode);
				}
				if(usedNode.x + usedNode.width < freeNode.x + freeNode.width)
				{
					newNode = freeNode.clone();
					newNode.x = usedNode.x + usedNode.width;
					newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width);
					_freeRectangles.push(newNode);
				}
			}
			return true;
		}
		
		private function pruneFreeList():void
		{
			for(var i:int = 0; i < _freeRectangles.length; i++)
			{
				for(var j:int = i + 1; j < _freeRectangles.length; j++)
				{
					if(isContainedIn(_freeRectangles[i], _freeRectangles[j]))
					{
						_freeRectangles.splice(i,1);
						break;
					}
					if(isContainedIn(_freeRectangles[j], _freeRectangles[i]))
					{
						_freeRectangles.splice(j,1);
					}
				}
			}
		}
		
		private function isContainedIn(a:Rectangle, b:Rectangle):Boolean
		{
			return a.x >= b.x && a.y >= b.y && a.x + a.width <= b.x + b.width && a.y + a.height <= b.y + b.height;
		}
	}
}
