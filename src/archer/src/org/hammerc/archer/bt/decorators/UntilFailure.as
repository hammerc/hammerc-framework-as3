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
	 * <code>UntilFailure</code> 类定义了直到子节点失败才返回成功的装饰节点.
	 * @author wizardc
	 */
	public class UntilFailure extends DecoratorNode
	{
		/**
		 * 创建一个 <code>UntilFailure</code> 对象.
		 * @param createChildFunc 创建子树的回调方法.
		 * @param id ID.
		 */
		public function UntilFailure(createChildFunc:Function, id:String = null)
		{
			super(createChildFunc, id || "UntilFailure");
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
			return BehaviorStatus.RUNNING;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():BehaviorNode
		{
			return new UntilFailure(_createChildFunc, _id);
		}
	}
}
