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
	 * <code>IState</code> 接口定义了一个状态的基本属性及方法.
	 * @author wizardc
	 */
	public interface IState
	{
		/**
		 * 获取该状态的状态.
		 */
		function get state():int;
		
		/**
		 * 当进入该状态时回调.
		 * @param stateMachine 执行该状态的状态机对象.
		 */
		function enter(stateMachine:StateMachine):void;
		
		/**
		 * 执行该状态.
		 * @param stateMachine 执行该状态的状态机对象.
		 * @param args 传递给本状态的参数.
		 * @return 当前状态的状态.
		 */
		function execute(stateMachine:StateMachine, ...args):int;
		
		/**
		 * 当退出该状态时回调.
		 * @param stateMachine 执行该状态的状态机对象.
		 */
		function exit(stateMachine:StateMachine):void;
	}
}
