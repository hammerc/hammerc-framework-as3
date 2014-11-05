// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.events
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.hammerc.components.IItemRenderer;
	
	/**
	 * <code>ListEvent</code> 类为列表的事件类.
	 * @author wizardc
	 */
	public class ListEvent extends MouseEvent
	{
		/**
		 * 指示用户执行了将鼠标指针从控件中某个项呈示器上移开的操作.
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
		 *   <tr><td><code>item</code></td><td>触发鼠标事件的项索引.</td></tr>
		 *   <tr><td><code>itemRenderer</code></td><td>触发鼠标事件的项呈示器数据源项.</td></tr>
		 *   <tr><td><code>itemIndex</code></td><td>触发鼠标事件的项呈示器.</td></tr>
		 * </table>
		 * @eventType itemRollOut
		 */
		public static const ITEM_ROLL_OUT:String = "itemRollOut";
		
		/**
		 * 指示用户执行了将鼠标指针滑过控件中某个项呈示器的操作.
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
		 *   <tr><td><code>item</code></td><td>触发鼠标事件的项索引.</td></tr>
		 *   <tr><td><code>itemRenderer</code></td><td>触发鼠标事件的项呈示器数据源项.</td></tr>
		 *   <tr><td><code>itemIndex</code></td><td>触发鼠标事件的项呈示器.</td></tr>
		 * </table>
		 * @eventType itemRollOver
		 */
		public static const ITEM_ROLL_OVER:String = "itemRollOver";
		
		/**
		 * 指示用户执行了将鼠标在某个项呈示器上单击的操作.
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
		 *   <tr><td><code>item</code></td><td>触发鼠标事件的项索引.</td></tr>
		 *   <tr><td><code>itemRenderer</code></td><td>触发鼠标事件的项呈示器数据源项.</td></tr>
		 *   <tr><td><code>itemIndex</code></td><td>触发鼠标事件的项呈示器.</td></tr>
		 * </table>
		 * @eventType itemClick
		 */
		public static const ITEM_CLICK:String = "itemClick";
		
		private var _item:Object;
		private var _itemRenderer:IItemRenderer;
		private var _itemIndex:int;
		
		/**
		 * 创建一个 <code>ListEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 * @param localX 事件发生点的相对于当前目标对象的水平坐标.
		 * @param localY 事件发生点的相对于当前目标对象的垂直坐标.
		 * @param relatedObject 受事件影响的补充 <code>InteractiveObject</code> 实例.
		 * @param ctrlKey 指示是否已激活 Ctrl 键.
		 * @param altKey 指示是否已激活 Alt 键(仅限 Windows).
		 * @param shiftKey 指示是否已激活 Shift 键.
		 * @param buttonDown 指示是否按下了鼠标主按键.
		 * @param delta 指示用户将鼠标滚轮每滚动一个单位应滚动多少行.
		 * @param itemIndex 触发鼠标事件的项索引.
		 * @param item 触发鼠标事件的项呈示器数据源项.
		 * @param itemRenderer 触发鼠标事件的项呈示器.
		 */
		public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, localX:Number = NaN, localY:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0, itemIndex:int = -1, item:Object = null, itemRenderer:IItemRenderer = null)
		{
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
			_itemIndex = itemIndex;
			_item = item;
			_itemRenderer = itemRenderer;
		}
		
		/**
		 * 获取触发鼠标事件的项呈示器数据源项.
		 */
		public function get item():Object
		{
			return _item;
		}
		
		/**
		 * 获取触发鼠标事件的项呈示器.
		 */
		public function get itemRenderer():IItemRenderer
		{
			return _itemRenderer;
		}
		
		/**
		 * 获取触发鼠标事件的项索引.
		 */
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			var cloneEvent:ListEvent = new ListEvent(this.type, this.bubbles, this.cancelable, this.localX, this.localY, this.relatedObject, this.ctrlKey, this.altKey, this.shiftKey, this.buttonDown, this.delta, this.itemIndex, this.item, this.itemRenderer);
			cloneEvent.relatedObject = this.relatedObject;
			return cloneEvent;
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("ListEvent", "type", "bubbles", "cancelable", "localX", "localY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "buttonDown", "delta", "item", "itemRenderer", "itemIndex");
		}
	}
}
