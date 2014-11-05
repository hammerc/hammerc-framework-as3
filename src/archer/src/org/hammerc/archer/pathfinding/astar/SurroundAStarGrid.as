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
	 * <code>SurroundAStarGrid</code> 类记录并描述一个需要被寻路的由多个格子组成的地图, 配合 <code>SurroundAStar</code> 类使用.
	 * @author wizardc
	 */
	public class SurroundAStarGrid extends AStarGrid
	{
		/**
		 * 创建一个 <code>SurroundAStarGrid</code> 对象.
		 * @param cols 设置地图的列数.
		 * @param rows 设置地图的行数.
		 */
		public function SurroundAStarGrid(cols:int, rows:int)
		{
			super(cols, rows);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createNode(x:int, y:int):AStarNode
		{
			return new SurroundAStarNode(x, y);
		}
		
		/**
		 * 清除地图的替换记录信息, 以便在该地图改变后仍可正常使用该类提供的新功能.
		 * <p>每当终点为不可通行的格子时都会计算距离该格子最近的一圈可用的所有格子. 出于复用的想法, 这些格子会被保存并关联该终点以便下次选择同样的终点时直接使用避免计算, 但这是出于地图里的格子保持不变的前提下使用的. 如果地图的格子发送改变应调用该方法清除这些保存下来的数据.</p>
		 */
		public function clearSurroundInfo():void
		{
			for each(var list:Vector.<SurroundAStarNode> in _grid)
			{
				for each(var value:SurroundAStarNode in list)
				{
					value._surroundNodes = null;
				}
			}
		}
	}
}
