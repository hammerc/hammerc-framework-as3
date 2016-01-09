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
	import flash.utils.getQualifiedClassName;
	
	import org.hammerc.archer.bt.BehaviorTree;
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>DecoratorNode</code> 类为抽象类, 定义了行为树的装饰节点对象.
	 * @author wizardc
	 */
	public class DecoratorNode extends BehaviorNode
	{
		/**
		 * 子节点.
		 */
		protected var _child:BehaviorNode;
		
		/**
		 * 创建子树的回调方法.
		 * <p>该节点子节点在这个方法中创建, 这样可以实现子树复用, 如果是外部添加的子树克隆时则需要再新建一个手动添加.</p>
		 */
		protected var _createChildFunc:Function;
		
		/**
		 * 创建一个 <code>DecoratorNode</code> 对象.
		 * @param createChildFunc 创建子树的回调方法.
		 * @param id ID.
		 */
		public function DecoratorNode(createChildFunc:Function, id:String = null)
		{
			AbstractEnforcer.enforceConstructor(this, CompositeNode);
			super(id);
			_createChildFunc = createChildFunc;
			this._createChildFunc(this);
		}
		
		/**
		 * 设置或获取子节点.
		 */
		public function set child(value:BehaviorNode):void
		{
			if(_child != value)
			{
				if(_child != null)
				{
					_child.setTree(null);
					_child.setParent(null);
				}
				_child = value;
				if(_child != null)
				{
					_child.setTree(this.tree);
					_child.setParent(this);
				}
			}
		}
		public function get child():BehaviorNode
		{
			return _child;
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function setTree(tree:BehaviorTree):void
		{
			super.setTree(tree);
			if(_child != null)
			{
				_child.setTree(tree);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function getTreeStructure(list:Vector.<String>, parent:String, showType:Boolean):void
		{
			if(parent.length > 0)
			{
				parent += "/";
			}
			parent += _id;
			list.push(parent + (showType ? "[" + getQualifiedClassName(this) + "]" : ""));
			_child.getTreeStructure(list, parent, showType);
		}
	}
}
