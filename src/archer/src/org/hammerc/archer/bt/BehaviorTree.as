// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt
{
	import org.hammerc.archer.bt.base.BehaviorNode;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>BehaviorTree</code> 类定义了行为树的根节点对象.
	 * @author wizardc
	 */
	public class BehaviorTree extends BehaviorNode
	{
		private var _child:BehaviorNode;
		private var _data:Object;
		
		/**
		 * 创建一个 <code>BehaviorTree</code> 对象.
		 * @param id ID.
		 */
		public function BehaviorTree(id:String = null)
		{
			super(id);
			this.setRoot(this);
		}
		
		/**
		 * 设置或获取子节点.
		 */
		public function set child(value:BehaviorNode):void
		{
			if(_child != value)
			{
				if(_child != null)
				{
					_child.setRoot(null);
					_child.setParent(null);
				}
				_child = value;
				if(_child != null)
				{
					_child.setRoot(this);
					_child.setParent(this);
				}
			}
		}
		public function get child():BehaviorNode
		{
			return _child;
		}
		
		/**
		 * 设置或获取行为树全局自定义数据.
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
		 * @inheritDoc
		 */
		override public function execute(time:Number):int
		{
			if(_child != null)
			{
				return _child.execute(time);
			}
			return BehaviorStatus.FAILURE;
		}
	}
}
