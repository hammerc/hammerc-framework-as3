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
	import org.hammerc.archer.bt.BehaviorStatus;
	import org.hammerc.archer.bt.base.BehaviorNode;
	import org.hammerc.archer.bt.base.CompositeNode;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>Selector</code> 类定义了选择节点.
	 * <p>该节点会从左到右的依次执行其子节点, 只要子节点返回 "失败", 就继续执行后面的节点, 直到有一个节点返回 "运行中" 或 "成功" 时, 会停止后续节点的运行, 并且向父节点返回 "运行中" 或 "成功", 如果所有子节点都返回 "失败" 则向父节点返回 "失败".</p>
	 * @author wizardc
	 */
	public class Selector extends CompositeNode
	{
		private var _runningChild:BehaviorNode;
		private var _runningChildIndex:int = 0;
		
		/**
		 * 创建一个 <code>Selector</code> 对象.
		 * @param id ID.
		 */
		public function Selector(id:String = null)
		{
			super(id);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function execute(time:Number):int
		{
			var state:int;
			//继续执行运行中的节点
			if(_runningChild != null)
			{
				state = _runningChild.tick(time);
				switch(state)
				{
					//失败则继续运行下一个节点
					case BehaviorStatus.FAILURE:
						_runningChild = null;
						break;
					//还在运行中则向父节点反馈还在运行中
					case BehaviorStatus.RUNNING:
						return BehaviorStatus.RUNNING;
					//运行成功则直接告诉父节点运行成功
					case BehaviorStatus.SUCCESS:
						_runningChild = null;
						return BehaviorStatus.SUCCESS;
				}
			}
			//遍历所有子节点
			for(var i:int = _runningChildIndex, len:int = _childList.length; i < len; i++)
			{
				var child:BehaviorNode = _childList[i];
				state = child.tick(time);
				switch(state)
				{
					//失败则继续运行下一个节点
					case BehaviorStatus.FAILURE:
						break;
					//还在运行中则向父节点反馈还在运行中
					case BehaviorStatus.RUNNING:
						_runningChild = child;
						_runningChildIndex = i + 1;
						return BehaviorStatus.RUNNING;
					//运行成功则直接告诉父节点运行成功
					case BehaviorStatus.SUCCESS:
						return BehaviorStatus.SUCCESS;
				}
			}
			//运行到这里表示所有节点都运行失败
			return BehaviorStatus.FAILURE;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function exit(success:Boolean):void
		{
			_runningChildIndex = 0;
		}
	}
}
