/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.tools
{
	import flash.events.MouseEvent;
	
	import org.hammerc.marble.editor.grid.IGridCell;
	
	import org.hammerc.marble.editor.grid.IGridEditor;
	
	/**
	 * <code>GridPencilTool</code> 类定义了铅笔绘制工具.
	 * @author wizardc
	 */
	public class GridPencilTool extends AbstractGridTool
	{
		private var _mouseIsDown:Boolean = false;
		
		/**
		 * 创建一个 <code>GridPencilTool</code> 对象.
		 * @param editor 编辑器对象.
		 */
		public function GridPencilTool(editor:IGridEditor)
		{
			super(editor);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			_editor.gridContainer.addEventListener(MouseEvent.MOUSE_DOWN, gridMouseDownHandler);
			_editor.gridContainer.addEventListener(MouseEvent.MOUSE_MOVE, gridMouseMoveHandler);
		}
		
		private function gridMouseDownHandler(event:MouseEvent):void
		{
			if(event.target != event.currentTarget)
			{
				this.dispatchDrawBeginEvent();
				_editor.gridContainer.stage.addEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
				_mouseIsDown = true;
				var target:IGridCell = IGridCell(event.target);
				drawArea(target);
			}
		}
		
		private function gridMouseMoveHandler(event:MouseEvent):void
		{
			if(event.target != event.currentTarget)
			{
				if(_mouseIsDown)
				{
					var target:IGridCell = IGridCell(event.target);
					drawArea(target);
				}
			}
		}
		
		private function drawArea(target:IGridCell):void
		{
			var drawAreaList:Vector.<IGridCell> = _editor.getDrawArea(target);
			for each (var gridCell:IGridCell in drawAreaList)
			{
				_editor.setGridCellSelect(gridCell.row, gridCell.column, _editor.selectMode);
			}
		}
		
		private function gridMouseUpHandler(event:MouseEvent):void
		{
			_editor.gridContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			_mouseIsDown = false;
			this.dispatchDrawEndEvent();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			_editor.gridContainer.removeEventListener(MouseEvent.MOUSE_DOWN, gridMouseDownHandler);
			_editor.gridContainer.removeEventListener(MouseEvent.MOUSE_MOVE, gridMouseMoveHandler);
			if(_editor.gridContainer.stage != null)
			{
				_editor.gridContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			}
		}
	}
}
