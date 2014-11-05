// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.frame
{
	/**
	 * <code>IFrameManager</code> 接口定义了帧执行管理器应有的属性及方法.
	 * @author wizardc
	 */
	public interface IFrameManager
	{
		/**
		 * 获取当前注册的帧执行对象的数量.
		 */
		function get numFrameClent():int;
		
		/**
		 * 获取当前正在运行的超时方法的数量.
		 */
		function get numTimeoutCount():int;
		
		/**
		 * 设置或获取当前帧处理对象是否暂停.
		 */
		function set paused(value:Boolean):void;
		function get paused():Boolean;
		
		/**
		 * 添加一个帧执行对象.
		 * @param client 帧执行对象.
		 */
		function addFrameClient(client:IFrameClient):void;
		
		/**
		 * 判断指定的帧执行对象是否存在.
		 * @param client 帧执行对象.
		 * @return 指定的帧执行对象是否存在.
		 */
		function hasFrameClient(client:IFrameClient):Boolean;
		
		/**
		 * 移除一个帧执行对象.
		 * @param client 帧执行对象.
		 */
		function removeFrameClient(client:IFrameClient):void;
		
		/**
		 * 在指定的延迟后运行指定的函数.
		 * @param closure 延迟回调方法.
		 * @param delay 延迟时间, 单位为毫秒. 本延迟回调是基于帧事件的, 所有的回调都至少会等候到下一帧执行, 所有如果这里设置为 0 也不会立即执行.
		 * @param args 会传递给延迟回调方法的参数.
		 * @return 延迟回调的数字标识符.
		 */
		function setTimeout(closure:Function, delay:int, ...args):uint;
		
		/**
		 * 取消指定的延迟调用.
		 * @param id 延迟回调的数字标识符.
		 */
		function clearTimeout(id:uint):void;
	}
}
