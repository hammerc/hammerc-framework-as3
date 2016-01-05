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
	 * <code>BehaviorTree</code> 类定义了行为树对象.
	 * @author wizardc
	 */
	public class BehaviorTree
	{
		private var _root:BehaviorNode;
		private var _data:Object;
		
		/**
		 * 创建一个 <code>BehaviorTree</code> 对象.
		 */
		public function BehaviorTree()
		{
		}
		
		/**
		 * 设置或获取根节点.
		 */
		public function set root(value:BehaviorNode):void
		{
			if(_root != value)
			{
				if(_root != null)
				{
					_root.setTree(null);
					_root.setParent(null);
				}
				_root = value;
				if(_root != null)
				{
					_root.setTree(this);
					_root.setParent(_root);
				}
			}
		}
		public function get root():BehaviorNode
		{
			return _root;
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
		 * 执行行为树.
		 * @param time 和上次执行间隔的时间, 单位为秒.
		 * @return 执行状态.
		 */
		public function execute(time:Number):int
		{
			if(_root != null)
			{
				return _root.tick(time);
			}
			return BehaviorStatus.FAILURE;
		}
		
		/**
		 * 根据 ID 获取对应的节点.
		 * @param path 由多个节点名称组合而成的路径, 用 "/" 符号分隔.
		 * @return 对应的节点.
		 */
		public function getNodeByID(path:String):BehaviorNode
		{
			return null;
		}
		
		/**
		 * 获取该树的结构描述.
		 * @return 所有节点的路径数组.
		 */
		public function getTreeStructure():Vector.<String>
		{
			return null;
		}
	}
}
