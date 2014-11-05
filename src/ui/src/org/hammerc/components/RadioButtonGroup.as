// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.UIComponent;
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
	 * <code>RadioButtonGroup</code> 类实现了单选按钮组对象.
	 * @author wizardc
	 */
	public class RadioButtonGroup extends EventDispatcher
	{
		private static var _groupCount:int = 0;
		
		/**
		 * 组名.
		 */
		hammerc_internal var _name:String;
		
		/**
		 * 单选按钮列表.
		 */
		private var _radioButtons:Array  = [];
		
		private var _enabled:Boolean = true;
		
		private var _selectedValue:Object;
		
		private var _selection:RadioButton;
		
		/**
		 * 创建一个 <code>RadioButtonGroup</code> 对象.
		 */
		public function RadioButtonGroup()
		{
			super();
			_name = "radioButtonGroup" + _groupCount;
			_groupCount++;
		}
		
		/**
		 * 设置或获取组件是否可以接受用户交互. 默认值为true. 设置此属性将影响组内所有单选按钮.
		 */
		public function set enabled(value:Boolean):void
		{
			if(_enabled == value)
			{
				return;
			}
			_enabled = value;
			for(var i:int = 0; i < this.numRadioButtons; i++)
			{
				this.getRadioButtonAt(i).invalidateSkinState();
			}
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * 组内单选按钮数量.
		 */
		public function get numRadioButtons():int
		{
			return _radioButtons.length;
		}
		
		/**
		 * 设置或获取当前被选中的单选按钮的 value 属性值. 注意, 此属性仅当目标 <code>RadioButton</code> 在显示列表时有效.
		 */
		public function set selectedValue(value:Object):void
		{
			_selectedValue = value;
			if(value == null)
			{
				this.setSelection(null, false);
				return;
			}
			var n:int = this.numRadioButtons;
			for(var i:int = 0; i < n; i++)
			{
				var radioButton:RadioButton = this.getRadioButtonAt(i);
				if (radioButton.value == value || radioButton.label == value)
				{
					changeSelection(i, false);
					_selectedValue = null;
					this.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
					break;
				}
			}
		}
		public function get selectedValue():Object
		{
			if(this.selection)
			{
				return this.selection.value != null ? this.selection.value : this.selection.label;
			}
			return null;
		}
		
		/**
		 * 设置或获取当前被选中的单选按钮引用. 注意, 此属性仅当目标 <code>RadioButton</code> 在显示列表时有效.
		 */
		public function set selection(value:RadioButton):void
		{
			if( _selection == value)
			{
				return;
			}
			this.setSelection(value, false);
		}
		public function get selection():RadioButton
		{
			return _selection;
		}
		
		/**
		 * 获取指定索引的单选按钮.
		 * @param index 单选按钮的索引.
		 */
		public function getRadioButtonAt(index:int):RadioButton
		{
			if(index >= 0 && index < this.numRadioButtons)
			{
				return _radioButtons[index];
			}
			return null;
		}
		
		/**
		 * 添加单选按钮到组内.
		 * @param instance 要添加的单选按钮.
		 */
		hammerc_internal function addInstance(instance:RadioButton):void
		{
			instance.addEventListener(Event.REMOVED, radioButton_removedHandler);
			_radioButtons.push(instance);
			_radioButtons.sort(breadthOrderCompare);
			for(var i:int = 0; i < _radioButtons.length; i++)
			{
				_radioButtons[i]._indexNumber = i;
			}
			if(_selectedValue != null)
			{
				selectedValue = _selectedValue;
			}
			if(instance.selected == true)
			{
				selection = instance;
			}
			instance._radioButtonGroup = this;
			instance.invalidateSkinState();
			this.dispatchEvent(new Event("numRadioButtonsChanged"));
		}
		
		/**
		 * 从组里移除单选按钮.
		 * @param instance 要移除的单选按钮.
		 */
		hammerc_internal function removeInstance(instance:RadioButton):void
		{
			doRemoveInstance(instance, false);
		}
		
		/**
		 * 执行从组里移除单选按钮.
		 */
		private function doRemoveInstance(instance:RadioButton, addListener:Boolean = true):void
		{
			if(instance != null)
			{
				var foundInstance:Boolean = false;
				for(var i:int = 0; i < this.numRadioButtons; i++)
				{
					var rb:RadioButton = this.getRadioButtonAt(i);
					if(foundInstance)
					{
						rb._indexNumber = rb._indexNumber - 1;
					}
					else if(rb == instance)
					{
						if(addListener)
						{
							instance.addEventListener(Event.ADDED, radioButton_addedHandler);
						}
						if(instance == _selection)
						{
							_selection = null;
						}
						instance._radioButtonGroup = null;
						instance.invalidateSkinState();
						_radioButtons.splice(i, 1);
						foundInstance = true;
						i--;
					}
				}
				if(foundInstance)
				{
					this.dispatchEvent(new Event("numRadioButtonsChanged"));
				}
			}
		}
		
		/**
		 * 设置选中的单选按钮.
		 */
		hammerc_internal function setSelection(value:RadioButton, fireChange:Boolean = true):void
		{
			if(_selection == value)
			{
				return;
			}
			if(value == null)
			{
				if(this.selection != null)
				{
					_selection.selected = false;
					_selection = null;
					if(fireChange)
					{
						this.dispatchEvent(new Event(Event.CHANGE));
					}
				}
			}
			else
			{
				var n:int = this.numRadioButtons;
				for(var i:int = 0; i < n; i++)
				{
					if(value == this.getRadioButtonAt(i))
					{
						changeSelection(i, fireChange);
						break;
					}
				}
			}
			this.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
		}
		
		/**
		 * 改变选中项.
		 */
		private function changeSelection(index:int, fireChange:Boolean = true):void
		{
			var rb:RadioButton = getRadioButtonAt(index);
			if(rb != null && rb != _selection)
			{
				if(_selection != null)
				{
					_selection.selected = false;
				}
				_selection = rb;
				_selection.selected = true;
				if(fireChange)
				{
					this.dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		/**
		 * 显示对象深度排序.
		 */
		private function breadthOrderCompare(a:DisplayObject, b:DisplayObject):Number
		{
			var aParent:DisplayObjectContainer = a.parent;
			var bParent:DisplayObjectContainer = b.parent;
			if(aParent == null || bParent == null)
			{
				return 0;
			}
			var aNestLevel:int = (a is UIComponent) ? UIComponent(a).nestLevel : -1;
			var bNestLevel:int = (b is UIComponent) ? UIComponent(b).nestLevel : -1;
			var aIndex:int = 0;
			var bIndex:int = 0;
			if(aParent == bParent)
			{
				if(aParent is IUIContainer && a is IUIComponent)
				{
					aIndex = IUIContainer(aParent).getElementIndex(IUIComponent(a));
				}
				else
				{
					aIndex = DisplayObjectContainer(aParent).getChildIndex(a);
				}
				if(bParent is IUIContainer && b is IUIComponent)
				{
					bIndex = IUIContainer(bParent).getElementIndex(IUIComponent(b));
				}
				else
				{
					bIndex = DisplayObjectContainer(bParent).getChildIndex(b);
				}
			}
			if(aNestLevel > bNestLevel || aIndex > bIndex)
			{
				return 1;
			}
			else if(aNestLevel < bNestLevel ||  bIndex > aIndex)
			{
				return -1;
			}
			else if(a == b)
			{
				return 0;
			}
			else 
			{
				return breadthOrderCompare(aParent, bParent);
			}
		}
		
		/**
		 * 单选按钮添加到显示列表.
		 */
		private function radioButton_addedHandler(event:Event):void
		{
			var rb:RadioButton = event.target as RadioButton;
			if(rb != null)
			{
				rb.removeEventListener(Event.ADDED, radioButton_addedHandler);
				this.addInstance(rb);
			}
		}
		
		/**
		 * 单选按钮从显示列表移除.
		 */
		private function radioButton_removedHandler(event:Event):void
		{
			var rb:RadioButton = event.target as RadioButton;
			if(rb != null)
			{
				rb.removeEventListener(Event.REMOVED, radioButton_removedHandler);
				doRemoveInstance(rb);
			}
		}
	}
}
