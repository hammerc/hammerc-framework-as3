// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.crystal.control.observer
{
	import org.hammerc.crystal.interfaces.INotification;
	import org.hammerc.crystal.interfaces.IObserver;
	
	/**
	 * <code>Provider</code> 类提供观察者模式的实现, 它是一个单例类, 为模块或视图广播命令视图对象接收并处理命令提供支持.
	 * <p>Crystal 框架的命令广播没有采用 ActionScript3.0 的消息机制, 而是采用了观察者模式进行实现.</p>
	 * @author wizardc
	 */
	public class Provider
	{
		private static var _instance:Provider;
		
		/**
		 * 获取本类的唯一实例.
		 * @return 本类的唯一实例.
		 */
		public static function getInstance():Provider
		{
			if(_instance == null)
			{
				_instance = new Provider(new SingletonEnforcer());
			}
			return _instance;
		}
		
		private var _observerMap:Object;
		
		/**
		 * 本类为单例类不能实例化.
		 * @param singletonEnforcer 单例类实现对象.
		 */
		public function Provider(singletonEnforcer:SingletonEnforcer)
		{
			if(singletonEnforcer == null)
			{
				throw new Error("单例类不能进行实例化！");
			}
			_observerMap = new Object();
		}
		
		/**
		 * 注册一个观察者对象映射到对应的消息名称上.
		 * @param notificationName 消息名称.
		 * @param observer 要被映射到该消息名称的对象.
		 */
		public function registerObserver(notificationName:String, observer:IObserver):void
		{
			if(notificationName != null && notificationName != "" && observer != null)
			{
				if(!_observerMap.hasOwnProperty(notificationName))
				{
					_observerMap[notificationName] = new Vector.<IObserver>();
				}
				var list:Vector.<IObserver> = _observerMap[notificationName] as Vector.<IObserver>;
				if(list.indexOf(observer) == -1)
				{
					list.push(observer);
				}
			}
		}
		
		/**
		 * 移除一个观察者对象的侦听.
		 * @param notificationName 消息名称.
		 * @param observer 要被移除的观察者对象.
		 */
		public function removeObserver(notificationName:String, observer:IObserver):void
		{
			if(notificationName != null && notificationName != "")
			{
				var list:Vector.<IObserver> = _observerMap[notificationName] as Vector.<IObserver>;
				if(list != null)
				{
					for(var i:int=0, len:int = list.length; i < len; i++)
					{
						if(list[i] == observer)
						{
							list.splice(i, 1);
							break;
						}
					}
					if(list.length == 0)
					{
						delete _observerMap[notificationName];
					}
				}
			}
		}
		
		/**
		 * 通知一个消息.
		 * @param notification 需要通知的消息对象.
		 */
		public function notifyObservers(notification:INotification):void
		{
			if(_observerMap.hasOwnProperty(notification.name))
			{
				var list:Vector.<IObserver> = _observerMap[notification.name] as Vector.<IObserver>;
				for each(var observer:IObserver in list)
				{
					observer.notificationHandler(notification);
				}
			}
		}
	}
}

class SingletonEnforcer{}
