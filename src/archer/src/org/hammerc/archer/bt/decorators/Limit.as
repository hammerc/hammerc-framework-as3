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
	 * <code>Limit</code> 类定义了运行指定次数后强制退出的装饰节点.
	 * @author wizardc
	 */
	public class Limit extends DecoratorNode
	{
		private var _nowCount:int;
		private var _maxCount:int;
		private var _resultSuccess:Boolean;
		
		/**
		 * 创建一个 <code>Limit</code> 对象.
		 * @param id ID.
		 * @param maxCount 最大运行次数.
		 * @param resultSuccess 超过限制后是否返回成功.
		 * @param child 子节点.
		 */
		public function Limit(id:String = null, maxCount:int = 1, resultSuccess:Boolean = false, child:BehaviorNode = null)
		{
			super(id || "Limit", child);
			_maxCount = maxCount;
			_resultSuccess = resultSuccess;
		}
		
		/**
		 * 设置或获取最大运行次数.
		 */
		public function set maxCount(value:int):void
		{
			_maxCount = value;
		}
		public function get maxCount():int
		{
			return _maxCount;
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
			_nowCount = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function execute(time:Number):int
		{
			if(_nowCount >= _maxCount)
			{
				return _resultSuccess ? BehaviorStatus.SUCCESS : BehaviorStatus.FAILURE;
			}
			++_nowCount;
			return _child.tick(time);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createSelf():DecoratorNode
		{
			return new Limit(_id, _maxCount, _resultSuccess);
		}
	}
}
