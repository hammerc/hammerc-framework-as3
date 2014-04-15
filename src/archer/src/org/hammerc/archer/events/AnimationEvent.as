/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.events
{
	import flash.events.Event;
	
	import org.hammerc.archer.animator.IAnimatable;
	
	/**
	 * <code>AnimationEvent</code> 类为动画的事件类.
	 * @author wizardc
	 */
	public class AnimationEvent extends Event
	{
		/**
		 * 播放到带有音效标识的帧时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>animatable</code></td><td>目标动画对象.</td></tr>
		 *   <tr><td><code>label</code></td><td>当前帧上的标签.</td></tr>
		 * </table>
		 * @eventType soundEvent
		 */
		public static const SOUND_EVENT:String = "soundEvent";
		
		/**
		 * 播放到带有帧标签的帧时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>animatable</code></td><td>目标动画对象.</td></tr>
		 *   <tr><td><code>label</code></td><td>当前帧上的标签.</td></tr>
		 * </table>
		 * @eventType frameEvent
		 */
		public static const FRAME_EVENT:String = "frameEvent";
		
		/**
		 * 不重复播放时播放完毕时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>animatable</code></td><td>目标动画对象.</td></tr>
		 *   <tr><td><code>label</code></td><td>当前帧上的标签.</td></tr>
		 * </table>
		 * @eventType playComplete
		 */
		public static const PLAY_COMPLETE:String = "playComplete";
		
		/**
		 * 重复播放时每播放完一遍时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>animatable</code></td><td>目标动画对象.</td></tr>
		 *   <tr><td><code>label</code></td><td>当前帧上的标签.</td></tr>
		 * </table>
		 * @eventType loopComplete
		 */
		public static const LOOP_COMPLETE:String = "loopComplete";
		
		private var _animatable:IAnimatable;
		private var _label:String;
		
		/**
		 * 创建一个 <code>AnimationEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param animatable 目标动画对象.
		 * @param label 当前帧上的标签.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 */
		public function AnimationEvent(type:String, animatable:IAnimatable, label:String = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_animatable = animatable;
			_label = label;
		}
		
		/**
		 * 获取目标动画对象.
		 */
		public function get animatable():IAnimatable
		{
			return _animatable;
		}
		
		/**
		 * 获取当前帧上的标签.
		 */
		public function get label():String
		{
			return _label;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new AnimationEvent(this.type, this.animatable, this.label, this.bubbles, this.cancelable);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("AnimationEvent", "type", "bubbles", "cancelable", "animatable", "label");
		}
	}
}
