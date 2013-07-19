/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.crystal.model
{
	import org.hammerc.crystal.interfaces.IProxy;
	
	/**
	 * <code>ModelManager</code> 类管理程序中使用到的所有代理对象.
	 * @author wizardc
	 */
	public class ModelManager
	{
		private static var _instance:ModelManager;
		
		/**
		 * 获取本类的唯一实例.
		 * @return 本类的唯一实例.
		 */
		public static function getInstance():ModelManager
		{
			if(_instance == null)
			{
				_instance = new ModelManager(new SingletonEnforcer());
			}
			return _instance;
		}
		
		private var _proxyMap:Object;
		
		/**
		 * 本类为单例类不能实例化.
		 * @param singletonEnforcer 单例类实现对象.
		 */
		public function ModelManager(singletonEnforcer:SingletonEnforcer)
		{
			if(singletonEnforcer == null)
			{
				throw new Error("单例类不能进行实例化！");
			}
			_proxyMap = new Object();
		}
		
		/**
		 * 注册一个代理对象.
		 * @param proxy 要被注册的代理对象.
		 */
		public function registerProxy(proxy:IProxy):void
		{
			if(this.hasProxy(proxy.name))
			{
				throw new Error("需要注册的代理名称已经存在！");
			}
			_proxyMap[proxy.name] = proxy;
			proxy.onRegister();
		}
		
		/**
		 * 判断一个代理对象是否被注册.
		 * @param proxyName 代理对象名称.
		 * @return 指定的代理对象被注册返回 (<code>true</code>), 否则返回 (<code>false</code>).
		 */
		public function hasProxy(proxyName:String):Boolean
		{
			return _proxyMap.hasOwnProperty(proxyName);
		}
		
		/**
		 * 获取一个代理对象.
		 * @param proxyName 代理对象名称.
		 * @return 指定的代理对象.
		 */
		public function getProxy(proxyName:String):IProxy
		{
			return _proxyMap[proxyName] as IProxy;
		}
		
		/**
		 * 移除一个代理对象.
		 * @param proxyName 代理对象名称.
		 * @return 移除的代理对象.
		 */
		public function removeProxy(proxyName:String):IProxy
		{
			var proxy:IProxy = this.getProxy(proxyName);
			if(proxy != null)
			{
				proxy.onRemove();
				delete _proxyMap[proxyName];
			}
			return proxy;
		}
	}
}

class SingletonEnforcer{}
