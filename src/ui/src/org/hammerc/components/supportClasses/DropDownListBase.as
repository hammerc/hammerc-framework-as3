/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.hammerc.collections.ICollection;
	import org.hammerc.components.IItemRenderer;
	import org.hammerc.components.List;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.CollectionEvent;
	import org.hammerc.events.ListEvent;
	import org.hammerc.events.UIEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.UIEvent.OPEN
	 */
	[Event(name="open",type="org.hammerc.events.UIEvent")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.CLOSE
	 */
	[Event(name="close",type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>DropDownListBase</code> 类为下拉列表控件基类.
	 * @author wizardc
	 */
	public class DropDownListBase extends List
	{
		/**
		 * 皮肤子件, 下拉区域显示对象.
		 */
		public var dropDown:DisplayObject;
		
		/**
		 * 皮肤子件, 下拉触发按钮.
		 */
		public var openButton:ButtonBase;
		
		private var _labelChanged:Boolean = false;
		
		private var _dropDownController:DropDownController;
		
		private var _userProposedSelectedIndex:Number = NO_SELECTION;
		
		/**
		 * 创建一个 <code>DropDownListBase</code> 对象.
		 */
		public function DropDownListBase()
		{
			super();
			_captureItemRenderer = false;
			this.dropDownController = new DropDownController();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set dataProvider(value:ICollection):void
		{
			if(this.dataProvider == value)
			{
				return;
			}
			super.dataProvider = value;
			_labelChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set labelField(value:String):void
		{
			if(this.labelField == value)
			{
				return;
			}
			super.labelField = value;
			_labelChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set labelFunction(value:Function):void
		{
			if(this.labelFunction == value)
			{
				return;
			}
			super.labelFunction = value;
			_labelChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * 设置或获取下拉控制器.
		 */
		protected function set dropDownController(value:DropDownController):void
		{
			if(_dropDownController == value)
			{
				return;
			}
			_dropDownController = value;
			_dropDownController.addEventListener(UIEvent.OPEN, this.dropDownController_openHandler);
			_dropDownController.addEventListener(UIEvent.CLOSE, this.dropDownController_closeHandler);
			if(openButton != null)
			{
				_dropDownController.openButton = openButton;
			}
			if(dropDown != null)
			{
				_dropDownController.dropDown = dropDown;
			}
		}
		protected function get dropDownController():DropDownController
		{
			return _dropDownController;
		}
		
		/**
		 * 获取下拉列表是否已经已打开.
		 */
		public function get isDropDownOpen():Boolean
		{
			if(dropDownController != null)
			{
				return dropDownController.isOpen;
			}
			else
			{
				return false;
			}
		}
		
		hammerc_internal function set userProposedSelectedIndex(value:Number):void
		{
			_userProposedSelectedIndex = value;
		}
		hammerc_internal function get userProposedSelectedIndex():Number
		{
			return _userProposedSelectedIndex;
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
			if(instance == openButton)
			{
				if(this.dropDownController != null)
				{
					this.dropDownController.openButton = openButton;
				}
			}
			else if(instance == dropDown && this.dropDownController != null)
			{
				this.dropDownController.dropDown = dropDown;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(dropDownController != null)
			{
				if(instance == openButton)
				{
					dropDownController.openButton = null;
				}
				if(instance == dropDown)
				{
					dropDownController.dropDown = null;
				}
			}
			super.partRemoved(partName, instance);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			return !this.enabled ? "disabled" : this.isDropDownOpen ? "open" : "normal";
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			var retVal:Boolean = super.commitSelection(dispatchChangedEvents);
			this.updateLabelDisplay();
			return retVal;
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function isItemIndexSelected(index:int):Boolean
		{
			return this.userProposedSelectedIndex == index;
		}
		
		/**
		 * 打开下拉列表并抛出 <code>UIEvent.OPEN</code> 事件.
		 */
		public function openDropDown():void
		{
			this.dropDownController.openDropDown();
		}
		
		/**
		 * 关闭下拉列表并抛出 <code>UIEvent.CLOSE</code> 事件.
		 */
		public function closeDropDown(commit:Boolean):void
		{
			this.dropDownController.closeDropDown(commit);
		}
		
		/**
		 * 更新选中项的提示文本.
		 */
		hammerc_internal function updateLabelDisplay(displayItem:* = undefined):void
		{
		}
		
		/**
		 * 改变高亮的选中项.
		 */
		hammerc_internal function changeHighlightedSelection(newIndex:int, scrollToTop:Boolean = false):void
		{
			this.itemSelected(this.userProposedSelectedIndex, false);
			this.userProposedSelectedIndex = newIndex;
			this.itemSelected(this.userProposedSelectedIndex, true);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{
			super.dataProvider_collectionChangeHandler(event);
			_labelChanged = true;
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function item_mouseDownHandler(event:MouseEvent):void
		{
			super.item_mouseDownHandler(event);
			var itemRenderer:IItemRenderer = event.currentTarget as IItemRenderer;
			this.dispatchListEvent(event, ListEvent.ITEM_CLICK, itemRenderer);
			this.userProposedSelectedIndex = this.selectedIndex;
			this.closeDropDown(true);
		}
		
		/**
		 * 控制器抛出打开列表事件.
		 */
		hammerc_internal function dropDownController_openHandler(event:UIEvent):void
		{
			this.addEventListener(UIEvent.UPDATE_COMPLETE, this.open_updateCompleteHandler);
			this.userProposedSelectedIndex = this.selectedIndex;
			this.invalidateSkinState();
		}
		
		/**
		 * 打开列表后组件一次失效验证全部完成.
		 */
		hammerc_internal function open_updateCompleteHandler(event:UIEvent):void
		{
			this.removeEventListener(UIEvent.UPDATE_COMPLETE, this.open_updateCompleteHandler);
			this.dispatchEvent(new UIEvent(UIEvent.OPEN));
		}
		
		/**
		 * 控制器抛出关闭列表事件.
		 */
		protected function dropDownController_closeHandler(event:UIEvent):void
		{
			this.addEventListener(UIEvent.UPDATE_COMPLETE, close_updateCompleteHandler);
			this.invalidateSkinState();
			if(!event.isDefaultPrevented())
			{
				this.setSelectedIndex(this.userProposedSelectedIndex, true);
			}
			else
			{
				this.changeHighlightedSelection(this.selectedIndex);
			}
		}
		
		/**
		 * 关闭列表后组件一次失效验证全部完成.
		 */
		private function close_updateCompleteHandler(event:UIEvent):void
		{
			this.removeEventListener(UIEvent.UPDATE_COMPLETE, close_updateCompleteHandler);
			this.dispatchEvent(new UIEvent(UIEvent.CLOSE));
		}
	}
}
