// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt.base
{
	import org.hammerc.archer.bt.BehaviorTree;
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>CompositeNode</code> 类为抽象类, 定义了行为树的组合节点对象.
	 * @author wizardc
	 */
	public class CompositeNode extends BehaviorNode
	{
		/**
		* 子节点列表.
		*/
		protected var _childList:Vector.<BehaviorNode>;
		
		/**
		 * 创建子树的回调方法.
		 * <p>该节点的所有子节点都应该这个回调方法中创建, 这样可以实现子树复用, 如果是外部添加的子树克隆时则需要再新建一个手动添加.</p>
		 */
		protected var _createChildrenFunc:Function;
		
		private var _childMap:Object;
		
		/**
		 * 创建一个 <code>CompositeNode</code> 对象.
		 * @param createChildrenFunc 创建子树的回调方法.
		 * @param id ID.
		 */
		public function CompositeNode(createChildrenFunc:Function, id:String = null)
		{
			AbstractEnforcer.enforceConstructor(this, CompositeNode);
			super(id);
			_childList = new Vector.<BehaviorNode>();
			_childMap = new Object();
			_createChildrenFunc = createChildrenFunc;
			this._createChildrenFunc(this);
		}
		
		/**
		 * 获取本节点包含的子节点数量.
		 */
		public function get numChildren():int
		{
			return _childList.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function setTree(tree:BehaviorTree):void
		{
			super.setTree(tree);
			for(var i:int = 0, len:int = _childList.length; i < len; i++)
			{
				var child:BehaviorNode = _childList[i];
				child.setTree(tree);
			}
		}
		
		/**
		 * 添加子节点.
		 * @param child 子节点.
		 * @return 添加的子节点.
		 */
		public function addChild(child:BehaviorNode):BehaviorNode
		{
			if(this.containChild(child))
			{
				this.removeChild(child);
			}
			_childList.push(child);
			if(child.id != null && child.id != "")
			{
				_childMap[child.id] = child;
			}
			child.setTree(this.tree);
			child.setParent(this);
			return child;
		}
		
		/**
		 * 添加多个子节点.
		 * @param args 子节点数组.
		 */
		public function addChildren(...args):void
		{
			for(var i:int = 0; i < args.length; i++)
			{
				this.addChild(args[i]);
			}
		}
		
		/**
		 * 获取当前节点是否包含子节点.
		 * @param child 子节点.
		 * @return 当前节点是否包含子节点.
		 */
		public function containChild(child:BehaviorNode):Boolean
		{
			return _childList.indexOf(child) != -1;
		}
		
		/**
		 * 根据 ID 获取子节点.
		 * @param id ID.
		 * @return 子节点.
		 */
		public function getChildByID(id:String):BehaviorNode
		{
			return _childMap[id] as BehaviorNode;
		}
		
		/**
		 * 根据索引获取子节点.
		 * @param index 索引.
		 * @return 子节点.
		 */
		public function getChildByIndex(index:int):BehaviorNode
		{
			return _childList[index];
		}
		
		/**
		 * 获取子节点的索引.
		 * @param child 子节点.
		 * @return 子节点的索引.
		 */
		public function getChildAt(child:BehaviorNode):int
		{
			return _childList.indexOf(child);
		}
		
		/**
		 * 移除子节点.
		 * @param child 子节点.
		 * @return 移除后的子节点.
		 */
		public function removeChild(child:BehaviorNode):BehaviorNode
		{
			var index:int = _childList.indexOf(child);
			if(index == -1)
			{
				return null;
			}
			_childList.splice(index, 1);
			if(child.id != null && child.id != "")
			{
				delete _childMap[child.id];
			}
			child.setTree(null);
			child.setParent(null);
			return child;
		}
		
		/**
		 * 根据索引移除子节点.
		 * @param index 索引.
		 * @return 移除后的子节点.
		 */
		public function removeChildAt(index:int):BehaviorNode
		{
			return this.removeChild(this.getChildByIndex(index));
		}
		
		/**
		 * 移除所有子节点.
		 */
		public function removeAllChildren():void
		{
			while(_childList.length > 0)
			{
				this.removeChildAt(0);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function getTreeStructure(list:Vector.<String>, parent:String):void
		{
			if(parent.length > 0)
			{
				parent += "/";
			}
			parent += _id;
			for(var i:int = 0, len:int = _childList.length; i < len; i++)
			{
				_childList[i].getTreeStructure(list, parent);
			}
		}
	}
}
