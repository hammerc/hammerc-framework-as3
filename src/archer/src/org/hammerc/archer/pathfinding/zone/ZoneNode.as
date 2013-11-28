/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.pathfinding.zone
{
	import org.hammerc.archer.pathfinding.astar.AStarNode;
	
	/**
	 * <code>ZoneNode</code> 类定义了一个房间内的格子的属性.
	 * @author wizardc
	 */
	public class ZoneNode extends AStarNode
	{
		/**
		 * 记录该格子所在的房间对象.
		 */
		protected var _room:ZoneRoom;
		
		/**
		 * 记录该格子是否为和其它房间联通的进出口.
		 */
		protected var _isGate:Boolean = false;
		
		/**
		 * 创建一个 <code>ZoneNode</code> 对象.
		 * @param room 格子所在的房间对象.
		 * @param x 格子的 x 轴坐标, 相对于所在的房间.
		 * @param y 格子的 y 轴坐标, 相对于所在的房间.
		 * @param isGate 该格子是否为和其它房间联通的进出口.
		 * @param costMultiplier 格子的地形代价.
		 * @param walkable 格子是否可以通过.
		 */
		public function ZoneNode(room:ZoneRoom, x:int, y:int, isGate:Boolean = false, costMultiplier:Number = 1, walkable:Boolean = true)
		{
			super(x, y, costMultiplier, walkable);
			_room = room;
			_isGate = isGate;
		}
		
		/**
		 * 设置或获取该格子所在的房间对象.
		 */
		public function set room(value:ZoneRoom):void
		{
			_room = value;
		}
		public function get room():ZoneRoom
		{
			return _room;
		}
		
		/**
		 * 设置或获取该格子是否为和其它房间联通的进出口.
		 */
		public function set isGate(value:Boolean):void
		{
			_isGate = value;
		}
		public function get isGate():Boolean
		{
			return _isGate;
		}
	}
}
