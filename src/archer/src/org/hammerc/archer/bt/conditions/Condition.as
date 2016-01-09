// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt.conditions
{
	import org.hammerc.archer.bt.BehaviorStatus;
	import org.hammerc.archer.bt.base.BehaviorNode;
	import org.hammerc.core.AbstractEnforcer;
	
	/**
	 * <code>Condition</code> 类为抽象类, 定义了条件节点.
	 * <p>条件节点用于进行条件判断.</p>
	 * @author wizardc
	 */
	public class Condition extends BehaviorNode
	{
		/**
		 * 创建一个 <code>Condition</code> 对象.
		 * @param id ID.
		 */
		public function Condition(id:String = null)
		{
			AbstractEnforcer.enforceConstructor(this, Condition);
			super(id || "Condition");
		}
		
		/**
		 * @inheritDoc
		 */
		override protected final function execute(time:Number):int
		{
			return this.checkCondition() ? BehaviorStatus.SUCCESS : BehaviorStatus.FAILURE;
		}
		
		/**
		 * 检测条件是否满足.
		 * @return 条件是否满足.
		 */
		protected function checkCondition():Boolean
		{
			AbstractEnforcer.enforceMethod();
			return false;
		}
	}
}
