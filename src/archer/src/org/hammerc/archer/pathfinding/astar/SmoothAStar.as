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
	/**
	 * <code>SmoothAStar</code> 类基于 <code>AStar</code> 类实现, 添加了获取平滑路径的功能.
	 * <p><b>注意: </b>该类得到的平滑路径为多个连续或不连续的格子对象, 每个格子对象按直线作为路径, 格子对象都出现在需要拐角处.</p>
	 * @author wizardc
	 */
	public class SmoothAStar extends AStar
	{
		/**
		 * 创建一个 <code>SmoothAStar</code> 对象.
		 * @param heuristic 应用的启发函数, 为空则使用曼哈顿启发函数.
		 */
		public function SmoothAStar(heuristic:Function = null)
		{
			super(heuristic);
		}
		
		/**
		 * 获取平滑的最优路径.
		 */
		public function get smoothPath():Vector.<AStarNode>
		{
			var path:Vector.<AStarNode> = this.path;
			if(path == null || path.length < 3)
			{
				return path;
			}
			else
			{
				//去掉共线格子
				path = removeCollinearAStarNode(path);
				//将多余的拐点去除
				path = smoothPathByFloyd(path);
			}
			return path;
		}
		
		/**
		 * 去掉路径中所有的共线格子.
		 * @param path 需要处理的路径.
		 * @return 去掉共线格子的路径.
		 */
		private function removeCollinearAStarNode(path:Vector.<AStarNode>):Vector.<AStarNode>
		{
			var result:Vector.<AStarNode> = new Vector.<AStarNode>();
			//添加第一个格子
			result.push(path[0]);
			//计算第一个格子和第二个格子的坐标差值, 判断时使用该差值即可, 差值相同则共线
			var offsetX:int = path[0].x - path[1].x;
			var offsetY:int = path[0].y - path[1].y;
			//获取路径长度及记录当前处理的格子索引, 注意最后一个格子不用处理并且从第一个格子开始处理
			var len:int = path.length - 1;
			var nowIndex:int = 1;
			//循环处理所有格子
			while(len > nowIndex)
			{
				//判断当前处理的格子和下一个格子的坐标差值是否不相等
				if((path[nowIndex].x - path[nowIndex + 1].x) != offsetX || (path[nowIndex].y - path[nowIndex + 1].y) != offsetY)
				{
					//如果不相等则说明当前处理的格子为拐点, 添加到返回列表
					result.push(path[nowIndex]);
					//重新设置差值
					offsetX = path[nowIndex].x - path[nowIndex + 1].x;
					offsetY = path[nowIndex].y - path[nowIndex + 1].y;
				}
				//索引递增
				nowIndex++;
			}
			//将最后一个格子添加到返回列表中
			result.push(path[nowIndex]);
			return result;
		}
		
		/**
		 * 去掉路径中的多余拐点.
		 * @param path 需要处理的路径.
		 * @return 去掉多余拐点的路径.
		 */
		private function smoothPathByFloyd(path:Vector.<AStarNode>):Vector.<AStarNode>
		{
			var result:Vector.<AStarNode> = new Vector.<AStarNode>();
			//添加第一个格子
			result.push(path[0]);
			//获取路径长度, 记录当前处理的格子索引及和当前处理的格子对比的格子索引
			var len:int = path.length;
			var nowIndex:int = 0;
			var testIndex:int = 2;
			//循环处理所有格子
			while(len > testIndex)
			{
				if(hasObstacle(path[nowIndex], path[testIndex]))
				{
					//将最后一个没有障碍的格子加入列表
					result.push(path[testIndex - 1]);
					//获取新的处理机对比格子
					nowIndex = testIndex - 1;
					testIndex++;
				}
				else
				{
					testIndex++;
				}
			}
			//将最后一个格子添加到返回列表中
			result.push(path[path.length - 1]);
			return result;
		}
		
		/**
		 * 判断两个格子之间的直线连线经过的路径中是否有不可通过的障碍点.
		 * @param node1 第一个格子.
		 * @param node2 第二个格子.
		 * @return 这两个格子之间的直线连线经过的路径中如果有不可通过的障碍点返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		private function hasObstacle(node1:AStarNode, node2:AStarNode):Boolean
		{
			var dx:int = node1.x - node2.x;
			dx = dx < 0 ? -dx : dx;
			var dy:int = node1.y - node2.y;
			dy = dy < 0 ? -dy : dy;
			//如果两个格子八方向相邻则可断定其间不存在障碍格子
			if(dx < 2 && dy < 2)
			{
				return false;
			}
			//两个格子恰好同一列
			else if(dx == 0)
			{
				return verticalHasObstacle(node1, node2);
			}
			//两个格子恰好同一行
			else if(dy == 0)
			{
				return horizontalHasObstacle(node1, node2);
			}
			//两个格子恰好位于同一 45 度的直线上
			else if(dx == dy)
			{
				return slopeHasObstacle(node1, node2);
			}
			//其他不规则的位置
			else
			{
				return otherHasObstacle(dx, dy, node1, node2);
			}
		}
		
		/**
		 * 判断两个格子之间的直线连线经过的路径中是否有不可通过的障碍点, 这两个格子位于同一列.
		 * @param node1 第一个格子.
		 * @param node2 第二个格子.
		 * @return 这两个格子之间的直线连线经过的路径中如果有不可通过的障碍点返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		private function verticalHasObstacle(node1:AStarNode, node2:AStarNode):Boolean
		{
			var col:int = node1.x;
			var minRow:int = node1.y > node2.y ? node2.y : node1.y;
			var maxRow:int = node1.y > node2.y ? node1.y : node2.y;
			for(var i:int = minRow + 1; i < maxRow; i++)
			{
				if(!_grid.getNode(col, i).walkable)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 判断两个格子之间的直线连线经过的路径中是否有不可通过的障碍点, 这两个格子位于同一行.
		 * @param node1 第一个格子.
		 * @param node2 第二个格子.
		 * @return 这两个格子之间的直线连线经过的路径中如果有不可通过的障碍点返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		private function horizontalHasObstacle(node1:AStarNode, node2:AStarNode):Boolean
		{
			var row:int = node1.y;
			var minCol:int = node1.x > node2.x ? node2.x : node1.x;
			var maxCol:int = node1.x > node2.x ? node1.x : node2.x;
			for(var i:int = minCol + 1; i < maxCol; i++)
			{
				if(!_grid.getNode(i, row).walkable)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 判断两个格子之间的直线连线经过的路径中是否有不可通过的障碍点, 这两个格子位于同一 45 度的斜角上.
		 * @param node1 第一个格子.
		 * @param node2 第二个格子.
		 * @return 这两个格子之间的直线连线经过的路径中如果有不可通过的障碍点返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		private function slopeHasObstacle(node1:AStarNode, node2:AStarNode):Boolean
		{
			var leftNode:AStarNode = node1.x > node2.x ? node2 : node1;
			var rightNode:AStarNode = node1.x > node2.x ? node1 : node2;
			//从左至右时格子的连线是否向上
			var up:Boolean = leftNode.y > rightNode.y ? true : false;
			var x:int = leftNode.x;
			var y:int = leftNode.y;
			for(var i:int = 0, len:int = rightNode.x - leftNode.x + 1; i < len; i++)
			{
				if(i == 0)
				{
					if(!_grid.getNode(x + 1, y).walkable)
					{
						return true;
					}
				}
				else if(i == len - 1)
				{
					if(!_grid.getNode(x - 1, y).walkable)
					{
						return true;
					}
				}
				else
				{
					for(var j:int = -1; j < 2; j++)
					{
						if(!_grid.getNode(x + j, y).walkable)
						{
							return true;
						}
					}
				}
				x++;
				up ? y-- : y++;
			}
			return false;
		}
		
		/**
		 * 判断两个格子之间的直线连线经过的路径中是否有不可通过的障碍点, 这两个格子位置没有特别的规律.
		 * @param dx 两个格子间的 x 轴距离.
		 * @param dy 两个格子间的 y 轴距离.
		 * @param node1 第一个格子.
		 * @param node2 第二个格子.
		 * @return 这两个格子之间的直线连线经过的路径中如果有不可通过的障碍点返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		private function otherHasObstacle(dx:int, dy:int, node1:AStarNode, node2:AStarNode):Boolean
		{
			//获取直线方程式的斜率及截距
			var k:Number = (node1.y - node2.y) / (node1.x - node2.x);
			var b:Number = node1.y - k * node1.x;
			//记录关键点是否纵向取
			var vertical:Boolean = dx < dy;
			//获取左右方向的节点
			var leftNode:AStarNode = node1.x > node2.x ? node2 : node1;
			var rightNode:AStarNode = node1.x > node2.x ? node1 : node2;
			//从左至右时格子的连线是否向上
			var up:Boolean = leftNode.y > rightNode.y ? true : false;
			//将距离扩大 1000 倍
			dx *= 1000;
			dy *= 1000;
			b *= 1000;
			//取得起始坐标及结束坐标, 根据横纵方向只使用一个轴, 使用方程式求另一个轴的值
			var startX:int = leftNode.x * 1000 + 500;
			var endX:int = startX + dx;
			var startY:int = up ? leftNode.y * 1000 - 500 : leftNode.y * 1000 + 500;
			var endY:int = up ? startY - dy : startY + dy;
			//记录当前获取的关键点坐标
			var x:int = startX;
			var y:int = startY;
			//循环判断
			while(true)
			{
				//取出每个关键点
				if(vertical)
				{
					x = int((y - b) / k);
				}
				else
				{
					y = int(k *x + b);
				}
				//根据坐标点取出每个相关的格子
				if(is4GridCenterPoint(x, y))
				{
					for(var i:int = int(x / 1000), iLen:int = i + 1; i <= iLen; i++)
					{
						for(var j:int = int(y / 1000), jLen:int = j + 1; j <= jLen; j++)
						{
							if(_grid.getNode(i, j) != _grid.startNode && _grid.getNode(i, j) != _grid.endNode && !_grid.getNode(i, j).walkable)
							{
								return true;
							}
						}
					}
				}
				else
				{
					if(vertical)
					{
						i = int((x + 500) / 1000);
						j = int(y / 1000);
						for(jLen = j + 1; j <= jLen; j++)
						{
							if(_grid.getNode(i, j) != _grid.startNode && _grid.getNode(i, j) != _grid.endNode && !_grid.getNode(i, j).walkable)
							{
								return true;
							}
						}
					}
					else
					{
						i = int(x / 1000);
						j = int((y + 500) / 1000);
						for(iLen = i + 1; i <= iLen; i++)
						{
							if(_grid.getNode(i, j) != _grid.startNode && _grid.getNode(i, j) != _grid.endNode && !_grid.getNode(i, j).walkable)
							{
								return true;
							}
						}
					}
				}
				//设置坐标为下一个关键点
				if(vertical)
				{
					if(up)
					{
						y -= 1000;
						if(y <= endY)
						{
							break;
						}
					}
					else
					{
						y += 1000;
						if(y >= endY)
						{
							break;
						}
					}
				}
				else
				{
					x += 1000;
					if(x >= endX)
					{
						break;
					}
				}
			}
			return false;
		}
		
		/**
		 * 判断一个坐标点是否为四个格子的中心点.
		 * @param x 需要判断的坐标点的 x 值.
		 * @param y 需要判断的坐标点的 y 值.
		 * @return 如果该坐标点是四个格子的中心点返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		private function is4GridCenterPoint(x:int, y:int):Boolean
		{
			if(x % 500 != 0 || y % 500 != 0)
			{
				return false;
			}
			if(x % 1000 != 500 || y %1000 != 500)
			{
				return false;
			}
			return true;
		}
	}
}
