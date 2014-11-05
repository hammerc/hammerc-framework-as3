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
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * <code>ReflectionUtil</code> 类提供反射编程的各种操作.
	 * @author wizardc
	 */
	public class ReflectionUtil
	{
		/**
		 * 更具对象的完全限定类名获取该对象的定义.
		 * @param fullClassName 完全限定类名.
		 * @param applicationDomain 类定义组的容器, 为空则表示当前域.
		 * @return 对应的类对象, 不存在则返回 <code>null</code>.
		 */
		public static function getClass(fullClassName:String, applicationDomain:ApplicationDomain = null):Class
		{
			if(applicationDomain == null)
			{
				applicationDomain = ApplicationDomain.currentDomain;
			}
			if(!applicationDomain.hasDefinition(fullClassName))
			{
				return null;
			}
			var assetClass:Class = applicationDomain.getDefinition(fullClassName) as Class;
			return assetClass;
		}
		
		/**
		 * 获取一个类型的所有属性名称, 仅 AS3 命名空间下的公共可读写属性.
		 * @param target 要获取的类型或类型的实例.
		 * @return 该类型的所有属性名称列表.
		 */
		public static function getAllAttributeName(target:*):Array
		{
			var result:Array = new Array();
			if(target == null)
			{
				return result;
			}
			if(target is String)
			{
				try
				{
					target = getDefinitionByName(target);
				}
				catch(error:ReferenceError)
				{
					return result;
				}
			}
			//过滤掉非 object 类型的其它类型
			switch(typeof(target))
			{
				case "boolean":
				case "function":
				case "number":
				case "string":
				case "xml":
				return result;
			}
			//获取属性
			var classInfo:XML = describeType(target);
			var isStatic:Boolean = String(classInfo.@isStatic) == "true";
			var isDynamic:Boolean = String(classInfo.@isDynamic) == "true";
			//动态类实例直接返回键列表
			if(isDynamic && !isStatic)
			{
				for(var key:* in target)
				{
					result.push(key);
				}
			}
			//类型名称返回其静态的所有属性名称
			var i:int, len:int;
			if(isStatic)
			{
				for(i = 0, len = XMLList(classInfo.factory.accessor).length(); i < len; i++)
				{
					if(String(XMLList(classInfo.factory.accessor)[i].@access) == "readwrite" && XMLList(classInfo.factory.accessor)[i].@uri == undefined)
					{
						result.push(String(classInfo.factory.accessor[i].@name));
					}
				}
				for(i = 0, len = XMLList(classInfo.factory.variable).length(); i < len; i++)
				{
					if(XMLList(classInfo.factory.variable)[i].@uri == undefined)
					{
						result.push(String(classInfo.factory.variable[i].@name));
					}
				}
			}
			//非动态类实例返回其静态的所有属性名称
			if(!isDynamic && !isStatic)
			{
				for(i = 0, len = XMLList(classInfo.accessor).length(); i < len; i++)
				{
					if(String(XMLList(classInfo.accessor)[i].@access) == "readwrite" && XMLList(classInfo.accessor)[i].@uri == undefined)
					{
						result.push(String(classInfo.accessor[i].@name));
					}
				}
				for(i = 0, len = XMLList(classInfo.variable).length(); i < len; i++)
				{
					if(XMLList(classInfo.variable)[i].@uri == undefined)
					{
						result.push(String(classInfo.variable[i].@name));
					}
				}
			}
			return result;
		}
		
		/**
		 * 获取一个类型的所有属性默认值, 仅 AS3 命名空间下的公共可读写属性.
		 * @param target 要获取的类型或类型的实例.
		 * @return 该类的所有公开属性默认值, key 为名称, value 为默认值.
		 */
		public static function getAllDefaultAttribute(target:*):Dictionary
		{
			var result:Dictionary = new Dictionary();
			if(target == null)
			{
				return result;
			}
			if(target is String)
			{
				try
				{
					target = getDefinitionByName(target);
				}
				catch(error:ReferenceError)
				{
					return result;
				}
			}
			var list:Array = getAllAttributeName(target);
			if(list.length == 0)
			{
				return result;
			}
			//创建一个新对象
			if(target is Class)
			{
				target = new target();
			}
			else
			{
				var assetClass:Class = getDefinitionByName(getQualifiedClassName(target)) as Class;
				target = new assetClass();
			}
			//获取默认属性
			for each(var value:* in list)
			{
				result[value] = target[value];
			}
			return result;
		}
		
		/**
		 * 获取一个类或类的实例用到的所有类型.
		 * @param target 要获取的类型或类型的实例.
		 * @return 所有类型的字符串列表.
		 */
		public static function getAllTypeName(target:*):Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			if(target == null)
			{
				return result;
			}
			if(target is String)
			{
				try
				{
					target = getDefinitionByName(target);
				}
				catch(error:ReferenceError)
				{
					return result;
				}
			}
			//过滤掉非 object 类型的其它类型
			switch(typeof(target))
			{
				case "boolean":
				case "function":
				case "number":
				case "string":
				case "xml":
				return result;
			}
			//获取属性
			var classInfo:XML = describeType(target);
			var isStatic:Boolean = (String(classInfo.@isStatic) == "true");
			//获取所有类型
			var record:Object = new Object();
			record[String(classInfo.@name)] = true;
			var i:int, ilen:int, j:int, jlen:int;
			if(isStatic)
			{
				for(i = 0, ilen = XMLList(classInfo.factory.extendsClass).length(); i < ilen; i++)
				{
					record[String(classInfo.factory.extendsClass[i].@type)] = true;
				}
				for(i = 0, ilen = XMLList(classInfo.factory.implementsInterface).length(); i < ilen; i++)
				{
					record[String(classInfo.factory.implementsInterface[i].@type)] = true;
				}
				for(i = 0, ilen = XMLList(classInfo.factory.accessor).length(); i < ilen; i++)
				{
					record[String(classInfo.factory.accessor[i].@type)] = true;
				}
				for(i = 0, ilen = XMLList(classInfo.factory.variable).length(); i < ilen; i++)
				{
					record[String(classInfo.factory.variable[i].@type)] = true;
				}
				for(i = 0, ilen = XMLList(classInfo.factory.method).length(); i < ilen; i++)
				{
					record[String(classInfo.factory.method[i].@returnType)] = true;
					for(j = 0, jlen = XMLList(classInfo.factory.method[i].parameter).length(); j < jlen; j++)
					{
						record[String(classInfo.factory.method[i].parameter[j].@type)] = true;
					}
				}
			}
			else
			{
				for(i = 0, ilen = XMLList(classInfo.extendsClass).length(); i < ilen; i++)
				{
					record[String(classInfo.extendsClass[i].@type)] = true;
				}
				for(i = 0, ilen = XMLList(classInfo.implementsInterface).length(); i < ilen; i++)
				{
					record[String(classInfo.implementsInterface[i].@type)] = true;
				}
				for(i = 0, ilen = XMLList(classInfo.accessor).length(); i < ilen; i++)
				{
					record[String(classInfo.accessor[i].@type)] = true;
				}
				for(i = 0, ilen = XMLList(classInfo.variable).length(); i < ilen; i++)
				{
					record[String(classInfo.variable[i].@type)] = true;
				}
				for(i = 0, ilen = XMLList(classInfo.method).length(); i < ilen; i++)
				{
					record[String(classInfo.method[i].@returnType)] = true;
					for(j = 0, jlen = XMLList(classInfo.method[i].parameter).length(); j < jlen; j++)
					{
						record[String(classInfo.method[i].parameter[j].@type)] = true;
					}
				}
			}
			for(var key:String in record)
			{
				if(key != "void" && key != "*")
				{
					result.push(key);
				}
			}
			return result;
		}
	}
}
