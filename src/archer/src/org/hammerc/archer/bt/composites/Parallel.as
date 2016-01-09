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
	 * <code>Parallel</code> 类定义了并行节点.
	 * <p>并行节点 "同时" 执行所有的节点, 然后根据所有节点的返回值判断最终返回的结果.</p>
	 * @author wizardc
	 */
	public class Parallel extends CompositeNode
	{
		private var _failurePolicy:int;
		private var _successPolicy:int;
		private var _childFinishPolicy:int;
		
		private var _status:Object;
		private var _completeCount:int;
		
		/**
		 * 创建一个 <code>Parallel</code> 对象.
		 * @param id ID.
		 * @param failurePolicy 返回失败的策略.
		 * @param successPolicy 返回成功的策略.
		 * @param childFinishPolicy 子节点结束运行的策略.
		 */
		public function Parallel(id:String = null, failurePolicy:int = ParallelFailurePolicy.ONE, successPolicy:int = ParallelSuccessPolicy.ONE, childFinishPolicy:int = ParallelChildFinishPolicy.ONCE)
		{
			super(id || "Parallel");
			_failurePolicy = failurePolicy;
			_successPolicy = successPolicy;
			_childFinishPolicy = childFinishPolicy;
		}
		
		/**
		 * 设置或获取并行节点返回失败的策略.
		 */
		public function set failurePolicy(value:int):void
		{
			_failurePolicy = value;
		}
		public function get failurePolicy():int
		{
			return _failurePolicy;
		}
		
		/**
		 * 设置或获取并行节点返回成功的策略.
		 */
		public function set successPolicy(value:int):void
		{
			_successPolicy = value;
		}
		public function get successPolicy():int
		{
			return _successPolicy;
		}
		
		/**
		 * 设置或获取子节点结束运行的策略.
		 */
		public function set childFinishPolicy(value:int):void
		{
			_childFinishPolicy = value;
		}
		public function get childFinishPolicy():int
		{
			return _childFinishPolicy;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function enter():void
		{
			_status = {};
			_completeCount = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function execute(time:Number):int
		{
			for(var i:int = 0, len:int = _childList.length; i < len; i++)
			{
				var node:BehaviorNode = _childList[i];
				//子节点只运行一次并且也运行结束就不再运行了
				if(_childFinishPolicy == ParallelChildFinishPolicy.ONCE && _status.hasOwnProperty(i))
				{
					continue;
				}
				var state:int = node.tick(time);
				switch(state)
				{
					case BehaviorStatus.FAILURE:
						//标记是否完成
						if(!_status.hasOwnProperty(i))
						{
							++_completeCount;
						}
						_status[i] = BehaviorStatus.FAILURE;
						//返回判断
						if(_failurePolicy == ParallelFailurePolicy.ONE)
						{
							return BehaviorStatus.FAILURE;
						}
						break;
					case BehaviorStatus.RUNNING:
						//子节点可以循环同时子节点以及结束过则需要将子节点设置为没有结束的状态
						if(_childFinishPolicy == ParallelChildFinishPolicy.LOOP && _status.hasOwnProperty(i))
						{
							delete _status[i];
							--_completeCount;
						}
						break;
					case BehaviorStatus.SUCCESS:
						//标记是否完成
						if(!_status.hasOwnProperty(i))
						{
							++_completeCount;
						}
						_status[i] = BehaviorStatus.SUCCESS;
						//返回判断
						if(_successPolicy == ParallelSuccessPolicy.ONE)
						{
							return BehaviorStatus.SUCCESS;
						}
						break;
				}
			}
			//所有节点都执行完毕
			if(_completeCount == _childList.length)
			{
				var allStatus:int = getAllChildStatus();
				//子节点返回值不统一返回失败
				if(allStatus == -1)
				{
					return BehaviorStatus.FAILURE;
				}
				//子节点全部返回失败且满足失败策略
				if(allStatus == BehaviorStatus.FAILURE && _failurePolicy == ParallelFailurePolicy.ALL)
				{
					return BehaviorStatus.FAILURE;
				}
				//子节点全部返回成功且满足成功策略
				if(allStatus == BehaviorStatus.SUCCESS && _successPolicy == ParallelSuccessPolicy.ALL)
				{
					return BehaviorStatus.SUCCESS;
				}
			}
			//子节点还在运行中则返回运行中
			return BehaviorStatus.RUNNING;
		}
		
		private function getAllChildStatus():int
		{
			var firstState:int = _status[0];
			for(var i:int = i, len:int = _childList.length; i < len; i++)
			{
				var state:int = _status[i];
				if(firstState != state)
				{
					return -1;
				}
			}
			return firstState;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function exit(success:Boolean):void
		{
			_status = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createSelf():CompositeNode
		{
			return new Parallel(_id, _failurePolicy, _successPolicy, _childFinishPolicy);
		}
	}
}
