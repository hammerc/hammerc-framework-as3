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
	[ExcludeClass]
	
	/**
	 * <code>StyleManagerImpl</code> 类实现了样式管理器的功能.
	 * @author wizardc
	 */
	public class StyleManagerImpl implements IStyleManager
	{
		private var _globalStyleDeclaration:SimpleStyleDeclaration;
		
		private var _styleMap:Object;
		
		/**
		 * 创建一个 <code>StyleManagerImpl</code> 对象.
		 */
		public function StyleManagerImpl()
		{
			_styleMap = new Object();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get globalStyleDeclaration():SimpleStyleDeclaration
		{
			if(_globalStyleDeclaration == null)
			{
				_globalStyleDeclaration = new SimpleStyleDeclaration();
			}
			return _globalStyleDeclaration;
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerStyleDeclaration(styleName:String, styleDeclaration:StyleDeclaration):void
		{
			if(styleName == null || styleName == "")
			{
				return;
			}
			_styleMap[styleName] = styleDeclaration;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getStyleDeclaration(styleName:String):StyleDeclaration
		{
			var styleDeclaration:StyleDeclaration = _styleMap[styleName] as StyleDeclaration;
			if(styleDeclaration != null)
			{
				return styleDeclaration.clone();
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clearStyleDeclaration(styleName:String):StyleDeclaration
		{
			var styleDeclaration:StyleDeclaration = _styleMap[styleName] as StyleDeclaration;
			delete _styleMap[styleName];
			return styleDeclaration;
		}
	}
}
