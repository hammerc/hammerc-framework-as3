// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.crystal.control
{
	import org.hammerc.crystal.interfaces.INotification;
	
	/**
	 * <code>Notification</code> 类实现了一个最简单的消息对象.
	 * @author wizardc
	 */
	public class Notification implements INotification
	{
		private var _name:String;
		private var _type:String;
		private var _body:Object;
		
		/**
		 * 创建一个 <code>Notification</code> 对象.
		 * @param name 消息名称.
		 * @param type 消息的类型.
		 * @param body 消息的数据.
		 */
		public function Notification(name:String, type:String = null, body:Object = null)
		{
			_name = name;
			_type = type;
			_body = body;
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
		public function set type(value:String):void
		{
			_type = value;
		}
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set body(value:Object):void
		{
			_body = value;
		}
		public function get body():Object
		{
			return _body;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			return "Notification[name=\"" + _name + "\", type=\"" + _type + "\", body=\"" + _body + "\"]";
		}
	}
}
