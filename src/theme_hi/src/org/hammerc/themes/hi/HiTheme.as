/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi
{
	import org.hammerc.skins.Theme;
	import org.hammerc.themes.hi.skins.ButtonSkin;
	import org.hammerc.themes.hi.skins.CheckBoxSkin;
	import org.hammerc.themes.hi.skins.ComboBoxSkin;
	import org.hammerc.themes.hi.skins.DropDownListSkin;
	import org.hammerc.themes.hi.skins.HScrollBarSkin;
	import org.hammerc.themes.hi.skins.HSliderSkin;
	import org.hammerc.themes.hi.skins.ItemRendererSkin;
	import org.hammerc.themes.hi.skins.ListSkin;
	import org.hammerc.themes.hi.skins.PanelSkin;
	import org.hammerc.themes.hi.skins.ProgressBarSkin;
	import org.hammerc.themes.hi.skins.RadioButtonSkin;
	import org.hammerc.themes.hi.skins.ScrollerSkin;
	import org.hammerc.themes.hi.skins.TabBarButtonSkin;
	import org.hammerc.themes.hi.skins.TabBarSkin;
	import org.hammerc.themes.hi.skins.TextAreaSkin;
	import org.hammerc.themes.hi.skins.TextInputSkin;
	import org.hammerc.themes.hi.skins.ToggleButtonSkin;
	import org.hammerc.themes.hi.skins.TreeItemRendererSkin;
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
			this.mapSkin("org.hammerc.components::Button", ButtonSkin);
			this.mapSkin("org.hammerc.components::CheckBox", CheckBoxSkin);
			this.mapSkin("org.hammerc.components::ComboBox", ComboBoxSkin);
			this.mapSkin("org.hammerc.components::DropDownList", DropDownListSkin);
			this.mapSkin("org.hammerc.components::HScrollBar", HScrollBarSkin);
			this.mapSkin("org.hammerc.components::HSlider", HSliderSkin);
			this.mapSkin("org.hammerc.components::ItemRenderer", ItemRendererSkin);
			this.mapSkin("org.hammerc.components::List", ListSkin);
			this.mapSkin("org.hammerc.components::Panel", PanelSkin);
			this.mapSkin("org.hammerc.components::ProgressBar", ProgressBarSkin);
			this.mapSkin("org.hammerc.components::RadioButton", RadioButtonSkin);
			this.mapSkin("org.hammerc.components::Scroller", ScrollerSkin);
			this.mapSkin("org.hammerc.components::TabBar", TabBarSkin);
			this.mapSkin("org.hammerc.components::TabBarButton", TabBarButtonSkin);
			this.mapSkin("org.hammerc.components::TextArea", TextAreaSkin);
			this.mapSkin("org.hammerc.components::TextInput", TextInputSkin);
			this.mapSkin("org.hammerc.components::ToggleButton", ToggleButtonSkin);
			this.mapSkin("org.hammerc.components::Tree", ListSkin);
			this.mapSkin("org.hammerc.components::TreeItemRenderer", TreeItemRendererSkin);
			this.mapSkin("org.hammerc.components::VScrollBar", VScrollBarSkin);
			this.mapSkin("org.hammerc.components::VSlider", VSliderSkin);
		}
	}
}
