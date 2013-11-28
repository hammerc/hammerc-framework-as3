/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.pathfinding.zone
{
	import org.hammerc.archer.ds.BinaryHeaps;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ZoneAStar</code> 类提供了房间间寻路的功能.
	 * <p>注意: 本类仅能寻找到多个连接房间间每个房间的出口格子和入口格子的路径, 每个房间具体的路径请使用其他的寻路类进行寻路.</p>
	 * @author wizardc
	 */
	public class ZoneAStar
	{
		private var _zone:Zone;
		private var _startNode:ZoneNode;
		private var _endNode:ZoneNode;
		
		private var _binaryHeaps:BinaryHeaps;
		
		private var _path:Vector.<ZoneNode>;
		
		/**
		 * 创建一个 <code>ZoneAStar</code> 对象.
		 */
		public function ZoneAStar()
		{
			_binaryHeaps = new BinaryHeaps(compare);
		}
		
		private function compare(a:ZoneGate, b:ZoneGate):Number
		{
			return b._f - a._f;
		}
		
		/**
		 * 获取最优路径.
		 */
		public function get path():Vector.<ZoneNode>
		{
			return _path.concat();
		}
		
		/**
		 * 根据传入的地图获取一个最佳路径.
		 * @param zone 需要寻路的地图对象.
		 * @return 是否可以搜寻到该路径.
		 */
		public function findPath(zone:Zone):Boolean
		{
			if(_zone != null)
			{
				this.clear();
			}
			_zone = zone;
			_startNode = _zone.startNode;
			_endNode = _zone.endNode;
			_startNode._g = 0;
			_startNode._h = heuristic(_startNode, _endNode);
			_startNode._f = _startNode._g + _startNode._h;
			return this.search();
		}
		
		/**
		 * 开始对该地图进行搜索.
		 * @return 是否可以搜寻到该路径.
		 */
		protected function search():Boolean
		{
			//记录当前操作的房间
			var room:ZoneRoom = _startNode.room;
			//记录当前操作的路口对象
			var gate:ZoneGate;
			//循环处理
			while(room == _endNode.room)
			{
				//获取当前房间的所有路口对象
				var gates:Vector.<ZoneGate> = room._gates;
				//遍历所有路口对象
				for(var i:int = 0, len:int = gates.length; i <len; i++)
				{
					//获取需要检测的路口对象
					var test:ZoneGate = gates[i];
					//测试路口对象就是当前路口对象或者该路口对象的出入口格子不可走时跳过该格子的测试
					if(test == gate || !test._insideNode.walkable || !test._outsideNode.walkable)
					{
						continue;
					}
					//计算出相应的成本
					var g:Number = (gate == null ? 0 : gate._g);
					if(gate == null)
					{
						g = heuristic(_startNode, test._insideNode);
					}
					else
					{
						g = heuristic(gate._outsideNode, test._insideNode);
					}
					var h:Number = heuristic(test._insideNode, _endNode);
					var f:Number = g + h;
					//设置成本，如果新的成本小于老的成本则需要进行更新
					if(test._checked)
					{
						if(test._f > f)
						{
							test._g = g;
							test._h = h;
							test._f = f;
							test._parent = gate;
						}
					}
					else
					{
						test._g = g;
						test._h = h;
						test._f = f;
						test._parent = gate;
						_binaryHeaps.enqueue(test);
						test._checked = true;
					}
				}
				//记录已经检测
				gate._checked = true;
				//当待查列表为空时则说明没有找到路径
				if(_binaryHeaps.length == 0)
				{
					return false;
				}
				//取出最小代价的路口作为当前路口进行检测
				gate = _binaryHeaps.dequeue() as ZoneGate;
				//取出下一个房间作为当前房间进行检测
				room = gate._outsideNode.room;
			}
			//获取路径
			buildPath(gate);
			//清除检查标记
			_zone.resetChecked();
			return true;
		}
		
		/**
		 * 启发函数.
		 * @param node1 第一个节点.
		 * @param node2 第二个节点.
		 * @return 两个节点移动的代价.
		 */
		public function heuristic(node1:ZoneNode, node2:ZoneNode):Number
		{
			var dx:int = node1.x > node2.x ? node1.x - node2.x : node2.x - node1.x;
			var dy:int = node1.y > node2.y ? node1.y - node2.y : node2.y - node1.y;
			return dx * dx + dy * dy;
		}
		
		/**
		 * 取出最优路径.
		 * @param gate 寻路得到的最后一个路口对象.
		 */
		private function buildPath(gate:ZoneGate):void
		{
			var gates:Vector.<ZoneGate> = new Vector.<ZoneGate>();
			while(gate != null)
			{
				gates.push(gate);
				gate = gate._parent;
			}
			_path = new Vector.<ZoneNode>();
			gate = gates.pop();
			while(gate != null)
			{
				_path.push(gate._insideNode, gate._outsideNode);
				gate = gates.pop();
			}
		}
		
		/**
		 * 清空所有数据.
		 */
		public function clear():void
		{
			_zone = null;
			_startNode = null;
			_endNode = null;
			_binaryHeaps.clear();
			_path = null;
		}
	}
}
