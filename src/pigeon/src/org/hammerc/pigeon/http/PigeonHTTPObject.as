// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.pigeon.http
{
	import flash.utils.Dictionary;
	
	import org.hammerc.pigeon.http.errors.PigeonHTTPError;
	
	/**
	 * <code>PigeonHTTPObject</code> 类定义了一个用于连接 HTTP 服务端并可以获取可用的连接通道的类.
	 * <p>内部使用若引用表记录所有的链接通道对象, 不使用的链接通道对象会自动回收.</p>
	 * @author wizardc
	 */
	public class PigeonHTTPObject
	{
		/**
		 * 记录用于连接的远程服务地址.
		 */
		protected var _url:String;
		
		/**
		 * 记录所有的连接通道.
		 */
		protected var _channelMap:Dictionary;
		
		/**
		 * 创建一个 <code>PigeonHTTPObject</code> 对象.
		 * @param url 指定用于连接的远程服务地址.
		 */
		public function PigeonHTTPObject(url:String = null)
		{
			_url = url;
			_channelMap = new Dictionary(true);
		}
		
		/**
		 * 设置或获取用于连接的远程服务地址.
		 */
		public function set url(value:String):void
		{
			_url = value;
			this.cleanAll();
		}
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * 获取可用的连接通道的类.
		 * @return 一个空闲的 HTTP 连接对象.
		 * @throws 没有指定 url 属性时抛出该异常.
		 */
		public function getRemoteChannel():HTTPChannel
		{
			if(_url == null)
			{
				throw new PigeonHTTPError("属性\"url\"不能为空！");
			}
			var channel:HTTPChannel;
			for(var key:HTTPChannel in _channelMap)
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
				channel = new HTTPChannel(_url);
				_channelMap[channel] = true;
			}
			return channel;
		}
		
		/**
		 * 清除并关闭该对象打开的所有连接.
		 */
		public function cleanAll():void
		{
			for(var key:HTTPChannel in _channelMap)
			{
				key.close();
			}
			_channelMap = new Dictionary(true);
		}
	}
}
