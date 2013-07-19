/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.load.parsers
{
	import flash.events.IEventDispatcher;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * <code>IResourceParser</code> 接口定义了资源解析对象应有的属性及方法.
	 * @author wizardc
	 */
	public interface IResourceParser extends IEventDispatcher
	{
		/**
		 * 获取其指定的资源类型.
		 */
		function get key():String;
		
		/**
		 * 获取解析后的对象.
		 */
		function get data():*;
		
		/**
		 * 解析方法.
		 * @param data 原始字节数组对象.
		 * @param context 载入上下文对象.
		 */
		function parse(data:ByteArray, context:LoaderContext):void;
	}
}
