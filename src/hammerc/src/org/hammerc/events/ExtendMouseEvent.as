/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * <code>ExtendMouseEvent</code> 类为鼠标扩展对象播放的事件类.
	 * <p>注意: 相对于自带的 <code>MouseEvent</code> 而言, 本事件并不会冒泡.</p>
	 * @author wizardc
	 */
	public class ExtendMouseEvent extends MouseEvent
	{
		/**
		 * 当鼠标在显示对象外部按下时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType mouseDownOutside
		 */
		public static const MOUSE_DOWN_OUTSIDE:String = "mouseDownOutside";
		
		/**
		 * 当鼠标在显示对象外部释放时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType mouseUpOutside
		 */
		public static const MOUSE_UP_OUTSIDE:String = "mouseUpOutside";
		
		/**
		 * 当鼠标在外部点击时触发, 即不在本对象内按下也不在本对象内释放时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType clickOutside
		 */
		public static const CLICK_OUTSIDE:String = "clickOutside";
		
		/**
		 * 当鼠标在内部释放时触发, 即不在本对象内按下但在本对象内释放时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType releaseInside
		 */
		public static const RELEASE_INSIDE:String = "releaseInside";
		
		/**
		 * 当鼠标在外部释放时触发, 即在本对象内按下但不在本对象内释放时触发.
		 * <p>Flash Player 11.3 已经提供该功能, 老版的 Flash Player 可以使用本类提供的功能实现外部释放事件.</p>
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType hammerc_releaseOutside
		 */
		public static const RELEASE_OUTSIDE:String = "hammerc_releaseOutside";
		
		/**
		 * 当鼠标双击时触发, 支持控制两次双击的间隔时间.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType doubleClickInInterval
		 */
		public static const DOUBLE_CLICK_IN_INTERVAL:String = "doubleClickInInterval";
		
		/**
		 * 当鼠标左键一直处在按下状态时, 会根据设定每隔一定时间播放一次该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType alwaysPress
		 */
		public static const ALWAYS_PRESS:String = "alwaysPress";
		
		/**
		 * 当鼠标在内部按下并移动时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType pressMove
		 */
		public static const PRESS_MOVE:String = "pressMove";
		
		/**
		 * 鼠标拖入本显示对象或子显示对象时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType dragOver
		 */
		public static const DRAG_OVER:String = "dragOver";
		
		/**
		 * 鼠标拖出本显示对象或子显示对象时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType dragOut
		 */
		public static const DRAG_OUT:String = "dragOut";
		
		/**
		 * 鼠标拖入本显示对象时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType rollDragOver
		 */
		public static const ROLL_DRAG_OVER:String = "rollDragOver";
		
		/**
		 * 鼠标拖出本显示对象时触发.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>altKey</code></td><td>如果 Alt 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>buttonDown</code></td><td>如果按下鼠标主按键, 则为 <code>true</code>; 否则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>ctrlKey</code></td><td>如果 Ctrl 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>localX</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的水平坐标.</td></tr>
		 *   <tr><td><code>localY</code></td><td>事件发生点的相对于包含 <code>Sprite</code> 的垂直坐标</td></tr>
		 *   <tr><td><code>shiftKey</code></td><td>如果 Shift 键处于活动状态, 则为 <code>true</code>; 如果处于非活动状态, 则为 <code>false</code>.</td></tr>
		 *   <tr><td><code>stageX</code></td><td>事件发生点在全局舞台坐标中的水平坐标.</td></tr>
		 *   <tr><td><code>stageY</code></td><td>事件发生点在全局舞台坐标中的垂直坐标.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 * </table>
		 * @eventType rollDragOut
		 */
		public static const ROLL_DRAG_OUT:String = "rollDragOut";
		
		/**
		 * 创建一个 <code>ExtendMouseEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param localX 事件发生点的相对于当前目标对象的水平坐标.
		 * @param localY 事件发生点的相对于当前目标对象的垂直坐标.
		 * @param relatedObject 受事件影响的补充 <code>InteractiveObject</code> 实例.
		 * @param ctrlKey 指示是否已激活 Ctrl 键.
		 * @param altKey 指示是否已激活 Alt 键(仅限 Windows).
		 * @param shiftKey 指示是否已激活 Shift 键.
		 * @param buttonDown 指示是否按下了鼠标主按键.
		 * @param delta 指示用户将鼠标滚轮每滚动一个单位应滚动多少行.
		 */
		public function ExtendMouseEvent(type:String, localX:Number = NaN, localY:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0)
		{
			super(type, false, false, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new ExtendMouseEvent(this.type, this.localX, this.localY, this.relatedObject, this.ctrlKey, this.altKey, this.shiftKey, this.buttonDown, this.delta);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("ExtendMouseEvent", "type", "bubbles", "cancelable", "localX", "localY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "buttonDown", "delta");
		}
	}
}
