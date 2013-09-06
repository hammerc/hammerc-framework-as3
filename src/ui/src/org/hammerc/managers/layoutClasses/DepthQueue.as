/**
 * Copyright (c) 2012 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers.layoutClasses
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.hammerc.managers.ILayoutManagerClient;
	
	/**
	 * <code>DepthQueue</code> 类管理显示列表嵌套深度排序队列.
	 * @author wizardc
	 */
	public class DepthQueue
	{
		/**
		 * 记录深度对象的数组.
		 */
		private var _depthBins:Array = new Array();
		
		/**
		 * 记录最小深度.
		 */
		private var _minDepth:int = 0;
		
		/**
		 * 记录最大深度.
		 */
		private var _maxDepth:int = -1;
		
		/**
		 * 创建一个 <code>DepthQueue</code> 对象.
		 */
		public function DepthQueue()
		{
			super();
		}
		
		/**
		 * 插入一个元素.
		 * @param client 要插入的元素.
		 */
		public function insert(client:ILayoutManagerClient):void
		{
			var depth:int = client.nestLevel;
			if(_maxDepth < _minDepth)
			{
				_minDepth = _maxDepth = depth;
			}
			else
			{
				if(depth < _minDepth)
				{
					_minDepth = depth;
				}
				if(depth > _maxDepth)
				{
					_maxDepth = depth;
				}
			}
			var bin:DepthBin = _depthBins[depth];
			if(bin == null)
			{
				bin = new DepthBin();
				_depthBins[depth] = bin;
				bin.items[client] = true;
				bin.length++;
			}
			else
			{
				if(bin.items[client] == null)
				{
					bin.items[client] = true;
					bin.length++;
				}
			}
		}
		
		/**
		 * 从队列尾弹出深度最大的一个对象.
		 * @return 深度最大的对象.
		 */
		public function pop():ILayoutManagerClient
		{
			var client:ILayoutManagerClient = null;
			if(_minDepth <= _maxDepth)
			{
				var bin:DepthBin = _depthBins[_maxDepth];
				//取出深度最大的对象
				while(bin == null || bin.length == 0)
				{
					_maxDepth--;
					if(_maxDepth < _minDepth)
					{
						return null;
					}
					bin = _depthBins[_maxDepth];
				}
				//取出最大深度中的一个显示对象
				for(var key:Object in bin.items)
				{
					client = key as ILayoutManagerClient;
					this.remove(client, _maxDepth);
					break;
				}
				//更新当前最大深度
				while(bin == null || bin.length == 0)
				{
					_maxDepth--;
					if(_maxDepth < _minDepth)
					{
						break;
					}
					bin = _depthBins[_maxDepth];
				}
			}
			return client;
		}
		
		/**
		 * 从队列首弹出深度最小的一个对象.
		 * @return 深度最小的对象.
		 */
		public function shift():ILayoutManagerClient
		{
			var client:ILayoutManagerClient = null;
			if (_minDepth <= _maxDepth)
			{
				var bin:DepthBin = _depthBins[_minDepth];
				//取出深度最小的对象
				while(bin == null || bin.length == 0)
				{
					_minDepth++;
					if(_minDepth > _maxDepth)
					{
						return null;
					}
					bin = _depthBins[_minDepth];
				}
				//取出最小深度中的一个显示对象
				for(var key:Object in bin.items)
				{
					client = key as ILayoutManagerClient;
					this.remove(client, _minDepth);
					break;
				}
				//更新当前最小深度
				while(bin == null || bin.length == 0)
				{
					_minDepth++;
					if(_minDepth > _maxDepth)
					{
						break;
					}
					bin = _depthBins[_minDepth];
				}
			}
			return client;
		}
		
		/**
		 * 移除大于等于指定组件层级的元素中最大的元素.
		 * @param client 指定组件.
		 * @return 大于等于指定组件层级的元素中最大的元素.
		 */
		public function removeLargestChild(client:ILayoutManagerClient):Object
		{
			var max:int = _maxDepth;
			var min:int = client.nestLevel;
			while(min <= max)
			{
				var bin:DepthBin = _depthBins[max];
				if(bin != null && bin.length > 0)
				{
					if(max == client.nestLevel)
					{
						if(bin.items[client] != null)
						{
							this.remove(ILayoutManagerClient(client), max);
							return client;
						}
					}
					else
					{
						for(var key:Object in bin.items)
						{
							if((key is DisplayObject) && (client is DisplayObjectContainer) && (client as DisplayObjectContainer).contains(DisplayObject(key)))
							{
								this.remove(ILayoutManagerClient(key), max);
								return key;
							}
						}
					}
					max--;
				}
				else
				{
					if(max == _maxDepth)
					{
						_maxDepth--;
					}
					max--;
					if(max < min)
					{
						break;
					}
				}
			}
			return null;
		}
		
		/**
		 * 移除大于等于指定组件层级的元素中最小的元素.
		 * @param client 指定组件.
		 * @return 大于等于指定组件层级的元素中最小的元素.
		 */
		public function removeSmallestChild(client:ILayoutManagerClient):Object
		{
			var min:int = client.nestLevel;
			while(min <= _maxDepth)
			{
				var bin:DepthBin = _depthBins[min];
				if(bin != null && bin.length > 0)
				{
					if(min == client.nestLevel)
					{
						if(bin.items[client])
						{
							this.remove(ILayoutManagerClient(client), min);
							return client;
						}
					}
					else
					{
						for(var key:Object in bin.items)
						{
							if((key is DisplayObject) && (client is DisplayObjectContainer) && (client as DisplayObjectContainer).contains(DisplayObject(key)))
							{
								this.remove(ILayoutManagerClient(key), min);
								return key;
							}
						}
					}
					min++;
				}
				else
				{
					if(min == _minDepth)
					{
						_minDepth++;
					}
					min++;
					if(min > _maxDepth)
					{
						break;
					}
				}
			}
			return null;
		}
		
		/**
		 * 移除一个元素.
		 * @param client 要移除的元素.
		 * @param level 指定该元素所在的深度.
		 * @return 移除的元素.
		 */
		public function remove(client:ILayoutManagerClient, level:int = -1):ILayoutManagerClient
		{
			var depth:int = (level >= 0) ? level : client.nestLevel;
			var bin:DepthBin = _depthBins[depth];
			if(bin != null && bin.items[client] != null)
			{
				delete bin.items[client];
				bin.length--;
				return client;
			}
			return null;
		}
		
		/**
		 * 清空队列.
		 */
		public function removeAll():void
		{
			_depthBins.length = 0;
			_minDepth = 0;
			_maxDepth = -1;
		}
		
		/**
		 * 队列是否为空.
		 * @return 队列是否为空.
		 */
		public function isEmpty():Boolean
		{
			return _minDepth > _maxDepth;
		}
	}
}

import flash.utils.Dictionary;

/**
 * <code>DepthBin</code> 类记录一个列表项的数据.
 * @author wizardc
 */
class DepthBin
{
	/**
	 * 包含的对象个数.
	 */
	public var length:int;
	
	/**
	 * 本深度的所有对象的哈希表.
	 */
	public var items:Dictionary = new Dictionary();
	
	/**
	 * 创建一个 <code>DepthBin</code> 对象.
	 */
	public function DepthBin()
	{
		super();
	}
}
