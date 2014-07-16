/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.square
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.marble.editor.grid.GridMouseEvent;
	
	import org.hammerc.marble.editor.grid.IGridHitTest;
	
	/**
	 * @eventType org.hammerc.marble.editor.grid.GridMouseEvent.GRID_MOUSE_OVER
	 */
	[Event(name="gridMouseOver", type="org.hammerc.marble.editor.grid.GridMouseEvent")]
	
	/**
	 * @eventType org.hammerc.marble.editor.grid.GridMouseEvent.GRID_MOUSE_DOWN
	 */
	[Event(name="gridMouseDown", type="org.hammerc.marble.editor.grid.GridMouseEvent")]
	
	/**
	 * @eventType org.hammerc.marble.editor.grid.GridMouseEvent.GRID_MOUSE_MOVE
	 */
	[Event(name="gridMouseMove", type="org.hammerc.marble.editor.grid.GridMouseEvent")]
	
	/**
	 * <code>SquareGridHitTest</code> 类定义了正方形格子的鼠标事件模拟类.
	 * @author wizardc
	 */
	public class SquareGridHitTest extends Sprite implements IGridHitTest
	{
		private var _gridWidth:int;
		private var _gridHeight:int;
		private var _row:int;
		private var _column:int;
		
		private var _lastColumn:int = -1;
		private var _lastRow:int = -1;
		
		/**
		 * 创建一个 <code>SquareGridHitTest</code> 对象.
		 * @param gridWidth 格子宽度.
		 * @param gridHeight 格子高度.
		 * @param row 行数.
		 * @param column 列数.
		 */
		public function SquareGridHitTest(gridWidth:int, gridHeight:int, row:int, column:int)
		{
			_gridWidth = gridWidth;
			_gridHeight = gridHeight;
			_row = row;
			_column = column;
			drawShape();
			addEventListeners();
		}
		
		private function drawShape():void
		{
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, _gridWidth * _column, _gridHeight * _row);
			this.graphics.endFill();
		}
		
		private function addEventListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			var column:int = Math.floor(event.localX / _gridWidth);
			var row:int = Math.floor(event.localY / _gridHeight);
			this.dispatchEvent(new GridMouseEvent(GridMouseEvent.GRID_MOUSE_DOWN, new Point(column, row)));
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var column:int = Math.floor(event.localX / _gridWidth);
			var row:int = Math.floor(event.localY / _gridHeight);
			this.dispatchEvent(new GridMouseEvent(GridMouseEvent.GRID_MOUSE_MOVE, new Point(column, row)));
			if(_lastColumn != column || _lastRow != row)
			{
				_lastColumn = column;
				_lastRow = row;
				this.dispatchEvent(new GridMouseEvent(GridMouseEvent.GRID_MOUSE_OVER, new Point(column, row)));
			}
		}
		
		private function rollOutHandler(event:MouseEvent):void
		{
			_lastColumn = -1;
			_lastRow = -1;
		}
	}
}
