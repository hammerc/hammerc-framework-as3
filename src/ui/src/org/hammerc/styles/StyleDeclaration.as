// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.styles
{
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>StyleDeclaration</code> 类定义了一个样式描述对象.
	 * @author wizardc
	 */
	public class StyleDeclaration extends SimpleStyleDeclaration
	{
		hammerc_internal var _globalStyleDeclaration:SimpleStyleDeclaration;
		
		/**
		 * 创建一个 <code>StyleDeclaration</code> 对象.
		 */
		public function StyleDeclaration()
		{
			super();
			_globalStyleDeclaration = StyleManager.globalStyleDeclaration;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getStyle(styleProp:String):*
		{
			var style:* = _declaration[styleProp];
			if(style == null || style == undefined)
			{
				return _globalStyleDeclaration.getStyle(styleProp);
			}
			return style;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		public function clone():StyleDeclaration
		{
			var declaration:Object = new Object();
			for(var key:* in _declaration)
			{
				declaration[key] = _declaration[key];
			}
			var styleDeclaration:StyleDeclaration = new StyleDeclaration();
			styleDeclaration._declaration = declaration;
			return styleDeclaration;
		}
	}
}
