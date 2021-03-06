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
	import flash.geom.Rectangle;
	
	import org.hammerc.components.Button;
	import org.hammerc.components.DataGroup;
	import org.hammerc.components.Group;
	import org.hammerc.components.PopUpAnchor;
	import org.hammerc.components.Scroller;
	import org.hammerc.components.TextInput;
	import org.hammerc.components.UIAsset;
	import org.hammerc.components.supportClasses.ButtonBase;
	import org.hammerc.core.PopUpPosition;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.ResizeEvent;
	import org.hammerc.layouts.HorizontalAlign;
	import org.hammerc.layouts.VerticalLayout;
	import org.hammerc.themes.wing.WingEffectUtil;
	import org.hammerc.themes.wing.WingSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ComboBoxSkin</code> 类定义了带输入框的下拉列表控件的皮肤.
	 * @author wizardc
	 */
	public class ComboBoxSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 内容容器.
		 */
		public var dataGroup:DataGroup;
		
		/**
		 * 皮肤子件, 下拉区域显示对象.
		 */
		public var dropDown:Group;
		
		/**
		 * 皮肤子件, 下拉触发按钮.
		 */
		public var openButton:ButtonBase;
		
		/**
		 * 皮肤子件, 文本输入控件.
		 */
		public var textInput:TextInput;
		
		private var _background:UIAsset;
		private var _popUp:PopUpAnchor;
		private var _scroller:Scroller;
		private var _popUpBackground:UIAsset;
		
		/**
		 * 创建一个 <code>ComboBoxSkin</code> 对象.
		 */
		public function ComboBoxSkin()
		{
			super();
			this.states = this.states.concat(["open"]);
			this.minWidth = 10;
			this.minHeight = 10;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			_background = new UIAsset();
			_background.skinName = this.getScaleBitmap(ComboBox_uneditableSkin_c, 5, 5, 67, 11);
			this.addElement(_background);
			openButton = new Button();
			openButton.width = 16;
			openButton.right = 2;
			openButton.top = 2;
			openButton.bottom = 2;
			openButton.tabEnabled = false;
			openButton.createLabelIfNeed = false;
			openButton.skinName = NoLabelButtonSkin;
			openButton.setStyle("upSkin", ComboBox_arrowButton_upSkin_c);
			openButton.setStyle("overSkin", ComboBox_arrowButton_overSkin_c);
			openButton.setStyle("downSkin", ComboBox_arrowButton_downSkin_c);
			openButton.setStyle("disabledSkin", ComboBox_arrowButton_disabledSkin_c);
			openButton.setStyle("useTextFilter", false);
			openButton.setStyle("scale9Grid", new Rectangle(3, 3, 10, 11));
			this.addElement(openButton);
			textInput = new TextInput();
			textInput.left = 0;
			textInput.right = 16;
			textInput.top = 0;
			textInput.bottom = 0;
			textInput.setStyle("normalSkin", null);
			textInput.setStyle("disabledSkin", null);
			textInput.setStyle("normalWithPromptSkin", null);
			textInput.setStyle("disabledWithPromptSkin", null);
			this.addElement(textInput);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			switch(this.currentState)
			{
				case "open":
					if(_popUp == null)
					{
						createPopUp();
					}
					_popUp.displayPopUp = true;
					break;
				case "normal":
					if(_popUp != null)
					{
						_popUp.displayPopUp = false;
					}
					break;
				case "disabled":
					break;
			}
		}
		
		private function createPopUp():void
		{
			dataGroup = new DataGroup();
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 0;
			layout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
			dataGroup.layout = layout;
			_scroller = new Scroller();
			_scroller.left = 0;
			_scroller.top = 0;
			_scroller.right = 0;
			_scroller.bottom = 0;
			_scroller.minViewportInset = 1;
			_scroller.maxHeight = 200;
			_scroller.viewport = dataGroup;
			dropDown = new Group();
			dropDown.addEventListener(ResizeEvent.RESIZE, onResize);
			_popUpBackground = new UIAsset;
			_popUpBackground.skinName = this.getScaleBitmap(ComboBox_listSkin_c, 1, 1, 18, 18);
			dropDown.addElement(_popUpBackground);
			dropDown.addElement(_scroller);
			onResize();
			_popUp = new PopUpAnchor();
			_popUp.left = 0;
			_popUp.right = 0;
			_popUp.top = 0;
			_popUp.bottom = 0;
			_popUp.popUpPosition = PopUpPosition.DROP_DOWN_LIST;
			_popUp.popUpWidthMatchesAnchorWidth = true;
			_popUp.popUp = dropDown;
			this.addElement(_popUp);
		}
		
		private function onResize(event:ResizeEvent = null):void
		{
			var w:Number = isNaN(dropDown.width) ? 0 : dropDown.width;
			var h:Number = isNaN(dropDown.height) ? 0 : dropDown.height;
			_popUpBackground.skin.width = w;
			_popUpBackground.skin.height = h;
			this.drawScaleBitmap(_popUpBackground.skin);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			if(this.currentState == "disabled")
			{
				WingEffectUtil.setGray(this);
			}
			else
			{
				WingEffectUtil.clearGray(this);
			}
			_background.skin.width = w;
			_background.skin.height = h;
			this.drawScaleBitmap(_background.skin);
		}
	}
}
