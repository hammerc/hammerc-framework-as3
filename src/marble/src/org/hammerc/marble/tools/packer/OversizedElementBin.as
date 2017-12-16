// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.tools.packer
{
	/**
	 * <code>OversizedElementBin</code> 类定义了不能添加到图集中的图片区域对象.
	 * @author wizardc
	 */
	public class OversizedElementBin
	{
		/**
		 * 宽度.
		 */
		public var width:int;
		
		/**
		 * 高度.
		 */
		public var height:int;
		
		/**
		 * 自定义数据.
		 */
		public var data:Object;
		
		/**
		 * 创建一个 <code>OversizedElementBin</code> 对象.
		 * @param width 宽度.
		 * @param height 高度.
		 * @param data 自定义数据.
		 */
		public function OversizedElementBin(width:int, height:int, data:Object)
		{
			this.width = width;
			this.height = height;
			this.data = data;
		}
	}
}
