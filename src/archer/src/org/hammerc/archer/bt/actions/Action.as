// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt.actions
{
	import org.hammerc.archer.bt.base.BehaviorNode;
	
	/**
	 * <code>Action</code> 类定义了动作节点.
	 * <p>行为节点用来完成具体的操作.</p>
	 * @author wizardc
	 */
	public class Action extends BehaviorNode
	{
		/**
		 * 创建一个 <code>Action</code> 对象.
		 * @param id ID.
		 */
		public function Action(id:String = null)
		{
			super(id);
		}
	}
}
