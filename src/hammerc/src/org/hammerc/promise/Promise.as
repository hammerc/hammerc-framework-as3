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
	/**
	 * <code>Promise</code> 类遵循并实现了 ES6 Promises 的规范, 用来解决异步代码嵌套过多的问题.
	 * <code>具体的 Promise 使用方法可参考: http://liubin.org/promises-book/.</code>
	 * @author wizardc
	 */
	public final class Promise
	{
		/**
		 * 异步执行中.
		 */
		public static const PENDING:int = 0;
		
		/**
		 * 异步执行成功.
		 */
		public static const ACCEPTED:int = 1;
		
		/**
		 * 异步执行成功并运行结束.
		 */
		public static const FULFILLED:int = 2;
		
		/**
		 * 异步执行失败.
		 */
		public static const REJECTED:int = 3;
		
		/**
		 * 创建一个 <code>Promise</code> 并立即执行成功.
		 * @param value 成功执行后传递的数据.
		 * @return <code>Promise</code> 对象.
		 */
		public static function resolve(value:*):Promise
		{
			if(value && value is Promise)
			{
				return value;
			}
			return new Promise(function(resolve:Function, reject:Function):void
			{
				resolve(value);
			});
		}
		
		/**
		 * 创建一个 <code>Promise</code> 并立即执行失败.
		 * @param reason 执行失败后传递的数据.
		 * @return <code>Promise</code> 对象.
		 */
		public static function reject(reason:*):Promise
		{
			var promise:Promise = new Promise(function(resolve:Function, reject:Function):void{});
			promise._resolver.result = reason;
			promise._resolver.status = Promise.REJECTED;
			return promise;
		}
		
		/**
		 * 同时执行传入的多个 <code>Promise</code> 对象, 全部执行成功调用 then 的成功回调, 一个或多个失败调用 then 的失败回调.
		 * @param values <code>Promise</code> 数组.
		 * @return 监听整个执行的 <code>Promise</code> 对象.
		 */
		public static function all(values:Array):Promise
		{
			return new Promise(function(resolve:Function, reject:Function):void
			{
				var remaining:int = values.length, i:int = 0, length:int = values.length, results:Array = [];
				function oneDone(index:int):Function
				{
					return function(value:*):void
					{
						results[index] = value;
						remaining--;
						if(remaining == 0)
						{
							resolve(results);
						}
					};
				}
				if(length < 1)
				{
					resolve(results);
					return;
				}
				for(; i < length; i++)
				{
					Promise.resolve(values[i]).then(oneDone(i), reject);
				}
			});
		}
		
		/**
		 * 同时执行传入的多个 <code>Promise</code> 对象, 第一个执行成功后调用 then 的成功回调执行失败后调用 then 的失败回调, 不会取消其它 <code>Promise</code> 对象的执行但不会调用 then 回调.
		 * @param values <code>Promise</code> 数组.
		 * @return 监听整个执行的 <code>Promise</code> 对象.
		 */
		public static function race(values:Array):Promise
		{
			return new Promise(function(resolve:Function, reject:Function):void
			{
				for(var i:int = 0, count:int = values.length; i < count; i++)
				{
					Promise.resolve(values[i]).then(resolve, reject);
				}
			});
		}
		
		private var _resolver:Resolver = new Resolver();
		
		/**
		 * 创建一个 <code>Promise</code> 对象.
		 * @param func 逻辑执行函数, 接收两个 <code>Function</code> 类型的参数, 第一个运行成功时调用, 第二个运行失败是调用, 无返回值.
		 */
		public function Promise(func:Function)
		{
			try
			{
				func(function(value:*):void
				{
					_resolver.resolve(value);
				},function(reason:*):void
				{
					_resolver.reject(reason);
				});
			}
			catch(error:Error)
			{
				_resolver.reject(error);
			}
		}
		
		/**
		 * 获取当前的状态.
		 */
		public function get status():int
		{
			return _resolver.status;
		}
		
		/**
		 * 注册异步调用完成后的回调.
		 * @param callback 异步处理成功时的回调方法.
		 * @param errback 异步处理失败时的回调方法.
		 * @return 新的 <code>Promise</code> 对象.
		 */
		public function then(callback:Function, errback:Function = null):Promise
		{
			var resolve:Function = null, reject:Function = null;
			var promise:Promise = new Promise(function(res:Function, rej:Function):void
			{
				resolve = res;
				reject = rej;
			});
			this._resolver.addCallbacks(typeof callback === "function" ? makeCallback(promise, resolve, reject, callback) : resolve, typeof errback === "function" ? makeCallback(promise, resolve, reject, errback) : reject);
			return promise;
		}
		
		private function makeCallback(promise:Promise, resolve:Function, reject:Function, fn:Function):Function
		{
			return function(valueOrReason):void
			{
				var result:*;
				try
				{
					result = fn(valueOrReason);
				}
				catch(error:Error)
				{
					reject(error);
					return;
				}
				if(result == promise)
				{
					reject(new TypeError("Cannot resolve a promise with itself!"));
					return;
				}
				resolve(result);
			};
		}
		
		/**
		 * 注册异步调用失败后的回调.
		 * @param errback 异步处理失败时的回调方法.
		 * @return 新的 <code>Promise</code> 对象.
		 */
		public function caught(errback:Function):Promise
		{
			return this.then(null, errback);
		}
	}
}
