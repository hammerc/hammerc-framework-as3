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
	import flash.filters.DropShadowFilter;
	
	/**
	 * <code>DropShadowFilterPlugin</code> 类定义了支持投影滤镜的补丁.
	 * @author wizardc
	 */
	public class DropShadowFilterPlugin extends AbstractFilterPlugin
	{
		/**
		 * 补丁支持的滤镜类对象.
		 */
		public static const FILTER_CLASS:Class = DropShadowFilter;
		
		/**
		 * 补丁对象的键名.
		 */
		public static const PLUGIN_KEY:String = "dropShadowFilter";
		
		/**
		 * 缓动属性的列表.
		 */
		public static const TWEEN_KEYS:Vector.<String> = new <String>["alpha", "angle", "blurX", "blurY", "distance", "strength"];
		
		/**
		 * 用来设置的键名列表.
		 */
		public static const SETTING_KEYS:Vector.<String> = new <String>["color", "hideObject", "inner", "knockout", "quality"];
		
		/**
		 * 创建一个 <code>DropShadowFilterPlugin</code> 对象.
		 */
		public function DropShadowFilterPlugin()
		{
			super(FILTER_CLASS, PLUGIN_KEY, TWEEN_KEYS, SETTING_KEYS);
		}
	}
}
