/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.events.Event;
	
	import org.hammerc.components.supportClasses.Range;
	import org.hammerc.events.UIEvent;
	
	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * <code>Spinner</code> 类实现了从有序集中选择值的组件.
	 * @author wizardc
	 */
	public class Spinner extends Range
	{
		/**
		 * 皮肤子件, 减小按钮.
		 */
		public var decrementButton:Button;
		
		/**
		 * 皮肤子件, 增大按钮.
		 */
		public var incrementButton:Button;
		
		private var _allowValueWrap:Boolean = false;
		
		/**
		 * 创建一个 <code>Spinner</code> 对象.
		 */
		public function Spinner()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Spinner;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "Spinner";
		}
		
		/**
		 * 设置或获取值是否可循环. 如当前为最大值时再点击增加按钮是否会变成最小值.
		 */
		public function set allowValueWrap(value:Boolean):void
		{
			_allowValueWrap = value;
		}
		public function get allowValueWrap():Boolean
		{
			return _allowValueWrap;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function changeValueByStep(increase:Boolean = true):void
		{
			if(this.allowValueWrap)
			{
				if(increase && (this.value == this.maximum))
				{
					this.value = this.minimum;
				}
				else if(!increase && (this.value == this.minimum))
				{
					this.value = this.maximum;
				}
				else
				{
					super.changeValueByStep(increase);
				}
			}
			else
			{
				super.changeValueByStep(increase);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == incrementButton)
			{
				incrementButton.focusEnabled = false;
				incrementButton.addEventListener(UIEvent.BUTTON_DOWN, incrementButton_buttonDownHandler);
				incrementButton.autoRepeat = true;
			}
			else if(instance == decrementButton)
			{
				decrementButton.focusEnabled = false;
				decrementButton.addEventListener(UIEvent.BUTTON_DOWN, decrementButton_buttonDownHandler);
				decrementButton.autoRepeat = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == incrementButton)
			{
				incrementButton.removeEventListener(UIEvent.BUTTON_DOWN, incrementButton_buttonDownHandler);
			}
			else if(instance == decrementButton)
			{
				decrementButton.removeEventListener(UIEvent.BUTTON_DOWN, decrementButton_buttonDownHandler);
			}
		}
		
		/**
		 * 鼠标在增大按钮上按下的事件.
		 */
		protected function incrementButton_buttonDownHandler(event:UIEvent):void
		{
			var prevValue:Number = this.value;
			this.changeValueByStep(true);
			if(this.value != prevValue)
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 鼠标在减小按钮上按下的事件.
		 */
		protected function decrementButton_buttonDownHandler(event:UIEvent):void
		{
			var prevValue:Number = this.value;
			this.changeValueByStep(false);
			if(this.value != prevValue)
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}
