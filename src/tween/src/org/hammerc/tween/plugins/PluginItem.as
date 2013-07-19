/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.plugins
{
	/**
	 * <code>PluginItem</code> 类记录一个属性的缓动数据.
	 * @author wizardc
	 */
	public class PluginItem
	{
		/**
		 * 要进行缓动的属性名称.
		 */
		protected var _property:String;
		
		/**
		 * 缓动开始时的值.
		 */
		protected var _start:Number;
		
		/**
		 * 缓动的变化量.
		 */
		protected var _change:Number;
		
		/**
		 * 创建一个 <code>PluginItem</code> 对象.
		 * @param property 要进行缓动的属性名称.
		 * @param start 缓动开始时的值.
		 * @param change 缓动的变化量.
		 */
		public function PluginItem(property:String = null, start:Number = 0, change:Number = 0)
		{
			_property = property;
			_start = start;
			_change = change;
		}
		
		/**
		 * 设置或获取要进行缓动的属性名称.
		 */
		public function set property(value:String):void
		{
			_property = value;
		}
		public function get property():String
		{
			return _property;
		}
		
		/**
		 * 设置或获取缓动开始时的值.
		 */
		public function set start(value:Number):void
		{
			_start = value;
		}
		public function get start():Number
		{
			return _start;
		}
		
		/**
		 * 设置或获取缓动的变化量.
		 */
		public function set change(value:Number):void
		{
			_change = value;
		}
		public function get change():Number
		{
			return _change;
		}
	}
}
