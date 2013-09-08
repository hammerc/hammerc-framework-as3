/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.hammerc.core.IInvalidating;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.PopUpPosition;
	import org.hammerc.core.UIComponent;
	import org.hammerc.managers.PopUpManager;
	
	/**
	 * <code>PopUpAnchor</code> 类实现用于定位布局中的弹出控件或下拉控件的功能.
	 * @author wizardc
	 */
	public class PopUpAnchor extends UIComponent
	{
		//自身已经添加到舞台标志
		private var _addedToStage:Boolean = false;
		
		//popUp已经弹出的标志
		private var _popUpIsDisplayed:Boolean = false;
		
		private var _popUpWidthMatchesAnchorWidth:Boolean = false;
		private var _popUpHeightMatchesAnchorHeight:Boolean = false;
		
		private var _displayPopUp:Boolean = false;
		
		private var _popUp:IUIComponent;
		private var _popUpPosition:String = PopUpPosition.TOP_LEFT;
		
		/**
		 * 创建一个 <code>PopUpAnchor</code> 对象.
		 */
		public function PopUpAnchor()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			_addedToStage = true;
			callLater(checkPopUpState);
		}
		
		/**
		 * 延迟检查弹出状态, 防止堆栈溢出.
		 */
		private function checkPopUpState():void
		{
			if(_addedToStage)
			{
				addOrRemovePopUp();
			}
			else
			{
				if(popUp != null && DisplayObject(popUp).parent != null)
				{
					removeAndResetPopUp();
				}
			}
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			_addedToStage = false;
			callLater(checkPopUpState);
		}
		
		/**
		 * 设置或获取是否将 <code>popUp</code> 控件的宽度设置为 <code>PopUpAnchor</code> 的宽度值.
		 */
		public function set popUpWidthMatchesAnchorWidth(value:Boolean):void
		{
			if(_popUpWidthMatchesAnchorWidth != value)
			{
				_popUpWidthMatchesAnchorWidth = value;
				this.invalidateDisplayList();
			}
		}
		public function get popUpWidthMatchesAnchorWidth():Boolean
		{
			return _popUpWidthMatchesAnchorWidth;
		}
		
		/**
		 * 设置或获取是否将 <code>popUp</code> 控件的高度设置为 <code>PopUpAnchor</code> 的高度值.
		 */
		public function set popUpHeightMatchesAnchorHeight(value:Boolean):void
		{
			if(_popUpHeightMatchesAnchorHeight != value)
			{
				_popUpHeightMatchesAnchorHeight = value;
				this.invalidateDisplayList();
			}
		}
		public function get popUpHeightMatchesAnchorHeight():Boolean
		{
			return _popUpHeightMatchesAnchorHeight;
		}
		
		/**
		 * 设置或获取是将 <code>popUp</code> 控件弹出还是关闭.
		 */
		public function set displayPopUp(value:Boolean):void
		{
			if(_displayPopUp != value)
			{
				_displayPopUp = value;
				addOrRemovePopUp();
			}
		}
		public function get displayPopUp():Boolean
		{
			return _displayPopUp;
		}
		
		/**
		 * 设置或获取要弹出或移除的目标显示对象.
		 */
		public function set popUp(value:IUIComponent):void
		{
			if(_popUp != value)
			{
				_popUp = value;
				this.dispatchEvent(new Event("popUpChanged"));
			}
		}
		public function get popUp():IUIComponent
		{
			return _popUp;
		}
		
		/**
		 * 设置或获取 <code>popUp</code> 相对于 <code>PopUpAnchor</code> 的弹出位置. 默认值 <code>PopUpPosition.TOP_LEFT</code>.
		 */
		public function set popUpPosition(value:String):void
		{
			if(_popUpPosition != value)
			{
				_popUpPosition = value;
				this.invalidateDisplayList();
			}
		}
		public function get popUpPosition():String
		{
			return _popUpPosition;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			applyPopUpTransform(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * 手动刷新弹出位置和尺寸.
		 */
		public function updatePopUpTransform():void
		{
			applyPopUpTransform(width, height);
		}
		
		/**
		 * 添加或移除 popUp.
		 */
		private function addOrRemovePopUp():void
		{
			if(!_addedToStage || this.popUp == null)
			{
				return;
			}
			if(this.popUp.parent == null && _displayPopUp)
			{
				PopUpManager.addPopUp(this.popUp, false, false, this.systemManager);
				this.popUp.ownerChanged(this);
				_popUpIsDisplayed = true;
				applyPopUpTransform(this.width, this.height);
			}
			else if(this.popUp.parent != null && !_displayPopUp)
			{
				removeAndResetPopUp();
			}
		}
		
		/**
		 * 移除并重置 popUp.
		 */
		private function removeAndResetPopUp():void
		{
			_popUpIsDisplayed = false;
			PopUpManager.removePopUp(this.popUp);
			this.popUp.ownerChanged(null);
		}
		
		/**
		 * 对 popUp 应用尺寸和位置调整.
		 */
		private function applyPopUpTransform(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(!_popUpIsDisplayed)
			{
				return;
			}
			var w:Number;
			var h:Number;
			if(popUpWidthMatchesAnchorWidth)
			{
				w = unscaledWidth;
			}
			if(popUpHeightMatchesAnchorHeight)
			{
				h = unscaledHeight;
			}
			this.popUp.setLayoutBoundsSize(w, h);
			if(this.popUp is IInvalidating)
			{
				(this.popUp as IInvalidating).validateNow();
			}
			var popUpPoint:Point = calculatePopUpPosition();
			popUp.x = popUpPoint.x;
			popUp.y = popUpPoint.y;
		}
		
		/**
		 * 计算 popUp 的弹出位置.
		 */
		private function calculatePopUpPosition():Point
		{
			var registrationPoint:Point = new Point();
			switch(_popUpPosition)
			{
				case PopUpPosition.BELOW:
					registrationPoint.x = 0;
					registrationPoint.y = this.height;
					break;
				case PopUpPosition.ABOVE:
					registrationPoint.x = 0;
					registrationPoint.y = -this.popUp.layoutBoundsHeight;
					break;
				case PopUpPosition.LEFT:
					registrationPoint.x = -this.popUp.layoutBoundsWidth;
					registrationPoint.y = 0;
					break;
				case PopUpPosition.RIGHT:
					registrationPoint.x = this.width;
					registrationPoint.y = 0;
					break;
				case PopUpPosition.CENTER:
					registrationPoint.x = (this.width - this.popUp.layoutBoundsWidth) * 0.5;
					registrationPoint.y = (this.height - this.popUp.layoutBoundsHeight) * 0.5;
					break;
				case PopUpPosition.TOP_LEFT:
					break;
			}
			registrationPoint = this.localToGlobal(registrationPoint);
			registrationPoint = this.popUp.parent.globalToLocal(registrationPoint);
			return registrationPoint;
		}
	}
}
