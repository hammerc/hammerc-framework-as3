/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.pathfinding.zone
{
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>Zone</code> 类管理多个房间, 这些房间添加到本类后会自动连接可通过的房间.
	 * <ul>注意: 
	 *   <li>相互连接的房间之间不能重合和远离, 必须紧靠且路口必须在最外沿的四边上, 路口和路口之间需要紧靠;</li>
	 *   <li>由于路口之间寻路的局限性, 部分情况会出现选路口时走出非最短路径的情况, 针对该情况房间之间设计时应避免路口过多和房间过于复杂的情况;</li>
	 * </ul>
	 * @author wizardc
	 */
	public class Zone
	{
		/**
		 * 记录所有的房间.
		 */
		protected var _rooms:Vector.<ZoneRoom>;
		
		/**
		 * 记录起点格子.
		 */
		protected var _startNode:ZoneNode;
		
		/**
		 * 记录终点格子.
		 */
		protected var _endNode:ZoneNode;
		
		/**
		 * 创建一个 <code>Zone</code> 对象.
		 * @param rooms 设置多个房间对象.
		 */
		public function Zone(rooms:Vector.<ZoneRoom> = null)
		{
			if(rooms != null)
			{
				this.rooms = rooms;
			}
			else
			{
				_rooms = new Vector.<ZoneRoom>();
			}
		}
		
		/**
		 * 设置或获取当前管理的多个房间对象.
		 */
		public function set rooms(value:Vector.<ZoneRoom>):void
		{
			for each(var room:ZoneRoom in _rooms)
			{
				room._gates.length = 0;
			}
			_rooms.length = 0;
			for each(room in value)
			{
				this.addRoom(room);
			}
		}
		public function get rooms():Vector.<ZoneRoom>
		{
			return _rooms;
		}
		
		/**
		 * 设置或获取寻路的起点格子.
		 */
		public function set startNode(value:ZoneNode):void
		{
			_startNode = value;
		}
		public function get startNode():ZoneNode
		{
			return _startNode;
		}
		
		/**
		 * 设置或获取寻路的终点格子.
		 */
		public function set endNode(value:ZoneNode):void
		{
			_endNode = value;
		}
		public function get endNode():ZoneNode
		{
			return _endNode;
		}
		
		/**
		 * 获取一个格子对象.
		 * @param x 该格子在地图上的第几列.
		 * @param y 该格子在地图上的第几行.
		 * @return 对应坐标上的格子对象, 不存在返回 null.
		 */
		public function getNode(x:int, y:int):ZoneNode
		{
			for each(var room:ZoneRoom in _rooms)
			{
				if(room.x <= x && room.x + room.grid.cols > x && room.y <= y && room.y + room.grid.rows > y)
				{
					return room.grid.getNode(x - room.x, y - room.y) as ZoneNode;
				}
			}
			return null;
		}
		
		/**
		 * 设置寻路起点.
		 * @param x 设置起点格子在地图上的第几列.
		 * @param y 设置起点格子在地图上的第几行.
		 */
		public function setStartNode(x:int, y:int):void
		{
			_startNode = this.getNode(x, y);
		}
		
		/**
		 * 设置寻路终点.
		 * @param x 设置终点格子在地图上的第几列.
		 * @param y 设置终点格子在地图上的第几行.
		 */
		public function setEndNode(x:int, y:int):void
		{
			_endNode = this.getNode(x, y);
		}
		
		/**
		 * 添加一个房间并连接该房间.
		 * @param room 要添加的房间.
		 * @return 添加后的房间.
		 */
		public function addRoom(room:ZoneRoom):ZoneRoom
		{
			if(room._gates.length > 0)
			{
				room._gates.length = 0;
			}
			var i:int, j:int, len:int = _rooms.length;
			var nowRoom:ZoneRoom, testRoom:ZoneRoom;
			for(i = 0; i < 2; i++)
			{
				for(j = 0; j < len; j++)
				{
					testRoom = _rooms[j];
					if(nearby(room, testRoom))
					{
						nowRoom = (i == 0 ? testRoom : room);
						if(room.x + room.grid.cols == testRoom.x)
						{
							checkGateByHorizontal(nowRoom, room, testRoom);
						}
						else if(testRoom.x + testRoom.grid.cols == room.x)
						{
							checkGateByHorizontal(nowRoom, testRoom, room);
						}
						else if(room.y + room.grid.rows == testRoom.y)
						{
							checkGateByVertical(nowRoom, room, testRoom);
						}
						else if(testRoom.y + testRoom.grid.rows == room.y)
						{
							checkGateByVertical(nowRoom, testRoom, room);
						}
					}
				}
			}
			_rooms.push(room);
			return room;
		}
		
		/**
		 * 判断两个房间是否相互毗邻.
		 * @param room1 第一个房间对象.
		 * @param room2 第二个房间对象.
		 * @return 两个房间相互毗邻返回 true, 否则返回 false.
		 */
		private function nearby(room1:ZoneRoom, room2:ZoneRoom):Boolean
		{
			if((room1.x + room1.grid.cols < room2.x) || (room2.x + room2.grid.cols < room1.x))
			{
				return false;
			}
			if((room1.y + room1.grid.rows < room2.y) || (room2.y + room2.grid.rows < room1.y))
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 检测水平方向的两个房间的路口是否连接.
		 * @param nowRoom 需要添加路口对象的房间对象.
		 * @param leftRoom 位于左方的房间对象.
		 * @param rightRoom 位于右方的房间对象.
		 */
		private function checkGateByHorizontal(nowRoom:ZoneRoom, leftRoom:ZoneRoom, rightRoom:ZoneRoom):void
		{
			for(var i:int = 0; i < leftRoom.grid.rows; i++)
			{
				var rightGateRow:int = leftRoom.y - rightRoom.y + i;
				if(rightGateRow >= 0 && rightGateRow < rightRoom.grid.rows)
				{
					var leftNode:ZoneNode = leftRoom.grid.getNode(leftRoom.grid.cols - 1, i) as ZoneNode;
					var rightNode:ZoneNode = rightRoom.grid.getNode(0, rightGateRow) as ZoneNode;
					if(!leftNode.isGate || !rightNode.isGate)
					{
						continue;
					}
					var gate:ZoneGate;
					if(nowRoom == leftRoom)
					{
						gate = new ZoneGate(leftNode, rightNode);
					}
					else
					{
						gate = new ZoneGate(rightNode, leftNode);
					}
					nowRoom._gates.push(gate);
				}
			}
		}
		
		/**
		 * 检测垂直方向的两个房间的路口是否连接.
		 * @param nowRoom 需要添加路口对象的房间对象.
		 * @param topRoom 位于上方的房间对象.
		 * @param bottomRoom 位于下方的房间对象.
		 */
		private function checkGateByVertical(nowRoom:ZoneRoom, topRoom:ZoneRoom, bottomRoom:ZoneRoom):void
		{
			for(var i:int = 0; i < topRoom.grid.cols; i++)
			{
				var bottomGateCol:int = topRoom.x - bottomRoom.x + i;
				if(bottomGateCol >= 0 && bottomGateCol < bottomRoom.grid.cols)
				{
					var topNode:ZoneNode = topRoom.grid.getNode(i, topRoom.grid.rows - 1) as ZoneNode;
					var bottomNode:ZoneNode = bottomRoom.grid.getNode(bottomGateCol, 0) as ZoneNode;
					if(!topNode.isGate || !bottomNode.isGate)
					{
						continue;
					}
					var gate:ZoneGate;
					if(nowRoom == topRoom)
					{
						gate = new ZoneGate(topNode, bottomNode);
					}
					else
					{
						gate = new ZoneGate(bottomNode, topNode);
					}
					nowRoom._gates.push(gate);
				}
			}
		}
		
		/**
		 * 判断一个房间是否被添加到该对象中.
		 * @param room 需要判断的房间.
		 * @return 该房间已经被添加返回 true, 否则返回 false.
		 */
		public function hasZone(room:ZoneRoom):Boolean
		{
			if(_rooms.indexOf(room) != -1)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 移除一个已经添加的房间对象.
		 * @param room 要移除的房间对象.
		 * @return 移除的房间对象.
		 */
		public function removeZone(room:ZoneRoom):ZoneRoom
		{
			var index:int = _rooms.indexOf(room);
			if(index == -1)
			{
				return room;
			}
			_rooms.splice(index, 1);
			room._gates.length = 0;
			for(var i:int = 0, len:int = _rooms.length; i < len; i++)
			{
				var testRoom:ZoneRoom = _rooms[i];
				if(nearby(room, testRoom))
				{
					for(var j:int = 0; j < testRoom._gates.length; j++)
					{
						var gate:ZoneGate = testRoom._gates[j];
						if(gate._outsideNode.room == room)
						{
							testRoom._gates.splice(j, 1);
							j--;
						}
					}
				}
			}
			return room;
		}
		
		/**
		 * 还原所有路口对象为都未检查过.
		 */
		hammerc_internal function resetChecked():void
		{
			for each(var value:ZoneRoom in _rooms)
			{
				value.resetChecked();
			}
		}
	}
}
