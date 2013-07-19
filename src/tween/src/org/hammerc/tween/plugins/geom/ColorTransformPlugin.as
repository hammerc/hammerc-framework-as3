/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.plugins.geom
{
	/**
	 * <code>ColorTransformPlugin</code> 类定义了支持颜色转换的补丁.
	 * @author wizardc
	 */
	public class ColorTransformPlugin extends AbstractGeometryPlugin
	{
		/**
		 * 作用于 <code>Transform</code> 对象上的属性名称.
		 */
		public static const TRANSFORM_KEY:String = "colorTransform";
		
		/**
		 * 补丁对象的键名.
		 */
		public static const PLUGIN_KEY:String = "colorTransform";
		
		/**
		 * 缓动属性的列表.
		 */
		public static const TWEEN_KEYS:Vector.<String> = new <String>["alphaMultiplier", "alphaOffset", "blueMultiplier", "blueOffset", "greenMultiplier", "greenOffset", "redMultiplier", "redOffset"];
		
		/**
		 * 用来设置的键名列表.
		 */
		public static const SETTING_KEYS:Vector.<String> = new <String>["color"];
		
		/**
		 * 创建一个 <code>ColorTransformPlugin</code> 对象.
		 */
		public function ColorTransformPlugin()
		{
			super(TRANSFORM_KEY, PLUGIN_KEY, TWEEN_KEYS, SETTING_KEYS);
		}
	}
}
