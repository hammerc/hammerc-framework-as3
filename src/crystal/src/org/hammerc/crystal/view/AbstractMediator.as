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
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.crystal.control.observer.Observer;
	import org.hammerc.crystal.facade.Facade;
	import org.hammerc.crystal.interfaces.IMediator;
	
	/**
	 * <code>AbstractMediator</code> 类实现了中介的基类.
	 * @author wizardc
	 */
	public class AbstractMediator extends Observer implements IMediator
	{
		/**
		 * 代理 MVC 中所有处理方法的外观对象.
		 */
		protected var _facade:Facade = Facade.getInstance();
		
		/**
		 * 中介对象的名称.
		 */
		protected var _name:String;
		
		/**
		 * 中介对象对应的具体显示对象.
		 */
		protected var _viewComponent:Object;
		
		/**
		 * <code>AbstractMediator</code> 类为抽象类, 不能被实例化.
		 * @param name 中介对象的名称.
		 * @param viewComponent 中介对象对应的具体显示对象.
		 */
		public function AbstractMediator(name:String, viewComponent:Object = null)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractMediator);
			_name = name;
			_viewComponent = viewComponent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set viewComponent(value:Object):void
		{
			_viewComponent = value;
		}
		public function get viewComponent():Object
		{
			return _viewComponent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRegister():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRemove():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function interestNotificationList():Array
		{
			return null;
		}
	}
}
