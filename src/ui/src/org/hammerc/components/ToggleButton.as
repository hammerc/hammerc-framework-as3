// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components
{
	import org.hammerc.components.supportClasses.ToggleButtonBase;
	
	/**
	 * <code>ToggleButton</code> 类实现了切换按钮控件.
	 * @author wizardc
	 */
	public class ToggleButton extends ToggleButtonBase
	{
		/**
		 * 创建一个 <code>ToggleButton</code> 对象.
		 */
		public function ToggleButton()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return ToggleButton;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "ToggleButton";
		}
	}
}
