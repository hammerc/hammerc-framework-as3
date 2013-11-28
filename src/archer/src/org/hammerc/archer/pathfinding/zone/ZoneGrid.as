/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.pathfinding.zone
{
	import org.hammerc.archer.pathfinding.astar.AStarGrid;
	import org.hammerc.archer.pathfinding.astar.AStarNode;
	
	/**
	 * <code>ZoneGrid</code> 类定义了管理一个区域内的所有格子的对象.
	 * @author wizardc
	 */
	public class ZoneGrid extends AStarGrid
	{
		/**
		 * 记录该对象所在的房间对象.
		 */
		protected var _room:ZoneRoom;
		
		/**
		 * 创建一个 <code>ZoneGrid</code> 对象.
		 * @param room 设置该对象所在的房间对象.
		 * @param cols 设置地图的列数.
		 * @param rows 设置地图的行数.
		 */
		public function ZoneGrid(room:ZoneRoom, cols:int, rows:int)
		{
			super(cols, rows);
			_room = room;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createNode(x:int, y:int):AStarNode
		{
			return new ZoneNode(_room, x, y);
		}
		
		/**
		 * 设置地图中的一个指定的格子是否为路口.
		 * @param x 指定要设定的格子在地图上的第几列.
		 * @param y 指定要设定的格子在地图上的第几行.
		 * @param value 指定该格子是否为路口.
		 */
		public function setGate(x:int, y:int, value:Boolean):void
		{
			(_grid[x][y] as ZoneNode).isGate = value;
		}
	}
}
