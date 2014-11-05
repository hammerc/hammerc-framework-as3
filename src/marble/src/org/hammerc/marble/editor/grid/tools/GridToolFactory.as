// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.grid.tools
{
	import org.hammerc.marble.editor.grid.GridDrawType;
	import org.hammerc.marble.editor.grid.IGridEditor;
	
	/**
	 * <code>GridToolFactory</code> 类定义了格子编辑器绘制工具工厂类.
	 * @author wizardc
	 */
	public class GridToolFactory
	{
		/**
		 * 获取对应的绘制工具对象.
		 * @param drawType 绘制类型.
		 * @param editor 编辑器对象.
		 * @return 对应的绘制工具对象.
		 */
		public static function getGridTool(drawType:int, editor:IGridEditor):IGridTool
		{
			switch(drawType)
			{
				case GridDrawType.PENCIL:
					return new GridPencilTool(editor);
				case GridDrawType.RULER:
					return new GridRulerTool(editor);
				case GridDrawType.PLECHOVKA:
					return new GridPlechovkaTool(editor);
			}
			return null;
		}
	}
}
