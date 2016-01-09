// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt.decorators
{
	import org.hammerc.archer.bt.BehaviorStatus;
	import org.hammerc.archer.bt.base.BehaviorNode;
	import org.hammerc.archer.bt.base.DecoratorNode;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TimeLimit</code> 类定义了运行指定时间后强制退出的装饰节点.
	 * @author wizardc
	 */
	public class TimeLimit extends DecoratorNode
	{
		private var _nowTime:Number;
		private var _maxTime:Number;
		private var _resultSuccess:Boolean;
		
		/**
		 * 创建一个 <code>TimeLimit</code> 对象.
		 * @param createChildFunc 创建子树的回调方法.
		 * @param id ID.
		 * @param maxTime 最大运行时间, 单位为秒.
		 * @param resultSuccess 超过限制后是否返回成功.
		 */
		public function TimeLimit(createChildFunc:Function, id:String = null, maxTime:Number = 1, resultSuccess:Boolean = false)
		{
			super(createChildFunc, id || "TimeLimit");
			_maxTime = maxTime;
			_resultSuccess = resultSuccess;
		}
		
		/**
		 * 设置或获取最大运行时间, 单位为秒.
		 */
		public function set maxTime(value:Number):void
		{
			_maxTime = value;
		}
		public function get maxTime():Number
		{
			return _maxTime;
		}
		
		/**
		 * 设置或获取超过限制后是否返回成功.
		 */
		public function set resultSuccess(value:Boolean):void
		{
			_resultSuccess = value;
		}
		public function get resultSuccess():Boolean
		{
			return _resultSuccess;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function enter():void
		{
			_nowTime = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function execute(time:Number):int
		{
			if(_nowTime >= _maxTime)
			{
				return _resultSuccess ? BehaviorStatus.SUCCESS : BehaviorStatus.FAILURE;
			}
			_nowTime += time;
			return _child.tick(time);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():BehaviorNode
		{
			return new TimeLimit(_createChildFunc, _id);
		}
	}
}
