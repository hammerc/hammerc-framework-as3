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
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.crystal.interfaces.INotification;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>Notification</code> 类实现了一个最简单的消息对象.
	 * @author wizardc
	 */
	public class Notification implements INotification
	{
		private static var _pool:Vector.<Notification> = new Vector.<Notification>();
		
		/**
		 * 从对象池中取出一个消息对象.
		 * @param name 消息名称.
		 * @param type 消息的类型.
		 * @param body 消息的数据.
		 * @return 消息对象.
		 */
		hammerc_internal static function fromPool(name:String, type:String = null, body:Object = null):Notification
		{
			if(_pool.length > 0)
			{
				return _pool.pop().reset(name, type, body);
			}
			else
			{
				return new Notification(name, type, body);
			}
		}
		
		/**
		 * 回收一个消息对象.
		 * @param notification 消息对象.
		 */
		hammerc_internal static function toPool(notification:INotification):void
		{
			if(notification is Notification)
			{
				(notification as Notification).clear();
				_pool[_pool.length] = notification as Notification;
			}
		}
		
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
		 * 重置消息的数据.
		 * @param name 消息名称.
		 * @param type 消息的类型.
		 * @param body 消息的数据.
		 * @return 消息对象.
		 */
		hammerc_internal function reset(name:String, type:String = null, body:Object = null):Notification
		{
			_name = name;
			_type = type;
			_body = body;
			return this;
		}
		
		/**
		 * 清除消息的数据.
		 */
		hammerc_internal function clear():void
		{
			_name = null;
			_type = null;
			_body = null;
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
