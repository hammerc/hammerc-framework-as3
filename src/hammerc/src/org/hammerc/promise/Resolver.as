// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2016 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.promise
{
	import flash.utils.setTimeout;
	
	/**
	 * <code>Resolver</code> 类实现了 <code>Promise</code> 的核心逻辑.
	 * @author wizardc
	 */
	[ExcludeClass]
	internal final class Resolver
	{
		/**
		 * 执行成功回调列表.
		 */
		public var callbacks:Array = [];
		
		/**
		 * 执行失败回调列表.
		 */
		public var errbacks:Array = [];
		
		/**
		 * 执行状态.
		 */
		public var status:int = Promise.PENDING;
		
		/**
		 * 异步返回的数据.
		 */
		public var result:*;
		
		/**
		 * 异步返回的数据.
		 */
		public var value:*;
		
		/**
		 * 创建一个 <code>Resolver</code> 对象.
		 */
		public function Resolver()
		{
		}
		
		/**
		 * 添加回调.
		 * @param callback 成功的回调.
		 * @param errback 失败的回调.
		 */
		public function addCallbacks(callback:Function, errback:Function):void
		{
			if(callbacks != null)
			{
				callbacks.push(callback);
			}
			if(errbacks != null)
			{
				errbacks.push(errback);
			}
			switch(status)
			{
				case Promise.ACCEPTED:
					unwrap(value);
					break;
				case Promise.FULFILLED:
					fulfill(result);
					break;
				case Promise.REJECTED:
					this.reject(result);
					break;
			}
		}
		
		/**
		 * 执行失败.
		 * @param reason 执行失败的返回值.
		 */
		public function reject(reason:*):void
		{
			if(status == Promise.PENDING || status == Promise.ACCEPTED)
			{
				result = reason;
				status = Promise.REJECTED;
			}
			if(status == Promise.REJECTED)
			{
				notify(errbacks, result);
				callbacks = null;
				errbacks = [];
			}
		}
		
		/**
		 * 执行成功.
		 * @param value 执行成功的返回值.
		 */
		public function resolve(value:*):void
		{
			if(status == Promise.PENDING)
			{
				status = Promise.ACCEPTED;
				this.value = value;
				if((callbacks && callbacks.length > 0) || (errbacks && errbacks.length > 0))
				{
					unwrap(this.value);
				}
			}
		}
		
		private function fulfill(value:*):void
		{
			if(status == Promise.PENDING || status == Promise.ACCEPTED)
			{
				result = value;
				status = Promise.FULFILLED;
			}
			if(status == Promise.FULFILLED)
			{
				notify(callbacks, result);
				callbacks = [];
				errbacks = null;
			}
		}
		
		private function unwrap(value:*):void
		{
			var unwrapped:Boolean = false, then:*;
			if(!value || (typeof value != "object" && typeof value != "function"))
			{
				fulfill(value);
				return;
			}
			try
			{
				then = value.then;
				if(typeof then == "function")
				{
					then.call(value, function(value:*):void
					{
						if(!unwrapped)
						{
							unwrapped = true;
							unwrap(value);
						}
					}, function(reason:*):void
					{
						if(!unwrapped)
						{
							unwrapped = true;
							reject(reason);
						}
					});
				}
				else
				{
					fulfill(value);
				}
			}
			catch(error:Error)
			{
				if(!unwrapped)
				{
					this.reject(error);
				}
			}
		}
		
		private function notify(subs:Array, result:*):void
		{
			if(subs.length > 0)
			{
				setTimeout(function():void
				{
					for(var i:int = 0, len:int = subs.length; i < len; ++i)
					{
						subs[i](result);
					}
				}, 0);
			}
		}
	}
}
