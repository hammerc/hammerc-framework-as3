// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.pathfinding.zone
{
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	[ExcludeClass]
	
	/**
	 * <code>ZoneGate</code> 类定义了房间和房间之间联通的进出口对象.
	 * @author wizardc
	 */
	public class ZoneGate
	{
		/**
		 * 记录该路口的总代价.
		 */
		hammerc_internal var _f:Number;
		
		/**
		 * 记录该路口到同区域下个路口的代价.
		 */
		hammerc_internal var _g:Number;
		
		/**
		 * 记录该路口到目标路口的代价.
		 */
		hammerc_internal var _h:Number;
		
		/**
		 * 记录该路口的上一层路口.
		 */
		hammerc_internal var _parent:ZoneGate;
		
		/**
		 * 记录该格子是否已经被检查过.
		 */
		hammerc_internal var _checked:Boolean = false;
		
		/**
		 * 记录该路口区域内的格子.
		 */
		hammerc_internal var _insideNode:ZoneNode;
		
		/**
		 * 记录该路口区域外的格子.
		 */
		hammerc_internal var _outsideNode:ZoneNode;
		
		/**
		 * 创建一个 <code>ZoneGate</code> 对象.
		 * @param insideNode 设置该路口区域内的格子.
		 * @param outsideNode 设置该路口区域外的格子.
		 */
		public function ZoneGate(insideNode:ZoneNode, outsideNode:ZoneNode)
		{
			_insideNode = insideNode;
			_outsideNode = outsideNode;
		}
	}
}
