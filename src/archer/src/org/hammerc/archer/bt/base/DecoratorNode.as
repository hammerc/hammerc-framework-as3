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
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>DecoratorNode</code> 类为抽象类, 定义了行为树的装饰节点对象.
	 * @author wizardc
	 */
	public class DecoratorNode extends BehaviorNode
	{
		private var _child:BehaviorNode;
		
		/**
		 * 创建一个 <code>DecoratorNode</code> 对象.
		 * @param id ID.
		 */
		public function DecoratorNode(id:String = null)
		{
			AbstractEnforcer.enforceConstructor(this, CompositeNode);
			super(id);
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
					_child.setRoot(null);
					_child.setParent(null);
				}
				_child = value;
				if(_child != null)
				{
					_child.setRoot(this);
					_child.setParent(this);
				}
			}
		}
		public function get child():BehaviorNode
		{
			return _child;
		}
	}
}
