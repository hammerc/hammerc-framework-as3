/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing.skins
{
	import flash.display.DisplayObject;
	
	import org.hammerc.themes.wing.skins.supportClasses.ButtonBaseSkin;
	
	/**
	 * <code>NoLabelToggleButtonSkin</code> 类定义了无文本切换按钮控件的皮肤.
	 * @author wizardc
	 */
	public class NoLabelToggleButtonSkin extends ButtonBaseSkin
	{
		/**
		 * 创建一个 <code>NoLabelToggleButtonSkin</code> 对象.
		 */
		public function NoLabelToggleButtonSkin()
		{
			super();
			this.states = this.states.concat(["upAndSelected", "overAndSelected", "downAndSelected", "disabledAndSelected"]);
			this.styleProperties = this.styleProperties.concat(["upAndSelectedSkin", "overAndSelectedSkin", "downAndSelectedSkin", "disabledAndSelectedSkin"]);
			this.minWidth = 10;
			this.minHeight = 10;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentStyle(styleProperty:String, hasSet:Boolean, value:* = null):void
		{
			super.commitCurrentStyle(styleProperty, hasSet, value);
			switch(styleProperty)
			{
				case "upAndSelectedSkin":
				case "overAndSelectedSkin":
				case "downAndSelectedSkin":
				case "disabledAndSelectedSkin":
					var key:String = styleProperty.replace("Skin", "");
					_skinMap[key] = this.getSkinObject(value);
					if(_skinMap[key] != null)
					{
						DisplayObject(_skinMap[key]).scale9Grid = _scale9Grid;
					}
					break;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			if(_currentSkin != null)
			{
				_currentSkin.width = w;
				_currentSkin.height = h;
				this.drawScaleBitmap(_currentSkin);
			}
		}
	}
}
