/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.hammerc.display.IRepaint;
	
	/**
	 * <code>RepaintManager</code> 类管理所有需要在呈现之前重绘的显示对象.
	 * @author wizardc
	 */
	public class RepaintManager
	{
		private static var _instance:RepaintManager;
		
		/**
		 * 获取本类的唯一实例.
		 * @return 本类的唯一实例.
		 */
		public static function getInstance():RepaintManager
		{
			if(_instance == null)
			{
				_instance = new RepaintManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/**
		 * 本类为单例类不能实例化.
		 * @param singletonEnforcer 单例类实现对象.
		 */
		public function RepaintManager(singletonEnforcer:SingletonEnforcer)
		{
			if(singletonEnforcer == null)
			{
				throw new Error("单例类不能进行实例化！");
			}
		}
		
		/**
		 * 呼叫重绘方法, 只有调用本方法后才会在呈现显示对象之前调用 <code>repaint()</code> 方法.
		 * @param repaint 需要重绘的对象.
		 * @throws Error 如果传入的参数 <code>repaint</code> 不是 <code>DisplayObject</code> 的子类时会抛出该异常.
		 */
		public function callRepaint(repaint:IRepaint):void
		{
			if(!(repaint is DisplayObject))
			{
				throw new Error("参数\"repaint\"必须是\"DisplayObject\"类的子类！");
			}
			var display:DisplayObject = repaint as DisplayObject;
			if(display.stage != null)
			{
				display.stage.invalidate();
			}
			display.addEventListener(Event.EXIT_FRAME, renderHandler);
		}
		
		/**
		 * 注册需要重绘的对象.
		 * @param repaint 需要重绘的对象.
		 * @throws Error 如果传入的参数 <code>repaint</code> 不是 <code>DisplayObject</code> 的子类时会抛出该异常.
		 */
		public function register(repaint:IRepaint):void
		{
			if(!(repaint is DisplayObject))
			{
				throw new Error("参数\"repaint\"必须是\"DisplayObject\"类的子类！");
			}
			(repaint as DisplayObject).addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			(repaint as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			(event.target as DisplayObject).addEventListener(Event.RENDER, renderHandler);
			(event.target as IRepaint).repaint();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			(event.target as DisplayObject).removeEventListener(Event.RENDER, renderHandler);
		}
		
		private function renderHandler(event:Event):void
		{
			if(event.type == Event.EXIT_FRAME)
			{
				(event.target as DisplayObject).removeEventListener(Event.EXIT_FRAME, renderHandler);
			}
			(event.target as IRepaint).repaint();
		}
	}
}

class SingletonEnforcer{}
