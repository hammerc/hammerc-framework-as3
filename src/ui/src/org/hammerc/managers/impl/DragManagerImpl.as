// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.managers.impl
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.geom.Point;
	
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.managers.IDragManager;
	import org.hammerc.managers.ILayoutManagerClient;
	import org.hammerc.managers.ISystemManager;
	import org.hammerc.managers.dragClasses.DragData;
	import org.hammerc.managers.dragClasses.DragProxy;
	
	use namespace hammerc_internal;
	
	[ExcludeClass]
	
	/**
	 * <code>DragManagerImpl</code> 类实现了拖拽管理器的功能.
	 * @author wizardc
	 */
	public class DragManagerImpl implements IDragManager
	{
		private var _dragInitiator:InteractiveObject;
		private var _dragProxy:DragProxy;
		private var _isDragging:Boolean = false;
		
		/**
		 * 创建一个 <code>DragManagerImpl</code> 对象.
		 */
		public function DragManagerImpl()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isDragging():Boolean
		{
			return _isDragging;
		}
		
		/**
		 * 获取弹出层.
		 */
		private function get popUpContainer():IUIContainer
		{
			var sm:ISystemManager;
			if(_dragInitiator is IUIComponent)
			{
				sm = IUIComponent(_dragInitiator).systemManager;
			}
			if(sm == null)
			{
				sm = HammercGlobals.systemManager;
			}
			return sm.popUpContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function doDrag(dragInitiator:InteractiveObject, dragData:DragData, dragImage:DisplayObject = null, offsetX:Number = 0, offsetY:Number = 0, imageAlpha:Number = 0.5):void
		{
			if(_isDragging)
			{
				return;
			}
			_isDragging = true;
			_dragInitiator = dragInitiator;
			_dragProxy = new DragProxy(dragInitiator, dragData);
			var stage:Stage = HammercGlobals.stage;
			if(stage == null)
			{
				return;
			}
			popUpContainer.addElement(_dragProxy);
			if(dragImage != null)
			{
				_dragProxy.addChild(dragImage);
				if(dragImage is ILayoutManagerClient)
				{
					HammercGlobals.layoutManager.validateClient(ILayoutManagerClient(dragImage), true);
				}
			}
			_dragProxy.alpha = imageAlpha;
			var mouseX:Number = stage.mouseX;
			var mouseY:Number = stage.mouseY;
			var proxyOrigin:Point = dragInitiator.localToGlobal(new Point(-offsetX, -offsetY));
			_dragProxy.offsetX = mouseX - proxyOrigin.x;
			_dragProxy.offsetY = mouseY - proxyOrigin.y;
			_dragProxy.x = proxyOrigin.x;
			_dragProxy.y = proxyOrigin.y;
			if(dragImage != null)
			{
				dragImage.cacheAsBitmap = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function acceptDragDrop(target:InteractiveObject):void
		{
			if(_dragProxy != null)
			{
				_dragProxy.target = target;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function endDrag():void
		{
			if(_dragProxy != null)
			{
				popUpContainer.removeElement(_dragProxy);
				if(_dragProxy.numChildren > 0)
				{
					_dragProxy.removeChildAt(0);
				}
				_dragProxy = null;
			}
			_dragInitiator = null;
			_isDragging = false;
		}
	}
}
