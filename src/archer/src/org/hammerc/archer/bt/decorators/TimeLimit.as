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
		private var _resultSuccess:Boolean = false;
		
		/**
		 * 创建一个 <code>TimeLimit</code> 对象.
		 * @param id ID.
		 */
		public function TimeLimit(id:String = null)
		{
			super(id);
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
	}
}
