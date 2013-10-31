/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.events
{
	import flash.events.Event;
	
	import org.hammerc.components.IItemRenderer;
	
	/**
	 * <code>RendererExistenceEvent</code> 类在 <code>DataGroup</code> 对象添加或删除项呈示器时播放的事件类.
	 * @author wizardc
	 */
	public class RendererExistenceEvent extends Event
	{
		/**
		 * 添加了项呈示器时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>data</code></td><td>呈示器的数据项目.</td></tr>
		 *   <tr><td><code>index</code></td><td>已添加或删除呈示器的位置的索引.</td></tr>
		 *   <tr><td><code>renderer</code></td><td>已添加或删除的项呈示器.</td></tr>
		 * </table>
		 * @eventType rendererAdd
		 */
		public static const RENDERER_ADD:String = "rendererAdd";
		
		/**
		 * 移除了项呈示器时会播放该事件.
		 * <p>此事件具有以下属性:</p>
		 * <table class="innertable">
		 *   <tr><th>Property</th><th>Value</th></tr>
		 *   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
		 *   <tr><td><code>currentTarget</code></td><td>当前正在使用某个事件侦听器处理该事件的对象.</td></tr>
		 *   <tr><td><code>target</code></td><td>发送该事件的对象.</td></tr>
		 *   <tr><td><code>data</code></td><td>呈示器的数据项目.</td></tr>
		 *   <tr><td><code>index</code></td><td>已添加或删除呈示器的位置的索引.</td></tr>
		 *   <tr><td><code>renderer</code></td><td>已添加或删除的项呈示器.</td></tr>
		 * </table>
		 * @eventType rendererRemove
		 */
		public static const RENDERER_REMOVE:String = "rendererRemove";
		
		private var _data:Object;
		private var _index:int;
		private var _renderer:IItemRenderer;
		
		/**
		 * 创建一个 <code>RendererExistenceEvent</code> 对象.
		 * @param type 事件的类型.
		 * @param data 呈示器的数据项目.
		 * @param index 已添加或删除呈示器的位置的索引.
		 * @param renderer 已添加或删除的项呈示器.
		 * @param bubbles 是否参与事件流的冒泡阶段.
		 * @param cancelable 是否可以取消事件对象.
		 */
		public function RendererExistenceEvent(type:String, data:Object = null, index:int = -1, renderer:IItemRenderer = null, bubbles:Boolean = false,cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_data = data;
			_index = index;
			_renderer = renderer;
		}
		
		/**
		 * 获取呈示器的数据项目.
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 获取已添加或删除呈示器的位置的索引.
		 */
		public function get index():int
		{
			return _index;
		}
		
		/**
		 * 获取已添加或删除的项呈示器.
		 */
		public function get renderer():IItemRenderer
		{
			return _renderer;
		}
		
		/**
		 * 创建本事件对象的副本, 并设置每个属性的值以匹配原始属性值.
		 * @return 其属性值与原始属性值匹配的新对象.
		 */
		override public function clone():Event
		{
			return new RendererExistenceEvent(this.type, this.data, this.index, this.renderer, this.bubbles, this.cancelable);
		}
		
		/**
		 * 返回一个描述本对象的字符串.
		 * @return 一个字符串, 其中包含本对象的描述.
		 */
		override public function toString():String
		{
			return this.formatToString("RendererExistenceEvent", "type", "bubbles", "cancelable", "data", "index", "renderer");
		}
	}
}
