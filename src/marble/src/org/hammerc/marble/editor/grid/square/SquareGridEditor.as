/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.square
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.hammerc.marble.editor.grid.AbstractGridEditor;
	import org.hammerc.marble.editor.grid.IGridDrawArea;
	import org.hammerc.marble.editor.grid.IGridHitTest;
	
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
		override protected function drawBorder(graphics:Graphics):void
		{
			graphics.lineStyle(0, this.style.gridBorderColor);
			var i:int, x:int, y:int;
			var w:int = this.column * this.gridWidth;
			var h:int = this.row * this.gridHeight;
			for(i = 0; i <= this.column; i++)
			{
				x = i * this.gridWidth;
				graphics.moveTo(x, 0);
				graphics.lineTo(x, h);
			}
			for(i = 0; i <= this.row; i++)
			{
				y = i * this.gridHeight;
				graphics.moveTo(0, y);
				graphics.lineTo(w, y);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawFill(graphics:Graphics, bitmapData:BitmapData):void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(this.gridWidth, this.gridHeight);
			graphics.beginBitmapFill(bitmapData, matrix);
			graphics.drawRect(0, 0, this.column * this.gridWidth, this.row * this.gridHeight);
			graphics.endFill();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createGridHitTest():IGridHitTest
		{
			return new SquareGridHitTest(this.gridWidth, this.gridHeight, this.row, this.column);
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
		override public function getDrawArea(target:Point):Vector.<Point>
		{
			//求出包含的范围
			var minRow:int = target.y - int((this.drawArea.y - 1) / 2);
			var maxRow:int = target.y + int(this.drawArea.y / 2);
			var minColumn:int = target.x - int((this.drawArea.x - 1) / 2);
			var maxColumn:int = target.x + int(this.drawArea.x / 2);
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
			var result:Vector.<Point> = new Vector.<Point>();
			for(var i:int = minColumn; i <= maxColumn; i++)
			{
				for(var j:int = minRow; j <= maxRow; j++)
				{
					result.push(new Point(i, j));
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getLineArea(gridCell1:Point, gridCell2:Point):Vector.<Point>
		{
			//使用 DDA 直线算法计算
			var result:Vector.<Point> = new Vector.<Point>();
			var xDis:int = gridCell2.x - gridCell1.x;
			var yDis:int = gridCell2.y - gridCell1.y;
			var maxStep:int = Math.max(Math.abs(xDis), Math.abs(yDis));
			var xUnitLen:Number = xDis / maxStep;
			var yUnitLen:Number = yDis / maxStep;
			result.push(gridCell1);
			var x:Number = gridCell1.x;
			var y:Number = gridCell1.y;
			for(var i:int = 0; i < maxStep; i++)
			{
				x += xUnitLen;
				y += yUnitLen;
				result.push(new Point(x, y));
			}
			return result;
		}
	}
}
