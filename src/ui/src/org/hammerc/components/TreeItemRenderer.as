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
	import flash.events.MouseEvent;
	
	import org.hammerc.components.supportClasses.ToggleButtonBase;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.TreeEvent;
	import org.hammerc.skins.ISkinnableClient;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TreeItemRenderer</code> 类实现了简单的树形组件的项呈示器.
	 * @author wizardc
	 */
	public class TreeItemRenderer extends ItemRenderer implements ITreeItemRenderer
	{
		/**
		 * 皮肤子件, 图标显示对象.
		 */
		public var iconDisplay:ISkinnableClient;
		
		/**
		 * 皮肤子件, 子节点开启按钮.
		 */
		public var disclosureButton:ToggleButtonBase;
		
		/**
		 * 皮肤子件, 用于调整缩进值的容器对象.
		 */
		public var contentGroup:DisplayObject;
		
		private var _indentation:Number = 17;
		
		private var _iconSkinName:Object;
		
		private var _depth:int = 0;
		
		private var _hasChildren:Boolean = false;
		
		private var _isOpen:Boolean = false;
		
		/**
		 * 创建一个 <code>TreeItemRenderer</code> 对象.
		 */
		public function TreeItemRenderer()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, onItemMouseDown, false, int.MAX_VALUE);
		}
		
		private function onItemMouseDown(event:MouseEvent):void
		{
			if(event.target == disclosureButton)
			{
				event.stopImmediatePropagation();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TreeItemRenderer;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "TreeItemRenderer";
		}
		
		/**
		 * 子节点相对父节点的缩进值, 以像素为单位.
		 */
		public function set indentation(value:Number):void
		{
			_indentation = value;
		}
		public function get indentation():Number
		{
			return _indentation;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set iconSkinName(value:Object):void
		{
			if(_iconSkinName == value)
			{
				return;
			}
			_iconSkinName = value;
			if(iconDisplay != null)
			{
				iconDisplay.skinName = _iconSkinName;
			}
		}
		public function get iconSkinName():Object
		{
			return _iconSkinName;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set depth(value:int):void
		{
			if(value == _depth)
			{
				return;
			}
			_depth = value;
			if(contentGroup != null)
			{
				contentGroup.x = _depth * _indentation;
			}
		}
		public function get depth():int
		{
			return _depth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set hasChildren(value:Boolean):void
		{
			if(_hasChildren == value)
			{
				return;
			}
			_hasChildren = value;
			if(disclosureButton != null)
			{
				disclosureButton.visible = _hasChildren;
			}
		}
		public function get hasChildren():Boolean
		{
			return _hasChildren;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set opened(value:Boolean):void
		{
			if(_isOpen == value)
			{
				return;
			}
			_isOpen = value;
			if(disclosureButton != null)
			{
				disclosureButton.selected = _isOpen;
			}
		}
		public function get opened():Boolean
		{
			return _isOpen;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == iconDisplay)
			{
				iconDisplay.skinName = _iconSkinName;
			}
			else if(instance == disclosureButton)
			{
				disclosureButton.visible = _hasChildren;
				disclosureButton.selected = _isOpen;
				disclosureButton._autoSelected = false;
				disclosureButton.addEventListener(MouseEvent.MOUSE_DOWN, this.disclosureButton_mouseDownHandler);
			}
			else if(instance == contentGroup)
			{
				contentGroup.x = _depth * _indentation;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == iconDisplay)
			{
				iconDisplay.skinName = null;
			}
			else if(instance == disclosureButton)
			{
				disclosureButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.disclosureButton_mouseDownHandler);
				disclosureButton._autoSelected = true;
				disclosureButton.visible = true;
			}
		}
		
		/**
		 * 鼠标在 disclosureButton 上按下.
		 */
		protected function disclosureButton_mouseDownHandler(event:MouseEvent):void
		{
			var evt:TreeEvent = new TreeEvent(TreeEvent.ITEM_OPENING, false, true, itemIndex, data, this);
			evt.opening = !_isOpen;
			this.dispatchEvent(evt);
		}
	}
}
