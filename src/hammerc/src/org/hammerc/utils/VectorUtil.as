// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.utils
{
	import flash.system.ApplicationDomain;
	
	/**
	 * <code>VectorUtil</code> 类提供对列表的各种处理.
	 * @author wizardc
	 */
	public class VectorUtil
	{
		/**
		 * 动态创建一个列表对象.
		 * @param className 列表中存放的数据类型名称.
		 * @param applicationDomain 类定义组的容器, 为空则表示当前域.
		 * @return 对应的列表对象.
		 */
		public static function createVector(className:String, applicationDomain:ApplicationDomain = null):Object
		{
			var vectorType:String = "__AS3__.vec.Vector.<" + className + ">";
			var vectorClass:Class = ReflectionUtil.getClass(vectorType, applicationDomain);
			if(vectorClass != null)
			{
				return new vectorClass();
			}
			return null;
		}
	}
}
