/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.pathfinding.astar
{
	[ExcludeClass]
	
	/**
	 * <code>AStarLink</code> 类定义了一个格子可移动到的格子的关系.
	 * @author wizardc
	 */
	public class AStarLink
	{
		protected var _node:AStarNode;
		protected var _cost:Number;
		
		/**
		 * 创建一个 <code>AStarLink</code> 对象.
		 * @param node 格子对象.
		 * @param cost 移动的代价.
		 */
		public function AStarLink(node:AStarNode, cost:Number)
		{
			_node = node;
			_cost = cost;
		}
		
		/**
		 * 设置或获取格子对象.
		 */
		public function set node(value:AStarNode):void
		{
			_node = value;
		}
		public function get node():AStarNode
		{
			return _node;
		}
		
		/**
		 * 设置或获取移动的代价.
		 */
		public function set cost(value:Number):void
		{
			_cost = value;
		}
		public function get cost():Number
		{
			return _cost;
		}
	}
}
