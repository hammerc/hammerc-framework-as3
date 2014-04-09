/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.animator
{
	/**
	 * <code>IAnimationController</code> 接口定义了动画控制应有的属性及方法.
	 * @author wizardc
	 */
	public interface IAnimationController
	{
		/**
		 * 设置或获取是否循环播放.
		 */
		function set repeatPlay(value:Boolean):void;
		function get repeatPlay():Boolean;
		
		/**
		 * 获取当前是否正在播放.
		 */
		function get isPlaying():Boolean;
		
		/**
		 * 跳到指定帧并播放.
		 * @param frame 帧索引, 从 1 开始.
		 */
		function gotoAndPlay(frame:Number):void;
		
		/**
		 * 跳到指定帧并停止.
		 * @param frame 帧索引, 从 1 开始.
		 */
		function gotoAndStop(frame:Number):void;
		
		/**
		 * 开始播放.
		 */
		function play():void;
		
		/**
		 * 停止播放.
		 */
		function stop():void;
	}
}
