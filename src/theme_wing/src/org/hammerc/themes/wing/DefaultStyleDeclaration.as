// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.themes.wing
{
	import flash.geom.Rectangle;
	
	import org.hammerc.managers.ToolTipManager;
	import org.hammerc.styles.SimpleStyleDeclaration;
	import org.hammerc.styles.StyleDeclaration;
	import org.hammerc.styles.StyleManager;
	import org.hammerc.themes.wing.skins.ToolTipSkin;
	
	/**
	 * <code>DefaultStyleDeclaration</code> 类定义了所有 UI 的默认样式, 程序初始化时应先调用 install 方法进行样式设定.
	 * @author wizardc
	 */
	public class DefaultStyleDeclaration
	{
		/**
		 * 安装 UI 默认样式.
		 */
		public static function install():void
		{
			//全局样式
			registerGlobalStyle({
				fontFamily:"Verdana", 
				fontSize:12, 
				fontColor:0xffffff, 
				fontItalic:false, 
				fontBold:false, 
				useTextFilter:false, 
				textFilterColor:0x000000, 
				scale9Grid:null
			});
			
			//按钮
			registerStyle("Button", {
				upSkin:Button_upSkin_c, 
				overSkin:Button_overSkin_c, 
				downSkin:Button_downSkin_c, 
				disabledSkin:Button_disabledSkin_c, 
				overFontColor:0xffffff, 
				downFontColor:0xffffff, 
				disabledFontColor:0xcccccc, 
				textAlign:"center", 
				useTextFilter:true, 
				textFilterColor:0x000000, 
				scale9Grid:new Rectangle(10, 5, 60, 11)
			});
			
			//切换按钮
			registerStyle("ToggleButton", {
				upSkin:Button_upSkin_c, 
				overSkin:Button_overSkin_c, 
				downSkin:Button_downSkin_c, 
				disabledSkin:Button_disabledSkin_c, 
				upAndSelectedSkin:Button_upAndSelectedSkin_c, 
				overAndSelectedSkin:Button_overAndSelectedSkin_c, 
				downAndSelectedSkin:Button_downSkin_c, 
				disabledAndSelectedSkin:Button_disabledSkin_c, 
				overFontColor:0xffffff, 
				downFontColor:0xffffff, 
				disabledFontColor:0xcccccc, 
				upAndSelectedFontColor:0xffffff, 
				overAndSelectedFontColor:0xffffff, 
				downAndSelectedFontColor:0xffffff, 
				disabledAndSelectedFontColor:0xcccccc, 
				textAlign:"center", 
				useTextFilter:true, 
				textFilterColor:0x000000, 
				scale9Grid:new Rectangle(10, 5, 60, 11)
			});
			
			//复选框控件
			registerStyle("CheckBox", {
				upSkin:CheckBox_upSkin_c, 
				overSkin:CheckBox_overSkin_c, 
				downSkin:CheckBox_downSkin_c, 
				disabledSkin:CheckBox_disabledSkin_c, 
				upAndSelectedSkin:CheckBox_upAndSelectedSkin_c, 
				overAndSelectedSkin:CheckBox_overAndSelectedSkin_c, 
				downAndSelectedSkin:CheckBox_downAndSelectedSkin_c, 
				disabledAndSelectedSkin:CheckBox_disabledAndSelectedSkin_c, 
				overFontColor:0xffffff, 
				downFontColor:0xffffff, 
				disabledFontColor:0xcccccc, 
				upAndSelectedFontColor:0xffffff, 
				overAndSelectedFontColor:0xffffff, 
				downAndSelectedFontColor:0xffffff, 
				disabledAndSelectedFontColor:0xcccccc, 
				textAlign:"left", 
				useTextFilter:true, 
				textFilterColor:0x000000, 
				scale9Grid:null
			});
			
			//单选按钮
			registerStyle("RadioButton", {
				upSkin:RadioButton_upSkin_c, 
				overSkin:RadioButton_overSkin_c, 
				downSkin:RadioButton_downSkin_c, 
				disabledSkin:RadioButton_disabledSkin_c, 
				upAndSelectedSkin:RadioButton_upAndSelectedSkin_c, 
				overAndSelectedSkin:RadioButton_overAndSelectedSkin_c, 
				downAndSelectedSkin:RadioButton_downAndSelectedSkin_c, 
				disabledAndSelectedSkin:RadioButton_disabledAndSelectedSkin_c, 
				overFontColor:0xffffff, 
				downFontColor:0xffffff, 
				disabledFontColor:0xcccccc, 
				upAndSelectedFontColor:0xffffff, 
				overAndSelectedFontColor:0xffffff, 
				downAndSelectedFontColor:0xffffff, 
				disabledAndSelectedFontColor:0xcccccc, 
				textAlign:"left", 
				useTextFilter:true, 
				textFilterColor:0x000000, 
				scale9Grid:null
			});
			
			//输入文本框
			registerStyle("TextInput", {
				normalSkin:TextArea_normalSkin_c, 
				disabledSkin:TextArea_disabledSkin_c, 
				normalWithPromptSkin:TextArea_normalSkin_c, 
				disabledWithPromptSkin:TextArea_disabledSkin_c, 
				fontColor:0x333333, 
				disabledFontColor:0xcccccc, 
				normalWithPromptFontColor:0x666666, 
				disabledWithPromptFontColor:0xcccccc, 
				paddingTop:2, 
				paddingBottom:2, 
				paddingLeft:3, 
				paddingRight:3, 
				textAlign:"left", 
				useTextFilter:false, 
				textFilterColor:0x000000, 
				scale9Grid:new Rectangle(5, 5, 132, 11)
			});
			
			//多行文本输入框
			registerStyle("TextArea", {
				normalSkin:TextArea_normalSkin_c, 
				disabledSkin:TextArea_disabledSkin_c, 
				normalWithPromptSkin:TextArea_normalSkin_c, 
				disabledWithPromptSkin:TextArea_disabledSkin_c, 
				fontColor:0x333333, 
				disabledFontColor:0xcccccc, 
				normalWithPromptFontColor:0x666666, 
				disabledWithPromptFontColor:0xcccccc, 
				paddingTop:2, 
				paddingBottom:2, 
				paddingLeft:3, 
				paddingRight:3, 
				textAlign:"left", 
				useTextFilter:false, 
				textFilterColor:0x000000, 
				scale9Grid:new Rectangle(5, 5, 132, 11)
			});
			
			//列表渲染项
			registerStyle("ItemRenderer", {
				upSkin:null, 
				overSkin:ItemRenderer_overSkin_c, 
				downSkin:ItemRenderer_downSkin_c, 
				disabledSkin:null, 
				upAndSelectedSkin:ItemRenderer_downSkin_c, 
				overAndSelectedSkin:ItemRenderer_downSkin_c, 
				downAndSelectedSkin:ItemRenderer_downSkin_c, 
				disabledAndSelectedSkin:null, 
				overFontColor:0xffffff, 
				downFontColor:0xffffff, 
				disabledFontColor:0xcccccc, 
				upAndSelectedFontColor:0xffffff, 
				overAndSelectedFontColor:0xffffff, 
				downAndSelectedFontColor:0xffffff, 
				disabledAndSelectedFontColor:0xcccccc, 
				textAlign:"center", 
				useTextFilter:true, 
				textFilterColor:0x000000, 
				scale9Grid:new Rectangle(10, 5, 60, 11)
			});
			
			//树列表渲染项
			registerStyle("TreeItemRenderer", {
				upSkin:null,
				overSkin:ItemRenderer_overSkin_c,
				downSkin:ItemRenderer_downSkin_c,
				disabledSkin:null,
				upAndSelectedSkin:ItemRenderer_downSkin_c,
				overAndSelectedSkin:ItemRenderer_downSkin_c,
				downAndSelectedSkin:ItemRenderer_downSkin_c,
				disabledAndSelectedSkin:null,
				overFontColor:0xffffff,
				downFontColor:0xffffff,
				disabledFontColor:0xcccccc,
				upAndSelectedFontColor:0xffffff,
				overAndSelectedFontColor:0xffffff,
				downAndSelectedFontColor:0xffffff,
				disabledAndSelectedFontColor:0xcccccc,
				textAlign:"center",
				useTextFilter:true,
				textFilterColor:0x000000,
				scale9Grid:new Rectangle(10, 5, 60, 11)
			});
			
			//标签页按钮
			registerStyle("TabBarButton", {
				upSkin:Tab_upSkin_c,
				overSkin:Tab_overSkin_c,
				downSkin:Tab_downSkin_c,
				disabledSkin:Tab_disabledSkin_c,
				upAndSelectedSkin:Tab_selectedSkin_c,
				overAndSelectedSkin:Tab_overSelectedSkin_c,
				downAndSelectedSkin:Tab_downSelectedSkin_c,
				disabledAndSelectedSkin:Tab_disabledSkin_c,
				overFontColor:0xffffff,
				downFontColor:0xffffff,
				disabledFontColor:0xcccccc,
				upAndSelectedFontColor:0xffffff,
				overAndSelectedFontColor:0xffffff,
				downAndSelectedFontColor:0xffffff,
				disabledAndSelectedFontColor:0xcccccc,
				textAlign:"center",
				useTextFilter:true,
				textFilterColor:0x000000,
				scale9Grid:new Rectangle(5, 5, 56, 8)
			});
			
			//工具提示
			ToolTipManager.toolTipRenderer = ToolTipSkin;
		}
		
		/**
		 * 注册全局样式.
		 * @param style 样式.
		 */
		private static function registerGlobalStyle(style:Object):void
		{
			var styleDeclaration:SimpleStyleDeclaration = StyleManager.globalStyleDeclaration;
			for(var key:String in style)
			{
				styleDeclaration.setStyle(key, style[key]);
			}
		}
		
		/**
		 * 注册指定样式.
		 * @param styleName 样式名.
		 * @param style 样式.
		 */
		private static function registerStyle(styleName:String, style:Object):void
		{
			var styleDeclaration:StyleDeclaration = new StyleDeclaration();
			for(var key:String in style)
			{
				styleDeclaration.setStyle(key, style[key]);
			}
			StyleManager.registerStyleDeclaration(styleName, styleDeclaration);
		}
	}
}
