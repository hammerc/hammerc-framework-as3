/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import org.hammerc.components.supportClasses.ButtonBase;
	
	/**
	 * <code>ItemRenderer</code> 类实现了简单的项呈示器.
	 * @author wizardc
	 */
	public class ItemRenderer extends ButtonBase implements IItemRenderer
	{
		private var _data:Object;
		private var _dataChangedFlag:Boolean = false;
		
		private var _selected:Boolean = false;
		
		private var _itemIndex:int = -1;
		
		/**
		 * 创建一个 <code>ItemRenderer</code> 对象.
		 */
		public function ItemRenderer()
		{
			super();
			this.mouseChildren = true;
			this.buttonMode = false;
			this.useHandCursor = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return ItemRenderer;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "ItemRenderer";
		}
		
		/**
		 * @inheritDoc
		 */
		public function set data(value:Object):void
		{
			_data = value;
			if(this.initialized || this.hasParent)
			{
				_dataChangedFlag = false;
				this.dataChanged();
			}
			else
			{
				_dataChangedFlag = true;
				this.invalidateProperties();
			}
		}
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
			{
				return;
			}
			_selected = value;
			this.invalidateSkinState();
		}
		public function get selected():Boolean
		{
			return _selected;
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
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_dataChangedFlag)
			{
				_dataChangedFlag = false;
				this.dataChanged();
			}
		}
		
		/**
		 * 子类复写此方法以在 data 数据源发生改变时跟新显示列表.
		 * 与直接复写 data 的 setter 方法不同, 它会确保在皮肤已经附加完成后再被调用.
		 */
		protected function dataChanged():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			if(_selected)
			{
				return "down";
			}
			return super.getCurrentSkinState();
		}
	}
}
