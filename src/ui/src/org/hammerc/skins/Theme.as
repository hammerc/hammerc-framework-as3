/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.skins
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * <code>Theme</code> 类为主题管理类.
	 * @author wizardc
	 */
	public class Theme
	{
		/**
		 * 储存类的映射规则.
		 */
		private var _skinNameDic:Dictionary;
		
		/**
		 * 创建一个 <code>Theme</code> 对象.
		 */
		public function Theme()
		{
			super();
		}
		
		/**
		 * 为指定的组件映射默认皮肤.
		 * @param hostComponentKey 传入组件实例, 类定义或完全限定类名.
		 * @param skinClass 传递类定义作为需要映射的皮肤, 它的构造函数参数必须为空.
		 * @param named 可选参数, 当需要为同一个组件映射多个皮肤时, 可以传入此参数区分不同的映射. 在调用 <code>getSkinName</code> 方法时要传入同样的参数.
		 */
		public function mapSkin(hostComponentKey:Object, skinName:Object, named:String = ""):void
		{
			var requestName:String = getKey(hostComponentKey) + "#" + named;
			if(_skinNameDic == null)
			{
				_skinNameDic = new Dictionary();
			}
			_skinNameDic[requestName] = skinName;
		}
		
		/**
		 * 获取指定类映射的实例.
		 * @param hostComponentKey 组件实例, 类定义或完全限定类名.
		 * @param named 可选参数, 若在调用 <code>mapSkin</code> 映射时设置了这个值, 则要传入同样的字符串才能获取对应的实例.
		 */
		public function getSkinName(hostComponentKey:Object, named:String = ""):Object
		{
			var requestName:String = getKey(hostComponentKey) + "#" + named;
			if(_skinNameDic != null)
			{
				return _skinNameDic[requestName];
			}
			return null;
		}
		
		private function getKey(hostComponentKey:Object):String
		{
			if(hostComponentKey is String)
			{
				return hostComponentKey as String;
			}
			return getQualifiedClassName(hostComponentKey);
		}
	}
}
