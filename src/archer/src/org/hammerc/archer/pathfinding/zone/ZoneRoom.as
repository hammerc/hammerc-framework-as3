// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.pathfinding.zone
{
	import org.hammerc.archer.pathfinding.astar.AStarNode;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ZoneRoom</code> 类定义了一个房间对象.
	 * @author wizardc
	 */
	public class ZoneRoom
	{
		/**
		 * 记录该房间对象的 x 轴坐标.
		 */
		protected var _x:int;
		
		/**
		 * 记录该房间对象的 y 轴坐标.
		 */
		protected var _y:int;
		
		/**
		 * 记录该房间的所有格子对象.
		 */
		protected var _grid:ZoneGrid;
		
		/**
		 * 记录该房间内的所有路口对象.
		 */
		hammerc_internal var _gates:Vector.<ZoneGate>;
		
		/**
		 * 创建一个 <code>ZoneRoom</code> 对象.
		 * @param x 设置该房间的 x 轴坐标.
		 * @param y 设置该房间的 y 轴坐标.
		 * @param cols 设置该房间的列数.
		 * @param rows 设置该房间的行数.
		 */
		public function ZoneRoom(x:int, y:int, cols:int, rows:int)
		{
			_x = x;
			_y = y;
			_grid = new ZoneGrid(this, cols, rows);
			_gates = new Vector.<ZoneGate>();
		}
		
		/**
		 * 设置或获取该房间的 x 轴坐标.
		 */
		public function set x(value:int):void
		{
			_x = value;
		}
		public function get x():int
		{
			return _x;
		}
		
		/**
		 * 设置或获取该房间的 y 轴坐标.
		 */
		public function set y(value:int):void
		{
			_y = value;
		}
		public function get y():int
		{
			return _y;
		}
		
		/**
		 * 获取该房间的所有格子对象.
		 */
		public function get grid():ZoneGrid
		{
			return _grid;
		}
		
		/**
		 * 还原所有路口对象为都未检查过.
		 */
		hammerc_internal function resetChecked():void
		{
			for each(var value:ZoneGate in _gates)
			{
				value._checked = false;
			}
		}
	}
}
