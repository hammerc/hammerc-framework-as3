/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.net.registerClassAlias;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	/**
	 * <code>ObjectUtil</code> 类提供对象的各种操作.
	 * @author wizardc
	 */
	public class ObjectUtil
	{
		/**
		 * 对一个动态对象进行浅复制.
		 * @param object 要被复制的对象.
		 * @return 返回一个新对象, 该对象内部的键都拥有一个指向原对象的值的引用.
		 */
		public static function simpleClone(object:Object):Object
		{
			if(object == null)
			{
				return null;
			}
			var result:Object = new Object();
			for(var key:* in object)
			{
				result[key] = object[key];
			}
			return result;
		}
		
		/**
		 * 对一个任意对象进行深复制, 需要注意该对象不能为显示对象或本身或内部属性的构造函数带参数的对象.
		 * @param object 要被复制的对象.
		 * @return 返回一个新对象, 该对象的值都为一个独立的新对象.
		 */
		public static function deepClone(object:Object):Object
		{
			if(object == null)
			{
				return null;
			}
			var typeList:Vector.<String> = ReflectionUtil.getAllTypeName(object);
			for each(var item:String in typeList)
			{
				registerClassAlias(item, getDefinitionByName(item) as Class);
			}
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(object);
			bytes.position = 0;
			return bytes.readObject();
		}
		
		/**
		 * 判断一个类型是否为动态类.
		 * @param target 要获取的类型或类型的实例.
		 * @return 该类型是否为动态类.
		 */
		public static function isDynamic(target:*):Boolean
		{
			if(target is String)
			{
				try
				{
					target = getDefinitionByName(target);
				}
				catch(error:ReferenceError)
				{
					return false;
				}
			}
			//过滤掉非 object 类型的其它类型
			switch(typeof(target))
			{
				case "boolean":
				case "function":
				case "number":
				case "string":
					return false;
				case "xml":
					return true;
			}
			//获取属性
			var classInfo:XML = describeType(target);
			var isDynamic:Boolean = false;
			if(classInfo == "")
			{
				isDynamic = true;
			}
			else
			{
				isDynamic = (String(classInfo.@isDynamic) == "true");
			}
			return isDynamic;
		}
		
		/**
		 * 将一个强类型对象 (静态类) 转换为弱类型对象 (动态类).
		 * <p>仅转换读写或只读存取器和公共属性, <code>Array</code> 和 <code>Vector</code> 类型都会转换为 <code>Array</code> 类型.</p>
		 * @param object 要转换的强类型对象.
		 * @return 对应的弱类型对象.
		 */
		public static function stronglyToWeak(object:Object):Object
		{
			if(object == null || typeof(object) != "object")
			{
				return object;
			}
			//获取属性
			var classInfo:XML = describeType(object);
			//处理数组
			var className:String = String(classInfo.@name);
			var isArrayOrVector:Boolean = (className == "Array" || StringUtil.startsWith(className, "__AS3__.vec::Vector.<"));
			if(isArrayOrVector)
			{
				var array:Array = new Array();
				for each(var value:* in object)
				{
					array.push(stronglyToWeak(value));
				}
				return array;
			}
			//排除非实例对象和动态对象
			var isStatic:Boolean = String(classInfo.@isStatic) == "true";
			var isDynamic:Boolean = String(classInfo.@isDynamic) == "true";
			if(isStatic || isDynamic)
			{
				return object;
			}
			//转换存取器和公共属性
			var result:Object = new Object();
			var i:int, len:int, name:String, access:String;
			for(i = 0, len = XMLList(classInfo.accessor).length(); i < len; i++)
			{
				name = String(classInfo.accessor[i].@name);
				access = String(classInfo.accessor[i].@access);
				if(access != "writeonly")
				{
					result[name] = stronglyToWeak(object[name]);
				}
			}
			for(i = 0, len = XMLList(classInfo.variable).length(); i < len; i++)
			{
				name = String(classInfo.variable[i].@name);
				result[name] = stronglyToWeak(object[name]);
			}
			return result;
		}
		
		/**
		 * 将一个弱类型对象 (动态类) 转换为强类型对象 (静态类).
		 * <p>仅转换读写或只读存取器和公共属性, <code>Array</code>类型会根据强类型对象的类型转换为 <code>Array</code> 类型或 <code>Vector</code> 类型.</p>
		 * @param object 要转换的弱类型对象.
		 * @param target 强类型对象对应的类型, 注意其构造函数不能带参数或所有参数都带有默认值.
		 * @param applicationDomain 类定义组的容器, 为空则表示当前域.
		 * @return 对应的强类型对象.
		 */
		public static function weakToStrongly(object:Object, target:Class, applicationDomain:ApplicationDomain = null):Object
		{
			if(object == null || typeof(object) != "object")
			{
				return object;
			}
			//获取属性
			var classInfo:XML = describeType(object);
			//排除非实例对象和静态对象
			var isStatic:Boolean = String(classInfo.@isStatic) == "true";
			var isDynamic:Boolean = String(classInfo.@isDynamic) == "true";
			if(isStatic || !isDynamic)
			{
				return object;
			}
			//创建目标对象
			var result:Object = new target();
			classInfo = describeType(result);
			//转换存取器和公共属性
			var i:int, len:int, name:String, access:String, type:String;
			for(i = 0, len = XMLList(classInfo.accessor).length(); i < len; i++)
			{
				name = String(classInfo.accessor[i].@name);
				access = String(classInfo.accessor[i].@access);
				type = String(classInfo.accessor[i].@type);
				if(access != "readonly")
				{
					result[name] = assignValue(object, name, type, applicationDomain);
				}
			}
			for(i = 0, len = XMLList(classInfo.variable).length(); i < len; i++)
			{
				name = String(classInfo.variable[i].@name);
				type = String(classInfo.variable[i].@type);
				result[name] = assignValue(object, name, type, applicationDomain);
			}
			return result;
		}
		
		private static function assignValue(object:Object, name:String, type:String, applicationDomain:ApplicationDomain):Object
		{
			if(type == "Array")
			{
				var array:Array = new Array();
				for each(var value:* in object[name])
				{
					//数组无法得知其内部存放的具体类型
					array.push(value);
				}
				return array;
			}
			else if(StringUtil.startsWith(type, "__AS3__.vec::Vector.<"))
			{
				var internalType:String = type.substring(type.lastIndexOf("<") + 1, type.lastIndexOf(">"));
				var vector:Object = VectorUtil.createVector(internalType, applicationDomain);
				for each(value in object[name])
				{
					vector.push(weakToStrongly(value, ReflectionUtil.getClass(internalType, applicationDomain), applicationDomain));
				}
				return vector;
			}
			return weakToStrongly(object[name], ReflectionUtil.getClass(type, applicationDomain), applicationDomain);
		}
	}
}
