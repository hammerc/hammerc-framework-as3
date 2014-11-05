// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.pigeon.rpc
{
	import flash.utils.Dictionary;
	
	import org.hammerc.pigeon.rpc.errors.PigeonRemoteError;
	
	/**
	 * <code>PigeonRemoteObject</code> 类定义了一个用于连接远程服务端并可以获取可用的远程调用通道的类.
	 * <p>内部使用若引用表记录所有的远程调用通道对象, 不使用的远程调用通道对象会自动回收.</p>
	 * @author wizardc
	 */
	public class PigeonRemoteObject
	{
		/**
		 * 记录用于连接的远程服务地址.
		 */
		protected var _gateway:String;
		
		/**
		 * 记录远程服务的哈希表.
		 */
		protected var _serviceMap:Object;
		
		/**
		 * 创建一个 <code>PigeonRemoteObject</code> 对象.
		 * @param gateway 指定用于连接的远程服务地址.
		 */
		public function PigeonRemoteObject(gateway:String = null)
		{
			_gateway = gateway;
			_serviceMap = new Object();
		}
		
		/**
		 * 设置或获取用于连接的远程服务地址.
		 */
		public function set gateway(value:String):void
		{
			_gateway = value;
			this.cleanAll();
		}
		public function get gateway():String
		{
			return _gateway;
		}
		
		/**
		 * 获取可用的远程调用通道对象.
		 * @param service 位于指定的远程服务地址上的一个服务对象名称.
		 * @return 对应参数指定服务对象名称的远程调用通道对象.
		 * @throws PigeonRemoteError 没有指定 gateway 属性时抛出该异常.
		 * @throws PigeonRemoteError 没有指定服务对象名称时抛出该异常.
		 */
		public function getRemoteChannel(service:String):RemoteChannel
		{
			if(_gateway == null)
			{
				throw new PigeonRemoteError("属性\"gateway\"不能为空！");
			}
			if(service == null)
			{
				throw new PigeonRemoteError("属性\"service\"不能为空！");
			}
			if(!_serviceMap.hasOwnProperty(service) || !(_serviceMap[service] is Dictionary))
			{
				_serviceMap[service] = new Dictionary(true);
			}
			var channelMap:Dictionary = _serviceMap[service] as Dictionary;
			var channel:RemoteChannel;
			for(var key:RemoteChannel in channelMap)
			{
				if(key.idle)
				{
					channel = key;
					channel.removeAllEventListeners();
					channel.userData = null;
					break;
				}
			}
			if(channel == null)
			{
				channel = new RemoteChannel(_gateway);
				channel.service = service;
				channel.connect();
				channelMap[channel] = true;
			}
			return channel;
		}
		
		/**
		 * 清除并关闭一个指定服务对象名称打开的所有连接.
		 * @param service 位于指定的远程服务地址上的一个服务对象名称.
		 */
		public function cleanService(service:String):void
		{
			if(_serviceMap.hasOwnProperty(service))
			{
				var channelMap:Dictionary = _serviceMap[service] as Dictionary;
				for(var key:RemoteChannel in channelMap)
				{
					key.close();
				}
				delete _serviceMap[service];
			}
		}
		
		/**
		 * 清除并关闭该对象打开的所有连接.
		 */
		public function cleanAll():void
		{
			for(var key:String in _serviceMap)
			{
				this.cleanService(key);
			}
			_serviceMap = new Object();
		}
	}
}
