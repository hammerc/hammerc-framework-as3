/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers.dragClasses
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.UIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.DragEvent;
	import org.hammerc.managers.DragManager;
	import org.hammerc.utils.DisplayUtil;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>DragProxy</code> 类实现了拖动时的图像代理及拖拽核心方法.
	 * @author wizardc
	 */
	public class DragProxy extends UIComponent
	{
		/**
		 * 记录上一次的鼠标事件对象.
		 */
		private var _lastMouseEvent:MouseEvent;
		
		/**
		 * 记录舞台引用.
		 */
		private var _stageRoot:Stage;
		
		private var _dragInitiator:DisplayObject;
		private var _dragData:DragData;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _target:DisplayObject;
		
		/**
		 * 创建一个 <code>DragProxy</code> 对象.
		 * @param dragInitiator 启动拖动的显示对象.
		 * @param dragData 正在拖动的数据对象.
		 */
		public function DragProxy(dragInitiator:InteractiveObject, dragData:DragData)
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_dragInitiator = dragInitiator;
			_dragData = dragData;
			_stageRoot = HammercGlobals.stage;
			_stageRoot.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_stageRoot.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_stageRoot.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
		}
		
		/**
		 * 获取启动拖动的显示对象.
		 */
		public function get dragInitiator():DisplayObject
		{
			return _dragInitiator;
		}
		
		/**
		 * 获取正在拖动的数据对象.
		 */
		public function get dragData():DragData
		{
			return _dragData;
		}
		
		/**
		 * 设置或获取拖动图像的 x 轴偏移.
		 */
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		/**
		 * 设置或获取拖动图像的 y 轴偏移.
		 */
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		/**
		 * 设置或获取允许放置拖动数据的显示对象.
		 */
		public function set target(value:DisplayObject):void
		{
			_target = value;
		}
		public function get target():DisplayObject
		{
			return _target;
		}
		
		/**
		 * 获取最后的鼠标事件.
		 */
		public function get lastMouseEvent():MouseEvent
		{
			return _lastMouseEvent;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if(_stageRoot.focus == null)
			{
				this.setFocus();
			}
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			_lastMouseEvent = event;
			var dragEvent:DragEvent;
			var dropTarget:DisplayObject;
			var i:int;
			var point:Point = new Point(event.localX, event.localY);
			var stagePoint:Point = DisplayObject(event.target).localToGlobal(point);
			point = parent.globalToLocal(stagePoint);
			var mouseX:Number = point.x;
			var mouseY:Number = point.y;
			x = mouseX - _offsetX;
			y = mouseY - _offsetY;
			if(event == null)
			{
				return;
			}
			var targetList:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			DisplayUtil.getObjectsUnderPoint(_stageRoot, stagePoint, targetList);
			var newTarget:DisplayObject = null;
			var targetIndex:int = targetList.length - 1;
			while(targetIndex >= 0)
			{
				newTarget = targetList[targetIndex];
				if(newTarget != this && !contains(newTarget))
				{
					break;
				}
				targetIndex--;
			}
			if(_target != null)
			{
				var foundIt:Boolean = false;
				var oldTarget:DisplayObject = _target;
				dropTarget = newTarget;
				while(dropTarget)
				{
					if(dropTarget == _target)
					{
						this.dispatchDragEvent(DragEvent.DRAG_OVER, event, dropTarget);
						foundIt = true;
						break;
					}
					else
					{
						this.dispatchDragEvent(DragEvent.DRAG_ENTER, event, dropTarget);
						if(_target == dropTarget)
						{
							foundIt = false;
							break;
						}
					}
					dropTarget = dropTarget.parent;
				}
				if(!foundIt)
				{
					this.dispatchDragEvent(DragEvent.DRAG_EXIT, event, oldTarget);
					if(_target == oldTarget)
					{
						_target = null;
					}
				}
			}
			if(_target == null)
			{
				dropTarget = newTarget;
				while(dropTarget != null)
				{
					if(dropTarget != this)
					{
						this.dispatchDragEvent(DragEvent.DRAG_ENTER, event, dropTarget);
						if(_target != null)
						{
							break;
						}
					}
					dropTarget = dropTarget.parent;
				}
			}
			if(HammercGlobals.useUpdateAfterEvent)
			{
				event.updateAfterEvent();
			}
		}
		
		private function mouseLeaveHandler(event:Event):void
		{
			mouseUpHandler(lastMouseEvent);
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			_stageRoot.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_stageRoot.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_stageRoot.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			var dragEvent:DragEvent;
			if(_target != null)
			{
				dragEvent = new DragEvent(DragEvent.DRAG_DROP, _dragInitiator, _dragData);
				if(event != null)
				{
					dragEvent.ctrlKey = event.ctrlKey;
					dragEvent.altKey = event.altKey;
					dragEvent.shiftKey = event.shiftKey;
				}
				var pt:Point = new Point();
				pt.x = lastMouseEvent.localX;
				pt.y = lastMouseEvent.localY;
				pt = DisplayObject(lastMouseEvent.target).localToGlobal(pt);
				pt = DisplayObject(_target).globalToLocal(pt);
				dragEvent.localX = pt.x;
				dragEvent.localY = pt.y;
				_target.dispatchEvent(dragEvent);
			}
			dragEvent = new DragEvent(DragEvent.DRAG_COMPLETE, _dragInitiator, _dragData);
			dragEvent.relatedObject = InteractiveObject(_target);
			if(event != null)
			{
				dragEvent.ctrlKey = event.ctrlKey;
				dragEvent.altKey = event.altKey;
				dragEvent.shiftKey = event.shiftKey;
			}
			_dragInitiator.dispatchEvent(dragEvent);
			DragManager.endDrag();
			_lastMouseEvent = null;
		}
		
		/**
		 * 派送拖拽事件.
		 * @param type 事件类型.
		 * @param mouseEvent 对应的鼠标事件.
		 * @param eventTarget 发送事件的目标对象.
		 */
		public function dispatchDragEvent(type:String, mouseEvent:MouseEvent, eventTarget:Object):void
		{
			var point:Point = new Point(mouseEvent.localX, mouseEvent.localY);
			point = (mouseEvent.target as DisplayObject).localToGlobal(point);
			point = (eventTarget as DisplayObject).globalToLocal(point);
			var dragEvent:DragEvent = new DragEvent(type, _dragInitiator, _dragData);
			dragEvent.buttonDown = mouseEvent.buttonDown;
			dragEvent.relatedObject = mouseEvent.relatedObject;
			dragEvent.localX = point.x;
			dragEvent.localY = point.y;
			dragEvent.altKey = mouseEvent.altKey;
			dragEvent.ctrlKey = mouseEvent.ctrlKey;
			dragEvent.shiftKey = mouseEvent.shiftKey;
			(eventTarget as DisplayObject).dispatchEvent(dragEvent);
		}
	}
}
