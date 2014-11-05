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
	import org.hammerc.tween.MoveMode;
	
	/**
	 * <code>AbstractTweenPlugin</code> 类抽象出缓动补丁对象应有的属性及方法.
	 * @author wizardc
	 */
	public class AbstractTweenPlugin implements ITweenPlugin
	{
		/**
		 * 记录补丁对象的键名.
		 */
		protected var _key:String;
		
		/**
		 * 记录补丁对象可以用来进行缓动的键名.
		 */
		protected var _tweenKeys:Vector.<String>;
		
		/**
		 * 记录所有缓动属性的列表.
		 */
		protected var _propertyList:Vector.<PluginItem>;
		
		/**
		 * 记录缓动开始前所有缓动属性的初始状态.
		 */
		protected var _startVariables:Object;
		
		/**
		 * <code>AbstractTweenPlugin</code> 类为抽象类, 不能被实例化.
		 * @param key 补丁对象的键名.
		 * @param tweenKeys 补丁对象可以用来进行缓动的键名.
		 */
		public function AbstractTweenPlugin(key:String, tweenKeys:Vector.<String>)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractTweenPlugin);
			_key = key;
			_tweenKeys = tweenKeys;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get key():String
		{
			return _key;
		}
		
		/**
		 * @inheritDoc
		 */
		public function checkSupport(target:Object):Boolean
		{
			AbstractEnforcer.enforceMethod();
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function initPlugin(target:Object, variables:Object, moveMode:int):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 创建所有的缓动属性对象.
		 * @param variables 具体的目标状态属性.
		 * @param moveMode 移动模式.
		 */
		protected function createPropertyList(variables:Object, moveMode:int):void
		{
			_startVariables = this.getStartVariables(variables);
			_propertyList = new Vector.<PluginItem>();
			for each(var key:String in _tweenKeys)
			{
				if(variables.hasOwnProperty(key))
				{
					var item:PluginItem = getPluginItem(_propertyList, key);
					if(item == null)
					{
						item = new PluginItem(key);
						_propertyList.push(item);
					}
					item.start = _startVariables[key];
					if(moveMode == MoveMode.ADDITION)
					{
						item.change = variables[key];
					}
					else
					{
						item.change = variables[key] - item.start;
					}
				}
			}
		}
		
		private function getPluginItem(list:Vector.<PluginItem>, key:String):PluginItem
		{
			var item:PluginItem = null;
			for(var i:int = 0; i < list.length; i++)
			{
				var value:PluginItem = list[i];
				if(value.property == key)
				{
					item = value;
					break;
				}
			}
			return item;
		}
		
		/**
		 * 获取缓动开始前所有缓动属性的初始状态.
		 * @param variables 具体的目标状态属性.
		 * @return 缓动开始前所有缓动属性的初始状态.
		 */
		protected function getStartVariables(variables:Object):Object
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function update(baseValue:Number):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateVariables(variables:Object, moveMode:int):void
		{
			for each(var key:String in _tweenKeys)
			{
				if(variables.hasOwnProperty(key))
				{
					var item:PluginItem = getPluginItem(_propertyList, key);
					if(item == null)
					{
						item = new PluginItem(key);
						_propertyList.push(item);
					}
					item.start = _startVariables[key];
					if(moveMode == MoveMode.ADDITION)
					{
						item.change = variables[key];
					}
					else
					{
						item.change = variables[key] - item.start;
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeVariables(variables:Object):void
		{
			var reset:Boolean = false;
			var resetVariables:Object = new Object();
			for each(var key:String in _tweenKeys)
			{
				if(variables.hasOwnProperty(key))
				{
					var item:PluginItem = getPluginItem(_propertyList, key);
					if(item != null)
					{
						var value:* = variables[key];
						if(value is Boolean && !value)
						{
							reset = true;
							resetVariables[key] = item.start;
						}
						else if(value is Number)
						{
							reset = true;
							resetVariables[key] = value;
						}
					}
				}
			}
			if(reset)
			{
				this.resetVariables(resetVariables);
			}
		}
		
		/**
		 * 移除目标属性时需要重新设定属性值时会调用本方法.
		 * @param variables 要重设的目标属性.
		 */
		protected function resetVariables(variables:Object):void
		{
			AbstractEnforcer.enforceMethod();
		}
	}
}
