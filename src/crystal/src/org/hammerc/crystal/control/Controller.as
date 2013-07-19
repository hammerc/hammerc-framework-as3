/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.crystal.control
{
	import org.hammerc.crystal.interfaces.ICommand;
	import org.hammerc.crystal.interfaces.INotification;
	
	/**
	 * <code>Contorller</code> 类是整个 MVC 框架中的控制者, 它是一个单例类, 为模块或视图广播命令 <code>ICommand</code> 对象接收并处理命令提供支持.
	 * <p>Crystal 框架的命令广播没有采用 ActionScript3.0 的消息机制, 而是采用了观察者模式进行实现.</p>
	 * @author wizardc
	 */
	public class Controller
	{
		private static var _instance:Controller;
		
		/**
		 * 获取本类的唯一实例.
		 * @return 本类的唯一实例.
		 */
		public static function getInstance():Controller
		{
			if(_instance == null)
			{
				_instance = new Controller(new SingletonEnforcer());
			}
			return _instance;
		}
		
		private var _commandMap:Object;
		
		/**
		 * 本类为单例类不能实例化.
		 * @param singletonEnforcer 单例类实现对象.
		 */
		public function Controller(singletonEnforcer:SingletonEnforcer)
		{
			if(singletonEnforcer == null)
			{
				throw new Error("单例类不能进行实例化！");
			}
			_commandMap = new Object();
		}
		
		/**
		 * 注册一个命令类对象映射到对应的消息名称上.
		 * @param notificationName 消息名称.
		 * @param commandClass 要被映射到该消息名称的类.
		 */
		public function registerCommand(notificationName:String, commandClass:Class):void
		{
			if(notificationName != null && notificationName != "" && commandClass != null)
			{
				if(!this.hasCommand(notificationName))
				{
					_commandMap[notificationName] = new Vector.<Class>();
				}
				var list:Vector.<Class> = _commandMap[notificationName] as Vector.<Class>;
				if(list.indexOf(commandClass) == -1)
				{
					list.push(commandClass);
				}
			}
		}
		
		/**
		 * 判断一个消息名称是否正在被侦听.
		 * @param notificationName 消息名称.
		 */
		public function hasCommand(notificationName:String):Boolean
		{
			return _commandMap.hasOwnProperty(notificationName);
		}
		
		/**
		 * 移除一个消息名称的所有侦听.
		 * @param notificationName 消息名称.
		 */
		public function removeCommand(notificationName:String):void
		{
			if(notificationName != null && notificationName != "")
			{
				if(this.hasCommand(notificationName))
				{
					delete _commandMap[notificationName];
				}
			}
		}
		
		/**
		 * 执行一个命令.
		 * @param notification 包含要被执行的命令和信息的通知对象.
		 */
		public function executeCommand(notification:INotification):void
		{
			if(this.hasCommand(notification.name))
			{
				var list:Vector.<Class> = _commandMap[notification.name] as Vector.<Class>;
				for each(var commandClass:Class in list)
				{
					var instance:ICommand = new commandClass() as ICommand;
					if(instance != null)
					{
						instance.execute(notification);
					}
				}
			}
		}
	}
}

class SingletonEnforcer{}
