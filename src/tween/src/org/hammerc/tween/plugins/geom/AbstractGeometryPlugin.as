/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.plugins.geom
{
	import flash.display.DisplayObject;
	
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.tween.plugins.AbstractTweenPlugin;
	import org.hammerc.tween.plugins.PluginItem;
	
	/**
	 * <code>AbstractGeometryPlugin</code> 类抽象出转换补丁对象应有的属性及方法.
	 * @author wizardc
	 */
	public class AbstractGeometryPlugin extends AbstractTweenPlugin
	{
		/**
		 * 记录作用于 <code>Transform</code> 对象上的属性名称.
		 */
		protected var _transformKey:String;
		
		/**
		 * 记录用来设置的键名列表.
		 */
		protected var _settingKeys:Vector.<String>;
		
		/**
		 * 记录目标对象.
		 */
		protected var _target:DisplayObject;
		
		/**
		 * <code>AbstractGeometryPlugin</code> 类为抽象类, 不能被实例化.
		 * @param transformKey 作用于 <code>Transform</code> 对象上的属性名称.
		 * @param key 补丁对象的键名.
		 * @param tweenKeys 补丁对象可以用来进行缓动的键名.
		 * @param settingKeys 用来设置的键名列表.
		 */
		public function AbstractGeometryPlugin(transformKey:String, key:String, tweenKeys:Vector.<String>, settingKeys:Vector.<String>)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractGeometryPlugin);
			super(key, tweenKeys);
			_transformKey = transformKey;
			_settingKeys = settingKeys;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function checkSupport(target:Object):Boolean
		{
			if(target is DisplayObject)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initPlugin(target:Object, variables:Object, moveMode:int):void
		{
			_target = target as DisplayObject;
			this.createPropertyList(variables, moveMode);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getStartVariables(variables:Object):Object
		{
			//取出指定的转换对象
			var transform:Object = _target.transform[_transformKey];
			//设置不用于缓动的值
			for each(var value:String in _settingKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					transform[value] = variables[value];
				}
			}
			//立即设置
			_target.transform[_transformKey] = transform;
			//获取所有的初始值
			var startVariables:Object = new Object();
			for each(value in _tweenKeys)
			{
				startVariables[value] = transform[value];
			}
			return startVariables;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update(baseValue:Number):void
		{
			var transform:Object = _target.transform[_transformKey];
			for(var i:int = 0, len:int = _propertyList.length; i < len; i++)
			{
				var item:PluginItem = _propertyList[i];
				transform[item.property] = item.start + item.change * baseValue;
			}
			_target.transform[_transformKey] = transform;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateVariables(variables:Object, moveMode:int):void
		{
			super.updateVariables(variables, moveMode);
			var transform:Object = _target.transform[_transformKey];
			for each(var value:String in _settingKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					transform[value] = variables[value];
				}
			}
			_target.transform[_transformKey] = transform;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resetVariables(variables:Object):void
		{
			var transform:Object = _target.transform[_transformKey];
			for each(var value:String in _tweenKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					transform[value] = variables[value];
				}
			}
			_target.transform[_transformKey] = transform;
		}
	}
}
