/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.plugins.filters
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.tween.plugins.AbstractTweenPlugin;
	import org.hammerc.tween.plugins.PluginItem;
	
	/**
	 * <code>AbstractFilterPlugin</code> 类抽象出滤镜缓动补丁对象应有的属性及方法.
	 * @author wizardc
	 */
	public class AbstractFilterPlugin extends AbstractTweenPlugin
	{
		/**
		 * 记录缓动的具体滤镜类对象.
		 */
		protected var _filterClass:Class;
		
		/**
		 * 记录用来设置的键名列表.
		 */
		protected var _settingKeys:Vector.<String>;
		
		/**
		 * 记录目标对象.
		 */
		protected var _target:DisplayObject;
		
		/**
		 * <code>AbstractFilterPlugin</code> 类为抽象类, 不能被实例化.
		 * @param filterClass 缓动的具体滤镜类对象.
		 * @param key 补丁对象的键名.
		 * @param tweenKeys 补丁对象可以用来进行缓动的键名.
		 * @param settingKeys 用来设置的键名列表.
		 */
		public function AbstractFilterPlugin(filterClass:Class, key:String, tweenKeys:Vector.<String>, settingKeys:Vector.<String>)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractFilterPlugin);
			super(key, tweenKeys);
			_filterClass = filterClass;
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
			//创建或取出指定的滤镜
			var filter:BitmapFilter;
			var index:int = this.getFilterIndex();
			if(index == -1)
			{
				filter = new _filterClass() as BitmapFilter;
			}
			else
			{
				filter = _target.filters[index] as BitmapFilter;
			}
			//设置不用于缓动的值
			for each(var value:String in _settingKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					filter[value] = variables[value];
				}
			}
			//立即设置滤镜
			this.setFilter(filter);
			//获取所有的初始值
			var startVariables:Object = new Object();
			for each(value in _tweenKeys)
			{
				startVariables[value] = filter[value];
			}
			return startVariables;
		}
		
		/**
		 * 获取指定滤镜的索引.
		 * @return 指定滤镜的索引. 如果有多个相同的滤镜则返回第一个滤镜的索引, 没有则返回 -1.
		 */
		protected function getFilterIndex():int
		{
			var filters:Array = _target.filters;
			for(var i:int = 0, len:int = filters.length; i < len; i++)
			{
				if(filters[i] is _filterClass)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update(baseValue:Number):void
		{
			var index:int = this.getFilterIndex();
			var filter:BitmapFilter = _target.filters[index] as BitmapFilter;
			for(var i:int = 0, len:int = _propertyList.length; i < len; i++)
			{
				var item:PluginItem = _propertyList[i];
				filter[item.property] = item.start + item.change * baseValue;
			}
			this.setFilter(filter);
		}
		
		/**
		 * 设置滤镜.
		 * @param filter 要进行设置的滤镜对象.
		 */
		protected function setFilter(filter:BitmapFilter):void
		{
			var index:int = this.getFilterIndex();
			var filters:Array = _target.filters;
			if(index == -1)
			{
				filters.push(filter);
			}
			else
			{
				filters[index] = filter;
			}
			_target.filters = filters;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function updateVariables(variables:Object, moveMode:int):void
		{
			super.updateVariables(variables, moveMode);
			var index:int = this.getFilterIndex();
			var filter:BitmapFilter = _target.filters[index] as BitmapFilter;
			for each(var value:String in _settingKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					filter[value] = variables[value];
				}
			}
			this.setFilter(filter);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function resetVariables(variables:Object):void
		{
			var index:int = this.getFilterIndex();
			var filter:BitmapFilter = _target.filters[index] as BitmapFilter;
			for each(var value:String in _tweenKeys)
			{
				if(variables.hasOwnProperty(value))
				{
					filter[value] = variables[value];
				}
			}
			this.setFilter(filter);
		}
	}
}
