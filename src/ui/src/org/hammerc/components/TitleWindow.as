// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.CloseEvent;
	import org.hammerc.managers.PopUpManager;
	import org.hammerc.utils.LayoutUtil;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.CloseEvent.CLOSE
	 */
	[Event(name="close", type="org.hammerc.events.CloseEvent")]
	
	/**
	 * <code>TitleWindow</code> 类为可移动窗口组件.
	 * <p>注意: 此窗口必须使用 <code>PopUpManager.addPopUp()</code> 弹出之后才能移动.</p>
	 * @author wizardc
	 */
	public class TitleWindow extends Panel
	{
		/**
		 * 皮肤子件, 关闭按钮.
		 */
		public var closeButton:Button;
		
		/**
		 * 皮肤子件, 可移动区域.
		 */
		public var moveArea:InteractiveObject;
		
		private var _showCloseButton:Boolean = true;
		
		private var _autoBackToStage:Boolean = true;
		
		private var _offsetPoint:Point;
		
		/**
		 * 创建一个 <code>TitleWindow</code> 对象.
		 */
		public function TitleWindow()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN, onWindowMouseDown, true, 100);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return TitleWindow;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "TitleWindow";
		}
		
		/**
		 * 设置或获取是否显示关闭按钮.
		 */
		public function set showCloseButton(value:Boolean):void
		{
			if(_showCloseButton == value)
			{
				return;
			}
			_showCloseButton = value;
			if(closeButton != null)
			{
				closeButton.visible = _showCloseButton;
			}
		}
		public function get showCloseButton():Boolean
		{
			return _showCloseButton;
		}
		
		/**
		 * 设置或获取是否自动调整窗口位置使窗口始终可点击.
		 */
		public function set autoBackToStage(value:Boolean):void
		{
			_autoBackToStage = value;
		}
		public function get autoBackToStage():Boolean
		{
			return _autoBackToStage;
		}
		
		/**
		 * 在窗体上按下时前置窗口.
		 */
		private function onWindowMouseDown(event:MouseEvent):void
		{
			if(this.enabled && isPopUp&&event.target != closeButton)
			{
				PopUpManager.bringToFront(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == moveArea)
			{
				moveArea.addEventListener(MouseEvent.MOUSE_DOWN, this.moveArea_mouseDownHandler);
			}
			else if(instance == closeButton)
			{
				closeButton.addEventListener(MouseEvent.CLICK, this.closeButton_clickHandler);
				closeButton.visible = _showCloseButton;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			if(instance == moveArea)
			{
				moveArea.removeEventListener(MouseEvent.MOUSE_DOWN, this.moveArea_mouseDownHandler);
			}
			else if(instance == closeButton)
			{
				closeButton.removeEventListener(MouseEvent.CLICK, this.closeButton_clickHandler);
			}
		}
		
		/**
		 * 关闭按钮按下.
		 * @param event 对应的事件.
		 */
		protected function closeButton_clickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
		/**
		 * 鼠标在可移动区域按下.
		 * @param event 对应的事件.
		 */
		protected function moveArea_mouseDownHandler(event:MouseEvent):void
		{
			if(this.enabled && this.isPopUp)
			{
				_offsetPoint = this.globalToLocal(new Point(event.stageX, event.stageY));
				_includeInLayout = false;
				HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.moveArea_mouseMoveHandler);
				HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, this.moveArea_mouseUpHandler);
				HammercGlobals.stage.addEventListener(Event.MOUSE_LEAVE, this.moveArea_mouseUpHandler);
			}
		}
		
		/**
		 * 鼠标拖拽时的移动事件.
		 * @param event 对应的事件.
		 */
		protected function moveArea_mouseMoveHandler(event:MouseEvent):void
		{
			var pos:Point = this.globalToLocal(new Point(event.stageX, event.stageY));
			this.x += pos.x - _offsetPoint.x;
			this.y += pos.y - _offsetPoint.y;
			if(HammercGlobals.useUpdateAfterEvent)
			{
				event.updateAfterEvent();
			}
		}
		
		/**
		 * 鼠标在舞台上弹起事件.
		 * @param event 对应的事件.
		 */
		protected function moveArea_mouseUpHandler(event:Event):void
		{
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveArea_mouseMoveHandler);
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, this.moveArea_mouseUpHandler);
			HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, this.moveArea_mouseUpHandler);
			if(_autoBackToStage)
			{
				adjustPosForStage();
			}
			_offsetPoint = null;
			LayoutUtil.adjustRelativeByXY(this);
			this.includeInLayout = true;
		}
		
		/**
		 * 调整窗口位置, 使其可以在舞台中被点中.
		 */
		private function adjustPosForStage():void
		{
			if(moveArea == null || stage == null)
			{
				return;
			}
			var pos:Point = moveArea.localToGlobal(new Point());
			var stageX:Number = pos.x;
			var stageY:Number = pos.y;
			if(pos.x + moveArea.width < 35)
			{
				stageX = 35 - moveArea.width;
			}
			if(pos.x > stage.stageWidth - 20)
			{
				stageX = stage.stageWidth - 20;
			}
			if(pos.y + moveArea.height < 20)
			{
				stageY = 20 - moveArea.height;
			}
			if(pos.y > stage.stageHeight - 20)
			{
				stageY = stage.stageHeight - 20;
			}
			this.x += stageX - pos.x;
			this.y += stageY - pos.y;
		}
	}
}
