/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.events.Event;
	
	import org.hammerc.components.supportClasses.ToggleButtonBase;
	
	/**
	 * <code>TabBarButton</code> 类为选项卡组件的按钮条目.
	 * @author wizardc
	 */
	public class TabBarButton extends ToggleButtonBase implements IItemRenderer
	{
		private var _allowDeselection:Boolean = true;
		
		private var _data:Object;
		
		private var _itemIndex:int;
		
		/**
		 * 创建一个 <code>TabBarButton</code> 对象.
		 */
		public function TabBarButton()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TabBarButton;
		}
		
		/**
		 * 设置或获取用户单击当前选定的按钮时是否会取消其选择.
		 */
		public function set allowDeselection(value:Boolean):void
		{
			_allowDeselection = value;
		}
		public function get allowDeselection():Boolean
		{
			return _allowDeselection;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set data(value:Object):void
		{
			_data = value;
			this.dispatchEvent(new Event("dataChange"));
		}
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buttonReleased():void
		{
			if(this.selected && !this.allowDeselection)
			{
				return;
			}
			super.buttonReleased();
		}
	}
}
