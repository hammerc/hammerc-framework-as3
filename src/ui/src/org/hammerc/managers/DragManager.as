/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	
	import org.hammerc.core.Injector;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.managers.dragClasses.DragData;
	import org.hammerc.managers.impl.DragManagerImpl;
	
	/**
	 * <code>DragManager</code> 类管理和提供显示对象的拖动.
	 * @author wizardc
	 */
	public class DragManager
	{
		private static var _impl:IDragManager;
		
		private static function get impl():IDragManager
		{
			if(_impl == null)
			{
				try
				{
					_impl = Injector.getInstance(IDragManager);
				}
				catch(error:Error)
				{
					_impl = new DragManagerImpl();
				}
			}
			return _impl;
		}
		
		/**
		 * 获取当前是否正在进行拖拽操作.
		 */
		public static function get isDragging():Boolean
		{
			return impl.isDragging;
		}
		
		/**
		 * 启动拖放操作.
		 * @param dragInitiator 指定启动拖动的显示对象.
		 * @param dragData 设置正在拖动的数据对象.
		 * @param dragImage 要拖动的图像, 默认使用黑边白底的矩形.
		 * @param offsetX 拖动图像的 x 轴偏移, 如指定偏移量则拖动代理对齐该偏移量, 否则使用鼠标按下的坐标.
		 * @param offsetY 拖动图像的 y 轴偏移, 如指定偏移量则拖动代理对齐该偏移量, 否则使用鼠标按下的坐标.
		 * @param imageAlpha 拖动图像的透明度.
		 */
		public static function doDrag(dragInitiator:InteractiveObject, dragData:DragData, dragImage:DisplayObject = null, offsetX:Number = 0, offsetY:Number = 0, imageAlpha:Number = 0.5):void
		{
			impl.doDrag(dragInitiator, dragData, dragImage, offsetX, offsetY, imageAlpha);
		}
		
		/**
		 * 设置拖动的显示对象允许放置到指定的显示对象上.
		 * @param target 可以接收当前拖动对象的显示对象.
		 */
		public static function acceptDragDrop(target:InteractiveObject):void
		{
			impl.acceptDragDrop(target);
		}
		
		/**
		 * 结束当前进行的拖动操作.
		 */
		hammerc_internal static function endDrag():void
		{
			impl.endDrag();
		}
	}
}
