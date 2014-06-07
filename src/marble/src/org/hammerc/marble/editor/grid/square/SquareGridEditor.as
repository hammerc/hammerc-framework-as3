/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.square
{
	import flash.display.DisplayObject;
	
	import org.hammerc.marble.editor.grid.AbstractGridEditor;
	import org.hammerc.marble.editor.grid.IGridCell;
	import org.hammerc.marble.editor.grid.IGridDrawArea;
	
	/**
	 * <code>SquareGridEditor</code> 类定义了正方形格子的编辑器.
	 * @author wizardc
	 */
	public class SquareGridEditor extends AbstractGridEditor
	{
		/**
		 * 创建一个 <code>SquareGridEditor</code> 对象.
		 * @param gridWidth 格子宽度.
		 * @param gridHeight 格子高度.
		 * @param row 行数.
		 * @param column 列数.
		 * @param undoStep 可撤销的步骤数.
		 * @param style 编辑器样式描述对象.
		 */
		public function SquareGridEditor(gridWidth:int, gridHeight:int, row:int, column:int, undoStep:int = 3, style:Object = null)
		{
			super(gridWidth, gridHeight, row, column, undoStep, style);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createGridCell(row:int, column:int):IGridCell
		{
			return new SquareGridCell(this, row, column);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function alignGridCell(cell:DisplayObject, row:int, column:int):void
		{
			cell.x = column * this.gridWidth;
			cell.y = row * this.gridHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createGridDrawArea():IGridDrawArea
		{
			return new SquareGridDrawArea(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getDrawArea(target:IGridCell):Vector.<IGridCell>
		{
			//求出包含的范围
			var minRow:int = target.row - int((this.drawArea.y - 1) / 2);
			var maxRow:int = target.row + int(this.drawArea.y / 2);
			var minColumn:int = target.column - int((this.drawArea.x - 1) / 2);
			var maxColumn:int = target.column + int(this.drawArea.x / 2);
			//边界处理
			if(minRow < 0)
			{
				minRow = 0;
			}
			if(maxRow > this.row - 1)
			{
				maxRow = this.row - 1;
			}
			if(minColumn < 0)
			{
				minColumn = 0;
			}
			if(maxColumn > this.column - 1)
			{
				maxColumn = this.column - 1;
			}
			//获取格子
			var result:Vector.<IGridCell> = new Vector.<IGridCell>();
			for(var i:int = minColumn; i <= maxColumn; i++)
			{
				for(var j:int = minRow; j <= maxRow; j++)
				{
					result.push(_gridCellList[j * this.column + i]);
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getLineArea(gridCell1:IGridCell, gridCell2:IGridCell):Vector.<IGridCell>
		{
			//使用 DDA 直线算法计算
			var result:Vector.<IGridCell> = new Vector.<IGridCell>();
			var yDis:int = (gridCell2.row - gridCell1.row);
			var xDis:int = (gridCell2.column - gridCell1.column);
			var maxStep:int = Math.max(Math.abs(yDis), Math.abs(xDis));
			var yUnitLen:Number = yDis / maxStep;
			var xUnitLen:Number = xDis / maxStep;
			result.push(gridCell1);
			var x:Number = gridCell1.column;
			var y:Number = gridCell1.row;
			for(var i:int = 0; i < maxStep; i++)
			{
				x += xUnitLen;
				y += yUnitLen;
				result.push(this.getGridCell(int(y), int(x)));
			}
			return result;
		}
	}
}
