/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.animation
{
	/**
	 * <code>IAnimatable</code> 接口定义了基于时间播放的动画对象应有的属性及方法.
	 * @author wizardc
	 */
	public interface IAnimatable
	{
		/**
		 * 获取当前播放到的帧索引, 从 1 开始.
		 */
		function get currentFrame():int;
		
		/**
		 * 获取动画的总帧数.
		 * <p>提供给持有本对象的 <code>IAnimation</code> 对象使用, 修改本对象的显示动画源也要更新该属性.</p>
		 */
		function get totalFrames():int;
		
		/**
		 * 获取指定帧的音效标识.
		 * @param frame 指定的帧数.
		 * @return 音效标识.
		 */
		function getSoundAt(frame:int):String;
		
		/**
		 * 获取指定帧的帧标签.
		 * @param frame 指定的帧数.
		 * @return 帧标签.
		 */
		function getLabelAt(frame:int):String;
		
		/**
		 * 显示指定帧图像.
		 * @param frameIndex 指定的帧数.
		 */
		function showFrame(frameIndex:int):void;
	}
}
