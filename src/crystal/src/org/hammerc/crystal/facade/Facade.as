// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.crystal.facade
{
	import org.hammerc.crystal.control.Controller;
	import org.hammerc.crystal.control.Notification;
	import org.hammerc.crystal.control.observer.Provider;
	import org.hammerc.crystal.interfaces.IProxy;
	import org.hammerc.crystal.interfaces.INotification;
	import org.hammerc.crystal.interfaces.IObserver;
	import org.hammerc.crystal.interfaces.IMediator;
	import org.hammerc.crystal.model.ModelManager;
	import org.hammerc.crystal.view.ViewManager;
	
	/**
	 * <code>Facade</code> 类代理 MVC 中所有处理方法.
	 * @author wizardc
	 */
	public class Facade
	{
		private static var _instance:Facade;
		
		/**
		 * 获取本类的唯一实例.
		 * @return 本类的唯一实例.
		 */
		public static function getInstance():Facade
		{
			if(_instance == null)
			{
				_instance = new Facade(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/**
		 * 记录控制者对象.
		 */
		protected var _controller:Controller;
		
		/**
		 * 记录观察者管理对象.
		 */
		protected var _provider:Provider;
		
		/**
		 * 记录代理管理对象.
		 */
		protected var _modelManager:ModelManager;
		
		/**
		 * 记录中介管理对象.
		 */
		protected var _viewManager:ViewManager;
		
		/**
		 * 本类为单例类不能实例化.
		 * @param singletonEnforcer 单例类实现对象.
		 */
		public function Facade(singletonEnforcer:SingletonEnforcer)
		{
			if(singletonEnforcer == null)
			{
				throw new Error("单例类不能进行实例化！");
			}
			_controller = Controller.getInstance();
			_provider = Provider.getInstance();
			_modelManager = ModelManager.getInstance();
			_viewManager = ViewManager.getInstance();
		}
		
		/**
		 * 发送一个消息.
		 * @param notificationName 消息的名称.
		 * @param body 消息的数据.
		 * @param type 消息的类型.
		 */
		public function sendNotification(notificationName:String, body:Object = null, type:String = null):void
		{
			var notification:INotification = new Notification(notificationName, type, body);
			_controller.executeCommand(notification);
			_provider.notifyObservers(notification);
		}
		
		/**
		 * 注册一个命令类对象映射到对应的消息名称上.
		 * @param notificationName 消息名称.
		 * @param commandClass 要被映射到该消息名称的类.
		 */
		public function registerCommand(notificationName:String, commandClass:Class):void
		{
			_controller.registerCommand(notificationName, commandClass);
		}
		
		/**
		 * 判断一个消息名称是否正在被侦听.
		 * @param notificationName 消息名称.
		 */
		public function hasCommand(notificationName:String):Boolean
		{
			return _controller.hasCommand(notificationName);
		}
		
		/**
		 * 移除一个消息名称的所有侦听.
		 * @param notificationName 消息名称.
		 */
		public function removeCommand(notificationName:String):void
		{
			_controller.removeCommand(notificationName);
		}
		
		/**
		 * 注册一个观察者对象映射到对应的消息名称上.
		 * @param notificationName 消息名称.
		 * @param observer 要被映射到该消息名称的对象.
		 */
		public function registerObserver(notificationName:String, observer:IObserver):void
		{
			_provider.registerObserver(notificationName, observer);
		}
		
		/**
		 * 移除一个观察者对象的侦听.
		 * @param notificationName 消息名称.
		 * @param observer 要被移除的观察者对象.
		 */
		public function removeObserver(notificationName:String, observer:IObserver):void
		{
			_provider.removeObserver(notificationName, observer);
		}
		
		/**
		 * 注册一个代理对象.
		 * @param proxy 要被注册的代理对象.
		 */
		public function registerProxy(proxy:IProxy):void
		{
			_modelManager.registerProxy(proxy);
		}
		
		/**
		 * 判断一个代理对象是否被注册.
		 * @param proxyName 代理对象名称.
		 * @return 指定的代理对象被注册返回 (<code>true</code>), 否则返回 (<code>false</code>).
		 */
		public function hasProxy(proxyName:String):Boolean
		{
			return _modelManager.hasProxy(proxyName);
		}
		
		/**
		 * 获取一个代理对象.
		 * @param proxyName 代理对象名称.
		 * @return 指定的代理对象.
		 */
		public function getProxy(proxyName:String):IProxy
		{
			return _modelManager.getProxy(proxyName);
		}
		
		/**
		 * 移除一个代理对象.
		 * @param proxyName 代理对象名称.
		 * @return 移除的代理对象.
		 */
		public function removeProxy(proxyName:String):IProxy
		{
			return _modelManager.removeProxy(proxyName);
		}
		
		/**
		 * 注册一个中介对象.
		 * @param mediator 要被注册的中介对象.
		 */
		public function registerMediator(mediator:IMediator):void
		{
			_viewManager.registerMediator(mediator);
		}
		
		/**
		 * 判断一个中介对象是否被注册.
		 * @param mediatorName 中介对象名称.
		 * @return 指定的中介对象被注册返回 (<code>true</code>), 否则返回 (<code>false</code>).
		 */
		public function hasMediator(mediatorName:String):Boolean
		{
			return _viewManager.hasMediator(mediatorName);
		}
		
		/**
		 * 获取一个中介对象.
		 * @param mediatorName 中介对象名称.
		 * @return 指定的中介对象.
		 */
		public function getMediator(mediatorName:String):IMediator
		{
			return _viewManager.getMediator(mediatorName);
		}
		
		/**
		 * 移除一个中介对象.
		 * @param mediatorName 中介对象名称.
		 * @return 移除的中介对象.
		 */
		public function removeMediator(mediatorName:String):IMediator
		{
			return _viewManager.removeMediator(mediatorName);
		}
	}
}

class SingletonEnforcer{}
