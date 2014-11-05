// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.themes.wing.skins.supportClasses
{
	import flash.display.DisplayObject;
	
	import org.hammerc.components.Label;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.themes.wing.WingSkin;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>ButtonBaseSkin</code> 类定义了按钮控件皮肤的基类.
	 * @author wizardc
	 */
	public class ButtonBaseSkin extends WingSkin
	{
		/**
		 * 皮肤子件, 按钮上的文本标签.
		 */
		public var labelDisplay:Label;
		
		/**
		 * 皮肤显示对象表.
		 */
		protected var _skinMap:Object;
		
		/**
		 * 当前的皮肤显示对象.
		 */
		protected var _currentSkin:DisplayObject;
		
		/**
		 * 创建一个 <code>ButtonBaseSkin</code> 对象.
		 */
		public function ButtonBaseSkin()
		{
			super();
			_skinMap = new Object();
			this.states = ["up", "over", "down", "disabled"];
			this.styleProperties = this.styleProperties.concat(["upSkin", "overSkin", "downSkin", "disabledSkin"]);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			super.commitCurrentState();
			if(_currentSkin != null && _currentSkin.parent == _container)
			{
				_container.removeChild(_currentSkin);
			}
			_currentSkin = _skinMap[this.currentState];
			if(_currentSkin == null)
			{
				_currentSkin = _skinMap["up"];
			}
			if(_currentSkin != null)
			{
				_container.addChild(_currentSkin);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentStyle(styleProperty:String, hasSet:Boolean, value:* = null):void
		{
			super.commitCurrentStyle(styleProperty, hasSet, value);
			switch(styleProperty)
			{
				case "upSkin":
				case "overSkin":
				case "downSkin":
				case "disabledSkin":
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
		override protected function scale9GridChanged():void
		{
			for(var i:int = 0; i < this.states.length; i++)
			{
				if(_skinMap.hasOwnProperty(this.states[i]))
				{
					DisplayObject(_skinMap[this.states[i]]).scale9Grid = _scale9Grid;
				}
			}
		}
	}
}
