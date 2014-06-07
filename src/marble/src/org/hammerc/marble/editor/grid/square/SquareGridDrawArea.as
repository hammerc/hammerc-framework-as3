/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.square
{
	import flash.display.Shape;
	
	import org.hammerc.marble.editor.grid.AbstractGridDrawArea;
	import org.hammerc.marble.editor.grid.IGridCell;
	
	import org.hammerc.marble.editor.grid.IGridEditor;
	
	/**
	 * <code>SquareGridDrawArea</code> 类定义了正方形格子编辑器绘制区域显示对象.
	 * @author wizardc
	 */
	public class SquareGridDrawArea extends AbstractGridDrawArea
	{
		private var _shape:Shape;
		
		/**
		 * 创建一个 <code>SquareGridCell</code> 对象.
		 * @param editor 编辑器对象.
		 */
		public function SquareGridDrawArea(editor:IGridEditor)
		{
			super(editor);
			drawAreaShape();
		}
		
		private function drawAreaShape():void
		{
			_shape = new Shape();
			if(_editor.style.showDrawAreaBorder)
			{
				_shape.graphics.lineStyle(0, _editor.style.drawAreaBorderColor);
			}
			if(_editor.style.showDrawAreaFill)
			{
				_shape.graphics.beginFill(_editor.style.drawAreaFillColor, _editor.style.drawAreaFillAlpha);
			}
			if(_editor.style.showDrawAreaBorder || _editor.style.showDrawAreaFill)
			{
				_shape.graphics.drawRect(0, 0, _editor.gridWidth, _editor.gridHeight);
				_shape.graphics.endFill();
			}
			this.addChild(_shape);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function targetChanged(target:IGridCell):void
		{
			//求出包含的范围
			var minRow:int = target.row - int((_editor.drawArea.y - 1) / 2);
			var maxRow:int = target.row + int(_editor.drawArea.y / 2);
			var minColumn:int = target.column - int((_editor.drawArea.x - 1) / 2);
			var maxColumn:int = target.column + int(_editor.drawArea.x / 2);
			//边界处理
			if(minRow < 0)
			{
				minRow = 0;
			}
			if(maxRow > _editor.row - 1)
			{
				maxRow = _editor.row - 1;
			}
			if(minColumn < 0)
			{
				minColumn = 0;
			}
			if(maxColumn > _editor.column - 1)
			{
				maxColumn = _editor.column - 1;
			}
			//应用位置和尺寸
			this.x = minColumn * _editor.gridWidth;
			this.y = minRow * _editor.gridHeight;
			_shape.width = (maxColumn - minColumn + 1) * _editor.gridWidth;
			_shape.height = (maxRow - minRow + 1) * _editor.gridHeight;
		}
	}
}
