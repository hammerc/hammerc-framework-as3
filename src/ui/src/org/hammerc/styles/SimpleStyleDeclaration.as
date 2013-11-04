/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.styles
{
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>SimpleStyleDeclaration</code> 类定义了一个简单的样式描述对象.
	 * @author wizardc
	 */
	public class SimpleStyleDeclaration
	{
		hammerc_internal var _declaration:Object;
		
		/**
		 * 创建一个 <code>SimpleStyleDeclaration</code> 对象.
		 */
		public function SimpleStyleDeclaration()
		{
			_declaration = new Object();
		}
		
		/**
		 * 设置样式的一个属性.
		 * @param styleProp 样式属性的名称.
		 * @param newValue 样式的新值.
		 */
		public function setStyle(styleProp:String, newValue:*):void
		{
			_declaration[styleProp] = newValue;
		}
		
		/**
		 * 获取样式的一个属性.
		 * @param styleProp 样式属性的名称.
		 * @return 样式的值.
		 */
		public function getStyle(styleProp:String):*
		{
			return _declaration[styleProp];
		}
		
		/**
		 * 删除此组件实例的样式属性.
		 * @param styleProp 样式属性的名称.
		 * @return 样式的值.
		 */
		public function clearStyle(styleProp:String):*
		{
			var value:* = _declaration[styleProp];
			delete _declaration[styleProp];
			return value;
		}
	}
}
