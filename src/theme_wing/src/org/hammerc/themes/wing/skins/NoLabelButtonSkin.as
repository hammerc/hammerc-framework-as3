// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.themes.wing.skins
{
	import org.hammerc.themes.wing.skins.supportClasses.ButtonBaseSkin;
	
	/**
	 * <code>NoLabelButtonSkin</code> 类定义了无文本按钮控件的皮肤.
	 * @author wizardc
	 */
	public class NoLabelButtonSkin extends ButtonBaseSkin
	{
		/**
		 * 创建一个 <code>NoLabelButtonSkin</code> 对象.
		 */
		public function NoLabelButtonSkin()
		{
			super();
			this.minWidth = 10;
			this.minHeight = 10;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			if(_currentSkin != null)
			{
				_currentSkin.width = w;
				_currentSkin.height = h;
				this.drawScaleBitmap(_currentSkin);
			}
		}
	}
}
