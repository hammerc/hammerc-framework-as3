/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * <code>DisplayUtil</code> 类提供各种显示对象的操作.
	 * @author wizardc
	 */
	public class DisplayUtil
	{
		/**
		 * 移除显示容器对象的所有子对象.
		 * @param container 要被移除所有子对象的显示容器对象.
		 * @param clearShape 如果可以释放清除所有的图形对象.
		 */
		public static function removeChildren(container:DisplayObjectContainer, clearShape:Boolean = true):void
		{
			if(container != null)
			{
				while(container.numChildren)
				{
					container.removeChildAt(0);
				}
				if(clearShape)
				{
					if(container is Sprite)
					{
						(container as Sprite).graphics.clear();
					}
				}
			}
		}
		
		/**
		 * 添加一个子对象到另一个对象之后.
		 * @param child 要添加的子对象.
		 * @param target 指定的参照的对象.
		 * @return 添加后的子对象.
		 */
		public static function addChildAfter(child:DisplayObject, target:DisplayObject):DisplayObject
		{
			return target.parent.addChildAt(child, target.parent.getChildIndex(target) + 1);
		}
		
		/**
		 * 添加一个子对象到另一个对象之前.
		 * @param child 要添加的子对象.
		 * @param target 指定的参照的对象.
		 * @return 添加后的子对象.
		 */
		public static function addChildBefore(child:DisplayObject, target:DisplayObject):DisplayObject
		{
			return target.parent.addChildAt(child, target.parent.getChildIndex(target));
		}
		
		/**
		 * 设置一个显示对象置顶.
		 * @param target 要置顶的对象.
		 * @return 置顶后的对象.
		 */
		public static function toTop(target:DisplayObject):DisplayObject
		{
			target.parent.setChildIndex(target, target.parent.numChildren - 1);
			return target;
		}
		
		/**
		 * 设置一个显示对象置底.
		 * @param target 要置底的对象.
		 * @return 置底后的对象.
		 */
		public static function toBottom(target:DisplayObject):DisplayObject
		{
			target.parent.setChildIndex(target, 0);
			return target;
		}
		
		/**
		 * 判断一个显示对象是否在一个容器对象中.
		 * @param container 容器对象.
		 * @param target 显示对象.
		 * @return 指定的显示对象是否在容器对象中.
		 */
		public static function inContainer(container:DisplayObjectContainer, target:DisplayObject):Boolean
		{
			var current:DisplayObjectContainer = target.parent;
			while(current != null && current.parent != current)
			{
				if(current == container)
				{
					return true;
				}
				current = current.parent;
			}
			return false;
		}
		
		/**
		 * 对指定容器中的每一个显示对象都进行指定的操作.
		 * @param container 容器对象.
		 * @param operation 进行操作的方法, 接收两个参数, 第一个为当前操作的显示对象, 第二个为该显示对象的深度索引.
		 * @param onlyChildren 是否仅处理子层, 如果为假则会处理所有位于该容器中的显示对象.
		 */
		public static function each(container:DisplayObjectContainer, operation:Function, onlyChildren:Boolean = true):void
		{
			for(var i:int = 0, len:int = container.numChildren; i < len; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				operation.call(null, child, i);
				if(!onlyChildren && child is DisplayObjectContainer)
				{
					each(child as DisplayObjectContainer, operation, false);
				}
			}
		}
		
		/**
		 * 按顺序排列一个容器显示对象中的所有子容器.
		 * @param container 要排列子容器的容器对象.
		 * @param sortFields 进行排序的子容器字段或用于排序的函数.
		 * @param descending 是否使用降序排序.
		 */
		public static function sortChildren(container:DisplayObjectContainer, sortFields:* = null, descending:Boolean = false):void
		{
			if(sortFields == null)
			{
				sortFields = ["y"];
			}
			if(sortFields is String)
			{
				sortFields = [sortFields];
			}
			var children:Array = new Array();
			for(var i:int = 0, len:int = container.numChildren; i < len; i++)
			{
				children.push(container.getChildAt(i));
			}
			var option:uint = Array.NUMERIC | Array.RETURNINDEXEDARRAY;
			if(descending)
			{
				option |= Array.DESCENDING;
			}
			var sortIndexs:Array;
			if(sortFields is Array)
			{
				sortIndexs = children.sortOn(sortFields, option);
			}
			else if(sortFields is Function)
			{
				sortIndexs = children.sort(sortFields, option);
			}
			else
			{
				return;
			}
			for(i = 0, len = sortIndexs.length; i < len; i++)
			{
				var child:DisplayObject = children[sortIndexs[i]] as DisplayObject;
				container.setChildIndex(child, i);
			}
		}
		
		/**
		 * 获取指定显示对象中特定点下方的所有显示对象.
		 * <p>由于 FlashPlayer 自带的 <code>DisplayObjectContainer.getObjectsUnderPoint()</code> 方法检测的是上一帧渲染时的显示列表的状态, 所以这里实现能获取到实时显示列表的方法.</p>
		 * @param target 需要获取指定点下方显示列表的显示对象.
		 * @param point 舞台坐标空间中指定的点.
		 * @param displayList 存放指定点下方的所有显示对象的列表, 按嵌套深度从低到高排序, 如果存在显示对象则第一个对象为指定的显示对象.
		 */
		public static function getObjectsUnderPoint(target:DisplayObject, point:Point, displayList:Vector.<DisplayObject>):void
		{
			if(!target.visible)
			{
				return;
			}
			if(target.hitTestPoint(point.x, point.y, true))
			{
				if(target is InteractiveObject && (target as InteractiveObject).mouseEnabled)
				{
					displayList.push(target);
				}
				if(target is DisplayObjectContainer)
				{
					var container:DisplayObjectContainer = target as DisplayObjectContainer;
					if(container.mouseChildren && container.numChildren > 0)
					{
						var num:int = container.numChildren;
						for(var i:int = 0; i < num; i++)
						{
							getObjectsUnderPoint(container.getChildAt(i), point, displayList);
						}
					}
				}
			}
		}
	}
}
