/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi
{
	import org.hammerc.components.Button;
	import org.hammerc.components.CheckBox;
	import org.hammerc.components.RadioButton;
	import org.hammerc.components.ToggleButton;
	import org.hammerc.skins.Theme;
	import org.hammerc.themes.hi.skins.ButtonSkin;
	import org.hammerc.themes.hi.skins.CheckBoxSkin;
	import org.hammerc.themes.hi.skins.RadioButtonSkin;
	import org.hammerc.themes.hi.skins.ToggleButtonSkin;
	
	/**
	 * <code>HiTheme</code> 类为 Hi 主题类.
	 * @author wizardc
	 */
	public class HiTheme extends Theme
	{
		/**
		 * 创建一个 <code>HiTheme</code> 对象.
		 */
		public function HiTheme()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this.mapSkin(Button, ButtonSkin);
			this.mapSkin(CheckBox, CheckBoxSkin);
			this.mapSkin(RadioButton, RadioButtonSkin);
			this.mapSkin(ToggleButton, ToggleButtonSkin);
		}
	}
}
