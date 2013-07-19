/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.errors
{
	/**
	 * 试图实例化抽象类时会抛出 <code>AbstractError</code> 异常.
	 * @see org.hammerc.core.AbstractEnforcer
	 * @author wizardc
	 */
	public class AbstractError extends Error
	{
		/**
		 * 实例化抽象类时抛出的异常.
		 */
		public static const CONSTRUCTOR_ERROR:int = 0;
		
		/**
		 * 直接调用抽象方法时抛出的异常.
		 */
		public static const METHOD_ERROR:int = 1;
		
		private var _state:int = 0;												//记录错误的具体类型
		
		/**
		 * 创建 <code>AbstractError</code> 对象.
		 * @param state 指定该错误的具体类型.
		 * @param name 抛出该异常对象的名称.
		 */
		public function AbstractError(state:int, name:String = "undefined")
		{
			_state = state;
			var _message:String;
			switch(_state)
			{
				case CONSTRUCTOR_ERROR:
					_message = "抽象类\"" + name + "\"不能被实例化！";
					break;
				case METHOD_ERROR:
					if(name == null)
					{
						_message = "抽象方法不能被直接调用！";
					}
					else
					{
						_message = "抽象方法\"" + name + "\"不能被直接调用！";
					}
					break;
			}
			super(_message);
		}
		
		/**
		 * 获取该错误的具体类型.
		 * <p>
		 * 可能出现的值如下:
		 * <ul>
		 * <li><code>HAbstractError.CONSTRUCTOR_ERROR</code></li>
		 * <li><code>HAbstractError.METHOD_ERROR</code></li>
		 * </ul>
		 * </p>
		 */
		public function get state():int
		{
			return _state;
		}
	}
}
