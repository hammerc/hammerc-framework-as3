// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.grid.tools
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.marble.editor.grid.GridMouseEvent;
	
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
		private var _beginCell:Point;
		private var _endCell:Point;
		
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
			_lineShape = new Shape();
			DisplayObjectContainer(_editor).addChild(_lineShape);
			_editor.gridHitTest.addEventListener(GridMouseEvent.GRID_MOUSE_DOWN, gridMouseDownHandler);
			_editor.gridHitTest.addEventListener(GridMouseEvent.GRID_MOUSE_MOVE, gridMouseMoveHandler);
		}
		
		private function gridMouseDownHandler(event:GridMouseEvent):void
		{
			this.dispatchDrawBeginEvent();
			DisplayObject(_editor.gridHitTest).stage.addEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			_mouseIsDown = true;
			_beginPoint.x = DisplayObject(_editor.gridHitTest).mouseX;
			_beginPoint.y = DisplayObject(_editor.gridHitTest).mouseY;
			_beginCell = event.gridCell;
			_endCell = event.gridCell;
		}
		
		private function gridMouseMoveHandler(event:GridMouseEvent):void
		{
			if(_mouseIsDown)
			{
				_lineShape.graphics.clear();
				_lineShape.graphics.lineStyle(0, _editor.style.rulerLineColor);
				_lineShape.graphics.moveTo(_beginPoint.x, _beginPoint.y);
				_lineShape.graphics.lineTo(DisplayObject(_editor.gridHitTest).mouseX, DisplayObject(_editor.gridHitTest).mouseY);
				_endCell = event.gridCell;
			}
		}
		
		private function gridMouseUpHandler(event:MouseEvent):void
		{
			DisplayObject(_editor.gridHitTest).stage.removeEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			_mouseIsDown = false;
			_lineShape.graphics.clear();
			if(event.target == _editor.gridHitTest)
			{
				drawArea(_beginCell, _endCell);
			}
			this.dispatchDrawEndEvent();
		}
		
		private function drawArea(gridCell1:Point, gridCell2:Point):void
		{
			var drawAreaList:Vector.<Point> = _editor.getLineArea(gridCell1, gridCell2);
			for each(var gridCell:Point in drawAreaList)
			{
				drawAreaNow(gridCell);
			}
		}
		
		private function drawAreaNow(target:Point):void
		{
			var drawAreaList:Vector.<Point> = _editor.getDrawArea(target);
			for each (var gridCell:Point in drawAreaList)
			{
				_editor.setGridCellSelect(gridCell.y, gridCell.x, _editor.selectMode);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			DisplayObjectContainer(_editor).removeChild(_lineShape);
			_editor.gridHitTest.removeEventListener(GridMouseEvent.GRID_MOUSE_DOWN, gridMouseDownHandler);
			_editor.gridHitTest.removeEventListener(GridMouseEvent.GRID_MOUSE_MOVE, gridMouseMoveHandler);
			if(DisplayObject(_editor.gridHitTest).stage != null)
			{
				DisplayObject(_editor.gridHitTest).stage.removeEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			}
		}
	}
}
