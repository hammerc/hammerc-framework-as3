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
	import flash.filters.BlurFilter;
	
	/**
	 * <code>BlurFilterPlugin</code> 类定义了支持模糊滤镜的补丁.
	 * @author wizardc
	 */
	public class BlurFilterPlugin extends AbstractFilterPlugin
	{
		/**
		 * 补丁支持的滤镜类对象.
		 */
		public static const FILTER_CLASS:Class = BlurFilter;
		
		/**
		 * 补丁对象的键名.
		 */
		public static const PLUGIN_KEY:String = "blurFilter";
		
		/**
		 * 缓动属性的列表.
		 */
		public static const TWEEN_KEYS:Vector.<String> = new <String>["blurX", "blurY"];
		
		/**
		 * 用来设置的键名列表.
		 */
		public static const SETTING_KEYS:Vector.<String> = new <String>["quality"];
		
		/**
		 * 创建一个 <code>BlurFilterPlugin</code> 对象.
		 */
		public function BlurFilterPlugin()
		{
			super(FILTER_CLASS, PLUGIN_KEY, TWEEN_KEYS, SETTING_KEYS);
		}
	}
}
