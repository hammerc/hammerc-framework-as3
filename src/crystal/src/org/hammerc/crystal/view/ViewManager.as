// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.crystal.view
{
	import flash.utils.Dictionary;
	
	import org.hammerc.crystal.control.observer.Provider;
	import org.hammerc.crystal.interfaces.IMediator;
	
	/**
	 * <code>ViewManager</code> 类管理程序中使用到的所有中介对象.
	 * @author wizardc
	 */
	public class ViewManager
	{
		private static var _instance:ViewManager;
		
		/**
		 * 获取本类的唯一实例.
		 * @return 本类的唯一实例.
		 */
		public static function getInstance():ViewManager
		{
			if(_instance == null)
			{
				_instance = new ViewManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		private var _mediatorMap:Dictionary;
		
		/**
		 * 本类为单例类不能实例化.
		 * @param singletonEnforcer 单例类实现对象.
		 */
		public function ViewManager(singletonEnforcer:SingletonEnforcer)
		{
			if(singletonEnforcer == null)
			{
				throw new Error("单例类不能进行实例化！");
			}
			_mediatorMap = new Dictionary();
		}
		
		/**
		 * 注册一个中介对象.
		 * @param mediator 要被注册的中介对象.
		 */
		public function registerMediator(mediator:IMediator):void
		{
			if(this.hasMediator(mediator.viewComponent))
			{
				throw new Error("需要注册的中介名称已经存在！");
			}
			var list:Array = mediator.interestNotificationList();
			if(list != null && list.length != 0)
			{
				for each(var notificationName:String in list)
				{
					Provider.getInstance().registerObserver(notificationName, mediator);
				}
			}
			_mediatorMap[mediator.viewComponent] = mediator;
			mediator.onRegister();
		}
		
		/**
		 * 判断一个中介对象是否被创建.
		 * @param viewComponent 对应的视图对象.
		 * @return 指定的中介对象被创建返回 (<code>true</code>), 否则返回 (<code>false</code>).
		 */
		public function hasMediator(viewComponent:Object):Boolean
		{
			return _mediatorMap.hasOwnProperty(viewComponent);
		}
		
		/**
		 * 获取一个中介对象.
		 * @param viewComponent 对应的视图对象.
		 * @return 指定的中介对象.
		 */
		public function getMediator(viewComponent:Object):IMediator
		{
			return _mediatorMap[viewComponent] as IMediator;
		}
		
		/**
		 * 移除一个中介对象.
		 * @param viewComponent 对应的视图对象.
		 * @return 移除的中介对象.
		 */
		public function removeMediator(viewComponent:Object):IMediator
		{
			var mediator:IMediator = this.getMediator(viewComponent);
			if(mediator != null)
			{
				var list:Array = mediator.interestNotificationList();
				if(list != null && list.length != 0)
				{
					for each(var notificationName:String in list)
					{
						Provider.getInstance().removeObserver(notificationName, mediator);
					}
				}
				mediator.onRemove();
				delete _mediatorMap[viewComponent];
			}
			return mediator;
		}
	}
}

class SingletonEnforcer{}
