/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import org.hammerc.components.SkinnableComponent;
	
	/**
	 * <code>SkinPartUtil</code> 类为获取皮肤定义的公开属性名的工具类.
	 * @author wizardc
	 */
	public class SkinPartUtil
	{
		/**
		 * 基本数据类型列表.
		 */
		private static const BASIC_TYPES:Vector.<String> = new <String>["Number", "int", "String", "Boolean", "uint", "Object"];
		
		/**
		 * 皮肤公开属性名缓存表.
		 */
		private static var _skinPartCache:Dictionary = new Dictionary();
		
		/**
		 * 获取逻辑组件实例里定义的公开属性名列表, 排除掉基本属性类型, 列表中的属性如果皮肤类中也有则视为子组件对象.
		 * @param host 逻辑组件实例.
		 */
		public static function getSkinParts(host:SkinnableComponent):Vector.<String>
		{
			var key:String = getQualifiedClassName(host);
			if(_skinPartCache[key] != null)
			{
				return _skinPartCache[key];
			}
			var info:XML = describeType(host);
			var node:XML;
			var skinParts:Vector.<String> = new Vector.<String>();
			var partName:String;
			for each(node in info.variable)
			{
				partName = node.@name.toString();
				if(BASIC_TYPES.indexOf(node.@type) == -1)
				{
					skinParts.push(partName);
				}
			}
			_skinPartCache[key] = skinParts;
			return skinParts;
		}
	}
}
