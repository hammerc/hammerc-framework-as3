/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.stage
{
	import flash.display.Sprite;
	
	import org.hammerc.core.AbstractEnforcer;
	
	import org.hammerc.managers.RepaintManager;
	
	/**
	 * <code>AbstractStageLayer</code> 类定义了一个抽象舞台层类.
	 * @author wizardc
	 */
	public class AbstractStageLayer extends Sprite implements IStageLayer
	{
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		/**
		 * 记录是否显示本对象.
		 */
		protected var _show:Boolean = true;
		
		/**
		 * 记录是否锁定本对象.
		 */
		protected var _lock:Boolean = false;
		
		/**
		 * <code>AbstractStageLayer</code> 类为抽象类, 不能被实例化.
		 */
		public function AbstractStageLayer()
		{
			AbstractEnforcer.enforceConstructor(this, AbstractStageLayer);
			RepaintManager.getInstance().register(this);
			//调用初始化方法
			this.init();
		}
		
		/**
		 * 初始化时会调用该方法.
		 */
		protected function init():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function set show(value:Boolean):void
		{
			if(_show != value)
			{
				_show = value;
				this.visible = _show;
			}
		}
		public function get show():Boolean
		{
			return _show;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set lock(value:Boolean):void
		{
			if(_lock != value)
			{
				_lock = value;
				this.mouseEnabled = _lock;
				this.mouseChildren = _lock;
			}
		}
		public function get lock():Boolean
		{
			return _lock;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onAdd():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRemove():void
		{
		}
		
		/**
		 * 侦听下次显示列表的绘制.
		 */
		protected function callRedraw():void
		{
			_changed = true;
			RepaintManager.getInstance().callRepaint(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function repaint():void
		{
			if(_changed)
			{
				this.redraw();
				_changed = false;
			}
		}
		
		/**
		 * 绘制编辑器.
		 */
		protected function redraw():void
		{
		}
	}
}
