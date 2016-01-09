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
		 * @param id ID.
		 * @param child 子节点.
		 */
		public function UntilFailure(id:String = null, child:BehaviorNode = null)
		{
			super(id || "UntilFailure", child);
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
		override protected function createSelf():DecoratorNode
		{
			return new UntilFailure(_id);
		}
	}
}
