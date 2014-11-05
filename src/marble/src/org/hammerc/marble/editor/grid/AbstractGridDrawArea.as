// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.grid
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.hammerc.core.AbstractEnforcer;
	
	/**
	 * <code>AbstractGridDrawArea</code> 类为抽象类, 定义了格子编辑器绘制区域显示对象.
	 * @author wizardc
	 */
	public class AbstractGridDrawArea extends Sprite implements IGridDrawArea
	{
		/**
		 * 编辑器对象.
		 */
		protected var _editor:IGridEditor;
		
		/**
		 * <code>AbstractGridDrawArea</code> 类为抽象类, 不能被实例化.
		 * @param editor 编辑器对象.
		 */
		public function AbstractGridDrawArea(editor:IGridEditor)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractGridDrawArea);
			_editor = editor;
			this.mouseChildren = this.mouseEnabled = false;
			this.visible = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function targetChanged(target:Point):void
		{
			AbstractEnforcer.enforceMethod();
		}
	}
}
