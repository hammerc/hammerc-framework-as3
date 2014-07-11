/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.pathfinding.astar
{
	import org.hammerc.archer.ds.BinaryHeaps;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>AStar</code> 类提供了基本的 A 星寻路功能.
	 * <p>该类基于《Flash ActionScript 3.0 动画高级教程》一书中寻路章节的脚本改写, 并对寻路效率进行了特别优化.</p>
	 * <p><b>注意: </b>该类得到的最短路径为一个个连续的格子对象, 该路径并非为平滑的最佳最短路径.</p>
	 * @author wizardc
	 */
	public class AStar
	{
		/**
		 * 上下左右的移动成本.
		 */
		public static const STRAIGHT_COST:int = 10;
		
		/**
		 * 斜角的移动成本.
		 */
		public static const DIAG_COST:int = 14;
		
		/**
		 * 曼哈顿启发函数.
		 * @param node1 第一个节点.
		 * @param node2 第二个节点.
		 * @return 两个节点移动的代价.
		 */
		public static function manhattan(node1:AStarNode, node2:AStarNode):int
		{
			var dx:int = node1.x > node2.x ? node1.x - node2.x : node2.x - node1.x;
			var dy:int = node1.y > node2.y ? node1.y - node2.y : node2.y - node1.y;
			return (dx + dy) * STRAIGHT_COST;
		}
		
		/**
		 * 欧式启发函数.
		 * @param node1 第一个节点.
		 * @param node2 第二个节点.
		 * @return 两个节点移动的代价.
		 */
		public static function euclidian(node1:AStarNode, node2:AStarNode):int
		{
			var dx:int = node1.x > node2.x ? node1.x - node2.x : node2.x - node1.x;
			var dy:int = node1.y > node2.y ? node1.y - node2.y : node2.y - node1.y;
			return (dx * dx + dy * dy) * STRAIGHT_COST;
		}
		
		/**
		 * 对角启发函数.
		 * @param node1 第一个节点.
		 * @param node2 第二个节点.
		 * @return 两个节点移动的代价.
		 */
		public static function diagonal(node1:AStarNode, node2:AStarNode):int
		{
			var dx:int = node1.x > node2.x ? node1.x - node2.x : node2.x - node1.x;
			var dy:int = node1.y > node2.y ? node1.y - node2.y : node2.y - node1.y;
			return dx > dy ? DIAG_COST * dy + STRAIGHT_COST * (dx - dy) : DIAG_COST * dx + STRAIGHT_COST * (dy - dx);
		}
		
		private var _heuristic:Function;
		
		protected var _grid:AStarGrid;
		
		private var _startNode:AStarNode;
		private var _endNode:AStarNode;
		
		private var _nowCheckNum:int = 1;
		private var _binaryHeaps:BinaryHeaps;
		
		private var _path:Vector.<AStarNode>;
		
		/**
		 * 创建一个 <code>AStar</code> 对象.
		 * @param heuristic 应用的启发函数, 为空则使用曼哈顿启发函数.
		 */
		public function AStar(heuristic:Function = null)
		{
			_binaryHeaps = new BinaryHeaps(compare);
			if(heuristic == null)
			{
				_heuristic = manhattan;
			}
			else
			{
				_heuristic = heuristic;
			}
		}
		
		private function compare(a:AStarNode, b:AStarNode):int
		{
			return b._f - a._f;
		}
		
		/**
		 * 获取最优路径.
		 */
		public function get path():Vector.<AStarNode>
		{
			return _path.concat();
		}
		
		/**
		 * 根据传入的地图获取一个最佳路径.
		 * @param grid 需要寻路的地图对象.
		 * @return 是否可以搜寻到该路径.
		 */
		public function findPath(grid:AStarGrid):Boolean
		{
			if(_grid != null)
			{
				this.clear();
			}
			_grid = grid;
			_startNode = _grid.startNode;
			_endNode = _grid.endNode;
			_startNode._g = 0;
			_startNode._h = _heuristic(_startNode, _endNode);
			_startNode._f = _startNode._g + _startNode._h;
			return this.search();
		}
		
		/**
		 * 开始对该地图进行搜索.
		 * @return 是否可以搜寻到该路径.
		 */
		protected function search():Boolean
		{
			var node:AStarNode = _startNode;
			while(node != _endNode)
			{
				var aroundLinks:Vector.<AStarLink> = node._aroundLinks;
				for(var i:int = 0, len:int = aroundLinks.length; i < len; i++)
				{
					var test:AStarNode = aroundLinks[i].node;
					var cost:int = aroundLinks[i].cost;
					var g:int = node._g + cost;
					var h:int = _heuristic(test, _endNode);
					var f:int = g + h;
					if(test._checkNum == _nowCheckNum)
					{
						if(test._f > f)
						{
							test._f = f;
							test._g = g;
							test._h = h;
							test._parent = node;
							_binaryHeaps.modify(test, test);
						}
					}
					else
					{
						test._f = f;
						test._g = g;
						test._h = h;
						test._parent = node;
						_binaryHeaps.enqueue(test);
						test._checkNum = _nowCheckNum;
					}
				}
				node._checkNum = _nowCheckNum;
				if(_binaryHeaps.length == 0)
				{
					return false;
				}
				node = _binaryHeaps.dequeue() as AStarNode;
			}
			buildPath();
			_nowCheckNum++;
			return true;
		}
		
		private function buildPath():void
		{
			_path = new Vector.<AStarNode>();
			var node:AStarNode = _endNode;
			_path.push(node);
			while(node != _startNode)
			{
				node = node._parent;
				_path.push(node);
			}
			_path = _path.reverse();
		}
		
		/**
		 * 清空所有数据.
		 */
		public function clear():void
		{
			_grid = null;
			_startNode = null;
			_endNode = null;
			_binaryHeaps.clear();
			_path = null;
		}
	}
}
