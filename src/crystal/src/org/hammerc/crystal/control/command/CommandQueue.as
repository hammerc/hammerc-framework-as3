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
	import org.hammerc.crystal.interfaces.ICommand;
	import org.hammerc.crystal.interfaces.INotification;
	
	/**
	 * <code>CommandQueue</code> 类实现了多个命令顺序执行的命令列表类.
	 * @author wizardc
	 */
	public class CommandQueue implements ICommand
	{
		/**
		 * 记录需要顺序执行的命令类列表.
		 */
		protected var _subCommands:Vector.<Class>;
		
		/**
		 * <code>CommandQueue</code> 类为抽象类, 不能被实例化.
		 */
		public function CommandQueue()
		{
			AbstractEnforcer.enforceConstructor(this, CommandQueue);
			_subCommands = new Vector.<Class>();
			this.initializeCommands();
		}
		
		/**
		 * 初始化命令列表.
		 */
		protected function initializeCommands():void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 添加一个需要执行的命令类.
		 * @param commandClass 需要执行的命令类.
		 */
		protected function addSubCommand(commandClass:Class):void
		{
			_subCommands.push(commandClass);
		}
		
		/**
		 * @inheritDoc
		 */
		public final function execute(notification:INotification):void
		{
			while(_subCommands.length != 0)
			{
				var commandClass:Class = _subCommands.shift();
				var commandInstance:ICommand = new commandClass() as ICommand;
				commandInstance.execute(notification);
			}
		}
	}
}
