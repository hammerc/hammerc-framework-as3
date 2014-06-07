/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid.tools
{
	import flash.events.EventDispatcher;
	
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.marble.editor.grid.GridDrawEvent;
	
	import org.hammerc.marble.editor.grid.IGridEditor;
	
	/**
	 * @eventType org.hammerc.marble.editor.grid.GridDrawEvent.DRAW_BEGIN
	 */
	[Event(name="drawBegin", type="org.hammerc.marble.editor.grid.GridDrawEvent")]
	
	/**
	 * @eventType org.hammerc.marble.editor.grid.GridDrawEvent.DRAW_END
	 */
	[Event(name="drawEnd", type="org.hammerc.marble.editor.grid.GridDrawEvent")]
	
	/**
	 * <code>AbstractGridTool</code> 类为抽象类, 定义了用于格子编辑器的绘制工具.
	 * @author wizardc
	 */
	public class AbstractGridTool extends EventDispatcher implements IGridTool
	{
		/**
		 * 编辑器对象.
		 */
		protected var _editor:IGridEditor;
		
		/**
		 * <code>AbstractGridTool</code> 类为抽象类, 不能被实例化.
		 * @param editor 编辑器对象.
		 */
		public function AbstractGridTool(editor:IGridEditor)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractGridTool);
			_editor = editor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRegister():void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRemove():void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 抛出一次绘制开始事件.
		 */
		protected function dispatchDrawBeginEvent():void
		{
			this.dispatchEvent(new GridDrawEvent(GridDrawEvent.DRAW_BEGIN));
		}
		
		/**
		 * 抛出一次绘制完成事件.
		 */
		protected function dispatchDrawEndEvent():void
		{
			this.dispatchEvent(new GridDrawEvent(GridDrawEvent.DRAW_END));
		}
	}
}
