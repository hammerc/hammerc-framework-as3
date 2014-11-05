// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.utils
{
	/**
	 * <code>InstanceBuilder</code> 类实现了动态创建实例的功能.
	 * @author wizardc
	 */
	public class InstanceBuilder
	{
		/**
		 * 创建一个实例.
		 * @param target 创建的实例类型.
		 * @param args 需要传递给构造函数的参数.
		 * @return 指定类的一个实例.
		 */
		public static function createInstance(target:Class, ...args):Object
		{
			var ib:InstanceBuilder = new InstanceBuilder(target, args);
			return ib.create();
		}
		
		private var _target:Class;
		private var _param:Array;
		private var _properties:Object;
		private var _initialize:Function;
		
		/**
		 * 创建一个 <code>InstanceBuilder</code> 的实例.
		 * @param target 要创建的实例的类型.
		 * @param param 要传递给构造函数的参数.
		 * @param properties 实例创建好后会被赋予的初始值.
		 * @param initialize 实例创建好后会回调该方法, 同时该方法的 <code>this</code> 属性会指向新创建的实例.
		 */
		public function InstanceBuilder(target:Class = null, param:Array = null, properties:Object = null, initialize:Function = null)
		{
			_target = target;
			this.param = param;
			this.properties = properties;
			_initialize = initialize;
		}
		
		/**
		 * 设置或获取要创建的实例的类型.
		 */
		public function set target(value:Class):void
		{
			_target = value;
		}
		public function get target():Class
		{
			return _target;
		}
		
		/**
		 * 设置或获取要传递给构造函数的参数.
		 */
		public function set param(value:Array):void
		{
			if(value == null)
			{
				_param = null;
			}
			else
			{
				_param = ArrayUtil.simpleClone(value);
			}
		}
		public function get param():Array
		{
			return ArrayUtil.simpleClone(_param);
		}
		
		/**
		 * 设置或获取实例创建好后会被赋予的初始值..
		 */
		public function set properties(value:Object):void
		{
			if(value == null)
			{
				_properties = null;
			}
			else
			{
				_properties = ObjectUtil.simpleClone(value);
			}
		}
		public function get properties():Object
		{
			return ObjectUtil.simpleClone(_properties);
		}
		
		/**
		 * 设置或获取实例创建好后会回调该方法, 同时该方法的 <code>this</code> 属性会指向新创建的实例..
		 */
		public function set initialize(value:Function):void
		{
			_initialize = value;
		}
		public function get initialize():Function
		{
			return _initialize;
		}
		
		/**
		 * 判断一个实例对象是否为本对象指定的类型.
		 * @param instance 需要判断的实例对象.
		 * @return 该实例对象是否为本对象指定的类型.
		 */
		public function isThis(instance:Object):Boolean
		{
			if(_target == null)
			{
				return false;
			}
			return instance is _target;
		}
		
		/**
		 * 创建一个实例.
		 * @return 更具设定的指定创建的一个实例, 如果类型未指定则返回 <code>null</code>.
		 */
		public function create():Object
		{
			if(_target == null)
			{
				return null;
			}
			var numParam:int = _param == null ? 0 : _param.length;
			var instance:* = null;
			switch(numParam)
			{
				case 0:
					instance = new _target();
					break;
				case 1:
					instance = new _target(_param[0]);
					break;
				case 2:
					instance = new _target(_param[0], _param[1]);
					break;
				case 3:
					instance = new _target(_param[0], _param[1], _param[2]);
					break;
				case 4:
					instance = new _target(_param[0], _param[1], _param[2], _param[3]);
					break;
				case 5:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4]);
					break;
				case 6:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5]);
					break;
				case 7:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6]);
					break;
				case 8:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6], _param[7]);
					break;
				case 9:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6], _param[7], _param[8]);
					break;
				case 10:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6], _param[7], _param[8], _param[9]);
					break;
				case 11:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6], _param[7], _param[8], _param[9], _param[10]);
					break;
				case 12:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6], _param[7], _param[8], _param[9], _param[10], _param[11]);
					break;
				case 13:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6], _param[7], _param[8], _param[9], _param[10], _param[11], _param[12]);
					break;
				case 14:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6], _param[7], _param[8], _param[9], _param[10], _param[11], _param[12], _param[13]);
					break;
				case 15:
					instance = new _target(_param[0], _param[1], _param[2], _param[3], _param[4], _param[5], _param[6], _param[7], _param[8], _param[9], _param[10], _param[11], _param[12], _param[13], _param[14]);
					break;
			}
			if(_properties != null)
			{
				for(var key:* in _properties)
				{
					instance[key] = _properties[key];
				}
			}
			if(_initialize != null)
			{
				_initialize.call(instance);
			}
			return instance;
		}
	}
}
