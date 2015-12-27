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
		
		private var _root:BehaviorNode;
		private var _parent:BehaviorNode;
		
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
		 * 获取根节点.
		 */
		public function get root():BehaviorNode
		{
			return _root;
		}
		
		/**
		 * 获取父节点.
		 */
		public function get parent():BehaviorNode
		{
			return _parent;
		}
		
		/**
		 * 设置根节点.
		 * @param root 根节点.
		 */
		hammerc_internal function setRoot(root:BehaviorNode):void
		{
			_root = root;
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
		 * 进入该节点时调用该方法.
		 */
		public function enter():void
		{
		}
		
		/**
		 * 执行该节点.
		 * @param time 和上次执行间隔的时间, 单位为秒.
		 * @return 执行状态.
		 */
		public function execute(time:Number):int
		{
			return BehaviorStatus.FAILURE;
		}
		
		/**
		 * 离开该节点时调用该方法.
		 */
		public function exit():void
		{
		}
	}
}
