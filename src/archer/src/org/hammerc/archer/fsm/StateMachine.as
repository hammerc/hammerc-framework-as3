/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.fsm
{
	/**
	 * <code>StateMachine</code> 类定义了一个状态机对象, 可以对一系列的状态进行控制.
	 * @author wizardc
	 */
	public class StateMachine
	{
		/**
		 * 记录当前的状态.
		 */
		protected var _currentState:IState;
		
		/**
		 * 记录状态机附带的数据.
		 */
		protected var _data:Object;
		
		/**
		 * 创建一个 <code>StateMachine</code> 对象.
		 */
		public function StateMachine()
		{
			this.init();
		}
		
		/**
		 * 当状态机初始化时回调.
		 */
		protected function init():void
		{
		}
		
		/**
		 * 设置或获取状态机附带的数据.
		 */
		public function set data(value:Object):void
		{
			_data = value;
		}
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 改变状态.
		 * @param name 要改变到的状态名称.
		 */
		public function changeState(state:IState):void
		{
			if(_currentState != null)
			{
				_currentState.exit(this);
			}
			_currentState = state;
			if(_currentState != null)
			{
				_currentState.enter(this);
			}
		}
		
		/**
		 * 执行当前的状态.
		 * @param args 传递给当前状态的参数.
		 */
		public function execute(...args):void
		{
			if(_currentState != null)
			{
				_currentState.execute.apply(_currentState, [this].concat(args));
			}
		}
	}
}
