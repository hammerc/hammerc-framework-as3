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
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.crystal.control.Notifier;
	import org.hammerc.crystal.interfaces.INotification;
	import org.hammerc.crystal.interfaces.IObserver;
	
	/**
	 * <code>Observer</code> 类实现了一个简单的观察者.
	 * @author wizardc
	 */
	public class Observer extends Notifier implements IObserver
	{
		/**
		 * <code>Observer</code> 类为抽象类, 不能被实例化.
		 */
		public function Observer()
		{
			AbstractEnforcer.enforceConstructor(this, Observer);
		}
		
		/**
		 * @inheritDoc
		 */
		public function notificationHandler(notification:INotification):void
		{
			AbstractEnforcer.enforceMethod();
		}
	}
}
