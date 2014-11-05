// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.core
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.hammerc.errors.AbstractError;
	
	/**
	 * <code>AbstractEnforcer</code> 为 AS3.0 提供抽象类支持.
	 * <p>实现方法参考了 Mims Wright 的 abstract classes in as3.</p>
	 * @author wizardc
	 */
	public class AbstractEnforcer
	{
		/**
		 * 实现抽象类, 将该方法放在抽象类的构造函数中第一行执行即可.
		 * @param instance 抽象类的实例.
		 * @param compareClass 抽象类.
		 * @throws org.hammerc.errors.AbstractError 当 <code>instance</code> 为 <code>compareClass</code> 的一个实例时(但不包括子类生成的实例)抛出 <code>AbstractError</code> 异常.
		 */
		public static function enforceConstructor(instance:Object, compareClass:Class):void
		{
			if(strictIs(instance, compareClass))
			{
				var className:String = getQualifiedClassName(compareClass);
				throw new AbstractError(AbstractError.CONSTRUCTOR_ERROR, className);
			}
		}
		
		/**
		 * 严格判断一个类的实例是否就是这个类生成的.
		 * @param instance 生成的实例.
		 * @param compareClass 类.
		 * @return 如果 <code>instance</code> 是直接由 <code>compareClass</code> 类生成则返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		private static function strictIs(instance:Object, compareClass:Class):Boolean
		{
			var instanceClass:Class = Class(getDefinitionByName(getQualifiedClassName(instance)));
			return instanceClass == compareClass;
		}
		
		/**
		 * 实现抽象方法, 将该方法放在抽象函数中第一行执行即可.
		 * @throws org.hammerc.errors.AbstractError 执行该方法会抛出 <code>AbstractError</code> 异常.
		 */
		public static function enforceMethod():void
		{
			var methodName:String = getMethodName();
			throw new AbstractError(AbstractError.METHOD_ERROR, methodName);
		}
		
		/**
		 * 获取抽象方法的名称.
		 * @return 抽象方法的名称.
		 */
		private static function getMethodName():String
		{
			var stackTrace:String;
			try
			{
				throw new Error("Get method name.");
			}
			catch(error:Error)
			{
				stackTrace = error.getStackTrace();
			}
			if(stackTrace == null)
			{
				return null;
			}
			var stackList:Array = stackTrace.split("\n");
			var message:String = stackList[3] as String;
			var methodName:String = message.substring(message.indexOf("/") + 1, message.indexOf("("));
			return methodName;
		}
	}
}
