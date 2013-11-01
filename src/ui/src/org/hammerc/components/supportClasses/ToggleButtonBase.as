/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.events.Event;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.UIEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.VALUE_COMMIT
	 */
	[Event(name="valueCommit", type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>ToggleButtonBase</code> 类为切换按钮组件基类.
	 * @author wizardc
	 */
	public class ToggleButtonBase extends ButtonBase
	{
		private var _selected:Boolean;
		
		/**
		 * 是否根据鼠标事件自动变换选中状态,默认true。
		 */
		hammerc_internal var _autoSelected:Boolean = true;
		
		/**
		 * 创建一个 <code>ToggleButtonBase</code> 对象.
		 */
		public function ToggleButtonBase()
		{
			super();
		}
		
		/**
		 * 设置或获取按钮是否处于按下状态.
		 */
		public function set selected(value:Boolean):void
		{
			if(value == _selected)
			{
				return;
			}
			_selected = value;
			this.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			this.invalidateSkinState();
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			if(!this.selected)
			{
				return super.getCurrentSkinState();
			}
			else
			{
				return super.getCurrentSkinState() + "AndSelected";
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buttonReleased():void
		{
			if(!this.enabled)
			{
				return;
			}
			super.buttonReleased();
			if(!this._autoSelected)
			{
				return;
			}
			this.selected = !this.selected;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
