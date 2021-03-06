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
	 * <code>Timer</code> 类定义了延时指定时间才开始运行的装饰节点.
	 * @author wizardc
	 */
	public class Timer extends DecoratorNode
	{
		private var _nowTime:Number;
		private var _delayTime:Number;
		
		/**
		 * 创建一个 <code>Timer</code> 对象.
		 * @param id ID.
		 * @param delayTime 延时, 单位为秒.
		 * @param child 子节点.
		 */
		public function Timer(id:String = null, delayTime:Number = 1, child:BehaviorNode = null)
		{
			super(id || "Timer", child);
			_delayTime = delayTime;
		}
		
		/**
		 * 设置或获取延时, 单位为秒.
		 */
		public function set delayTime(value:Number):void
		{
			_delayTime = value;
		}
		public function get delayTime():Number
		{
			return _delayTime;
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
			if(_nowTime >= _delayTime)
			{
				return _child.tick(time);
			}
			_nowTime += time;
			return BehaviorStatus.RUNNING;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createSelf():DecoratorNode
		{
			return new Timer(_id, _delayTime);
		}
	}
}
