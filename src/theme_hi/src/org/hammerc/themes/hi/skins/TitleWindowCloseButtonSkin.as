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
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TitleWindowCloseButtonSkin</code> 类为可移动窗口组件的关闭按钮皮肤类.
	 * @author wizardc
	 */
	public class TitleWindowCloseButtonSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>TitleWindowCloseButtonSkin</code> 对象.
		 */
		public function TitleWindowCloseButtonSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.minHeight = 16;
			this.minWidth = 16;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0, 0);
			g.drawRect(0, 0, w, h);
			g.endFill();
			var offsetX:Number = Math.round(w * 0.5 - 8);
			var offsetY:Number = Math.round(h * 0.5 - 8);
			switch(this.currentState)
			{
				case "up":
				case "disabled":
					drawCloseIcon(_otherColors[8], offsetX, offsetY);
					break;
				case "over":
					drawCloseIcon(_otherColors[9], offsetX, offsetY);
					break;
				case "down":
					drawCloseIcon(_otherColors[10], offsetX, offsetY+1);
					break;
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
		
		/**
		 * 绘制关闭图标.
		 */
		private function drawCloseIcon(color:uint, offsetX:Number, offsetY:Number):void
		{
			var g:Graphics = this.graphics;
			g.lineStyle(2, color, 1, false, "normal", CapsStyle.SQUARE);
			g.moveTo(offsetX + 6, offsetY + 6);
			g.lineTo(offsetX + 10, offsetY + 10);
			g.endFill();
			g.moveTo(offsetX + 10, offsetY + 6);
			g.lineTo(offsetX + 6, offsetY + 10);
			g.endFill();
			g.lineStyle();
			g.beginFill(color);
			g.drawEllipse(offsetX + 0, offsetY + 0, 16, 16);
			g.drawEllipse(offsetX + 2, offsetY + 2, 12, 12);
			g.endFill();
		}
	}
}
