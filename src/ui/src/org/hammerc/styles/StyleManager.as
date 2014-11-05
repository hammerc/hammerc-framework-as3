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
	import org.hammerc.core.Injector;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>StyleManager</code> 类管理样式.
	 * @author wizardc
	 */
	public class StyleManager
	{
		private static var _impl:IStyleManager;
		
		private static function get impl():IStyleManager
		{
			if(_impl == null)
			{
				try
				{
					_impl = Injector.getInstance(IStyleManager);
				}
				catch(error:Error)
				{
					_impl = new StyleManagerImpl();
				}
			}
			return _impl;
		}
		
		/**
		 * 获取全局样式描述对象.
		 * <p>所有 <code>styleName</code> 属性不为 null 的组件的样式都会继承自该样式, 同名属性可覆盖.</p>
		 */
		public static function get globalStyleDeclaration():SimpleStyleDeclaration
		{
			return impl.globalStyleDeclaration;
		}
		
		/**
		 * 获取样式管理器.
		 * @return 样式管理器.
		 */
		hammerc_internal static function getStyleManager():IStyleManager
		{
			return impl;
		}
		
		/**
		 * 注册一个样式.
		 * @param styleName 样式名称.
		 * @param styleDeclaration 对应的样式对象.
		 */
		public static function registerStyleDeclaration(styleName:String, styleDeclaration:StyleDeclaration):void
		{
			impl.registerStyleDeclaration(styleName, styleDeclaration);
		}
		
		/**
		 * 获取一个样式.
		 * @param styleName 样式名称.
		 * @return 对应的样式对象.
		 */
		public static function getStyleDeclaration(styleName:String):StyleDeclaration
		{
			return impl.getStyleDeclaration(styleName);
		}
		
		/**
		 * 清除一个样式.
		 * @param styleName 样式名称.
		 * @return 清除的样式对象.
		 */
		public static function clearStyleDeclaration(styleName:String):StyleDeclaration
		{
			return impl.clearStyleDeclaration(styleName);
		}
	}
}
