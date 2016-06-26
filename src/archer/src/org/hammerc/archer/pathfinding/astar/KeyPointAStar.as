// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.pathfinding.astar
{
	/**
	 * <code>KeyPointAStar</code> 类基于 <code>AStar</code> 类实现, 添加了获取关键点路径的功能.
	 * <p><b>注意: </b>该类得到的路径中如果属于同一条直线的路径则仅保留直线的两个端点, 每个格子对象按直线作为路径, 格子对象都出现在需要拐角处.</p>
	 * @author wizardc
	 */
	public class KeyPointAStar extends AStar
	{
		/**
		 * 创建一个 <code>SmoothAStar</code> 对象.
		 * @param heuristic 应用的启发函数, 为空则使用曼哈顿启发函数.
		 */
		public function KeyPointAStar(heuristic:Function = null)
		{
			super(heuristic);
		}
		
		/**
		 * 获取关键点路径.
		 */
		public function get keyPointPath():Vector.<AStarNode>
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
	}
}
