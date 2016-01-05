// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt.decorators
{
	import org.hammerc.archer.bt.BehaviorStatus;
	import org.hammerc.archer.bt.base.BehaviorNode;
	import org.hammerc.archer.bt.base.DecoratorNode;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>Invert</code> 类定义了对子节点的返回结果取非的装饰节点.
	 * @author wizardc
	 */
	public class Invert extends DecoratorNode
	{
		/**
		 * 创建一个 <code>Invert</code> 对象.
		 * @param createChildFunc 创建子树的回调方法.
		 * @param id ID.
		 */
		public function Invert(createChildFunc:Function, id:String = null)
		{
			super(createChildFunc, id);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function execute(time:Number):int
		{
			var state:int = _child.tick(time);
			if(state == BehaviorStatus.FAILURE)
			{
				return BehaviorStatus.SUCCESS;
			}
			else if(state == BehaviorStatus.SUCCESS)
			{
				return BehaviorStatus.FAILURE;
			}
			return BehaviorStatus.RUNNING;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():BehaviorNode
		{
			return new Invert(_createChildFunc, _id);
		}
	}
}
