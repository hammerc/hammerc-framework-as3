/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.tools
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.marble.editor.grid.IGridCell;
	
	import org.hammerc.marble.editor.grid.IGridEditor;
	
	/**
	 * <code>GridRulerTool</code> 类定义了直线工具.
	 * @author wizardc
	 */
	public class GridRulerTool extends AbstractGridTool
	{
		private var _lineShape:Shape;
		private var _mouseIsDown:Boolean = false;
		private var _beginPoint:Point;
		private var _beginCell:IGridCell;
		
		/**
		 * 创建一个 <code>GridRulerTool</code> 对象.
		 * @param editor 编辑器对象.
		 */
		public function GridRulerTool(editor:IGridEditor)
		{
			super(editor);
			_beginPoint = new Point();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			_editor.useMinDrawArea = true;
			_lineShape = new Shape();
			DisplayObjectContainer(_editor).addChild(_lineShape);
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
				_beginPoint.x = _editor.gridContainer.mouseX;
				_beginPoint.y = _editor.gridContainer.mouseY;
				_beginCell = IGridCell(event.target);
			}
		}
		
		private function gridMouseMoveHandler(event:MouseEvent):void
		{
			if(_mouseIsDown)
			{
				_lineShape.graphics.clear();
				_lineShape.graphics.lineStyle(0, _editor.style.rulerLineColor);
				_lineShape.graphics.moveTo(_beginPoint.x, _beginPoint.y);
				_lineShape.graphics.lineTo(_editor.gridContainer.mouseX, _editor.gridContainer.mouseY);
			}
		}
		
		private function gridMouseUpHandler(event:MouseEvent):void
		{
			_editor.gridContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			_mouseIsDown = false;
			_lineShape.graphics.clear();
			if(event.target != event.currentTarget)
			{
				drawArea(_beginCell, IGridCell(event.target));
			}
			this.dispatchDrawEndEvent();
		}
		
		private function drawArea(gridCell1:IGridCell, gridCell2:IGridCell):void
		{
			var drawAreaList:Vector.<IGridCell> = _editor.getLineArea(gridCell1, gridCell2);
			for each (var gridCell:IGridCell in drawAreaList)
			{
				_editor.setGridCellSelect(gridCell.row, gridCell.column, _editor.selectMode);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			_editor.useMinDrawArea = false;
			DisplayObjectContainer(_editor).removeChild(_lineShape);
			_editor.gridContainer.removeEventListener(MouseEvent.MOUSE_DOWN, gridMouseDownHandler);
			_editor.gridContainer.removeEventListener(MouseEvent.MOUSE_MOVE, gridMouseMoveHandler);
			if(_editor.gridContainer.stage != null)
			{
				_editor.gridContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			}
		}
	}
}
