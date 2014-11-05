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
	import org.hammerc.components.supportClasses.ButtonBase;
	
	/**
	 * <code>Button</code> 类实现了按钮控件.
	 * @author wizardc
	 */
	public class Button extends ButtonBase
	{
		/**
		 * 创建一个 <code>Button</code> 对象.
		 */
		public function Button()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Button;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "Button";
		}
	}
}
