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
	[ExcludeClass]
	
	/**
	 * <code>AStarLink</code> 类定义了一个格子可移动到的格子的关系.
	 * @author wizardc
	 */
	public class AStarLink
	{
		/**
		 * 格子对象.
		 */
		public var node:AStarNode;
		
		/**
		 * 移动的代价.
		 */
		public var cost:int;
		
		/**
		 * 创建一个 <code>AStarLink</code> 对象.
		 * @param node 格子对象.
		 * @param cost 移动的代价.
		 */
		public function AStarLink(node:AStarNode, cost:int)
		{
			this.node = node;
			this.cost = cost;
		}
	}
}
