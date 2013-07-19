/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.crystal.view
{
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
		
		private var _mediatorMap:Object;
		
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
			_mediatorMap = new Object();
		}
		
		/**
		 * 注册一个中介对象.
		 * @param mediator 要被注册的中介对象.
		 */
		public function registerMediator(mediator:IMediator):void
		{
			if(this.hasMediator(mediator.name))
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
			_mediatorMap[mediator.name] = mediator;
			mediator.onRegister();
		}
		
		/**
		 * 判断一个中介对象是否被注册.
		 * @param mediatorName 中介对象名称.
		 * @return 指定的中介对象被注册返回 (<code>true</code>), 否则返回 (<code>false</code>).
		 */
		public function hasMediator(mediatorName:String):Boolean
		{
			return _mediatorMap.hasOwnProperty(mediatorName);
		}
		
		/**
		 * 获取一个中介对象.
		 * @param mediatorName 中介对象名称.
		 * @return 指定的中介对象.
		 */
		public function getMediator(mediatorName:String):IMediator
		{
			return _mediatorMap[mediatorName] as IMediator;
		}
		
		/**
		 * 移除一个中介对象.
		 * @param mediatorName 中介对象名称.
		 * @return 移除的中介对象.
		 */
		public function removeMediator(mediatorName:String):IMediator
		{
			var mediator:IMediator = this.getMediator(mediatorName);
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
				delete _mediatorMap[mediatorName];
			}
			return mediator;
		}
	}
}

class SingletonEnforcer{}
