/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.pigeon.http
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import org.hammerc.events.ExtendEventDispatcher;
	import org.hammerc.pigeon.http.errors.HTTPChannelError;
	import org.hammerc.pigeon.http.events.HTTPChannelEvent;
	
	/**
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	
	/**
	 * @eventType flash.events.NetStatusEvent.NET_STATUS
	 */
	[Event(name="netStatus",type="flash.events.NetStatusEvent")]
	
	/**
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]
	
	/**
	 * @eventType org.hammerc.pigeon.http.events.HTTPChannelEvent.DATA_ARRIVE
	 */
	[Event(name="dataArrive",type="org.hammerc.pigeon.http.events.HTTPChannelEvent")]
	
	/**
	 * <code>HTTPChannel</code> 类定义了一个 HTTP 请求的通道对象.
	 * @author wizardc
	 */
	public class HTTPChannel extends ExtendEventDispatcher
	{
		/**
		 * 记录用于连接的远程服务地址.
		 */
		protected var _url:String;
		
		/**
		 * 用来与后台进行连接的对象.
		 */
		protected var _urlLoader:URLLoader;
		
		/**
		 * 记录当前该通道是否处于空闲状态.
		 */
		protected var _idle:Boolean = true;
		
		/**
		 * 记录附带的用户数据.
		 */
		protected var _userData:Object;
		
		/**
		 * 创建一个 <code>HTTPChannel</code> 对象.
		 * @param url 指定用于连接的远程服务地址.
		 */
		public function HTTPChannel(url:String)
		{
			_url = url;
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_urlLoader.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		/**
		 * 设置或获取用于连接的远程服务地址.
		 */
		public function set url(value:String):void
		{
			_url = value;
		}
		public function get url():String
		{
			return _url;
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
		 * 访问指定的页面.
		 * @param dataFormat 指定接收的数据格式.
		 * @throws HTTPChannelError 没有指定地址时抛出该错误.
		 */
		public function visit(dataFormat:String = "text"):void
		{
			if(_url == null)
			{
				throw new HTTPChannelError("属性\"url\"不能为空！");
			}
			var request:URLRequest = new URLRequest();
			request.url = _url;
			_urlLoader.dataFormat = dataFormat;
			_urlLoader.load(request);
			_idle = false;
		}
		
		/**
		 * 使用 GET 方法访问指定的页面.
		 * @param variables 需要传递给后台的数据.
		 * @param dataFormat 指定接收的数据格式.
		 * @throws HTTPChannelError 没有指定地址时抛出该错误.
		 */
		public function get(variables:URLVariables, dataFormat:String = "text"):void
		{
			if(_url == null)
			{
				throw new HTTPChannelError("属性\"url\"不能为空！");
			}
			var request:URLRequest = new URLRequest();
			request.url = _url;
			request.data = variables;
			request.method = URLRequestMethod.GET;
			_urlLoader.dataFormat = dataFormat;
			_urlLoader.load(request);
			_idle = false;
		}
		
		/**
		 * 使用 POST 方法访问指定的页面.
		 * @param variables 需要传递给后台的数据.
		 * @param dataFormat 指定接收的数据格式.
		 * @throws HTTPChannelError 没有指定地址时抛出该错误.
		 */
		public function post(variables:URLVariables, dataFormat:String = "text"):void
		{
			if(_url == null)
			{
				throw new HTTPChannelError("属性\"url\"不能为空！");
			}
			var request:URLRequest = new URLRequest();
			request.url = _url;
			request.data = variables;
			request.method = URLRequestMethod.POST;
			_urlLoader.dataFormat = dataFormat;
			_urlLoader.load(request);
			_idle = false;
		}
		
		/**
		 * 使用 POST 方法访问指定的页面同时传递二进制数据到后台.
		 * @param bytes 需要传递给后台的二进制数据.
		 * @param dataFormat 指定接收的数据格式.
		 * @throws HTTPChannelError 没有指定地址时抛出该错误.
		 */
		public function sendBytes(bytes:ByteArray, dataFormat:String = "text"):void
		{
			if(_url == null)
			{
				throw new HTTPChannelError("属性\"url\"不能为空！");
			}
			var request:URLRequest = new URLRequest();
			request.requestHeaders.push(new URLRequestHeader("Content-type", "application/octet-stream"));
			request.url = _url;
			request.data = bytes;
			request.method = URLRequestMethod.POST;
			_urlLoader.dataFormat = dataFormat;
			_urlLoader.load(request);
			_idle = false;
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			this.dispatchEvent(event);
			_idle = true;
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			this.dispatchEvent(event);
			_idle = true;
		}
		
		private function netStatusHandler(event:IOErrorEvent):void
		{
			this.dispatchEvent(event);
			_idle = true;
		}
		
		private function completeHandler(event:Event):void
		{
			this.dispatchEvent(new HTTPChannelEvent(HTTPChannelEvent.DATA_ARRIVE, _urlLoader.dataFormat, _urlLoader.data));
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
		 * 关闭该 HTTP 请求通道的链接.
		 */
		public function close():void
		{
			try
			{
				_urlLoader.close();
			}
			catch(error:Error)
			{
			}
			_idle = true;
		}
	}
}
