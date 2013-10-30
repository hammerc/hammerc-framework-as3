/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi
{
	import org.hammerc.components.Button;
	import org.hammerc.components.CheckBox;
	import org.hammerc.components.HScrollBar;
	import org.hammerc.components.HSlider;
	import org.hammerc.components.ItemRenderer;
	import org.hammerc.components.List;
	import org.hammerc.components.ProgressBar;
	import org.hammerc.components.RadioButton;
	import org.hammerc.components.Scroller;
	import org.hammerc.components.TabBar;
	import org.hammerc.components.TabBarButton;
	import org.hammerc.components.TextArea;
	import org.hammerc.components.TextInput;
	import org.hammerc.components.ToggleButton;
	import org.hammerc.components.VScrollBar;
	import org.hammerc.components.VSlider;
	import org.hammerc.skins.Theme;
	import org.hammerc.themes.hi.skins.ButtonSkin;
	import org.hammerc.themes.hi.skins.CheckBoxSkin;
	import org.hammerc.themes.hi.skins.HScrollBarSkin;
	import org.hammerc.themes.hi.skins.HSliderSkin;
	import org.hammerc.themes.hi.skins.ItemRendererSkin;
	import org.hammerc.themes.hi.skins.ListSkin;
	import org.hammerc.themes.hi.skins.ProgressBarSkin;
	import org.hammerc.themes.hi.skins.RadioButtonSkin;
	import org.hammerc.themes.hi.skins.ScrollerSkin;
	import org.hammerc.themes.hi.skins.TabBarButtonSkin;
	import org.hammerc.themes.hi.skins.TabBarSkin;
	import org.hammerc.themes.hi.skins.TextAreaSkin;
	import org.hammerc.themes.hi.skins.TextInputSkin;
	import org.hammerc.themes.hi.skins.ToggleButtonSkin;
	import org.hammerc.themes.hi.skins.VScrollBarSkin;
	import org.hammerc.themes.hi.skins.VSliderSkin;
	
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
			this.mapSkin(HScrollBar, HScrollBarSkin);
			this.mapSkin(HSlider, HSliderSkin);
			this.mapSkin(ItemRenderer, ItemRendererSkin);
			this.mapSkin(List, ListSkin);
			this.mapSkin(ProgressBar, ProgressBarSkin);
			this.mapSkin(RadioButton, RadioButtonSkin);
			this.mapSkin(Scroller, ScrollerSkin);
			this.mapSkin(TabBar, TabBarSkin);
			this.mapSkin(TabBarButton, TabBarButtonSkin);
			this.mapSkin(TextArea, TextAreaSkin);
			this.mapSkin(TextInput, TextInputSkin);
			this.mapSkin(ToggleButton, ToggleButtonSkin);
			this.mapSkin(VScrollBar, VScrollBarSkin);
			this.mapSkin(VSlider, VSliderSkin);
		}
	}
}
