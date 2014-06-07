/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.square
{
	import flash.display.Graphics;
	
	import org.hammerc.marble.editor.grid.AbstractGridCell;
	import org.hammerc.marble.editor.grid.IGridEditor;
	
	/**
	 * <code>SquareGridCell</code> 类定义了用于编辑器的正方形格子.
	 * @author wizardc
	 */
	public class SquareGridCell extends AbstractGridCell
	{
		/**
		 * 创建一个 <code>SquareGridCell</code> 对象.
		 * @param editor 编辑器对象.
		 * @param row 行数.
		 * @param column 列数.
		 */
		public function SquareGridCell(editor:IGridEditor, row:int, column:int)
		{
			super(editor, row, column);
			this.mouseChildren = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawRectShape(graphics:Graphics):void
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _editor.gridWidth, _editor.gridHeight);
			graphics.endFill();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawSelectedShape(graphics:Graphics):void
		{
			drawCellGraphics(graphics, true);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function drawUnselectedShape(graphics:Graphics):void
		{
			drawCellGraphics(graphics, false);
		}
		
		/**
		 * @inheritDoc
		 */
		private function drawCellGraphics(graphics:Graphics, selected:Boolean):void
		{
			var showBorder:Boolean = selected ? _editor.style.showSelectedBorder : _editor.style.showUnselectedBorder;
			var borderColor:uint = selected ? _editor.style.selectedBorderColor : _editor.style.unselectedBorderColor;
			var showFill:Boolean = selected ? _editor.style.showSelectedFill : _editor.style.showUnselectedFill;
			var fillColor:uint = selected ? _editor.style.selectedFillColor : _editor.style.unselectedFillColor;
			var fillAlpha:Number = selected ? _editor.style.selectedFillAlpha : _editor.style.unselectedFillAlpha;
			graphics.clear();
			if(showBorder)
			{
				graphics.lineStyle(0, borderColor);
			}
			if(showFill)
			{
				graphics.beginFill(fillColor, fillAlpha);
			}
			if(showBorder || showFill)
			{
				graphics.drawRect(0, 0, _editor.gridWidth, _editor.gridHeight);
				graphics.endFill();
			}
		}
	}
}
