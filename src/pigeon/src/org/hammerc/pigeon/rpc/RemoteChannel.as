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
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	import org.hammerc.events.ExtendEventDispatcher;
	import org.hammerc.pigeon.rpc.errors.RemoteChannelError;
	import org.hammerc.pigeon.rpc.events.RemoteChannelEvent;
	
	/**
	 * @eventType org.hammerc.pigeon.rpc.events.ChannelEvent.CONNECT_SUCCESS
	 */
	[Event(name="connectSuccess",type="org.hammerc.pigeon.rpc.events.RemoteChannelEvent")]
	
	/**
	 * @eventType org.hammerc.pigeon.rpc.events.ChannelEvent.CONNECT_FAILED
	 */
	[Event(name="connectFailed",type="org.hammerc.pigeon.rpc.events.RemoteChannelEvent")]
	
	/**
	 * @eventType org.hammerc.pigeon.rpc.events.ChannelEvent.CONNECT_CLOSED
	 */
	[Event(name="connectClosed",type="org.hammerc.pigeon.rpc.events.RemoteChannelEvent")]
	
	/**
	 * @eventType org.hammerc.pigeon.rpc.events.ChannelEvent.SERVER_RESULT
	 */
	[Event(name="serverResult",type="org.hammerc.pigeon.rpc.events.RemoteChannelEvent")]
	
	/**
	 * @eventType org.hammerc.pigeon.rpc.events.ChannelEvent.SERVER_FAULT
	 */
	[Event(name="serverFault",type="org.hammerc.pigeon.rpc.events.RemoteChannelEvent")]
	
	/**
	 * <code>RemoteChannel</code> 类定义了一个用于和远程服务进行远程过程调用链接的通道对象.
	 * @author wizardc
	 */
	public class RemoteChannel extends ExtendEventDispatcher
	{
		/**
		 * 记录用于连接的远程服务地址.
		 */
		protected var _gateway:String;
		
		/**
		 * 记录远程服务的具体服务对象名称.
		 */
		protected var _service:String;
		
		/**
		 * 用于和远程服务连接的对象.
		 */
		protected var _netConnection:NetConnection;
		
		/**
		 * 服务端相应接收对象.
		 */
		protected var _responder:Responder;
		
		/**
		 * 标示该客户端的 session id.
		 */
		protected var _sessionId:String;
		
		/**
		 * 记录当前该通道是否处于空闲状态.
		 */
		protected var _idle:Boolean = true;
		
		/**
		 * 记录附带的用户数据.
		 */
		protected var _userData:Object;
		
		/**
		 * 创建一个 <code>RemoteChannel</code> 对象.
		 * @param gateway 指定用于连接的远程服务地址.
		 */
		public function RemoteChannel(gateway:String = null)
		{
			_gateway = gateway;
			_netConnection = new NetConnection();
			_netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_netConnection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_netConnection.objectEncoding = ObjectEncoding.AMF3;
			_netConnection.client = this;
			_responder = new Responder(onResult, onStatus);
		}
		
		private function asyncErrorHandler(event:IOErrorEvent):void
		{
			this.close();
			var fault:RemoteFault = new RemoteFault("RemoteChannel.Async.Error", "error");
			this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.CONNECT_FAILED, null, fault));
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			this.close();
			var fault:RemoteFault = new RemoteFault("RemoteChannel.IO.Error", "error");
			this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.CONNECT_FAILED, null, fault));
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			this.close();
			var fault:RemoteFault = new RemoteFault("RemoteChannel.Security.Error", "error");
			this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.CONNECT_FAILED, null, fault));
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			var info:Object = event.info;
			if(info != null)
			{
				if(info["level"] == "error")
				{
					var fault:RemoteFault = new RemoteFault(info["code"], info["level"], info["description"]);
					if(String(info["code"]).indexOf("Connect") != -1)
					{
						this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.CONNECT_FAILED, null, fault));
						this.close();
					}
					else
					{
						this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.SERVER_FAULT, null, fault));
					}
				}
				else
				{
					if(info["code"] == "NetConnection.Connect.Success")
					{
						this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.CONNECT_SUCCESS));
					}
					else if(info["code"] == "NetConnection.Connect.Closed")
					{
						this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.CONNECT_CLOSED));
					}
				}
			}
		}
		
		/**
		 * @private
		 * 该方法会被服务端回调, 服务端会分配一个 session id 给该客户端, 在下一次连接时可以加上该 id.
		 * @param sessionId 服务端分配给该客户端的 session id.
		 */
		public function AppendToGatewayUrl(sessionId:String):void
		{
			if(sessionId != null && sessionId != "" && sessionId != _sessionId)
			{
				_sessionId = sessionId;
			}
		}
		
		/**
		 * 链接远程服务.
		 * @param gateway 指定用于连接的远程服务地址.
		 * @throws org.hammerc.pigeon.rpc.error.ChannelError 没有指定 gateway 属性时抛出该异常.
		 * @throws ArgumentError 指定的 gateway 格式不正确时抛出该异常.
		 * @throws flash.errors.IOError 连接失败时抛出该异常.
		 * @throws SecurityError 连接到常用的保留端口或不受信任时抛出该异常.
		 */
		public function connect(gateway:String = null):void
		{
			if(gateway != null)
			{
				_gateway = gateway;
			}
			if(_gateway == null)
			{
				throw new RemoteChannelError("属性\"gateway\"不能为空！");
			}
			//获取用于连接的地址, 添加 session id
			var url:String = _gateway;
			if(_sessionId != null)
			{
				var i:int = url.indexOf("wsrp-url=");
				if(i != -1)
				{
					var temp:String = url.substr(i + 9, url.length);
					var j:int = temp.indexOf("&");
					if(j != -1)
					{
						temp = temp.substr(0, j);
					}
					url = url.replace(temp, temp + _sessionId);
				}
				else
				{
					url += _sessionId;
				}
			}
			try
			{
				//连接服务端
				_netConnection.connect(url);
			}
			catch(error:Error)
			{
				error.message += " url:'" + url + "'";
				throw error;
			}
		}
		
		/**
		 * 获取该对象当前是否连接到服务器.
		 */
		public function get connected():Boolean
		{
			return _netConnection.connected;
		}
		
		/**
		 * 设置或获取用于连接的远程服务地址.
		 */
		public function set gateway(value:String):void
		{
			_gateway = value;
		}
		public function get gateway():String
		{
			return _gateway;
		}
		
		/**
		 * 设置或获取远程服务的具体对象名称/目标.
		 */
		public function set service(value:String):void
		{
			_service = value;
		}
		public function get service():String
		{
			return _service;
		}
		
		/**
		 * 设置或获取附带的用户数据.
		 */
		public function set userData(value:Object):void
		{
			_userData = value;
		}
		public function get userData():Object
		{
			return _userData;
		}
		
		/**
		 * 调用一个远程方法.
		 * @param method 要被调用的远程方法名.
		 * @param args 传递给该远程方法的参数.
		 * @throws RemoteChannelError 没有指定服务对象名称时抛出该异常.
		 * @throws RemoteChannelError 该通道正在使用时抛出该异常.
		 * @throws RemoteChannelError 没有指定要被调用的远程方法名时抛出该异常.
		 */
		public function call(method:String, ...args:Array):void
		{
			if(_service == null)
			{
				throw new RemoteChannelError("属性\"service\"不能为空！");
			}
			if(!_idle)
			{
				throw new RemoteChannelError("当前通道正在使用！");
			}
			if(method == null)
			{
				throw new RemoteChannelError("参数\"method\"不能为空！");
			}
			_netConnection.call.apply(undefined, [_service + "." + method, _responder].concat(args));
			_idle = false;
		}
		
		private function onResult(result:Object):void
		{
			if(result != null)
			{
				this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.SERVER_RESULT, result));
			}
			_idle = true;
		}
		
		private function onStatus(status:Object):void
		{
			if(status != null)
			{
				var fault:RemoteFault = new RemoteFault(status["faultCode"], status["faultString"], status["faultDetail"]);
				this.dispatchEvent(new RemoteChannelEvent(RemoteChannelEvent.SERVER_FAULT, null, fault));
			}
			_idle = true;
		}
		
		/**
		 * 获取当前该通道是否处于空闲状态.
		 */
		public function get idle():Boolean
		{
			return _idle;
		}
		
		/**
		 * 关闭该远程通道的链接.
		 */
		public function close():void
		{
			_netConnection.close();
			_idle = true;
		}
	}
}
