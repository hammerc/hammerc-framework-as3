/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.plugins.geom
{
	/**
	 * <code>MatrixPlugin</code> 类定义了支持转换矩阵的补丁.
	 * @author wizardc
	 */
	public class MatrixPlugin extends AbstractGeometryPlugin
	{
		/**
		 * 作用于 <code>Transform</code> 对象上的属性名称.
		 */
		public static const TRANSFORM_KEY:String = "matrix";
		
		/**
		 * 补丁对象的键名.
		 */
		public static const PLUGIN_KEY:String = "matrix";
		
		/**
		 * 缓动属性的列表.
		 */
		public static const TWEEN_KEYS:Vector.<String> = new <String>["a", "b", "c", "d", "tx", "ty"];
		
		/**
		 * 用来设置的键名列表.
		 */
		public static const SETTING_KEYS:Vector.<String> = new <String>[];
		
		/**
		 * 创建一个 <code>MatrixPlugin</code> 对象.
		 */
		public function MatrixPlugin()
		{
			super(TRANSFORM_KEY, PLUGIN_KEY, TWEEN_KEYS, SETTING_KEYS);
		}
	}
}
