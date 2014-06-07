/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.hammerc.core.AbstractEnforcer;
	
	/**
	 * <code>AbstractGridCell</code> 类为抽象类, 定义了用于编辑器的格子.
	 * @author wizardc
	 */
	public class AbstractGridCell extends Sprite implements IGridCell
	{
		/**
		 * 编辑器对象.
		 */
		protected var _editor:IGridEditor;
		
		private var _row:int;
		private var _column:int;
		
		private var _hitArea:Sprite;
		private var _selectedShape:Shape;
		private var _unselectedShape:Shape;
		
		/**
		 * <code>AbstractGridCell</code> 类为抽象类, 不能被实例化.
		 * @param editor 编辑器对象.
		 * @param row 行数.
		 * @param column 列数.
		 */
		public function AbstractGridCell(editor:IGridEditor, row:int, column:int)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractGridCell);
			_editor = editor;
			_row = row;
			_column = column;
			_hitArea = new Sprite();
			this.drawRectShape(_hitArea.graphics);
			this.addChild(_hitArea);
			this.hitArea = _hitArea;
			_selectedShape = new Shape();
			_selectedShape.visible = false;
			this.drawSelectedShape(_selectedShape.graphics);
			this.addChild(_selectedShape);
			_unselectedShape = new Shape();
			_unselectedShape.visible = false;
			this.drawUnselectedShape(_unselectedShape.graphics);
			this.addChild(_unselectedShape);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get row():int
		{
			return _row;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get column():int
		{
			return _column;
		}
		
		/**
		 * 绘制用于鼠标响应的透明区域.
		 * @param graphics 绘图对象.
		 */
		protected function drawRectShape(graphics:Graphics):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 绘制选中的格子.
		 * @param graphics 绘图对象.
		 * @param selected 是否被选中.
		 */
		protected function drawSelectedShape(graphics:Graphics):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 绘制未选中的格子.
		 * @param graphics 绘图对象.
		 * @param selected 是否被选中.
		 */
		protected function drawUnselectedShape(graphics:Graphics):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * @inheritDoc
		 */
		public function drawCell(selected:Boolean):void
		{
			_selectedShape.visible = selected;
			_unselectedShape.visible = !selected;
		}
	}
}
