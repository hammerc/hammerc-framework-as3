/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import org.hammerc.components.Button;
	import org.hammerc.components.DataGroup;
	import org.hammerc.components.Group;
	import org.hammerc.components.PopUpAnchor;
	import org.hammerc.components.Scroller;
	import org.hammerc.components.TextInput;
	import org.hammerc.components.supportClasses.ButtonBase;
	import org.hammerc.core.PopUpPosition;
	import org.hammerc.core.UIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.ResizeEvent;
	import org.hammerc.layouts.HorizontalAlign;
	import org.hammerc.layouts.VerticalLayout;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ComboBoxSkin</code> 类定义了带输入框的下拉列表控件的皮肤.
	 * @author wizardc
	 */
	public class ComboBoxSkin extends HiSkin
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
		
		private var _popUp:PopUpAnchor;
		private var _scroller:Scroller;
		private var _backgroud:UIComponent;
		
		/**
		 * 创建一个 <code>ComboBoxSkin</code> 对象.
		 */
		public function ComboBoxSkin()
		{
			super();
			this.states = ["open", "normal", "disabled"];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			openButton = new Button();
			openButton.width = 20;
			openButton.right = 0;
			openButton.top = 0;
			openButton.bottom = 0;
			openButton.skinName = ComboBoxButtonSkin;
			this.addElement(openButton);
			textInput = new TextInput();
			textInput.skinName = ComboBoxTextInputSkin;
			textInput.left = 0;
			textInput.right = 19;
			textInput.top = 0;
			textInput.bottom = 0;
			this.addElement(textInput);
		}
		
		private function onResize(event:ResizeEvent = null):void
		{
			var w:Number = isNaN(dropDown.width) ? 0 : dropDown.width;
			var h:Number = isNaN(dropDown.height) ? 0 : dropDown.height;
			var g:Graphics = _backgroud.graphics;
			g.clear();
			var crr1:Number = _cornerRadius > 0 ? _cornerRadius - 1 : 0;
			this.drawRoundRect(0, 0, w, h, _cornerRadius, _borderColors[0], 1, this.verticalGradientMatrix(0, 0, w, h ), GradientType.LINEAR, null, {x:1, y:1, w:w - 2, h:h - 2, r:crr1}, g); 
			//绘制填充
			this.drawRoundRect(1, 1, w - 2, h - 2, crr1, 0xFFFFFF, 1, this.verticalGradientMatrix(1, 1, w - 2, h - 2), "linear", null, null, g); 
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
					_popUp.displayPopUp = false;
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
			_scroller.left = 2;
			_scroller.top = 2;
			_scroller.right = 2;
			_scroller.bottom = 2;
			_scroller.minViewportInset = 1;
			_scroller.maxHeight = 200;
			_scroller.viewport = dataGroup;
			dropDown = new Group();
			dropDown.addEventListener(ResizeEvent.RESIZE, onResize);
			_backgroud = new UIComponent;
			dropDown.addElement(_backgroud);
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
	}
}
