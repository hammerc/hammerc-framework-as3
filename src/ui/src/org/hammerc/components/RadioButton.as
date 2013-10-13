/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import org.hammerc.collections.WeakHashMap;
	import org.hammerc.components.supportClasses.ToggleButtonBase;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.UIEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>RadioButton</code> 类实现了单选按钮控件.
	 * @author wizardc
	 */
	public class RadioButton extends ToggleButtonBase
	{
		/**
		 * 存储根据 groupName 自动创建的 RadioButtonGroup 列表.
		 */
		private static var _automaticRadioButtonGroups:WeakHashMap;
		
		/**
		 * 在 RadioButtonGroup 中的索引.
		 */
		hammerc_internal var _indexNumber:int = 0;
		
		/**
		 * 所属的 RadioButtonGroup.
		 */
		hammerc_internal var _radioButtonGroup:RadioButtonGroup = null;
		
		private var _group:RadioButtonGroup;
		
		private var _groupChanged:Boolean = false;
		
		private var _groupName:String = "radioGroup";
		
		private var _value:Object;
		
		/**
		 * 创建一个 <code>RadioButton</code> 对象.
		 */
		public function RadioButton()
		{
			super();
			this.groupName = "radioGroup";
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return RadioButton;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get enabled():Boolean
		{
			if(!super.enabled)
			{
				return false;
			}
			return _radioButtonGroup == null || _radioButtonGroup.enabled;
		}
		
		/**
		 * 设置或获取此单选按钮所属的组. 若不设置此属性, 则根据 <code>groupName</code> 属性自动创建一个唯一的 <code>RadioButtonGroup</code>.
		 */
		public function set group(value:RadioButtonGroup):void
		{
			if(_group == value)
			{
				return;
			}
			if(_radioButtonGroup != null)
			{
				_radioButtonGroup.removeInstance(this);
			}
			_group = value;
			_groupName = value != null ? _group._name : "radioGroup";
			_groupChanged = true;
			this.invalidateProperties();
			this.invalidateDisplayList();
		}
		public function get group():RadioButtonGroup
		{
			if(_group == null && _groupName != null)
			{
				if(_automaticRadioButtonGroups == null)
				{
					_automaticRadioButtonGroups = new WeakHashMap();
				}
				var g:RadioButtonGroup = _automaticRadioButtonGroups.get(_groupName);
				if(g == null)
				{
					g = new RadioButtonGroup();
					g._name = _groupName;
					_automaticRadioButtonGroups.put(_groupName, g);
				}
				_group = g;
			}
			return _group;
		}
		
		/**
		 * 设置或获取所属组的名称. 默认值"radioGroup". 可以把此属性当做设置组的一个简便方式, 作用与设置 <code>group</code> 属性相同.
		 */
		public function set groupName(value:String):void
		{
			if(value == null || value == "")
			{
				return;
			}
			_groupName = value;
			if(_radioButtonGroup != null)
			{
				_radioButtonGroup.removeInstance(this);
			}
			_group = null;
			_groupChanged = true;
			this.invalidateProperties();
			this.invalidateDisplayList();
		}
		public function get groupName():String
		{
			return _groupName;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			this.invalidateDisplayList();
		}
		
		/**
		 * 设置或获取与此单选按钮关联的自定义数据.
		 */
		public function set value(value:Object):void
		{
			if(_value == value)
			{
				return;
			}
			_value = value;
			if(this.selected && this.group != null)
			{
				this.group.dispatchEvent(new UIEvent(UIEvent.VALUE_COMMIT));
			}
		}
		public function get value():Object
		{
			return _value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			if(_groupChanged)
			{
				addToGroup();
				_groupChanged = false;
			}
			super.commitProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(this.group != null)
			{
				if(this.selected)
				{
					_group.selection = this;
				}
				else if(_group.selection == this)
				{
					_group.selection = null;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buttonReleased():void
		{
			if(!this.enabled || this.selected)
			{
				return; 
			}
			if(_radioButtonGroup == null)
			{
				addToGroup();
			}
			super.buttonReleased();
			this.group.setSelection(this);
		}
		
		/**
		 * 添此单选按钮加到组.
		 */
		private function addToGroup():RadioButtonGroup
		{
			var g:RadioButtonGroup = this.group;
			if(g != null)
			{
				g.addInstance(this);
			}
			return g;
		}
	}
}
