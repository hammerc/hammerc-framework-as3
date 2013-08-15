/**
 * Copyright (c) 2012 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.events.UIEvent;
	import org.hammerc.managers.layoutClasses.DepthQueue;
	
	/**
	 * @eventType org.hammerc.events.UIEvent.UPDATE_COMPLETE
	 */
	[Event(name="updateComplete", type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>LayoutManager</code> 类实现了布局管理器的功能.
	 * @author wizardc
	 */
	public class LayoutManager extends EventDispatcher
	{
		private var _targetLevel:int = int.MAX_VALUE;
		
		/**
		 * 需要抛出组件初始化完成事件的对象.
		 */
		private var _updateCompleteQueue:DepthQueue = new DepthQueue();
		
		private var _invalidatePropertiesFlag:Boolean = false;
		private var _invalidateClientPropertiesFlag:Boolean = false;
		private var _invalidatePropertiesQueue:DepthQueue = new DepthQueue();
		
		private var _invalidateSizeFlag:Boolean = false;
		private var _invalidateClientSizeFlag:Boolean = false;
		private var _invalidateSizeQueue:DepthQueue = new DepthQueue();
		
		private var _invalidateDisplayListFlag:Boolean = false;
		private var _invalidateDisplayListQueue:DepthQueue = new DepthQueue();
		
		/**
		 * 是否已经添加了事件监听.
		 */
		private var _listenersAttached:Boolean = false;
		
		/**
		 * 创建一个 <code>LayoutManager</code> 对象.
		 */
		public function LayoutManager()
		{
			super();
		}
		
		/**
		 * 标记组件提交过属性.
		 * @param client 要标记的组件.
		 */
		public function invalidateProperties(client:ILayoutManagerClient):void
		{
			if(!_invalidatePropertiesFlag)
			{
				_invalidatePropertiesFlag = true;
				if(!_listenersAttached)
				{
					attachListeners();
				}
			}
			if(_targetLevel <= client.nestLevel)
			{
				_invalidateClientPropertiesFlag = true;
			}
			_invalidatePropertiesQueue.insert(client);
		}
		
		/**
		 * 使提交的属性生效.
		 */
		private function validateProperties():void
		{
			var client:ILayoutManagerClient = _invalidatePropertiesQueue.shift();
			while(client)
			{
				if(client.hasParent)
				{
					client.validateProperties();
					if(!client.updateCompletePendingFlag)
					{
						_updateCompleteQueue.insert(client);
						client.updateCompletePendingFlag = true;
					}
				}
				client = _invalidatePropertiesQueue.shift();
			}
			if(_invalidatePropertiesQueue.isEmpty())
			{
				_invalidatePropertiesFlag = false;
			}
		}
		
		/**
		 * 标记需要重新测量尺寸.
		 * @param client 要标记的组件.
		 */
		public function invalidateSize(client:ILayoutManagerClient):void
		{
			if(!_invalidateSizeFlag)
			{
				_invalidateSizeFlag = true;
				if(!_listenersAttached)
				{
					attachListeners();
				}
			}
			if(_targetLevel <= client.nestLevel)
			{
				_invalidateClientSizeFlag = true;
			}
			_invalidateSizeQueue.insert(client);
		}
		
		/**
		 * 测量属性.
		 */
		private function validateSize():void
		{
			var client:ILayoutManagerClient = _invalidateSizeQueue.pop();
			while(client)
			{
				if(client.hasParent)
				{
					client.validateSize();
					if(!client.updateCompletePendingFlag)
					{
						_updateCompleteQueue.insert(client);
						client.updateCompletePendingFlag = true;
					}
				}
				client = _invalidateSizeQueue.pop();
			}
			if(_invalidateSizeQueue.isEmpty())
			{
				_invalidateSizeFlag = false;
			}
		}
		
		/**
		 * 标记需要更新显示列表.
		 * @param client 要标记的组件.
		 */
		public function invalidateDisplayList(client:ILayoutManagerClient):void
		{
			if(!_invalidateDisplayListFlag)
			{
				_invalidateDisplayListFlag = true;
				if(!_listenersAttached)
				{
					attachListeners();
				}
			}
			_invalidateDisplayListQueue.insert(client);
		}
		
		/**
		 * 更新显示列表.
		 */
		private function validateDisplayList():void
		{
			var client:ILayoutManagerClient = _invalidateDisplayListQueue.shift();
			while(client)
			{
				if(client.hasParent)
				{
					client.validateDisplayList();
					if(!client.updateCompletePendingFlag)
					{
						_updateCompleteQueue.insert(client);
						client.updateCompletePendingFlag = true;
					}
				}
				client = _invalidateDisplayListQueue.shift();
			}
			if(_invalidateDisplayListQueue.isEmpty())
			{
				_invalidateDisplayListFlag = false;
			}
		}
		
		/**
		 * 添加事件监听.
		 */
		private function attachListeners():void
		{
			HammercGlobals.stage.addEventListener(Event.ENTER_FRAME, doPhasedInstantiation);
			HammercGlobals.stage.addEventListener(Event.RENDER, doPhasedInstantiation);
			HammercGlobals.stage.invalidate();
			_listenersAttached = true;
		}
		
		/**
		 * 执行属性应用.
		 */
		private function doPhasedInstantiation(event:Event = null):void
		{
			HammercGlobals.stage.removeEventListener(Event.ENTER_FRAME, doPhasedInstantiation);
			HammercGlobals.stage.removeEventListener(Event.RENDER, doPhasedInstantiation);
			if(_invalidatePropertiesFlag)
			{
				validateProperties();
			}
			if(_invalidateSizeFlag)
			{
				validateSize();
			}
			if(_invalidateDisplayListFlag)
			{
				validateDisplayList();
			}
			if(_invalidatePropertiesFlag || _invalidateSizeFlag || _invalidateDisplayListFlag)
			{
				attachListeners();
			}
			else
			{
				_listenersAttached = false;
				var client:ILayoutManagerClient = _updateCompleteQueue.pop();
				while(client)
				{
					if(!client.initialized)
					{
						client.initialized = true;
					}
					if(client.hasEventListener(UIEvent.UPDATE_COMPLETE))
					{
						client.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
					}
					client.updateCompletePendingFlag = false;
					client = _updateCompleteQueue.pop();
				}
				this.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
			}
		}
		
		/**
		 * 立即应用所有延迟的属性.
		 */
		public function validateNow():void
		{
			var infiniteLoopGuard:int = 0;
			while(_listenersAttached && infiniteLoopGuard++ < 100)
			{
				doPhasedInstantiation();
			}
		}
		
		/**
		 * 使大于等于指定组件层级的元素立即应用属性.
		 * @param target 要立即应用属性的组件.
		 * @param skipDisplayList 是否跳过更新显示列表阶段.
		 */
		public function validateClient(target:ILayoutManagerClient, skipDisplayList:Boolean = false):void
		{
			var obj:ILayoutManagerClient;
			var i:int = 0;
			var done:Boolean = false;
			var oldTargetLevel:int = _targetLevel;
			if (_targetLevel == int.MAX_VALUE)
			{
				_targetLevel = target.nestLevel;
			}
			while(!done)
			{
				done = true;
				obj = ILayoutManagerClient(_invalidatePropertiesQueue.removeSmallestChild(target));
				while(obj != null)
				{
					if(obj.hasParent)
					{
						obj.validateProperties();
						if(!obj.updateCompletePendingFlag)
						{
							_updateCompleteQueue.insert(obj);
							obj.updateCompletePendingFlag = true;
						}
					}
					obj = ILayoutManagerClient(_invalidatePropertiesQueue.removeSmallestChild(target));
				}
				if(_invalidatePropertiesQueue.isEmpty())
				{
					_invalidatePropertiesFlag = false;
				}
				_invalidateClientPropertiesFlag = false;
				obj = ILayoutManagerClient(_invalidateSizeQueue.removeLargestChild(target));
				while(obj != null)
				{
					if(obj.hasParent)
					{
						obj.validateSize();
						if(!obj.updateCompletePendingFlag)
						{
							_updateCompleteQueue.insert(obj);
							obj.updateCompletePendingFlag = true;
						}
					}
					if(_invalidateClientPropertiesFlag)
					{
						obj = ILayoutManagerClient(_invalidatePropertiesQueue.removeSmallestChild(target));
						if(obj)
						{
							_invalidatePropertiesQueue.insert(obj);
							done = false;
							break;
						}
					}
					obj = ILayoutManagerClient(_invalidateSizeQueue.removeLargestChild(target));
				}
				if(_invalidateSizeQueue.isEmpty())
				{
					_invalidateSizeFlag = false;
				}
				_invalidateClientPropertiesFlag = false;
				_invalidateClientSizeFlag = false;
				if(!skipDisplayList)
				{
					obj = ILayoutManagerClient(_invalidateDisplayListQueue.removeSmallestChild(target));
					while(obj != null)
					{
						if(obj.hasParent)
						{
							obj.validateDisplayList();
							if(!obj.updateCompletePendingFlag)
							{
								_updateCompleteQueue.insert(obj);
								obj.updateCompletePendingFlag = true;
							}
						}
						if(_invalidateClientPropertiesFlag)
						{
							obj = ILayoutManagerClient(_invalidatePropertiesQueue.removeSmallestChild(target));
							if(obj != null)
							{
								_invalidatePropertiesQueue.insert(obj);
								done = false;
								break;
							}
						}
						if(_invalidateClientSizeFlag)
						{
							obj = ILayoutManagerClient(_invalidateSizeQueue.removeLargestChild(target));
							if(obj != null)
							{
								_invalidateSizeQueue.insert(obj);
								done = false;
								break;
							}
						}
						obj = ILayoutManagerClient(_invalidateDisplayListQueue.removeSmallestChild(target));
					}
					if(_invalidateDisplayListQueue.isEmpty())
					{
						_invalidateDisplayListFlag = false;
					}
				}
			}
			if(oldTargetLevel == int.MAX_VALUE)
			{
				_targetLevel = int.MAX_VALUE;
				if(!skipDisplayList)
				{
					obj = ILayoutManagerClient(_updateCompleteQueue.removeLargestChild(target));
					while(obj != null)
					{
						if(!obj.initialized)
						{
							obj.initialized = true;
						}
						if(obj.hasEventListener(UIEvent.UPDATE_COMPLETE))
						{
							obj.dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
						}
						obj.updateCompletePendingFlag = false;
						obj = ILayoutManagerClient(_updateCompleteQueue.removeLargestChild(target));
					}
				}
			}
		}
	}
}
