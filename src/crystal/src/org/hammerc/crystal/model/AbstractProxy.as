// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.crystal.model
{
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.crystal.control.Notifier;
	import org.hammerc.crystal.facade.Facade;
	import org.hammerc.crystal.interfaces.IProxy;
	
	/**
	 * <code>AbstractProxy</code> 类实现了代理的基类.
	 * @author wizardc
	 */
	public class AbstractProxy extends Notifier implements IProxy
	{
		/**
		 * 代理 MVC 中所有处理方法的外观对象.
		 */
		protected var _facade:Facade = Facade.getInstance();
		
		/**
		 * 代理对象的名称.
		 */
		protected var _name:String;
		
		/**
		 * 代理对象持有的数据.
		 */
		protected var _data:Object;
		
		/**
		 * <code>AbstractProxy</code> 类为抽象类, 不能被实例化.
		 * @param name 代理对象的名称.
		 * @param data 代理对象持有的数据.
		 */
		public function AbstractProxy(name:String, data:Object = null)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractProxy);
			_name = name;
			_data = data;
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
		public function set data(value:Object):void
		{
			_data = value;
		}
		public function get data():Object
		{
			return _data;
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
	}
}
