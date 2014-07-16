/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.pathfinding.astar
{
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>AStarNode</code> 类定义了寻路地图的每一个格子的属性.
	 * @author wizardc
	 */
	public class AStarNode
	{
		/**
		 * 该格子的 x 轴坐标.
		 */
		public var x:int;
		
		/**
		 * 该格子的 y 轴坐标.
		 */
		public var y:int;
		
		/**
		 * 该格子是否可以通过.
		 */
		public var walkable:Boolean;
		
		/**
		 * 该格子的地形代价.
		 */
		public var costMultiplier:int;
		
		/**
		 * 记录该格子的总代价.
		 */
		hammerc_internal var _f:int;
		
		/**
		 * 记录该格子到相邻格子的代价.
		 */
		hammerc_internal var _g:int;
		
		/**
		 * 记录该格子到目标格子的代价.
		 */
		hammerc_internal var _h:int;
		
		/**
		 * 记录该格子的上一层格子.
		 */
		hammerc_internal var _parent:AStarNode;
		
		/**
		 * 记录该格子是否已经被检查过.
		 */
		hammerc_internal var _checkNum:int = 0;
		
		/**
		 * 记录该格子周围的格子及移动的代价.
		 */
		hammerc_internal var _aroundLinks:Vector.<AStarLink>;
		
		/**
		 * 创建一个 <code>AStarNode</code> 对象.
		 * @param x 格子的 x 轴坐标.
		 * @param y 格子的 y 轴坐标.
		 * @param walkable 格子是否可以通过.
		 * @param costMultiplier 格子的地形代价.
		 */
		public function AStarNode(x:int, y:int, walkable:Boolean = true, costMultiplier:int = 1)
		{
			this.x = x;
			this.y = y;
			this.walkable = walkable;
			this.costMultiplier = costMultiplier;
		}
	}
}
