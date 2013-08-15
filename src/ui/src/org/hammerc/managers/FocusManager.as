/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.hammerc.core.IUIComponent;
	
	/**
	 * <code>FocusManager</code> 类管理程序中的焦点.
	 * @author wizardc
	 */
	public class FocusManager implements IFocusManager
	{
		/**
		 * 记录舞台.
		 */
		private var _stage:Stage;
		
		/**
		 * 记录当前拥有焦点的对象.
		 */
		private var _currentFocus:IUIComponent;
		
		/**
		 * 创建一个 <code>FocusManager</code> 对象.
		 */
		public function FocusManager()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function set stage(value:Stage):void
		{
			if(_stage != value)
			{
				var s:Stage = _stage ? stage : value;
				if(value != null)
				{
					s.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					s.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
					s.addEventListener(Event.ACTIVATE, activateHandler);
					s.addEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
				}
				else
				{
					s.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					s.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, mouseFocusChangeHandler);
					s.removeEventListener(Event.ACTIVATE, activateHandler);
					s.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler, true);
				}
				_stage = value;
			}
		}
		public function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * 屏蔽原生鼠标点击时的焦点管理.
		 * @param event 对应的事件.
		 */
		private function mouseFocusChangeHandler(event:FocusEvent):void
		{
			//如果已经取消默认的事件行为则跳过屏蔽
			if(event.isDefaultPrevented())
			{
				return;
			}
			//如果得到焦点的对象为可输入或可选择的文件区域对象则跳过屏蔽
			if(event.relatedObject is TextField)
			{
				var textField:TextField = event.relatedObject as TextField;
				if(textField.type == TextFieldType.INPUT || textField.selectable)
				{
					return;
				}
			}
			//屏蔽焦点的转换
			event.preventDefault();
		}
		
		private function focusInHandler(event:FocusEvent):void
		{
			_currentFocus = getTopLevelFocusTarget(event.target as InteractiveObject);
		}
		
		/**
		 * 获取指定交互对象及其父层可以接收焦点的组件.
		 * @param target 指定的交互对象.
		 * @return 可以接收焦点的组件.
		 */
		private function getTopLevelFocusTarget(target:InteractiveObject):IUIComponent
		{
			while(target != null)
			{
				if(target is IUIComponent && (target as IUIComponent).focusEnabled && (target as IUIComponent).enabled)
				{
					return target as IUIComponent;
				}
				target = target.parent;
			}
			return null;
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			var focus:IUIComponent = getTopLevelFocusTarget(event.target as InteractiveObject);
			if(focus == null)
			{
				return;
			}
			if(focus != _currentFocus && !(focus is TextField))
			{
				focus.setFocus();
			}
		}
		
		private function activateHandler(event:Event):void
		{
			if(_currentFocus != null)
			{
				_currentFocus.setFocus();
			}
		}
	}
}
