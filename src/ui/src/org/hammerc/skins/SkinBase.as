/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.skins
{
	import org.hammerc.components.Group;
	import org.hammerc.components.SkinnableComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.styles.StyleDeclaration;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>SkinBase</code> 类为皮肤布局基类.
	 * <p>本类及其子类中定义的公开属性, 会在初始化完成后被直接当做皮肤子件并将引用赋值到逻辑组件的同名属性上, 若有延迟加载的子件, 请在加载完成后手动调用 <code>hostComponent.findSkinParts()</code> 方法应用子件.</p>
	 * @author wizardc
	 */
	public class SkinBase extends Group implements ISkin, IStateClient
	{
		private var _hostComponent:SkinnableComponent;
		
		private var _states:Array = [];
		
		/**
		 * 记录当前视图状态.
		 */
		hammerc_internal var _currentState:String;
		
		/**
		 * 记录当前视图状态是否发生改变.
		 */
		hammerc_internal var _currentStateChanged:Boolean;
		
		private var _styleProperties:Array = [];
		
		/**
		 * 创建一个 <code>SkinBase</code> 对象.
		 */
		public function SkinBase()
		{
			super();
		}
		
		/**
		 * 设置或获取主机组件引用, 仅当皮肤被应用后才会对此属性赋值.
		 */
		public function set hostComponent(value:SkinnableComponent):void
		{
			_hostComponent = value;
		}
		public function get hostComponent():SkinnableComponent
		{
			return _hostComponent;
		}
		
		/**
		 * 设置或获取此组件定义的视图状态数组.
		 */
		public function set states(value:Array):void
		{
			_states = value;
		}
		public function get states():Array
		{
			return _states;
		}
		
		/**
		 * 设置或获取组件的当前视图状态.
		 */
		public function set currentState(value:String):void
		{
			if(_currentState == value)
			{
				return;
			}
			_currentState = value;
			if(this.initialized || this.hasParent)
			{
				_currentStateChanged = false;
				this.commitCurrentState();
				if(this.hostComponent != null)
				{
					this.hostComponent.findSkinParts();
				}
			}
			else
			{
				_currentStateChanged = true;
				this.invalidateProperties();
			}
		}
		public function get currentState():String
		{
			if(_currentState == null || _currentState == "")
			{
				return _states[0];
			}
			return _currentState;
		}
		
		/**
		 * 返回是否含有指定名称的视图状态.
		 * @param stateName 要检测的视图状态名称.
		 * @return 是否含有指定名称的视图状态.
		 */
		public function hasState(stateName:String):Boolean
		{
			for each(var state:String in states)
			{
				if(state == stateName)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 设置或获取此组件定义的可用样式数组.
		 * <p>仅该数组定义过的样式属性名称会调用到 <code>commitCurrentStyle</code> 方法中.</p>
		 */
		public function set styleProperties(value:Array):void
		{
			_styleProperties = value;
		}
		public function get styleProperties():Array
		{
			return _styleProperties;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_currentStateChanged)
			{
				_currentStateChanged = false;
				this.commitCurrentState();
				if(this.hostComponent != null)
				{
					this.hostComponent.findSkinParts();
				}
			}
		}
		
		/**
		 * 应用当前的视图状态.
		 */
		protected function commitCurrentState():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateCurrentStyle(styleDeclaration:StyleDeclaration):void
		{
			for each (var property:String in _styleProperties)
			{
				var value:* = styleDeclaration.getStyle(property);
				if(value != null && value != undefined)
				{
					this.commitCurrentStyle(property, true, value);
				}
				else
				{
					this.commitCurrentStyle(property, false);
				}
			}
		}
		
		/**
		 * 应用当前的视图样式.
		 * @param styleProperty 样式属性名称.
		 * @param hasSet 该样式是否被明确设置过.
		 * @param value 设置的样式值.
		 */
		protected function commitCurrentStyle(styleProperty:String, hasSet:Boolean, value:* = null):void
		{
		}
	}
}
