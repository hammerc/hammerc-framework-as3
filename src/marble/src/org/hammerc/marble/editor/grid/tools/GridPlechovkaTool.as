/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.tools
{
	import flash.events.MouseEvent;
	
	import org.hammerc.marble.editor.grid.GridColor;
	
	import org.hammerc.marble.editor.grid.IGridCell;
	
	import org.hammerc.marble.editor.grid.IGridEditor;
	
	/**
	 * <code>GridPlechovkaTool</code> 类定义了颜料桶工具.
	 * @author wizardc
	 */
	public class GridPlechovkaTool extends AbstractGridTool
	{
		/**
		 * 创建一个 <code>GridPlechovkaTool</code> 对象.
		 * @param editor 编辑器对象.
		 */
		public function GridPlechovkaTool(editor:IGridEditor)
		{
			super(editor);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			_editor.useMinDrawArea = true;
			_editor.gridContainer.addEventListener(MouseEvent.MOUSE_DOWN, gridMouseDownHandler);
		}
		
		private function gridMouseDownHandler(event:MouseEvent):void
		{
			if(event.target != event.currentTarget)
			{
				this.dispatchDrawBeginEvent();
				var target:IGridCell = IGridCell(event.target);
				floodFill(target, _editor.selectMode);
			}
		}
		
		private function floodFill(target:IGridCell, selected:Boolean):void
		{
			_editor.gridData.floodFill(target.column, target.row, selected ? GridColor.SELECTED_COLOR : GridColor.UNSELECTED_COLOR);
			_editor.callRedraw();
			this.dispatchDrawEndEvent();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			_editor.useMinDrawArea = false;
			_editor.gridContainer.removeEventListener(MouseEvent.MOUSE_DOWN, gridMouseDownHandler);
		}
	}
}
