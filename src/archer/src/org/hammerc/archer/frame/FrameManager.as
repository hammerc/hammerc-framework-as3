/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.archer.frame
{
	/**
	 * <code>FrameManager</code> 类为帧执行管理器.
	 * @author wizardc
	 */
	public class FrameManager
	{
		private static var _impl:IFrameManager;
		
		private static function get impl():IFrameManager
		{
			if(_impl == null)
			{
				_impl = new FrameManagerImpl();
			}
			return _impl;
		}
		
		/**
		 * 获取当前注册的帧执行对象的数量.
		 */
		public static function get numFrameClent():int
		{
			return impl.numFrameClent;
		}
		
		/**
		 * 获取当前正在运行的超时方法的数量.
		 */
		public static function get numTimeoutCount():int
		{
			return impl.numTimeoutCount;
		}
		
		/**
		 * 设置或获取当前帧处理对象是否暂停.
		 */
		public static function set paused(value:Boolean):void
		{
			impl.paused = value;
		}
		public static function get paused():Boolean
		{
			return impl.paused;
		}
		
		/**
		 * 添加一个帧执行对象.
		 * @param client 帧执行对象.
		 */
		public static function addFrameClient(client:IFrameClient):void
		{
			impl.addFrameClient(client);
		}
		
		/**
		 * 判断指定的帧执行对象是否存在.
		 * @param client 帧执行对象.
		 * @return 指定的帧执行对象是否存在.
		 */
		public static function hasFrameClient(client:IFrameClient):Boolean
		{
			return impl.hasFrameClient(client);
		}
		
		/**
		 * 移除一个帧执行对象.
		 * @param client 帧执行对象.
		 */
		public static function removeFrameClient(client:IFrameClient):void
		{
			impl.removeFrameClient(client);
		}
		
		/**
		 * 在指定的延迟后运行指定的函数.
		 * @param closure 延迟回调方法.
		 * @param delay 延迟时间, 单位为毫秒.
		 * @param args 会传递给延迟回调方法的参数.
		 * @return 延迟回调的数字标识符.
		 */
		public static function setTimeout(closure:Function, delay:int, ...args):int
		{
			return impl.setTimeout.apply(null, [closure, delay].concat(args));
		}
		
		/**
		 * 取消指定的延迟调用.
		 * @param id 延迟回调的数字标识符.
		 */
		public static function clearTimeout(id:int):void
		{
			impl.clearTimeout(id);
		}
	}
}
