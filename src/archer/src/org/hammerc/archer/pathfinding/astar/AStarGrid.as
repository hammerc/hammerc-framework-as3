// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.pathfinding.astar
{
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>AStarGrid</code> 类记录并描述一个需要被寻路的由多个格子组成的地图.
	 * @author wizardc
	 */
	public class AStarGrid
	{
		/**
		 * 记录所有格子的列表对象.
		 */
		protected var _grid:Vector.<Vector.<AStarNode>>;
		
		/**
		 * 记录地图的列数.
		 */
		protected var _cols:int;
		
		/**
		 * 记录地图的行数.
		 */
		protected var _rows:int;
		
		/**
		 * 记录开始格子.
		 */
		protected var _startNode:AStarNode;
		
		/**
		 * 记录终点格子.
		 */
		protected var _endNode:AStarNode;
		
		/**
		 * 创建一个 <code>AStarGrid</code> 对象.
		 * @param cols 设置地图的列数.
		 * @param rows 设置地图的行数.
		 */
		public function AStarGrid(cols:int, rows:int)
		{
			_cols = cols;
			_rows = rows;
			_grid = new Vector.<Vector.<AStarNode>>(_cols, true);
			for(var i:int = 0; i < _cols; i++)
			{
				_grid[i] = new Vector.<AStarNode>(_rows, true);
				for(var j:int = 0; j < _rows; j++)
				{
					_grid[i][j] = this.createNode(i, j);
				}
			}
		}
		
		/**
		 * 创建需要记录数据的格子对象.
		 * @param x 该格子在地图上的第几列.
		 * @param y 该格子在地图上的第几行.
		 * @return 需要记录数据的格子对象.
		 */
		protected function createNode(x:int, y:int):AStarNode
		{
			return new AStarNode(x, y);
		}
		
		/**
		 * 获取地图的列数.
		 */
		public function get cols():int
		{
			return _cols;
		}
		
		/**
		 * 获取地图的行数.
		 */
		public function get rows():int
		{
			return _rows;
		}
		
		/**
		 * 设置或获取寻路的起点格子.
		 */
		public function set startNode(value:AStarNode):void
		{
			_startNode = value;
		}
		public function get startNode():AStarNode
		{
			return _startNode;
		}
		
		/**
		 * 设置或获取寻路的终点格子.
		 */
		public function set endNode(value:AStarNode):void
		{
			_endNode = value;
		}
		public function get endNode():AStarNode
		{
			return _endNode;
		}
		
		/**
		 * 预处理每个格子四周可移动的格子数据.
		 * <p>注意: 在设置好地图数据后调用一次即可.</p>
		 */
		public function cacheAroundLinks():void
		{
			for(var i:int = 0; i < _cols; i++)
			{
				for(var j:int = 0; j < _rows; j++)
				{
					var node:AStarNode = _grid[i][j];
					node._aroundLinks = new Vector.<AStarLink>();
					var startX:int = Math.max(0, node.x - 1);
					var endX:int = Math.min(_cols - 1, node.x + 1);
					var startY:int = Math.max(0, node.y - 1);
					var endY:int = Math.min(_rows - 1, node.y + 1);
					for(var m:int = startX; m <= endX; m++)
					{
						for(var n:int = startY; n <= endY; n++)
						{
							var test:AStarNode = _grid[m][n];
							if(test == node || !test.walkable || !_grid[node.x][test.y].walkable || !_grid[test.x][node.y].walkable)
							{
								continue;
							}
							var cost:Number = AStar.STRAIGHT_COST;
							if(!((node.x == test.x) || (node.y == test.y)))
							{
								cost = AStar.DIAG_COST;
							}
							node._aroundLinks.push(new AStarLink(test, cost));
						}
					}
				}
			}
		}
		
		/**
		 * 获取地图中的一个指定的格子对象.
		 * @param x 指定要获取的格子在地图上的第几列.
		 * @param y 指定要获取的格子在地图上的第几行.
		 * @return 返回指定的格子.
		 */
		public function getNode(x:int, y:int):AStarNode
		{
			return _grid[x][y];
		}
		
		/**
		 * 设置地图中的一个指定格子的地形代价.
		 * @param x 指定要设定的格子在地图上的第几列.
		 * @param y 指定要设定的格子在地图上的第几行.
		 * @param value 指定该格子的地形代价.
		 */
		public function setCostMultiplier(x:int, y:int, value:Number):void
		{
			_grid[x][y].costMultiplier = value;
		}
		
		/**
		 * 设置地图中的一个指定的格子是否可以通行.
		 * @param x 指定要设定的格子在地图上的第几列.
		 * @param y 指定要设定的格子在地图上的第几行.
		 * @param value 指定该格子是否可以通行.
		 */
		public function setWalkable(x:int, y:int, value:Boolean):void
		{
			_grid[x][y].walkable = value;
		}
		
		/**
		 * 设置寻路起点.
		 * @param x 设置起点格子在地图上的第几列.
		 * @param y 设置起点格子在地图上的第几行.
		 */
		public function setStartNode(x:int, y:int):void
		{
			_startNode = _grid[x][y];
		}
		
		/**
		 * 设置寻路终点.
		 * @param x 设置终点格子在地图上的第几列.
		 * @param y 设置终点格子在地图上的第几行.
		 */
		public function setEndNode(x:int, y:int):void
		{
			_endNode = _grid[x][y];
		}
	}
}
