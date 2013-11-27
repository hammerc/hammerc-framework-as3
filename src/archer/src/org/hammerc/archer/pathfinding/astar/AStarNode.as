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
		protected var _x:int;
		protected var _y:int;
		
		protected var _costMultiplier:Number;
		protected var _walkable:Boolean;
		
		/**
		 * 记录该格子的总代价.
		 */
		hammerc_internal var _f:Number;
		
		/**
		 * 记录该格子到相邻格子的代价.
		 */
		hammerc_internal var _g:Number;
		
		/**
		 * 记录该格子到目标格子的代价.
		 */
		hammerc_internal var _h:Number;
		
		/**
		 * 记录该格子的上一层格子.
		 */
		hammerc_internal var _parent:AStarNode;
		
		/**
		 * 记录该格子是否已经被检查过.
		 */
		hammerc_internal var _checked:Boolean = false;
		
		/**
		 * 记录该格子周围的格子及移动的代价.
		 */
		hammerc_internal var _aroundLinks:Vector.<AStarLink>;
		
		/**
		 * 创建一个 <code>AStarNode</code> 对象.
		 * @param x 格子的 x 轴坐标.
		 * @param y 格子的 y 轴坐标.
		 * @param costMultiplier 格子的地形代价.
		 * @param walkable 格子是否可以通过.
		 */
		public function AStarNode(x:int, y:int, costMultiplier:Number = 1, walkable:Boolean = true)
		{
			_x = x;
			_y = y;
			_costMultiplier = costMultiplier;
			_walkable = walkable;
		}
		
		/**
		 * 设置或获取该格子的 x 轴坐标.
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
		 * 设置或获取该格子的 y 轴坐标.
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
		 * 设置或获取该格子的地形代价, 使用高级地形时有效.
		 * <p>该代价越高则说明通过该格子越困难, 寻路算法会寻找一条代价总和最低的路径.</p>
		 */
		public function set costMultiplier(value:Number):void
		{
			if(isNaN(value))
			{
				value = 1;
			}
			_costMultiplier = value;
		}
		public function get costMultiplier():Number
		{
			return _costMultiplier;
		}
		
		/**
		 * 设置或获取该格子是否可以通过.
		 */
		public function set walkable(value:Boolean):void
		{
			_walkable = value;
		}
		public function get walkable():Boolean
		{
			return _walkable;
		}
	}
}
