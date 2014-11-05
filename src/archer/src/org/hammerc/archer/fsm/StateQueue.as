// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.fsm
{
	/**
	 * <code>StateQueue</code> 类定义了能顺序执行的状态.
	 * @author wizardc
	 */
	public class StateQueue extends State
	{
		/**
		 * 记录内部状态列表.
		 */
		protected var _stateList:Vector.<IState>;
		
		/**
		 * 当前执行的状态索引.
		 */
		protected var _currentIndex:int;
		
		/**
		 * 创建一个 <code>StateQueue</code> 对象.
		 */
		public function StateQueue()
		{
			_stateList = new Vector.<IState>();
		}
		
		/**
		 * 添加一个子状态.
		 * @param state 要添加的子状态对象.
		 */
		public function addSubState(state:IState):void
		{
			_stateList.push(state);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function enter(stateMachine:StateMachine):void
		{
			super.enter(stateMachine);
			_currentIndex = 0;
			if(_currentIndex < _stateList.length)
			{
				_stateList[_currentIndex].enter(stateMachine);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function execute(stateMachine:StateMachine, ...args):int
		{
			if(_state == PROGRESS)
			{
				if(_currentIndex < _stateList.length)
				{
					var state:IState = _stateList[_currentIndex];
					if(state.execute.apply(null, [stateMachine].concat(args)) == COMPLETE)
					{
						state.exit(stateMachine);
						_currentIndex++;
						if(_currentIndex < _stateList.length)
						{
							_stateList[_currentIndex].enter(stateMachine);
						}
						else
						{
							_state = COMPLETE;
						}
					}
				}
				else
				{
					_state = COMPLETE;
				}
			}
			return _state;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function exit(stateMachine:StateMachine):void
		{
			super.exit(stateMachine);
			this.clear();
		}
		
		/**
		 * 清除状态队列对象.
		 */
		public function clear():void
		{
			_state = INVALID;
			_stateList.length = 0;
			_currentIndex = 0;
		}
	}
}
