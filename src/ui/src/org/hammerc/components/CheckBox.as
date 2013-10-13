/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import org.hammerc.components.supportClasses.ToggleButtonBase;
	
	/**
	 * <code>CheckBox</code> 类实现了复选框控件.
	 * @author wizardc
	 */
	public class CheckBox extends ToggleButtonBase
	{
		/**
		 * 创建一个 <code>CheckBox</code> 对象.
		 */
		public function CheckBox()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return CheckBox;
		}
	}
}
