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
	import flash.events.Event;
	
	import org.hammerc.core.IUIComponent;
	
	/**
	 * <code>PopUpEvent</code> 类为弹出的事件类.
	 * @author wizardc
	 */
	public class PopUpEvent extends Event
	{
		/**
		 * 添加一个弹出框时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>popUp</code></td><td>弹出框对象.</td></tr>
		 *   <tr><td><code>modal</code></td><td>弹出窗口是否为模态.</td></tr>
		 * </table>
		 * @eventType addPopUp
		 */
		public static const ADD_POPUP:String = "addPopUp";
		
		/**
		 * 移除一个弹出框时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>popUp</code></td><td>弹出框对象.</td></tr>
		 *   <tr><td><code>modal</code></td><td>弹出窗口是否为模态.</td></tr>
		 * </table>
		 * @eventType removePopUp
		 */
		public static const REMOVE_POPUP:String = "removePopUp";
		
		/**
		 * 移动弹出框到最前时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>popUp</code></td><td>弹出框对象.</td></tr>
		 *   <tr><td><code>modal</code></td><td>弹出窗口是否为模态.</td></tr>
		 * </table>
		 * @eventType bringToFront
		 */
		public static const BRING_TO_FRONT:String = "bringToFront";
		
		private var _popUp:IUIComponent;
		private var _modal:Boolean;
		
		/**
		 * 创建一个 <code>PopUpEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param popUp 弹出框对象.
		 * @param modal 弹出窗口是否为模态.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 */
		public function PopUpEvent(type:String, popUp:IUIComponent = null, modal:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_popUp = popUp;
			_modal = modal;
		}
		
		/**
		 * 获取弹出框对象.
		 */
		public function get popUp():IUIComponent
		{
			return _popUp;
		}
		
		/**
		 * 获取弹出窗口是否为模态.
		 */
		public function get modal():Boolean
		{
			return _modal;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new PopUpEvent(this.type, this.popUp, this.modal, this.bubbles, this.cancelable);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("PopUpEvent", "type", "bubbles", "cancelable", "popUp", "modal");
		}
	}
}
