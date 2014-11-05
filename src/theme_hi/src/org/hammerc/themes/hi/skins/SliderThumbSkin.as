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
	 * <code>SliderThumbSkin</code> 类定义了滑块控件滑块的皮肤.
	 * @author wizardc
	 */
	public class SliderThumbSkin extends HiSkin
	{
		/**
		 * 创建一个 <code>SliderThumbSkin</code> 对象.
		 */
		public function SliderThumbSkin()
		{
			super();
			this.states = ["up", "over", "down", "disabled"];
			this.currentState = "up";
			this.minHeight = 12;
			this.minWidth = 12;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			w = 12;
			h = 12;
			var g:Graphics = this.graphics;
			g.clear();
			switch(this.currentState)
			{
				case "up":
				case "disabled":
					this.drawCurrentState(0, 0, w, h, _borderColors[0], _bottomLineColors[0], [_fillColors[0], _fillColors[1]], 6);
					break;
				case "over":
					this.drawCurrentState(0, 0, w, h, _borderColors[1], _bottomLineColors[1], [_fillColors[2], _fillColors[3]], 6);
					break;
				case "down":
					this.drawCurrentState(0, 0, w, h, _borderColors[2], _bottomLineColors[2], [_fillColors[4], _fillColors[5]], 6);
					break;
			}
			this.alpha = this.currentState== "disabled" ? 0.5 : 1;
		}
	}
}
