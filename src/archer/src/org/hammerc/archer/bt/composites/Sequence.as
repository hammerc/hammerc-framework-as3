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
	 * <code>Sequence</code> 类定义了顺序节点.
	 * <p>该节点会从左到右的依次执行其子节点, 只要子节点返回 "成功", 就继续执行后面的节点, 直到有一个节点返回 "运行中" 或 "失败" 时, 会停止后续节点的运行, 并且向父节点返回 "运行中" 或 "失败", 如果所有子节点都返回 "成功" 则向父节点返回 "成功".</p>
	 * @author wizardc
	 */
	public class Sequence extends CompositeNode
	{
		private var _runningChild:BehaviorNode;
		private var _runningChildIndex:int = 0;
		
		/**
		 * 创建一个 <code>Sequence</code> 对象.
		 * @param createChildrenFunc 创建子树的回调方法.
		 * @param id ID.
		 */
		public function Sequence(createChildrenFunc:Function, id:String = null)
		{
			super(createChildrenFunc, id || "Sequence");
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
					//运行失败则直接告诉父节点运行失败
					case BehaviorStatus.FAILURE:
						_runningChild = null;
						return BehaviorStatus.FAILURE;
					//还在运行中则向父节点反馈还在运行中
					case BehaviorStatus.RUNNING:
						return BehaviorStatus.RUNNING;
					//成功则继续运行下一个节点
					case BehaviorStatus.SUCCESS:
						_runningChild = null;
						break;
				}
			}
			//遍历所有子节点
			for(var i:int = _runningChildIndex, len:int = _childList.length; i < len; i++)
			{
				var child:BehaviorNode = _childList[i];
				state = child.tick(time);
				switch(state)
				{
					//运行失败则直接告诉父节点运行失败
					case BehaviorStatus.FAILURE:
						return BehaviorStatus.FAILURE;
					//还在运行中则向父节点反馈还在运行中
					case BehaviorStatus.RUNNING:
						_runningChild = child;
						_runningChildIndex = i + 1;
						return BehaviorStatus.RUNNING;
					//成功则继续运行下一个节点
					case BehaviorStatus.SUCCESS:
						break;
				}
			}
			//运行到这里表示所有节点都运行成功
			return BehaviorStatus.SUCCESS;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function exit(success:Boolean):void
		{
			_runningChildIndex = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():BehaviorNode
		{
			return new Sequence(_createChildrenFunc, _id);
		}
	}
}
