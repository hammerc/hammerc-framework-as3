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
	 * <code>State</code> 类实现了一个基本的状态.
	 * @author wizardc
	 */
	public class State implements IState
	{
		/**
		 * 状态未处理.
		 */
		public static const INVALID:int = 0;
		
		/**
		 * 状态处理中.
		 */
		public static const PROGRESS:int = 1;
		
		/**
		 * 状态处理完成.
		 */
		public static const COMPLETE:int = 2;
		
		/**
		 * 记录状态的状态.
		 */
		protected var _state:int;
		
		/**
		 * 本类为抽象类不能被实例化.
		 */
		public function State()
		{
			_state = INVALID;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get state():int
		{
			return _state;
		}
		
		/**
		 * @inheritDoc
		 */
		public function enter(stateMachine:StateMachine):void
		{
			_state = PROGRESS;
		}
		
		/**
		 * @inheritDoc
		 */
		public function execute(stateMachine:StateMachine, ...args):int
		{
			return _state;
		}
		
		/**
		 * @inheritDoc
		 */
		public function exit(stateMachine:StateMachine):void
		{
			_state = COMPLETE;
		}
	}
}
