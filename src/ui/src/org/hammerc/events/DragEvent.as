/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.hammerc.managers.dragClasses.DragData;
	
	/**
	 * <code>DragEvent</code> 类为拖动的事件类.
	 * @author wizardc
	 */
	public class DragEvent extends MouseEvent
	{
		/**
		 * 当拖动操作开始时, 被拖动的显示对象会播放该事件.
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
		 *   <tr><td><code>dragInitiator</code></td><td>当前正在被拖动的显示对象.</td></tr>
		 *   <tr><td><code>dragData</code></td><td>正在拖动的数据对象.</td></tr>
		 * </table>
		 * @eventType dragStart
		 */
		public static const DRAG_START:String = "dragStart";
		
		/**
		 * 当被拖动的显示对象被拖入一个显示对象并释放时或拖动操作被终止时, 被拖动的显示对象会播放该事件.
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
		 *   <tr><td><code>dragInitiator</code></td><td>当前正在被拖动的显示对象.</td></tr>
		 *   <tr><td><code>dragData</code></td><td>正在拖动的数据对象.</td></tr>
		 * </table>
		 * @eventType dragComplete
		 */
		public static const DRAG_COMPLETE:String = "dragComplete";
		
		/**
		 * 当被拖动的显示对象被拖入显示对象上方时, 下方的显示对象在鼠标拖入和移动时会播放该事件.
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
		 *   <tr><td><code>dragInitiator</code></td><td>当前正在被拖动的显示对象.</td></tr>
		 *   <tr><td><code>dragData</code></td><td>正在拖动的数据对象.</td></tr>
		 * </table>
		 * @eventType dragEnter
		 */
		public static const DRAG_ENTER:String = "dragEnter";
		
		/**
		 * 当被拖动的显示对象拖出被设置为可拖入显示对象时, 可拖入的显示对象会播放该事件.
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
		 *   <tr><td><code>dragInitiator</code></td><td>当前正在被拖动的显示对象.</td></tr>
		 *   <tr><td><code>dragData</code></td><td>正在拖动的数据对象.</td></tr>
		 * </table>
		 * @eventType dragExit
		 */
		public static const DRAG_EXIT:String = "dragExit";
		
		/**
		 * 当被拖动的显示对象被拖入设置为可拖入显示对象并释放时, 可拖入的显示对象会播放该事件.
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
		 *   <tr><td><code>dragInitiator</code></td><td>当前正在被拖动的显示对象.</td></tr>
		 *   <tr><td><code>dragData</code></td><td>正在拖动的数据对象.</td></tr>
		 * </table>
		 * @eventType dragDrop
		 */
		public static const DRAG_DROP:String = "dragDrop";
		
		/**
		 * 记录当前正在被拖动的显示对象.
		 */
		protected var _dragInitiator:DisplayObject;
		
		/**
		 * 记录正在拖动的数据对象.
		 */
		protected var _dragData:DragData;
		
		/**
		 * 创建一个 <code>DragEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param dragInitiator 当前正在被拖动的显示对象.
		 * @param dragData 正在拖动的数据对象.
		 * @param ctrlKey 指示是否已激活 Ctrl 键.
		 * @param altKey 指示是否已激活 Alt 键(仅限 Windows).
		 * @param shiftKey 指示是否已激活 Shift 键.
		 */
		public function DragEvent(type:String, dragInitiator:DisplayObject, dragData:DragData, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false)
		{
			super(type, false, false);
			_dragInitiator = dragInitiator;
			_dragData = dragData;
			this.ctrlKey = ctrlKey;
			this.altKey = altKey;
			this.shiftKey = shiftKey;
		}
		
		/**
		 * 获取当前正在被拖动的显示对象.
		 */
		public function get dragInitiator():DisplayObject
		{
			return _dragInitiator;
		}
		
		/**
		 * 获取正在拖动的数据对象.
		 */
		public function get dragData():DragData
		{
			return _dragData;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			var cloneEvent:DragEvent = new DragEvent(this.type, this.dragInitiator, this.dragData, this.ctrlKey, this.altKey, this.shiftKey);
			cloneEvent.relatedObject = this.relatedObject;
			cloneEvent.localX = this.localX;
			cloneEvent.localY = this.localY;
			return cloneEvent;
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return formatToString("DragEvent", "type", "bubbles", "cancelable", "dragInitiator", "dragData", "localX", "localY", "relatedObject", "ctrlKey", "altKey", "shiftKey");
		}
	}
}
