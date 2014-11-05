// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.common
{
	import org.hammerc.core.AbstractEnforcer;
	
	/**
	 * <code>AbstractNoScopeEditor</code> 类为抽象类, 定义了有固定范围的编辑器.
	 * @author wizardc
	 */
	public class AbstractScopeEditor extends AbstractEditor
	{
		/**
		 * 记录编辑区域宽度.
		 */
		protected var _editAreaWidth:Number = 0;
		
		/**
		 * 记录编辑区域高度.
		 */
		protected var _editAreaHeight:Number = 0;
		
		/**
		 * <code>AbstractScopeEditor</code> 类为抽象类, 不能被实例化.
		 */
		public function AbstractScopeEditor()
		{
			AbstractEnforcer.enforceConstructor(this, AbstractScopeEditor);
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function init():void
		{
		}
		
		/**
		 * 设置或获取编辑区域宽度.
		 */
		public function set editAreaWidth(value:Number):void
		{
			if(_editAreaWidth != value)
			{
				_editAreaWidth = value;
				this.callRedraw();
			}
		}
		public function get editAreaWidth():Number
		{
			return _editAreaWidth;
		}
		
		/**
		 * 设置或获取编辑区域高度.
		 */
		public function set editAreaHeight(value:Number):void
		{
			if(_editAreaHeight != value)
			{
				_editAreaHeight = value;
				this.callRedraw();
			}
		}
		public function get editAreaHeight():Number
		{
			return _editAreaHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function sizeChanged():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function originMoved():void
		{
			super.originMoved();
			_canvas.x = _originX;
			_canvas.y = _originY;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function redraw():void
		{
			super.redraw();
			//画布
			switch(_canvasType)
			{
				case CanvasType.CHECKERBOARD:
					_checkerboardShape.width = _editAreaWidth * _scale;
					_checkerboardShape.height = _editAreaHeight * _scale;
					_canvas.graphics.clear();
					break;
				case CanvasType.PURE_COLOR:
				default:
					_checkerboardShape.width = 0;
					_checkerboardShape.height = 0;
					_canvas.graphics.clear();
					_canvas.graphics.beginFill(_canvasColor);
					_canvas.graphics.drawRect(0, 0, _editAreaWidth * _scale, _editAreaHeight * _scale);
					_canvas.graphics.endFill();
					break;
			}
		}
		
		/**
		 * 设置编辑区域居中.
		 */
		public function editAreaCenter():void
		{
			this.originX = (_width - _editAreaWidth * _scale) / 2;
			this.originY = (_height - _editAreaHeight * _scale) / 2;
		}
	}
}
