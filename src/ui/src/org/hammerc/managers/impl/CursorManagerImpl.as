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
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IUIContainer;
	import org.hammerc.core.UIComponent;
	import org.hammerc.managers.ICursorManager;
	
	[ExcludeClass]
	
	/**
	 * <code>CursorManagerImpl</code> 类实现了光标管理器的功能.
	 * @author wizardc
	 */
	public class CursorManagerImpl implements ICursorManager
	{
		private var _cursorHolder:UIComponent;
		
		private var _currentCursorName:String;
		private var _currentCursor:DisplayObject;
		
		//记录所有注册的光标对象
		private var _cursorItemMap:Object = new Object();
		
		//记录当前处于可视状态的光标对象的所有优先级, 数值从低到高排列
		private var _priorityList:Array = new Array();
		
		//记录所有处于可视状态的光标对象
		private var _visibleListMap:Object = new Object();
		
		//记录是否添加了舞台事件侦听
		private var _hasListener:Boolean = false;
		
		/**
		 * 创建一个 <code>CursorManagerImpl</code> 对象.
		 */
		public function CursorManagerImpl()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			_cursorHolder = new UIComponent();
			_cursorHolder.mouseEnabled = false;
			_cursorHolder.mouseChildren = false;
			cursorContainer.addElement(_cursorHolder);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentCursorName():String
		{
			return _currentCursorName;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get currentCursor():DisplayObject
		{
			return _currentCursor;
		}
		
		/**
		 * 获取光标层.
		 */
		private function get cursorContainer():IUIContainer
		{
			return HammercGlobals.systemManager.cursorContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function showSystemCursor():void
		{
			Mouse.show();
		}
		
		/**
		 * @inheritDoc
		 */
		public function hideSystemCursor():void
		{
			Mouse.hide();
		}
		
		/**
		 * @inheritDoc
		 */
		public function showCursor():void
		{
			_cursorHolder.visible = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hideCursor():void
		{
			_cursorHolder.visible = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setCursor(cursorName:String):void
		{
			if(!_cursorItemMap.hasOwnProperty(cursorName))
			{
				return;
			}
			var item:CursorItem = _cursorItemMap[cursorName];
			var visibleList:Vector.<CursorItem>;
			if(item.inVisibleList)
			{
				visibleList = _visibleListMap[item.priority];
				visibleList.splice(visibleList.indexOf(item), 1);
			}
			else
			{
				item.inVisibleList = true;
				//添加优先级
				if(_priorityList.indexOf(item.priority) == -1)
				{
					_priorityList.push(item.priority);
					_priorityList.sort(Array.NUMERIC);
				}
				//添加到可视列表
				visibleList = _visibleListMap[item.priority];
				if(visibleList == null)
				{
					visibleList = new Vector.<CursorItem>();
					_visibleListMap[item.priority] = visibleList;
				}
			}
			visibleList.push(item);
			//显示光标
			updateCursor();
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeCursor(cursorName:String):void
		{
			if(!_cursorItemMap.hasOwnProperty(cursorName))
			{
				return;
			}
			var item:CursorItem = _cursorItemMap[cursorName];
			if(!item.inVisibleList)
			{
				return;
			}
			item.inVisibleList = false;
			//从可视列表中移除
			var visibleList:Vector.<CursorItem> = _visibleListMap[item.priority];
			visibleList.splice(visibleList.indexOf(item), 1);
			if(visibleList.length == 0)
			{
				delete _visibleListMap[item.priority];
				_priorityList.splice(_priorityList.indexOf(item.priority), 1);
			}
			//显示光标
			updateCursor();
		}
		
		private function updateCursor():void
		{
			//移除光标
			if(_cursorHolder.numChildren != 0)
			{
				_cursorHolder.removeChildAt(0);
			}
			//是否有要显示的光标
			var hasItem:Boolean = _priorityList.length != 0;
			if(hasItem)
			{
				//获取优先级最高的光标
				var maxPriority:int = _priorityList[_priorityList.length - 1];
				var visibleList:Vector.<CursorItem> = _visibleListMap[maxPriority];
				var item:CursorItem = visibleList[visibleList.length - 1];
				item.cursor.x = item.offsetX;
				item.cursor.y = item.offsetY;
				_currentCursorName = item.cursorName;
				_currentCursor = item.cursor;
				_cursorHolder.addChild(_currentCursor);
				updateCursorPosition();
				//添加移动侦听
				if(!_hasListener)
				{
					HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
					_hasListener = true;
				}
			}
			else
			{
				_currentCursorName = null;
				_currentCursor = null;
				//移除移动侦听
				if(_hasListener)
				{
					HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				}
			}
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			updateCursorPosition();
			if(HammercGlobals.useUpdateAfterEvent)
			{
				event.updateAfterEvent();
			}
		}
		
		private function updateCursorPosition():void
		{
			var position:Point = _cursorHolder.parent.globalToLocal(new Point(HammercGlobals.stage.mouseX, HammercGlobals.stage.mouseY));
			_cursorHolder.x = position.x;
			_cursorHolder.y = position.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllCursor():void
		{
			if(_cursorHolder.numChildren != 0)
			{
				_cursorHolder.removeChildAt(0);
			}
			_currentCursorName = null;
			_currentCursor = null;
			_priorityList.length = 0;
			_visibleListMap = new Object();
			if(_hasListener)
			{
				HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerCursor(cursorName:String, cursor:DisplayObject, priority:int = 0, offsetX:Number = 0, offsetY:Number = 0):DisplayObject
		{
			if(_cursorItemMap.hasOwnProperty(cursorName))
			{
				this.unregisterCursor(cursorName);
			}
			var item:CursorItem = new CursorItem();
			item.cursorName = cursorName;
			item.cursor = cursor;
			item.priority = priority;
			item.offsetX = offsetX;
			item.offsetY = offsetY;
			item.inVisibleList = false;
			_cursorItemMap[cursorName] = item;
			return cursor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function unregisterCursor(cursorName:String):DisplayObject
		{
			if(!_cursorItemMap.hasOwnProperty(cursorName))
			{
				return null;
			}
			var item:CursorItem = _cursorItemMap[cursorName];
			if(item.inVisibleList)
			{
				this.removeCursor(item.cursorName);
			}
			delete _cursorItemMap[cursorName];
			return item.cursor;
		}
		
		/**
		 * @inheritDoc
		 */
		public function unregisterAllCursor():void
		{
			this.removeAllCursor();
			_cursorItemMap = new Object();
		}
	}
}

import flash.display.DisplayObject;

/**
 * <code>CursorItem</code> 类记录一个光标的数据.
 * @author wizardc
 */
class CursorItem
{
	/**
	 * 光标的名称.
	 */
	public var cursorName:String;
	
	/**
	 * 光标实例.
	 */
	public var cursor:DisplayObject;
	
	/**
	 * 光标显示优先级.
	 */
	public var priority:int;
	
	/**
	 * 光标注册点 x 轴偏移.
	 */
	public var offsetX:Number;
	
	/**
	 * 光标注册点 y 轴偏移.
	 */
	public var offsetY:Number;
	
	/**
	 * 光标是否在可视列表中.
	 */
	public var inVisibleList:Boolean;
	
	/**
	 * 创建一个 <code>CursorItem</code> 对象.
	 */
	public function CursorItem()
	{
		super();
	}
}
