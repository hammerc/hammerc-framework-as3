/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi.skins
{
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.hi.HiSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>HScrollBarThumbSkin</code> 类为水平滚动条滑块的皮肤.
	 * @author wizardc
	 */
	public class HScrollBarThumbSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>HScrollBarThumbSkin</code> 对象.
		 */
		public function HScrollBarThumbSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.currentState = "up";
			this.minHeight = 15;
			this.minWidth = 15;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			this.graphics.clear();
			switch(currentState)
			{
				case "up":
				case "disabled":
					this.drawCurrentState(0, 0, w, h, _borderColors[0], _bottomLineColors[0], [_fillColors[0], _fillColors[1]], 1);
					break;
				case "over":
					this.drawCurrentState(0, 0, w, h, _borderColors[1], _bottomLineColors[1], [_fillColors[2], _fillColors[3]], 1);
					break;
				case "down":
					this.drawCurrentState(0, 0, w, h, _borderColors[2], _bottomLineColors[2], [_fillColors[4], _fillColors[5]], 1);
					break;
			}
			this.alpha = this.currentState == "disabled" ? 0.5 : 1;
		}
	}
}
