// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.tween.plugins.filters
{
	import flash.filters.ColorMatrixFilter;
	
	import org.hammerc.tween.plugins.PluginItem;
	
	/**
	 * <code>ColorMatrixFilterPlugin</code> 类定义了支持颜色矩阵滤镜的补丁.
	 * @author wizardc
	 */
	public class ColorMatrixFilterPlugin extends AbstractFilterPlugin
	{
		/**
		 * 补丁支持的滤镜类对象.
		 */
		public static const FILTER_CLASS:Class = ColorMatrixFilter;
		
		/**
		 * 补丁对象的键名.
		 */
		public static const PLUGIN_KEY:String = "colorMatrixFilter";
		
		/**
		 * 缓动属性的列表.
		 */
		public static const TWEEN_KEYS:Vector.<String> = new <String>["redR", "redG", "redB", "redA", "redOffset", "greenR", "greenG", "greenB", "greenA", "greenOffset", "blueR", "blueG", "blueB", "blueA", "blueOffset", "alphaR", "alphaG", "alphaB", "alphaA", "alphaOffset"];
		
		/**
		 * 用来设置的键名列表.
		 */
		public static const SETTING_KEYS:Vector.<String> = new <String>[];
		
		/**
		 * 创建一个 <code>ColorMatrixFilterPlugin</code> 对象.
		 */
		public function ColorMatrixFilterPlugin()
		{
			super(FILTER_CLASS, PLUGIN_KEY, TWEEN_KEYS, SETTING_KEYS);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getStartVariables(variables:Object):Object
		{
			//创建或取出指定的滤镜
			var filter:ColorMatrixFilter;
			var index:int = this.getFilterIndex();
			if(index == -1)
			{
				filter = new ColorMatrixFilter();
			}
			else
			{
				filter = _target.filters[index] as ColorMatrixFilter;
			}
			//设置不用于缓动的值
			for each(var value:String in _settingKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					filter[value] = variables[value];
				}
			}
			//立即设置滤镜
			this.setFilter(filter);
			//获取所有的初始值
			var startVariables:Object = new Object();
			for(var i:int = 0; i < 20; i++)
			{
				startVariables[_tweenKeys[i]] = filter.matrix[i];
			}
			return startVariables;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update(baseValue:Number):void
		{
			var index:int = this.getFilterIndex();
			var filter:ColorMatrixFilter = _target.filters[index] as ColorMatrixFilter;
			for(var i:int = 0, len:int = _propertyList.length; i < len; i++)
			{
				var item:PluginItem = _propertyList[i];
				var matrix:Array = filter.matrix;
				matrix[_tweenKeys.indexOf(item.property)] = item.start + item.change * baseValue;
				filter.matrix = matrix;
			}
			this.setFilter(filter);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resetVariables(variables:Object):void
		{
			var index:int = this.getFilterIndex();
			var filter:ColorMatrixFilter = _target.filters[index] as ColorMatrixFilter;
			for each(var value:String in _tweenKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					var matrix:Array = filter.matrix;
					matrix[_tweenKeys.indexOf(value)] = variables[value];
					filter.matrix = matrix;
				}
			}
			this.setFilter(filter);
		}
	}
}
