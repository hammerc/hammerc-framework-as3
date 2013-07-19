/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.plugins.filters
{
	import flash.filters.GlowFilter;
	
	/**
	 * <code>GlowFilterPlugin</code> 类定义了支持发光滤镜的补丁.
	 * @author wizardc
	 */
	public class GlowFilterPlugin extends AbstractFilterPlugin
	{
		/**
		 * 补丁支持的滤镜类对象.
		 */
		public static const FILTER_CLASS:Class = GlowFilter;
		
		/**
		 * 补丁对象的键名.
		 */
		public static const PLUGIN_KEY:String = "glowFilter";
		
		/**
		 * 缓动属性的列表.
		 */
		public static const TWEEN_KEYS:Vector.<String> = new <String>["alpha", "blurX", "blurY", "strength"];
		
		/**
		 * 用来设置的键名列表.
		 */
		public static const SETTING_KEYS:Vector.<String> = new <String>["color", "inner", "knockout", "quality"];
		
		/**
		 * 创建一个 <code>GlowFilterPlugin</code> 对象.
		 */
		public function GlowFilterPlugin()
		{
			super(FILTER_CLASS, PLUGIN_KEY, TWEEN_KEYS, SETTING_KEYS);
		}
	}
}
