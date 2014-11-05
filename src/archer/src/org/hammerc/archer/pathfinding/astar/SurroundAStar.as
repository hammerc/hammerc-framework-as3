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
	 * <code>SurroundAStar</code> 基于 <code>SmoothAStar</code> 类实现, 添加了在终点为不可通过的格子时寻找最合适的可通过的格子为新终点的功能.
	 * <p>
	 * <b>注意: </b>要使用该类的新增功能传入的 <code>SurroundAStarGrid</code> 类的实例需要满足下面的条件: 
	 * <ul>
	 * <li>可通过的所有格子都是连接在一起的, 即任意的两个可通行的格子间都可以找到一条路径.</li>
	 * <li>所有不可通过的格子都是一块一块聚集在一起的, 这些不可通过的格子不能包围任何可通过的格子, 使这些可通过的格子成为一个孤岛.</li>
	 * <li>如果不能满足上面的条件并不会报错, 只是该类的新增功能在遇到终点在"孤岛"中时会无法找到路径而失效.</li>
	 * </ul>
	 * </p>
	 * <p>由于对于可通过的所有格子都是连接在一起的, 如果在一个游戏场景中需要存在"孤岛"时(如该场景就是由多个岛屿组成的)解决方法为为每个"孤岛"配置一个与之对应的 <code>SurroundAStarGrid</code> 类的实例, 仅对其的岛屿可通行, 在改变岛屿时更换 <code>SurroundAStarGrid</code> 类的实例即可.</p>
	 * @author wizardc
	 */
	public class SurroundAStar extends SmoothAStar
	{
		/**
		 * 创建一个 <code>SurroundAStar</code> 对象.
		 * @param heuristic 应用的启发函数, 为空则使用曼哈顿启发函数.
		 */
		public function SurroundAStar(heuristic:Function = null)
		{
			super(heuristic);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function findPath(grid:AStarGrid):Boolean
		{
			//如果终点为不可通行的点时为其寻找一个最合适的代替点
			if(!grid.endNode.walkable)
			{
				var endNode:AStarNode = findWalkableEndNode(grid.endNode as SurroundAStarNode);
				if(endNode != null)
				{
					grid.setEndNode(endNode.x, endNode.y);
				}
			}
			return super.findPath(grid);
		}
		
		/**
		 * 寻找不可通行终点的替换节点.
		 * @param endNode 需要被替换的终点.
		 * @return 终点的替换节点.
		 */
		private function findWalkableEndNode(endNode:SurroundAStarNode):SurroundAStarNode
		{
			//如果该终点没有记录最近的一圈可通行的格子则寻找并记录这些格子
			if(endNode._surroundNodes == null)
			{
				endNode._surroundNodes = getSurroundNodes(endNode);
			}
			//找不到可通行的格子时返回 null 否则返回可用的格子中距离起点最近的格子
			if(endNode._surroundNodes == null)
			{
				return null;
			}
			else
			{
				return getEndNodeReplacer(endNode);
			}
		}
		
		/**
		 * 获取不可通行的终点周围可通行的所有格子.
		 * @param endNode 不可通行的终点.
		 * @return 距离该终点最近且有可通行的一圈格子的所有可通行的格子.
		 */
		private function getSurroundNodes(endNode:SurroundAStarNode):Vector.<SurroundAStarNode>
		{
			var maxDist:int = _grid.cols > _grid.rows ? _grid.cols : _grid.rows;
			var nowDist:int = 1;
			var nodes:Vector.<SurroundAStarNode>;
			while(nodes == null)
			{
				//如果查询距离超过地图最大距离则说明该地图全部为不可通行, 返回 null 退出循环
				if(nowDist >= maxDist)
				{
					return null;
				}
				nodes = getSurroundNodesByDist(endNode, nowDist);
				nowDist++;
			}
			return nodes;
		}
		
		/**
		 * 获取和不可通行的终点指定距离的周围可通行的所有格子.
		 * @param endNode 不可通行的终点.
		 * @param dist 和不可通行终点的距离.
		 * @return 如果该距离能找到一个或多个可通行的格子则返回这些格子, 否则返回 <code>null</code>.
		 */
		private function getSurroundNodesByDist(endNode:SurroundAStarNode, dist:int):Vector.<SurroundAStarNode>
		{
			//根据记录获取这一圈格子的范围
			var minCol:int = endNode.x - dist;
			var startCol:int = minCol < 0 ? 0 : minCol;
			var maxCol:int = endNode.x + dist;
			var endCol:int = maxCol > (_grid.cols - 1) ? _grid.cols - 1 : maxCol;
			var minRow:int = endNode.y - dist;
			var startRow:int = minRow < 0 ? 0 : minRow;
			var maxRow:int = endNode.y + dist;
			var endRow:int = maxRow > (_grid.rows - 1) ? _grid.rows - 1 : maxRow;
			//声明记录所有可通行格子的列表对象
			var nodes:Vector.<SurroundAStarNode>;
			//开始循环查找格子
			for(var i:int = startCol; i <= endCol; i++)
			{
				for(var j:int = startRow; j <= endRow; j++)
				{
					//仅需要查找边上的格子, 排除内部的格子
					if((i != minCol && i != maxCol) && (j != minRow && j != maxRow))
					{
						continue;
					}
					//如果找到有可通行的格子时
					if(_grid.getNode(i, j).walkable)
					{
						if(nodes == null)
						{
							nodes = new Vector.<SurroundAStarNode>();
						}
						nodes.push(_grid.getNode(i, j));
					}
				}
			}
			return nodes;
		}
		
		/**
		 * 从多个可通行的格子中找到距离起点最近的格子并返回.
		 * @param endNode 不可通行的终点.
		 * @return 用于替换不可通行终点的可通行格子.
		 */
		private function getEndNodeReplacer(endNode:SurroundAStarNode):SurroundAStarNode
		{
			var startNode:SurroundAStarNode = _grid.startNode as SurroundAStarNode;
			var nodes:Vector.<SurroundAStarNode> = endNode._surroundNodes;
			//计算距离
			var dx:int = startNode.x - nodes[0].x;
			var dy:int = startNode.y - nodes[0].y;
			var distSquared:int = dx * dx + dy * dy;
			var minDist:int = distSquared;
			var minDistNode:SurroundAStarNode = nodes[0];
			//通过循环寻找距离最近的格子
			for(var i:int = 1, len:int = nodes.length; i < len; i++)
			{
				dx = startNode.x - nodes[i].x;
				dy = startNode.y - nodes[i].y;
				distSquared = dx * dx + dy * dy;
				if(minDist > distSquared)
				{
					minDist = distSquared;
					minDistNode = nodes[i];
				}
			}
			return minDistNode;
		}
	}
}
