// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.ds
{
	import flash.geom.Rectangle;
	
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>QuadTree</code> 类实现了四叉树.
	 * @author wizardc
	 */
	public class QuadTree
	{
		hammerc_internal var _topLeft:QuadTree;
		hammerc_internal var _topRight:QuadTree;
		hammerc_internal var _bottomLeft:QuadTree;
		hammerc_internal var _bottomRight:QuadTree;
		
		hammerc_internal var _rect:Rectangle;
		
		hammerc_internal var _depth:int;
		hammerc_internal var _maxDepth:int;
		
		hammerc_internal var _middleX:int;
		hammerc_internal var _middleY:int;
		hammerc_internal var _halfWidth:int;
		hammerc_internal var _halfHeight:int;
		
		hammerc_internal var _children:Array = new Array();
		
		/**
		 * 创建一个 <code>QuadTree</code> 对象.
		 * @param rect 此四叉树对象的范围.
		 * @param maxDepth 最大深度.
		 * @param currentDepth 当前深度.
		 */
		public function QuadTree(rect:Rectangle, maxDepth:int = 3, currentDepth:int = 0)
		{
			_rect = rect;
			_maxDepth = maxDepth;
			_depth = currentDepth;
			_halfWidth = _rect.width >> 1;
			_halfHeight = _rect.height >> 1;
			_middleX = _rect.x + _halfWidth;
			_middleY = _rect.y + _halfHeight;
		}
		
		/**
		 * 获取左上角的区域.
		 */
		public function get topLeft():QuadTree
		{
			return _topLeft;
		}
		
		/**
		 * 获取右上角的区域.
		 */
		public function get topRight():QuadTree
		{
			return _topRight;
		}
		
		/**
		 * 获取左下角的区域.
		 */
		public function get bottomLeft():QuadTree
		{
			return _bottomLeft;
		}
		
		/**
		 * 获取右下角的区域.
		 */
		public function get bottomRight():QuadTree
		{
			return _bottomRight;
		}
		
		/**
		 * 获取当前的区域.
		 */
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		/**
		 * 获取当前的深度.
		 */
		public function get depth():int
		{
			return _depth;
		}
		
		/**
		 * 获取最大的深度.
		 */
		public function get maxDepth():int
		{
			return _maxDepth;
		}
		
		/**
		 * 获取中心点 x 轴坐标.
		 */
		public function get middleX():int
		{
			return _middleX;
		}
		
		/**
		 * 获取中心点 y 轴坐标.
		 */
		public function get middleY():int
		{
			return _middleY;
		}
		
		/**
		 * 获取一半的宽度.
		 */
		public function get halfWidth():int
		{
			return _halfWidth;
		}
		
		/**
		 * 获取一半的高度.
		 */
		public function get halfHeight():int
		{
			return _halfHeight;
		}
		
		/**
		 * 获取包含在本区域的所有对象.
		 */
		public function get children():Array
		{
			return _children;
		}
		
		/**
		 * 插入一个对象.
		 * @param obj 要加入本四叉树的对象, 该对象必须有 <code>x</code>, <code>y</code>, <code>width</code>, <code>height</code> 这四个属性.
		 */
		public function insert(obj:*):void
		{
			//如果不能切分或者 obj 比整个区域还大, 就直接放到 children 中
			if(_depth >= _maxDepth || (obj.x <= _rect.x && obj.y <= _rect.y && obj.x + obj.width >= _rect.right && obj.y + obj.height >= _rect.bottom))
			{
				_children.push(obj);
				return;
			}
			//如果没有切分则开始切分为四个部分
			if(_topLeft == null)
			{
				var d:int = _depth + 1;
				_topLeft = new QuadTree(new Rectangle(_rect.x, _rect.y, _halfWidth, _halfHeight), _maxDepth, d);
				_topRight = new QuadTree(new Rectangle(_rect.x + _halfWidth, _rect.y, _halfWidth, _halfHeight), _maxDepth, d);
				_bottomLeft =new QuadTree(new Rectangle(_rect.x, _rect.y + _halfHeight, _halfWidth, _halfHeight), _maxDepth, d);
				_bottomRight= new QuadTree(new Rectangle(_rect.x + _halfWidth, _rect.y + _halfHeight, _halfWidth, _halfHeight), _maxDepth, d);
			}
			var objRight:Number = obj.x + obj.width;
			var objBottom:Number = obj.y + obj.height;
			//处理被分区完全包含的对象, 其不可能出现在其它分区所以加入后即退出运行
			if((obj.x > _rect.x) && (objRight < _middleX))
			{
				if(obj.y > _rect.y && objBottom < _middleY)
				{
					_topLeft.insert(obj);
					return;
				}
				if(obj.y > _middleY && objBottom < _rect.bottom)
				{
					_bottomLeft.insert(obj);
					return;
				}
			}
			if(obj.x > _middleX && objRight < _rect.right)
			{
				if(obj.y > _rect.y && objBottom < _middleY)
				{
					_topRight.insert(obj);
					return;
				}
				if(obj.y > _middleY && objBottom < _rect.bottom)
				{
					_bottomRight.insert(obj);
					return;
				}
			}
			//处理被分区部分包含的对象, 由于可以被其它分区部分包含, 所以每个分区都要判断一遍
			if(objBottom > _rect.y && obj.y < _middleY)
			{
				if(obj.x < _middleX && objRight > _rect.x)
				{
					_topLeft.insert(obj);
				}
				if( obj.x < _rect.right && objRight > _middleX)
				{
					_topRight.insert(obj);
				}
			}
			if(objBottom > _middleY && obj.y < _rect.bottom)
			{
				if(obj.x < _middleX && objRight > _rect.x)
				{
					_bottomLeft.insert(obj);
				}
				if(obj.x < _rect.right && objRight > _middleX)
				{
					_bottomRight.insert(obj);
				}
			}
		}
		
		/**
		 * 获取和指定对象位于同一区域的所有对象.
		 * @param obj 指定的对象.
		 */
		public function retrieve(obj:*):Array
		{
			var result:Array = new Array();
			//没有切分时就返回所有的子项
			if(_topLeft == null)
			{
				result.push.apply(result, _children);
				return result;
			}
			//如果所取区块比本身区域还大, 那么它所有子树的 children 都取出
			if(obj.x <= _rect.x && obj.y <= _rect.y && obj.x + obj.width >= _rect.right && obj.y + obj.height >= _rect.bottom)
			{
				result.push.apply(result, _children);
				result.push.apply(result, _topLeft.retrieve(obj));
				result.push.apply(result, _topRight.retrieve(obj));
				result.push.apply(result, _bottomLeft.retrieve(obj));
				result.push.apply(result, _bottomRight.retrieve(obj));
				return result;
			}
			//否则就只取对应的区域子树
			var objRight:Number = obj.x + obj.width;
			var objBottom:Number = obj.y + obj.height;
			//完全在分区里
			if((obj.x > _rect.x) && (objRight < _middleX))
			{
				if(obj.y > _rect.y && objBottom < _middleY)
				{
					result.push.apply(result, _topLeft.retrieve(obj));
					return result;
				}
				if(obj.y > _middleY && objBottom < _rect.bottom)
				{
					result.push.apply(result, _bottomLeft.retrieve(obj));
					return result;
				}
			}
			if(obj.x > _middleX && objRight < _rect.right)
			{
				if(obj.y > _rect.y && objBottom < _middleY)
				{
					result.push.apply(result, _topRight.retrieve(obj));
					return result;
				}
				if(obj.y > _middleY && objBottom < _rect.bottom)
				{
					result.push.apply(result, _bottomRight.retrieve(obj));
					return result;
				}
			}
			//部分在分区里
			if(objBottom > _rect.y && obj.y < _middleY)
			{
				if(obj.x < _middleX && objRight > _rect.x)
				{
					result.push.apply(result, _topLeft.retrieve(obj));
				}
				if(obj.x < _rect.right && objRight > _middleX)
				{
					result.push.apply(result, _topRight.retrieve(obj));
				}
			}
			if(objBottom > _middleY && obj.y < _rect.bottom)
			{
				if(obj.x < _middleX && objRight > _rect.x)
				{
					result.push.apply(result, _bottomLeft.retrieve(obj));
				}
				if(obj.x < _rect.right && objRight > _middleX)
				{
					result.push.apply(result, _bottomRight.retrieve(obj));
				}
			}
			return result;
		}
		
		/**
		 * 按左上, 右上, 左下, 右下的顺序处理每个四叉树对象.
		 * @param node 当前处理的四叉树对象.
		 * @param process 处理的回调方法, 如: <code>function(node:QuadTree):void{}</code>.
		 */
		public function preorder(node:QuadTree, process:Function):void
		{
			process(node);
			if(node._topLeft != null)
			{
				this.preorder(node._topLeft, process);
			}
			if(node._topRight != null)
			{
				this.preorder(node._topRight, process);
			}
			if(node._bottomLeft != null)
			{
				this.preorder(node._bottomLeft, process);
			}
			if(node._bottomRight != null)
			{
				this.preorder(node._bottomRight, process);
			}
		}
		
		/**
		 * 清空数据.
		 */
		public function clear():void
		{
			_topLeft = _topRight = _bottomLeft = _bottomRight = null;
			_children = new Array();
		}
		
		/**
		 * 获取本对象的详细内容说明.
		 * @return 详细内容说明字符串.
		 */
		public function dump():String
		{
			var s:String = "";
			this.preorder(this, function(node:QuadTree):void
			{
				var d:int = node._depth;
				for(var i:int = 0; i < d; i++)
				{
					if(i == d - 1)
					{
						s += "+---";
					}
					else
					{
						s += "|   ";
					}
				}
				s += node.toString() + "\n";
			});
			return s;
		}
		
		/**
		 * 获取本对象的字符串描述.
		 * @return 本对象的字符串描述.
		 */
		public function toString():String
		{
			var s:String = "[QuadTreeNode -> ";
			var l:int = this._children.length;
			s += l > 1 ? (l + " children") : (l + " child");
			return s + "]";
		}
	}
}
