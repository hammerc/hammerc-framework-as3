/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.core
{
	/**
	 * <code>IInvalidating</code> 接口定义了拥有失效验证机制组件的接口.
	 * @author wizardc
	 */
	public interface IInvalidating
	{
		/**
		 * 标记提交过需要延迟应用的属性.
		 */
		function invalidateProperties():void;
		
		/**
		 * 标记提交过需要验证组件尺寸.
		 */
		function invalidateSize():void;
		
		/**
		 * 标记需要验证显示列表.
		 */
		function invalidateDisplayList():void;
		
		/**
		 * 立即应用组件及其子项的所有属性.
		 * @param skipDisplayList 是否跳过显示列表验证阶段.
		 */
		function validateNow(skipDisplayList:Boolean = false):void;
	}
}
