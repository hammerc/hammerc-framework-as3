/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.animation
{
	import flash.events.IEventDispatcher;
	
	import org.hammerc.archer.clock.IClockClient;
	import org.hammerc.archer.clock.IClockManager;
	
	/**
	 * <code>IAnimation</code> 接口定义了基于时间播放的动画控制对象应有的属性及方法.
	 * @author wizardc
	 */
	public interface IAnimation extends IEventDispatcher, IClockClient, IAnimationController
	{
		/**
		 * 设置或获取时钟管理器.
		 */
		function set clockManager(value:IClockManager):void;
		function get clockManager():IClockManager;
		
		/**
		 * 设置或获取目标动画对象.
		 */
		function set target(value:IAnimatable):void;
		function get target():IAnimatable;
		
		/**
		 * 设置或获取帧率.
		 */
		function set frameRate(value:Number):void;
		function get frameRate():Number;
	}
}
