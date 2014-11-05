// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.crystal.control.command
{
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.crystal.control.Notifier;
	import org.hammerc.crystal.facade.Facade;
	import org.hammerc.crystal.interfaces.ICommand;
	import org.hammerc.crystal.interfaces.INotification;
	
	/**
	 * <code>Command</code> 类实现了一个简单的命令类.
	 * @author wizardc
	 */
	public class Command extends Notifier implements ICommand
	{
		/**
		 * 代理 MVC 中所有处理方法的外观对象.
		 */
		protected var _facade:Facade = Facade.getInstance();
		
		/**
		 * <code>Command</code> 类为抽象类, 不能被实例化.
		 */
		public function Command()
		{
			AbstractEnforcer.enforceConstructor(this, Command);
		}
		
		/**
		 * @inheritDoc
		 */
		public function execute(notification:INotification):void
		{
			AbstractEnforcer.enforceMethod();
		}
	}
}
