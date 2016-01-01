// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt.composites
{
	import org.hammerc.archer.bt.base.BehaviorNode;
	
	/**
	 * <code>RandomSelector</code> 类定义了随机选择节点.
	 * <p>随机选择节点的执行顺序是随机的. 但每个节点只会执行一次, 比如包含子节点: A, B, C, D, E; 使用随机选择节点, 执行顺序可能是: D, E, A, C, B或其他组合. 其它规则同选择节点一致.</p>
	 * @author wizardc
	 */
	public class RandomSelector extends Selector
	{
		/**
		 * 创建一个 <code>RandomSelector</code> 对象.
		 * @param id ID.
		 */
		public function RandomSelector(id:String = null)
		{
			super(id);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function enter():void
		{
			//随机打乱数组
			for(var i:int = 0, len:int = _childList.length; i < len; i++)
			{
				var index:int = int(Math.random() * len);
				var obj:BehaviorNode = _childList[i];
				_childList[i] = _childList[index];
				_childList[index] = obj;
			}
		}
	}
}
