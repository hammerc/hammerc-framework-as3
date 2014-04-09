/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	
	import org.hammerc.core.Injector;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.SkinPartEvent;
	import org.hammerc.skins.ISkin;
	import org.hammerc.skins.IStateClient;
	import org.hammerc.skins.SkinLayout;
	import org.hammerc.skins.Theme;
	import org.hammerc.styles.IStyleClient;
	import org.hammerc.styles.StyleDeclaration;
	import org.hammerc.styles.StyleManager;
	import org.hammerc.utils.SkinPartUtil;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.SkinPartEvent.PART_ADDED
	 */
	[Event(name="partAdded", type="org.hammerc.events.SkinPartEvent")]
	
	/**
	 * @eventType org.hammerc.events.SkinPartEvent.PART_REMOVED
	 */
	[Event(name="partRemoved", type="org.hammerc.events.SkinPartEvent")]
	
	/**
	 * <code>SkinnableComponent</code> 类定义了可设置外观组件的基类, 接受 <code>ISkin</code> 接口或任何显示对象作为皮肤.
	 * 当皮肤为 <code>ISkin</code> 时, 将自动匹配两个实例内同名的公开属性 (显示对象), 并将皮肤的属性引用赋值到此类定义的同名属性上.
	 * @author wizardc
	 */
	public class SkinnableComponent extends UIAsset implements IStyleClient
	{
		/**
		 * 默认的皮肤解析适配器.
		 */
		private static var _defaultTheme:Theme;
		
		/**
		 * 灰度滤镜.
		 */
		private static var _grayFilters:Array = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1])];
		
		/**
		 * 记录非显示对象的皮肤对象.
		 */
		private var _invisibleSkin:Object;
		
		/**
		 * 记录由组件自身创建了皮肤子件的标志.
		 */
		private var _hasCreatedSkinParts:Boolean = false;
		
		/**
		 * 记录状态是否改变的标志.
		 */
		private var _stateIsDirty:Boolean = false;
		
		/**
		 * 旧的滤镜列表
		 */
		private var _oldFilters:Array;
		
		/**
		 * 被替换过灰色滤镜的标志
		 */
		private var _grayFilterIsSet:Boolean = false;
		
		/**
		 * 记录在 enabled 属性发生改变时是否自动开启或禁用鼠标事件的响应
		 */
		private var _autoMouseEnabled:Boolean = true;
		
		private var _explicitMouseChildren:Boolean = true;
		private var _explicitMouseEnabled:Boolean = true;
		
		/**
		 * 非 <code>ISkin</code> 接口皮肤对象的布局类.
		 */
		private var _layout:SkinLayout;
		
		/**
		 * 记录样式名称.
		 */
		private var _styleName:String;
		
		/**
		 * 记录样式设置的属性.
		 */
		private var _styleDeclarationProperties:Object = new Object();
		
		/**
		 * 记录当前的样式描述对象.
		 */
		private var _styleDeclaration:StyleDeclaration;
		
		/**
		 * 记录样式是否改变的标志.
		 */
		private var _styleIsDirty:Boolean = false;
		
		/**
		 * 创建一个 <code>SkinnableComponent</code> 对象.
		 */
		public function SkinnableComponent()
		{
			super();
			this.mouseChildren = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			if(_defaultTheme == null)
			{
				try
				{
					_defaultTheme = Injector.getInstance(Theme);
				}
				catch(error:Error)
				{
				}
			}
			if(_defaultTheme != null && this.skinName == null)
			{
				this.skinName = _defaultTheme.getSkinName(this.hostComponentKey);
				_skinNameExplicitlySet = false;
			}
			//让部分组件在没有皮肤的情况下创建默认的子部件
			if(this.skinName == null)
			{
				this.onGetSkin(null, null);
			}
			super.createChildren();
		}
		
		/**
		 * 在皮肤注入管理器里标识自身的默认键, 可以是类定义, 实例, 或者是完全限定类名.
		 * <p>子类覆盖此方法, 用于获取注入的缺省 <code>skinName</code>.</p>
		 */
		protected function get hostComponentKey():Object
		{
			return SkinnableComponent;
		}
		
		/**
		 * 获取解析后的非显示对象皮肤对象.
		 */
		public function get invisibleSkin():Object
		{
			return _invisibleSkin;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onGetSkin(skin:Object, skinName:Object):void
		{
			var oldSkin:Object = this.getCurrentSkin();
			this.detachSkin(oldSkin);
			if(_skin != null)
			{
				if(_skin.parent == this)
				{
					this.removeFromDisplayList(_skin);
				}
			}
			_skin = null;
			_invisibleSkin = null;
			if(skin is DisplayObject)
			{
				_skin = skin as DisplayObject;
				this.addToDisplayListAt(_skin, 0);
				this.invalidateSkinStyle();
			}
			else
			{
				_invisibleSkin = skin;
			}
			var newSkin:Object = this.getCurrentSkin();
			this.attachSkin(newSkin);
			this.invalidateSkinState();
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 * 获取当前的皮肤对象.
		 * <p>当附加的皮肤为非显示对象时, 返回非显示对象.</p>
		 */
		hammerc_internal function getCurrentSkin():Object
		{
			return _invisibleSkin ? _invisibleSkin : _skin;
		}
		
		/**
		 * 添加皮肤对象.
		 * @param skin 解析获得的皮肤对象.
		 */
		protected function attachSkin(skin:Object):void
		{
			if(skin is ISkin)
			{
				(skin as ISkin).hostComponent = this;
				this.findSkinParts();
			}
			else
			{
				if(!_hasCreatedSkinParts)
				{
					this.createSkinParts();
					_hasCreatedSkinParts = true;
				}
			}
			if(skin is ISkin && skin is DisplayObject)
			{
				this.skinLayoutEnabled = false;
			}
			else
			{
				this.skinLayoutEnabled = true;
			}
		}
		
		/**
		 * 匹配皮肤和主机组件的公共变量, 并完成实例的注入.
		 * <p>此方法在附加皮肤时会自动执行一次. 若皮肤中含有延迟实例化的子部件, 在子部件实例化完成时需要从外部再次调用此方法, 完成注入.</p>
		 */
		public function findSkinParts():void
		{
			var curSkin:Object = this.getCurrentSkin();
			if(curSkin == null || !(curSkin is ISkin))
			{
				return;
			}
			var skinParts:Vector.<String> = SkinPartUtil.getSkinParts(this);
			for each(var partName:String in skinParts)
			{
				if((partName in this) && (partName in curSkin) && curSkin[partName] != null && this[partName] == null)
				{
					try
					{
						this[partName] = curSkin[partName];
						this.partAdded(partName, curSkin[partName]);
					}
					catch(error:Error)
					{
					}
				}
			}
		}
		
		/**
		 * 由组件自身来创建必要的皮肤子件, 通常是皮肤为空或皮肤不是 <code>ISkin</code> 接口时调用.
		 */
		hammerc_internal function createSkinParts():void
		{
		}
		
		/**
		 * 删除组件自身创建的皮肤子件.
		 */
		hammerc_internal function removeSkinParts():void
		{
		}
		
		/**
		 * 移除皮肤对象.
		 * @param skin 解析获得的皮肤对象.
		 */
		protected function detachSkin(skin:Object):void
		{
			if(_hasCreatedSkinParts)
			{
				this.removeSkinParts();
				_hasCreatedSkinParts = false;
			}
			if(skin is ISkin)
			{
				var skinParts:Vector.<String> = SkinPartUtil.getSkinParts(this);
				for each(var partName:String in skinParts)
				{
					if(!(partName in this))
					{
						continue;
					}
					if(this[partName] != null)
					{
						this.partRemoved(partName, this[partName]);
					}
					this[partName] = null;
				}
				(skin as ISkin).hostComponent = null;
			}
		}
		
		/**
		 * 若皮肤是 <code>ISkin</code> 接口, 则调用此方法附加皮肤中的公共部件.
		 * @param partName 皮肤子件名称.
		 * @param instance 皮肤子件实例.
		 */
		protected function partAdded(partName:String, instance:Object):void
		{
			var event:SkinPartEvent = new SkinPartEvent(SkinPartEvent.PART_ADDED, partName, instance);
			this.dispatchEvent(event);
		}
		
		/**
		 * 若皮肤是 <code>ISkin</code> 接口，则调用此方法卸载皮肤之前注入的公共部件.
		 * @param partName 皮肤子件名称.
		 * @param instance 皮肤子件实例.
		 */
		protected function partRemoved(partName:String, instance:Object):void
		{
			var event:SkinPartEvent = new SkinPartEvent(SkinPartEvent.PART_REMOVED, partName, instance);
			this.dispatchEvent(event);
		}
		
		/**
		 * 标记当前需要重新验证皮肤状态.
		 */
		public function invalidateSkinState():void
		{
			if(_stateIsDirty)
			{
				return;
			}
			_stateIsDirty = true;
			this.invalidateProperties();
		}
		
		/**
		 * 子类覆盖此方法, 应用当前的皮肤状态.
		 */
		protected function validateSkinState():void
		{
			var curState:String = this.getCurrentSkinState();
			var hasState:Boolean = false;
			var curSkin:Object = _invisibleSkin ? _invisibleSkin : _skin;
			if(curSkin is IStateClient)
			{
				(curSkin as IStateClient).currentState = curState;
				hasState = (curSkin as IStateClient).hasState(curState);
			}
			if(this.hasEventListener("stateChanged"))
			{
				this.dispatchEvent(new Event("stateChanged"));
			}
			if(this.enabled)
			{
				if(_grayFilterIsSet)
				{
					filters = _oldFilters;
					_oldFilters = null;
					_grayFilterIsSet = false;
				}
			}
			else
			{
				if(!hasState && !_grayFilterIsSet)
				{
					_oldFilters = filters;
					filters = _grayFilters;
					_grayFilterIsSet = true;
				}
			}
		}
		
		/**
		 * 设置或获取在 <code>enabled</code> 属性发生改变时是否自动开启或禁用鼠标事件的响应.
		 */
		public function set autoMouseEnabled(value:Boolean):void
		{
			if(_autoMouseEnabled == value)
			{
				return;
			}
			_autoMouseEnabled = value;
			if(_autoMouseEnabled)
			{
				super.mouseChildren = enabled ? _explicitMouseChildren : false;
				super.mouseEnabled = enabled ? _explicitMouseEnabled : false;
			}
			else
			{
				super.mouseChildren = _explicitMouseChildren;
				super.mouseEnabled = _explicitMouseEnabled;
			}
		}
		public function get autoMouseEnabled():Boolean
		{
			return _autoMouseEnabled;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set mouseChildren(value:Boolean):void
		{
			if(this.enabled)
			{
				super.mouseChildren = value;
			}
			_explicitMouseChildren = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set mouseEnabled(value:Boolean):void
		{
			if(this.enabled)
			{
				super.mouseEnabled = value;
			}
			_explicitMouseEnabled = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void
		{
			if(super.enabled == value)
			{
				return;
			}
			super.enabled = value;
			if(_autoMouseEnabled)
			{
				super.mouseChildren = value ? _explicitMouseChildren : false;
				super.mouseEnabled = value ? _explicitMouseEnabled : false;
			}
			this.invalidateSkinState();
		}
		
		/**
		 * 返回组件当前的皮肤状态名称, 子类覆盖此方法定义各种状态名.
		 */
		protected function getCurrentSkinState():String
		{
			return this.enabled ? "normal" : "disabled";
		}
		
		/**
		 * 获取默认的样式名称.
		 */
		protected function get defaultStyleName():String
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set styleName(value:String):void
		{
			_styleName = value;
		}
		public function get styleName():String
		{
			return _styleName;
		}
		
		/**
		 * 标记当前需要重新验证皮肤样式.
		 */
		public function invalidateSkinStyle():void
		{
			if(_styleIsDirty)
			{
				return;
			}
			_styleIsDirty = true;
			this.invalidateProperties();
		}
		
		/**
		 * @inheritDoc
		 */
		public function setStyle(styleProp:String, newValue:*):void
		{
			if(_styleDeclaration == null)
			{
				_styleDeclarationProperties[styleProp] = newValue;
			}
			else
			{
				_styleDeclaration.setStyle(styleProp, newValue);
				this.invalidateSkinStyle();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getStyle(styleProp:String):*
		{
			if(_styleDeclaration == null)
			{
				return _styleDeclarationProperties[styleProp];
			}
			else
			{
				return _styleDeclaration.getStyle(styleProp);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function clearStyle(styleProp:String):*
		{
			var value:*;
			if(_styleDeclaration == null)
			{
				value = _styleDeclarationProperties[styleProp];
				delete _styleDeclarationProperties[styleProp];
			}
			else
			{
				value = _styleDeclaration.clearStyle(styleProp);
				this.invalidateSkinStyle();
			}
			return value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_stateIsDirty)
			{
				_stateIsDirty = false;
				this.validateSkinState();
			}
			if(_styleDeclaration == null)
			{
				createStyle();
				_styleIsDirty = true;
			}
			if(_styleIsDirty && this.skin is ISkin)
			{
				_styleIsDirty = false;
				(this.skin as ISkin).validateCurrentStyle(_styleDeclaration);
			}
		}
		
		private function createStyle():void
		{
			if(this.styleName == null || this.styleName == "")
			{
				this.styleName = this.defaultStyleName;
			}
			if(this.styleName != null && this.styleName != "")
			{
				_styleDeclaration = StyleManager.getStyleDeclaration(this.styleName);
			}
			if(_styleDeclaration == null)
			{
				_styleDeclaration = new StyleDeclaration();
			}
			for(var key:String in _styleDeclarationProperties)
			{
				_styleDeclaration.setStyle(key, _styleDeclarationProperties[key]);
			}
			_styleDeclarationProperties = null;
		}
		
		/**
		 * 设置启用或禁用组件自身的布局.
		 * <p>通常用在当组件的皮肤不是 ISkin 接口, 又需要自己创建子项并布局时.</p>
		 */
		hammerc_internal function set skinLayoutEnabled(value:Boolean):void
		{
			var hasLayout:Boolean = (_layout != null);
			if(hasLayout == value)
			{
				return;
			}
			if(value)
			{
				_layout = new SkinLayout();
				_layout.target = this;
			}
			else
			{
				_layout.target = null;
				_layout = null;
			}
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function childXYChanged():void
		{
			if(_layout != null)
			{
				this.invalidateSize();
				this.invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			if(_layout != null)
			{
				_layout.measure();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_layout != null)
			{
				_layout.updateDisplayList(unscaledWidth, unscaledHeight);
			}
		}
	}
}
