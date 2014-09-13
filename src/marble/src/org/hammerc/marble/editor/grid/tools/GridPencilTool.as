/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.tools
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.marble.editor.grid.GridMouseEvent;
	import org.hammerc.marble.editor.grid.IGridEditor;
	
	/**
	 * <code>GridPencilTool</code> 类定义了铅笔绘制工具.
	 * @author wizardc
	 */
	public class GridPencilTool extends AbstractGridTool
	{
		private var _mouseIsDown:Boolean = false;
		//记录上一个格子的位置
		private var _lastPoint:Point;
		
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
			_editor.gridHitTest.addEventListener(GridMouseEvent.GRID_MOUSE_DOWN, gridMouseDownHandler);
			_editor.gridHitTest.addEventListener(GridMouseEvent.GRID_MOUSE_MOVE, gridMouseMoveHandler);
		}
		
		private function gridMouseDownHandler(event:GridMouseEvent):void
		{
			this.dispatchDrawBeginEvent();
			DisplayObject(_editor.gridHitTest).stage.addEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			_mouseIsDown = true;
			_lastPoint = event.gridCell;
			drawArea(event.gridCell);
		}
		
		private function gridMouseMoveHandler(event:GridMouseEvent):void
		{
			if(_mouseIsDown)
			{
				//判断中间是否会出现空隙
				var dx:int = Math.abs(_lastPoint.x - event.gridCell.x);
				var dy:int = Math.abs(_lastPoint.y - event.gridCell.y);
				if(dx < 2 && dy < 2)
				{
					//相邻则直接绘制
					drawArea(event.gridCell);
				}
				else
				{
					//会出现空隙则绘制直线
					var drawAreaList:Vector.<Point> = _editor.getLineArea(_lastPoint, event.gridCell);
					for each(var gridCell:Point in drawAreaList)
					{
						drawArea(gridCell);
					}
				}
				_lastPoint = event.gridCell;
			}
		}
		
		private function drawArea(target:Point):void
		{
			var drawAreaList:Vector.<Point> = _editor.getDrawArea(target);
			for each (var gridCell:Point in drawAreaList)
			{
				_editor.setGridCellSelect(gridCell.y, gridCell.x, _editor.selectMode);
			}
		}
		
		private function gridMouseUpHandler(event:MouseEvent):void
		{
			DisplayObject(_editor.gridHitTest).stage.removeEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			_mouseIsDown = false;
			_lastPoint = null;
			this.dispatchDrawEndEvent();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			_editor.gridHitTest.removeEventListener(GridMouseEvent.GRID_MOUSE_DOWN, gridMouseDownHandler);
			_editor.gridHitTest.removeEventListener(GridMouseEvent.GRID_MOUSE_MOVE, gridMouseMoveHandler);
			if(DisplayObject(_editor.gridHitTest).stage != null)
			{
				DisplayObject(_editor.gridHitTest).stage.removeEventListener(MouseEvent.MOUSE_UP, gridMouseUpHandler);
			}
		}
	}
}
