// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.tween
{
	import org.hammerc.tween.plugins.ITweenPlugin;
	
	/**
	 * <code>TweenItem</code> 类记录一个属性的缓动数据.
	 * @author wizardc
	 */
	public class TweenItem
	{
		/**
		 * 维护该对象的缓动对象.
		 */
		protected var _master:AbstractTween;
		
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
		 * 缓动项被补丁支持则对应处理该项目的补丁对象.
		 */
		protected var _plugin:ITweenPlugin;
		
		/**
		 * 创建一个 <code>TweenItem</code> 对象.
		 * @param master 维护该对象的缓动对象.
		 * @param property 要进行缓动的属性名称.
		 * @param start 缓动开始时的值.
		 * @param change 缓动的变化量.
		 * @param plugin 缓动项被补丁支持则对应处理该项目的补丁对象.
		 */
		public function TweenItem(master:AbstractTween = null, property:String = null, start:Number = 0, change:Number = 0, plugin:ITweenPlugin = null)
		{
			_master = master;
			_property = property;
			_start = start;
			_change = change;
			_plugin = plugin;
		}
		
		/**
		 * 设置或获取维护该对象的缓动对象.
		 */
		public function set master(value:AbstractTween):void
		{
			_master = value;
		}
		public function get master():AbstractTween
		{
			return _master;
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
		
		/**
		 * 设置或获取缓动项被补丁支持则对应处理该项目的补丁对象.
		 */
		public function set plugin(value:ITweenPlugin):void
		{
			_plugin = value;
		}
		public function get plugin():ITweenPlugin
		{
			return _plugin;
		}
	}
}
