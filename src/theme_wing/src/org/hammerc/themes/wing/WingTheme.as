/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing
{
	import org.hammerc.skins.Theme;
	import org.hammerc.themes.wing.skins.AlertSkin;
	import org.hammerc.themes.wing.skins.ButtonSkin;
	import org.hammerc.themes.wing.skins.CheckBoxSkin;
	import org.hammerc.themes.wing.skins.ComboBoxSkin;
	import org.hammerc.themes.wing.skins.DropDownListSkin;
	import org.hammerc.themes.wing.skins.HScrollBarSkin;
	import org.hammerc.themes.wing.skins.HSliderSkin;
	import org.hammerc.themes.wing.skins.ItemRendererSkin;
	import org.hammerc.themes.wing.skins.ListSkin;
	import org.hammerc.themes.wing.skins.NumericStepperSkin;
	import org.hammerc.themes.wing.skins.PanelSkin;
	import org.hammerc.themes.wing.skins.ProgressBarSkin;
	import org.hammerc.themes.wing.skins.RadioButtonSkin;
	import org.hammerc.themes.wing.skins.ScrollerSkin;
	import org.hammerc.themes.wing.skins.SpinnerSkin;
	import org.hammerc.themes.wing.skins.TabBarButtonSkin;
	import org.hammerc.themes.wing.skins.TabBarSkin;
	import org.hammerc.themes.wing.skins.TextAreaSkin;
	import org.hammerc.themes.wing.skins.TextInputSkin;
	import org.hammerc.themes.wing.skins.TitleWindowSkin;
	import org.hammerc.themes.wing.skins.ToggleButtonSkin;
	import org.hammerc.themes.wing.skins.TreeItemRendererSkin;
	import org.hammerc.themes.wing.skins.VScrollBarSkin;
	import org.hammerc.themes.wing.skins.VSliderSkin;
	
	/**
	 * <code>WingTheme</code> 类为 Wing 主题类.
	 * @author wizardc
	 */
	public class WingTheme extends Theme
	{
		/**
		 * 创建一个 <code>WingTheme</code> 对象.
		 */
		public function WingTheme()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this.mapSkin("org.hammerc.components::Alert", AlertSkin);
			this.mapSkin("org.hammerc.components::Button", ButtonSkin);
			this.mapSkin("org.hammerc.components::CheckBox", CheckBoxSkin);
			this.mapSkin("org.hammerc.components::ComboBox", ComboBoxSkin);
			this.mapSkin("org.hammerc.components::DropDownList", DropDownListSkin);
			this.mapSkin("org.hammerc.components::HScrollBar", HScrollBarSkin);
			this.mapSkin("org.hammerc.components::HSlider", HSliderSkin);
			this.mapSkin("org.hammerc.components::ItemRenderer", ItemRendererSkin);
			this.mapSkin("org.hammerc.components::List", ListSkin);
			this.mapSkin("org.hammerc.components::NumericStepper", NumericStepperSkin);
			this.mapSkin("org.hammerc.components::Panel", PanelSkin);
			this.mapSkin("org.hammerc.components::ProgressBar", ProgressBarSkin);
			this.mapSkin("org.hammerc.components::RadioButton", RadioButtonSkin);
			this.mapSkin("org.hammerc.components::Scroller", ScrollerSkin);
			this.mapSkin("org.hammerc.components::Spinner", SpinnerSkin);
			this.mapSkin("org.hammerc.components::TabBar", TabBarSkin);
			this.mapSkin("org.hammerc.components::TabBarButton", TabBarButtonSkin);
			this.mapSkin("org.hammerc.components::TextArea", TextAreaSkin);
			this.mapSkin("org.hammerc.components::TextInput", TextInputSkin);
			this.mapSkin("org.hammerc.components::TitleWindow", TitleWindowSkin);
			this.mapSkin("org.hammerc.components::ToggleButton", ToggleButtonSkin);
			this.mapSkin("org.hammerc.components::Tree", ListSkin);
			this.mapSkin("org.hammerc.components::TreeItemRenderer", TreeItemRendererSkin);
			this.mapSkin("org.hammerc.components::VScrollBar", VScrollBarSkin);
			this.mapSkin("org.hammerc.components::VSlider", VSliderSkin);
		}
	}
}
