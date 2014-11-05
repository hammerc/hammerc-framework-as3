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
	import flash.display.Graphics;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TreeDisclosureButtonSkin</code> 类定义了树形组件的项呈示器按钮的皮肤.
	 * @author wizardc
	 */
	public class TreeDisclosureButtonSkin extends HiSkin
	{
		private var _overColor:uint = _otherColors[11];
		private var _selectedColor:uint = _otherColors[12];
		
		/**
		 * 创建一个 <code>TreeDisclosureButtonSkin</code> 对象.
		 */
		public function TreeDisclosureButtonSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.height = 9;
			this.width = 9;
		}
		
		/**
		 * 设置或获取鼠标经过时的箭头颜色.
		 */
		public function set overColor(value:uint):void
		{
			if(_overColor == value)
			{
				return;
			}
			_overColor = value;
			this.invalidateDisplayList();
		}
		public function get overColor():uint
		{
			return _overColor;
		}
		
		/**
		 * 设置或获取节点开启时的箭头颜色.
		 */
		public function set selectedColor(value:uint):void
		{
			if(_selectedColor == value)
			{
				return;
			}
			_selectedColor = value;
			this.invalidateDisplayList();
		}
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0xFFFFFF, 0);
			g.drawRect(0, 0, 9, 9);
			g.endFill();
			var arrowColor:uint;
			var selected:Boolean = false;
			switch(this.currentState)
			{
				case "up":
				case "disabled":
				case "over":
				case "down":
					arrowColor = _overColor;
					break;
				case "overAndSelected":
				case "upAndSelected":
				case "downAndSelected":
				case "disabledAndSelected":
					selected = true;
					arrowColor = _selectedColor;
					break;
			}
			this.alpha = this.currentState == "disabled" || this.currentState == "disabledAndSelected" ? 0.5 : 1;
			g.beginFill(arrowColor);
			if(selected)
			{
				g.lineStyle(0, 0, 0);
				g.moveTo(1, 7);
				g.lineTo(7, 7);
				g.lineTo(7, 0);
				g.lineTo(1, 7);
				g.endFill();
			}
			else
			{
				g.moveTo(2, 0);
				g.lineTo(2, 9);
				g.lineTo(7, 5);
				g.lineTo(2, 0);
				g.endFill();
			}
		}
	}
}
