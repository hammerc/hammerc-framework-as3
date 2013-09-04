/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.hammerc.components.Rect;
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IUIComponent;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.managers.IPopUpManager;
	import org.hammerc.managers.ISystemManager;
	
	/**
	 * <code>PopUpManagerImpl</code> 类实现了弹出管理器的功能.
	 * @author wizardc
	 */
	public class PopUpManagerImpl extends EventDispatcher implements IPopUpManager
	{
		private static const REMOVE_FROM_SYSTEMMANAGER:String = "removeFromSystemManager";
		
		private var _modalColor:uint = 0x000000;
		private var _modalAlpha:Number = 0.5;
		
		private var _popUpList:Array = [];
		
		//模态窗口列表
		private var _popUpDataList:Vector.<PopUpData> = new Vector.<PopUpData>();
		
		//模态层失效的SystemManager列表
		private var _invalidateModalList:Vector.<ISystemManager> = new Vector.<ISystemManager>();
		private var _invalidateModalFlag:Boolean = false;
		
		private var _modalMaskDic:Dictionary = new Dictionary(true);
		
		/**
		 * 创建一个 <code>PopUpManagerImpl</code> 对象.
		 */
		public function PopUpManagerImpl()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function set modalColor(value:uint):void
		{
			if(_modalColor != value)
			{
				_modalColor = value;
				invalidateModal(HammercGlobals.systemManager);
			}
		}
		public function get modalColor():uint
		{
			return _modalColor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set modalAlpha(value:Number):void
		{
			if(_modalAlpha != value)
			{
				_modalAlpha = value;
				invalidateModal(HammercGlobals.systemManager);
			}
		}
		public function get modalAlpha():Number
		{
			return _modalAlpha;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get popUpList():Array
		{
			return _popUpList.concat();
		}
		
		/**
		 * @inheritDoc
		 */
		public function addPopUp(popUp:IUIComponent, modal:Boolean = false, center:Boolean = true, systemManager:ISystemManager = null):void
		{
			if(systemManager == null)
			{
				systemManager = HammercGlobals.systemManager;
			}
			if(systemManager == null)
			{
				return;
			}
			var data:PopUpData = findPopUpData(popUp);
			if(data != null)
			{
				data.modal = modal;
				popUp.removeEventListener(REMOVE_FROM_SYSTEMMANAGER, onRemoved);
			}
			else
			{
				data = new PopUpData(popUp, modal);
				_popUpDataList.push(data);
				_popUpList.push(popUp);
			}
			systemManager.popUpContainer.addElement(popUp);
			if(center)
			{
				this.centerPopUp(popUp);
			}
			if(popUp is IUIComponent)
			{
				IUIComponent(popUp).isPopUp = true;
			}
			if(modal)
			{
				invalidateModal(systemManager);
			}
			popUp.addEventListener(REMOVE_FROM_SYSTEMMANAGER, onRemoved);
		}
		
		/**
		 * 根据 popUp 获取对应的 popUpData.
		 */
		private function findPopUpData(popUp:IUIComponent):PopUpData
		{
			for each(var data:PopUpData in _popUpDataList)
			{
				if(data.popUp == popUp)
				{
					return data;
				}
			}
			return null;
		}
		
		/**
		 * 从舞台移除.
		 */
		private function onRemoved(event:Event):void
		{
			var index:int = 0;
			for each(var data:PopUpData in _popUpDataList)
			{
				if(data.popUp == event.target)
				{
					if(data.popUp is IUIComponent)
					{
						IUIComponent(data.popUp).isPopUp = false;
					}
					data.popUp.removeEventListener(REMOVE_FROM_SYSTEMMANAGER, onRemoved);
					_popUpDataList.splice(index, 1);
					_popUpList.splice(index, 1);
					invalidateModal(data.popUp.parent as ISystemManager);
					break;
				}
				index++;
			}
		}
		
		/**
		 * 标记一个 SystemManager 的模态层失效.
		 */
		private function invalidateModal(systemManager:ISystemManager):void
		{
			if(systemManager == null)
			{
				return;
			}
			if(_invalidateModalList.indexOf(systemManager) == -1)
			{
				_invalidateModalList.push(systemManager);
			}
			if(!_invalidateModalFlag)
			{
				_invalidateModalFlag = true;
				HammercGlobals.stage.addEventListener(Event.ENTER_FRAME, validateModal);
				HammercGlobals.stage.addEventListener(Event.RENDER, validateModal);
				HammercGlobals.stage.invalidate();
			}
		}
		
		private function validateModal(event:Event):void
		{
			_invalidateModalFlag = false;
			HammercGlobals.stage.removeEventListener(Event.ENTER_FRAME, validateModal);
			HammercGlobals.stage.removeEventListener(Event.RENDER, validateModal);
			for each(var sm:ISystemManager in _invalidateModalList)
			{
				updateModal(sm);
			}
			_invalidateModalList.length = 0;
		}
		
		/**
		 * 更新窗口模态效果.
		 */
		private function updateModal(systemManager:ISystemManager):void
		{
			var popUpContainer:IUIContainer = systemManager.popUpContainer;
			var found:Boolean = false;
			for(var i:int = popUpContainer.numElements - 1; i >= 0; i--)
			{
				var element:IUIComponent = popUpContainer.getElementAt(i);
				var data:PopUpData = findPopUpData(element);
				if(data != null && data.modal)
				{
					found = true;
					break;
				}
			}
			var modalMask:Rect = _modalMaskDic[systemManager];
			if(found)
			{
				if(modalMask == null)
				{
					_modalMaskDic[systemManager] = modalMask = new Rect();
					modalMask.top = modalMask.left = modalMask.right = modalMask.bottom = 0;
				}
				modalMask.strokeAlpha = 0;
				modalMask.fillColor = _modalColor;
				modalMask.alpha = _modalAlpha;
				if(modalMask.parent == systemManager)
				{
					if(popUpContainer.getElementIndex(modalMask) < i)
					{
						i--;
					}
					popUpContainer.setElementIndex(modalMask, i);
				}
				else
				{
					popUpContainer.addElementAt(modalMask, i);
				}
			}
			else if(modalMask && modalMask.parent == systemManager)
			{
				popUpContainer.removeElement(modalMask);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function bringToFront(popUp:IUIComponent):void
		{
			var data:PopUpData = findPopUpData(popUp);
			if(data != null && popUp.parent is ISystemManager)
			{
				var sm:ISystemManager = popUp.parent as ISystemManager;
				sm.popUpContainer.setElementIndex(popUp, sm.popUpContainer.numElements - 1);
				invalidateModal(sm);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function centerPopUp(popUp:IUIComponent):void
		{
			popUp.top = popUp.bottom = popUp.left = popUp.right = NaN;
			popUp.verticalCenter = popUp.horizontalCenter = 0;
			var parent:DisplayObjectContainer = popUp.parent;
			if(parent != null)
			{
				popUp.x = (parent.width - popUp.layoutBoundsWidth) * 0.5;
				popUp.y = (parent.height - popUp.layoutBoundsHeight) * 0.5;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removePopUp(popUp:IUIComponent):void
		{
			if(popUp && popUp.parent && findPopUpData(popUp))
			{
				if(popUp.parent is IUIContainer)
				{
					IUIContainer(popUp.parent).removeElement(popUp);
				}
				else if(popUp is DisplayObject)
				{
					popUp.parent.removeChild(DisplayObject(popUp));
				}
			}
		}
	}
}

import org.hammerc.core.IUIComponent;

/**
 * <code>PopUpData</code> 类记录一个弹出对象的信息.
 * @author wizardc
 */
class PopUpData
{
	/**
	 * 弹出框对象.
	 */
	public var popUp:IUIComponent;
	
	/**
	 * 弹出窗口是否为模态.
	 */
	public var modal:Boolean;
	
	/**
	 * 创建一个 <code>PopUpData</code> 对象.
	 * @param popUp 弹出框对象.
	 * @param modal 弹出窗口是否为模态.
	 */
	public function PopUpData(popUp:IUIComponent,modal:Boolean)
	{
		this.popUp = popUp;
		this.modal = modal;
	}
}
