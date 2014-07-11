/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.common
{
	import org.hammerc.core.AbstractEnforcer;
	
	/**
	 * <code>AbstractNoScopeEditor</code> 类为抽象类, 定义了没有固定范围的编辑器.
	 * @author wizardc
	 */
	public class AbstractNoScopeEditor extends AbstractEditor
	{
		/**
		 * <code>AbstractNoScopeEditor</code> 类为抽象类, 不能被实例化.
		 */
		public function AbstractNoScopeEditor()
		{
			AbstractEnforcer.enforceConstructor(this, AbstractNoScopeEditor);
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function init():void
		{
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
			this.adjustCanvas();
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
					_checkerboardShape.width = _width + _checkerboardShape.sizeX * 4;
					_checkerboardShape.height = _height + _checkerboardShape.sizeY * 4;
					_canvas.graphics.clear();
					break;
				case CanvasType.PURE_COLOR:
				default:
					_checkerboardShape.width = 0;
					_checkerboardShape.height = 0;
					_canvas.graphics.clear();
					_canvas.graphics.beginFill(_canvasColor);
					_canvas.graphics.drawRect(0, 0, _width, _height);
					_canvas.graphics.endFill();
					break;
			}
			this.adjustCanvas();
		}
		
		/**
		 * 调整画布的位置.
		 */
		protected function adjustCanvas():void
		{
			switch(_canvasType)
			{
				case CanvasType.CHECKERBOARD:
					_canvas.x = _originX % (_checkerboardShape.sizeX * 2) - (_checkerboardShape.sizeX * 2);
					_canvas.y = _originY % (_checkerboardShape.sizeY * 2) - (_checkerboardShape.sizeY * 2);
					break;
				case CanvasType.PURE_COLOR:
				default:
					_canvas.x = 0;
					_canvas.y = 0;
					break;
			}
		}
		
		/**
		 * 设置编辑区域居中.
		 */
		public function editAreaCenter():void
		{
			this.originX = _width / 2;
			this.originY = _height / 2;
		}
	}
}
