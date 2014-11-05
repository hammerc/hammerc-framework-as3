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
	import flash.filters.BevelFilter;
	
	/**
	 * <code>BevelFilterPlugin</code> 类定义了支持斜角滤镜的补丁.
	 * @author wizardc
	 */
	public class BevelFilterPlugin extends AbstractFilterPlugin
	{
		/**
		 * 补丁支持的滤镜类对象.
		 */
		public static const FILTER_CLASS:Class = BevelFilter;
		
		/**
		 * 补丁对象的键名.
		 */
		public static const PLUGIN_KEY:String = "bevelFilter";
		
		/**
		 * 缓动属性的列表.
		 */
		public static const TWEEN_KEYS:Vector.<String> = new <String>["alpha", "blurX", "blurY", "distance", "highlightAlpha", "shadowAlpha", "strength"];
		
		/**
		 * 用来设置的键名列表.
		 */
		public static const SETTING_KEYS:Vector.<String> = new <String>["highlightColor", "knockout", "quality", "shadowColor", "type"];
		
		/**
		 * 创建一个 <code>BevelFilterPlugin</code> 对象.
		 */
		public function BevelFilterPlugin()
		{
			super(FILTER_CLASS, PLUGIN_KEY, TWEEN_KEYS, SETTING_KEYS);
		}
	}
}
