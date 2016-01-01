// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.bt.base
{
	import org.hammerc.archer.bt.BehaviorStatus;
	import org.hammerc.archer.bt.BehaviorTree;
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>BehaviorNode</code> 类为抽象类, 定义了行为树的基础节点对象.
	 * @author wizardc
	 */
	public class BehaviorNode
	{
		private var _id:String;
		
		private var _tree:BehaviorTree;
		private var _parent:BehaviorNode;
		
		private var _running:Boolean = false;
		
		/**
		 * 创建一个 <code>BehaviorNode</code> 对象.
		 * @param id ID.
		 */
		public function BehaviorNode(id:String = null)
		{
			AbstractEnforcer.enforceConstructor(this, BehaviorNode);
			_id = id;
		}
		
		/**
		 * 获取本对象的 ID.
		 */
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * 获取该节点所属的行为树.
		 */
		public function get tree():BehaviorTree
		{
			return _tree;
		}
		
		/**
		 * 获取父节点.
		 */
		public function get parent():BehaviorNode
		{
			return _parent;
		}
		
		/**
		 * 设置该节点所属的行为树.
		 * @param tree 该节点所属的行为树.
		 */
		hammerc_internal function setTree(tree:BehaviorTree):void
		{
			_tree = tree;
		}
		
		/**
		 * 设置父节点.
		 * @param parent 父节点.
		 */
		hammerc_internal function setParent(parent:BehaviorNode):void
		{
			_parent = parent;
		}
		
		/**
		 * 执行该节点, 由父节点调用.
		 * @param time 和上次执行间隔的时间, 单位为秒.
		 * @return 执行状态.
		 */
		hammerc_internal final function tick(time:Number):int
		{
			if(!_running)
			{
				_running = true;
				this.enter();
			}
			var state:int = this.execute(time);
			if(state != BehaviorStatus.RUNNING)
			{
				_running = false;
				this.exit(state == BehaviorStatus.SUCCESS);
			}
			return state;
		}
		
		/**
		 * 进入该节点时调用该方法.
		 */
		protected function enter():void
		{
		}
		
		/**
		 * 执行该节点.
		 * @param time 和上次执行间隔的时间, 单位为秒.
		 * @return 执行状态.
		 */
		protected function execute(time:Number):int
		{
			return BehaviorStatus.FAILURE;
		}
		
		/**
		 * 离开该节点时调用该方法.
		 * @param success 该节点是否执行成功.
		 */
		protected function exit(success:Boolean):void
		{
		}
	}
}
