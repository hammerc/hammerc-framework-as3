// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.tween.plugins
{
	import org.hammerc.core.AbstractEnforcer;
	
	/**
	 * <code>AbstractPropertyPlugin</code> 类抽象出属性补丁对象应有的属性及方法.
	 * <p>继承本类可以实现缓动指定对象的非数值属性中的属性, 具体可以参照 <code>SoundTransformPlugin</code> 类来实现自定义的补丁类.</p>
	 * @author wizardc
	 */
	public class AbstractPropertyPlugin extends AbstractTweenPlugin
	{
		/**
		 * 记录作用于目标对象上的属性名称.
		 */
		protected var _propertyKey:String;
		
		/**
		 * 记录用来设置的键名列表.
		 */
		protected var _settingKeys:Vector.<String>;
		
		/**
		 * 记录目标对象.
		 */
		protected var _target:Object;
		
		/**
		 * <code>AbstractPropertyPlugin</code> 类为抽象类, 不能被实例化.
		 * @param propertyKey 作用于目标对象上的属性名称.
		 * @param key 补丁对象的键名.
		 * @param tweenKeys 补丁对象可以用来进行缓动的键名.
		 * @param settingKeys 用来设置的键名列表.
		 */
		public function AbstractPropertyPlugin(propertyKey:String, key:String, tweenKeys:Vector.<String>, settingKeys:Vector.<String>)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractPropertyPlugin);
			super(key, tweenKeys);
			_propertyKey = propertyKey;
			_settingKeys = settingKeys;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initPlugin(target:Object, variables:Object, moveMode:int):void
		{
			_target = target;
			this.createPropertyList(variables, moveMode);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getStartVariables(variables:Object):Object
		{
			//取出指定的属性对象
			var property:Object = _target[_propertyKey];
			//如果指定的属性为空
			if(property == null)
			{
				property = this.getDefaultInstance();
			}
			//设置不用于缓动的值
			for each(var value:String in _settingKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					property[value] = variables[value];
				}
			}
			//立即设置
			_target[_propertyKey] = property;
			//获取所有的初始值
			var startVariables:Object = new Object();
			for each(value in _tweenKeys)
			{
				startVariables[value] = property[value];
			}
			return startVariables;
		}
		
		/**
		 * 初始化补丁时如果指定的属性为空则应创建一个默认的属性值给该属性.
		 * @return 对应的属性的实例.
		 */
		protected function getDefaultInstance():Object
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update(baseValue:Number):void
		{
			var property:Object = _target[_propertyKey];
			for(var i:int = 0, len:int = _propertyList.length; i < len; i++)
			{
				var item:PluginItem = _propertyList[i];
				property[item.property] = item.start + item.change * baseValue;
			}
			_target[_propertyKey] = property;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateVariables(variables:Object, moveMode:int):void
		{
			super.updateVariables(variables, moveMode);
			var property:Object = _target[_propertyKey];
			for each(var value:String in _settingKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					property[value] = variables[value];
				}
			}
			_target[_propertyKey] = property;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resetVariables(variables:Object):void
		{
			var property:Object = _target[_propertyKey];
			for each(var value:String in _tweenKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					property[value] = variables[value];
				}
			}
			_target[_propertyKey] = property;
		}
	}
}
