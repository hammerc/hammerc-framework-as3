// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.themes.hi.skins
{
	import org.hammerc.components.Button;
	import org.hammerc.components.Group;
	
	/**
	 * <code>TitleWindowSkin</code> 类为可移动窗口组件的皮肤类.
	 * @author wizardc
	 */
	public class TitleWindowSkin extends PanelSkin
	{
		/**
		 * 皮肤子件, 关闭按钮.
		 */
		public var closeButton:Button;
		
		/**
		 * 皮肤子件, 可移动区域.
		 */
		public var moveArea:Group;
		
		/**
		 * 创建一个 <code>TitleWindowSkin</code> 对象.
		 */
		public function TitleWindowSkin()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			moveArea = new Group();
			moveArea.left = 0;
			moveArea.right = 0;
			moveArea.top = 0;
			moveArea.height = 30;
			this.addElement(moveArea);
			closeButton = new Button();
			closeButton.skinName = TitleWindowCloseButtonSkin;
			closeButton.right = 7;
			closeButton.top = 7;
			this.addElement(closeButton);
		}
	}
}
