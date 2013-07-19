/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	
	/**
	 * <code>TimelineEvent</code> 类定义了时间轴的事件.
	 * @see org.hammerc.tween.Timeline
	 * @author wizardc
	 */
	public class TimelineEvent extends TweenEvent
	{
		/**
		 * 时间轴开始时广播该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>yoyoReverse</code></td><td>当前的缓动是否正在反向播放中.</td></tr>
		 *   <tr><td><code>repeat</code></td><td>当前的缓动的重复播放次数.</td></tr>
		 *   <tr><td><code>data</code></td><td>缓动对象的附加资料.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType timelineStart
		 */
		public static const TIMELINE_START:String = "timelineStart";
		
		/**
		 * 时间轴每帧更新时广播该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>yoyoReverse</code></td><td>当前的缓动是否正在反向播放中.</td></tr>
		 *   <tr><td><code>repeat</code></td><td>当前的缓动的重复播放次数.</td></tr>
		 *   <tr><td><code>data</code></td><td>缓动对象的附加资料.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType timelineUpdate
		 */
		public static const TIMELINE_UPDATE:String = "timelineUpdate";
		
		/**
		 * 时间轴完成时广播该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>yoyoReverse</code></td><td>当前的缓动是否正在反向播放中.</td></tr>
		 *   <tr><td><code>repeat</code></td><td>当前的缓动的重复播放次数.</td></tr>
		 *   <tr><td><code>data</code></td><td>缓动对象的附加资料.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType timelineComplete
		 */
		public static const TIMELINE_COMPLETE:String = "timelineComplete";
		
		/**
		 * 时间轴重复开始播放时广播该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>yoyoReverse</code></td><td>当前的缓动是否正在反向播放中.</td></tr>
		 *   <tr><td><code>repeat</code></td><td>当前的缓动的重复播放次数.</td></tr>
		 *   <tr><td><code>data</code></td><td>缓动对象的附加资料.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType timelineRepeat
		 */
		public static const TIMELINE_REPEAT:String = "timelineRepeat";
		
		/**
		 * 时间轴反向播放完成时广播该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>yoyoReverse</code></td><td>当前的缓动是否正在反向播放中.</td></tr>
		 *   <tr><td><code>repeat</code></td><td>当前的缓动的重复播放次数.</td></tr>
		 *   <tr><td><code>data</code></td><td>缓动对象的附加资料.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType timelineYoyoComplete
		 */
		public static const TIMELINE_YOYO_COMPLETE:String = "timelineYoyoComplete";
		
		/**
		 * 创建一个 <code>TimelineEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param yoyoReversed 缓动是否正在反向播放中.
		 * @param repeat 缓动的重复播放次数.
		 * @param data 时间轴对象的附加资料.
		 */
		public function TimelineEvent(type:String, yoyoReverse:Boolean = false, repeat:int = 0, data:* = null)
		{
			super(type, yoyoReverse, repeat, data);
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new TimelineEvent(this.type, this.yoyoReverse, this.repeat, this.data);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("TimelineEvent", "type", "bubbles", "cancelable", "yoyoReverse", "repeat", "data");
		}
	}
}
