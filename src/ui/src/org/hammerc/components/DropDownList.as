/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import org.hammerc.components.supportClasses.DropDownListBase;
	import org.hammerc.core.IText;
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>DropDownList</code> 类实现了不可输入的下拉列表控件.
	 * @author wizardc
	 */
	public class DropDownList extends DropDownListBase
	{
		/**
		 * 皮肤子件, 选中项文本.
		 */
		public var labelDisplay:IText;
		
		private var _labelChanged:Boolean = false;
		
		private var _prompt:String = "";
		
		/**
		 * 创建一个 <code>DropDownList</code> 对象.
		 */
		public function DropDownList()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return DropDownList;
		}
		
		/**
		 * 设置或获取当没有选中项时要显示的字符串.
		 */
		public function set prompt(value:String):void
		{
			if(_prompt == value)
			{
				return;
			}
			_prompt = value;
			_labelChanged = true;
			this.invalidateProperties();
		}
		public function get prompt():String
		{
			return _prompt;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_labelChanged)
			{
				_labelChanged = false;
				this.updateLabelDisplay();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == labelDisplay)
			{
				_labelChanged = true;
				this.invalidateProperties();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function updateLabelDisplay(displayItem:* = undefined):void
		{
			if(labelDisplay != null)
			{
				if(displayItem == undefined)
				{
					displayItem = selectedItem;
				}
				if(displayItem != null && displayItem != undefined)
				{
					labelDisplay.text = this.itemToLabel(displayItem);
				}
				else
				{
					labelDisplay.text = _prompt;
				}
			}
		}
	}
}
