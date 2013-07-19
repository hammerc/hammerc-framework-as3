/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.crystal.control
{
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.crystal.control.observer.Provider;
	import org.hammerc.crystal.interfaces.INotification;
	import org.hammerc.crystal.interfaces.INotifier;
	
	/**
	 * <code>Notifier</code> 实现了一个最简单的消息发送对象.
	 * @author wizardc
	 */
	public class Notifier implements INotifier
	{
		/**
		 * <code>Notifier</code> 类为抽象类, 不能被实例化.
		 */
		public function Notifier()
		{
			AbstractEnforcer.enforceConstructor(this, Notifier);
		}
		
		/**
		 * @inheritDoc
		 */
		public function sendNotification(notificationName:String, body:Object = null, type:String = null):void
		{
			var notification:INotification = new Notification(notificationName, type, body);
			Controller.getInstance().executeCommand(notification);
			Provider.getInstance().notifyObservers(notification);
		}
	}
}
