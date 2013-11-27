/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.pathfinding.astar
{
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>SurroundAStarNode</code> 类定义了寻路地图的每一个格子的属性, 配合 <code>SurroundAStar</code> 类使用.
	 * @author wizardc
	 */
	public class SurroundAStarNode extends AStarNode
	{
		/**
		 * 记录在该格子为终点且不可通过时离该格子最近的周围可通过的格子的列表.
		 */
		hammerc_internal var _surroundNodes:Vector.<SurroundAStarNode>;
		
		/**
		 * 创建一个 <code>SurroundAStarNode</code> 对象.
		 * @param x 格子的 x 轴坐标.
		 * @param y 格子的 y 轴坐标.
		 * @param costMultiplier 格子的地形代价.
		 * @param walkable 格子是否可以通过.
		 */
		public function SurroundAStarNode(x:int, y:int, costMultiplier:Number = 1, walkable:Boolean = true)
		{
			super(x, y, costMultiplier, walkable);
		}
	}
}
