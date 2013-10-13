/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import org.hammerc.core.IInvalidating;
	import org.hammerc.core.ILayoutElement;
	import org.hammerc.core.Injector;
	import org.hammerc.core.UIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.UIEvent;
	import org.hammerc.skins.DefaultSkinAdapter;
	import org.hammerc.skins.ISkinAdapter;
	import org.hammerc.skins.ISkinnableClient;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.UIEvent.SKIN_CHANGED
	 */
	[Event(name="skinChanged", type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>UIAsset</code> 类实现了简单的可设置皮肤的组件, 解析后的皮肤对象会被直接添加到自身.
	 * <p>内部鼠标事件被屏蔽.</p>
	 * @author wizardc
	 */
	public class UIAsset extends UIComponent implements ISkinnableClient
	{
		/**
		 * 记录全局的皮肤解析适配器.
		 */
		private static var skinAdapter:ISkinAdapter;
		
		/**
		 * 是否外部显式设置了皮肤名.
		 */
		hammerc_internal var _skinNameExplicitlySet:Boolean = false;
		
		/**
		 * 皮肤名.
		 */
		hammerc_internal var _skinName:Object;
		
		/**
		 * 皮肤显示对象.
		 */
		hammerc_internal var _skin:DisplayObject;
		
		private var _skinNameChanged:Boolean = false;
		private var _scaleSkin:Boolean = true;
		
		/**
		 * 创建一个 <code>UIAsset</code> 对象.
		 */
		public function UIAsset()
		{
			super();
			this.mouseChildren = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set skinName(value:Object):void
		{
			if(_skinName == value)
			{
				return;
			}
			_skinName = value;
			_skinNameExplicitlySet = true;
			if(this.initialized || this.hasParent)
			{
				_skinNameChanged = false;
				parseSkinName();
			}
			else
			{
				_skinNameChanged = true;
			}
		}
		public function get skinName():Object
		{
			return _skinName;
		}
		
		/**
		 * 获取当前皮肤显示对象实例.
		 */
		public function get skin():DisplayObject
		{
			return _skin;
		}
		
		/**
		 * 解析皮肤名称.
		 */
		private function parseSkinName():void
		{
			if(skinAdapter == null)
			{
				try
				{
					skinAdapter = Injector.getInstance(ISkinAdapter);
				}
				catch(error:Error)
				{
					skinAdapter = new DefaultSkinAdapter();
				}
			}
			if(_skinName == null)
			{
				skinChnaged(null, _skinName);
			}
			else
			{
				skinAdapter.getSkin(_skinName, skinChnaged, _skin);
			}
		}
		
		/**
		 * 皮肤名称解析完毕时回调的方法.
		 * @param skin 解析后的皮肤对象.
		 * @param skinName 皮肤名称.
		 */
		private function skinChnaged(skin:Object, skinName:Object):void
		{
			if(skinName !== _skinName)
			{
				return;
			}
			onGetSkin(skin, skinName);
			if(this.hasEventListener(UIEvent.SKIN_CHANGED))
			{
				this.dispatchEvent(new UIEvent(UIEvent.SKIN_CHANGED));
			}
		}
		
		/**
		 * 皮肤适配器解析皮肤名称后回调函数.
		 * @param skin 皮肤显示对象.
		 * @param skinName 皮肤名称.
		 */
		protected function onGetSkin(skin:Object, skinName:Object):void
		{
			if(_skin !== skin)
			{
				if(_skin != null && _skin.parent == this)
				{
					super.removeChild(_skin);
				}
				_skin = skin as DisplayObject;
				if(_skin != null)
				{
					super.addChildAt(_skin, 0);
				}
			}
			this.invalidateSize();
			this.invalidateDisplayList();
			if(this.stage != null)
			{
				this.validateNow();
			}
		}
		
		/**
		 * 设置或获取是否让皮肤跟随组件尺寸缩放.
		 */
		public function set scaleSkin(value:Boolean):void
		{
			if(_scaleSkin != value)
			{
				_scaleSkin = value;
				//取消之前的强制布局
				if(!_scaleSkin && _skin != null && _skin is ILayoutElement)
				{
					(_skin as ILayoutElement).setLayoutBoundsSize(NaN, NaN);
				}
			}
		}
		public function get scaleSkin():Boolean
		{
			return _scaleSkin;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			if(_skinNameChanged)
			{
				_skinNameChanged = false;
				parseSkinName();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			if(_skin == null)
			{
				return;
			}
			if(_skin is ILayoutElement)
			{
				if(!(_skin as ILayoutElement).includeInLayout)
				{
					return;
				}
				this.measuredWidth = (_skin as ILayoutElement).preferredWidth;
				this.measuredHeight = (_skin as ILayoutElement).preferredHeight;
			}
			else if(_skin is TextField)
			{
				this.measuredWidth = (_skin as TextField).textWidth + 5;
				this.measuredHeight = (_skin as TextField).textHeight + 4;
			}
			else
			{
				var oldScaleX:Number = _skin.scaleX;
				var oldScaleY:Number = _skin.scaleY;
				_skin.scaleX = 1;
				_skin.scaleY = 1;
				this.measuredWidth = _skin.width;
				this.measuredHeight = _skin.height;
				_skin.scaleX = oldScaleX;
				_skin.scaleY = oldScaleY;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_scaleSkin && _skin != null)
			{
				if(_skin is ILayoutElement)
				{
					if((_skin as ILayoutElement).includeInLayout)
					{
						(_skin as ILayoutElement).setLayoutBoundsSize(unscaledWidth, unscaledHeight);
					}
				}
				else
				{
					_skin.width = unscaledWidth;
					_skin.height = unscaledHeight;
					if(_skin is IInvalidating)
					{
						IInvalidating(_skin).validateNow();
					}
				}
			}
		}
		
		/**
		 * 添加对象到显示列表.
		 * @param child 要添加的显示对象.
		 * @return 添加的对象.
		 */
		final hammerc_internal function addToDisplayList(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		/**
		 * 添加对象到显示列表.
		 * @param child 要添加的显示对象.
		 * @param index 要添加的深度索引.
		 * @return 添加的对象.
		 */
		final hammerc_internal function addToDisplayListAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child,index);
		}
		
		/**
		 * 从显示列表移除对象.
		 * @param child 要添加的显示对象.
		 * @return 移除的对象.
		 */
		final hammerc_internal function removeFromDisplayList(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		
		[Deprecated]
		override public function addChild(child:DisplayObject):DisplayObject
		{
			throw new Error("addChild()在组件中不可用!");
		}
		
		[Deprecated]
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			throw new Error("addChildAt()在组件中不可用!");
		}
		
		[Deprecated]
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			throw new Error("removeChild()在组件中不可用!");
		}
		
		[Deprecated]
		override public function removeChildAt(index:int):DisplayObject
		{
			throw new Error("removeChildAt()在组件中不可用！");
		}
		
		[Deprecated]
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			throw new Error("setChildIndex()在组件中不可用！");
		}
		
		[Deprecated]
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			throw new Error("swapChildren()在组件中不可用！");
		}
		
		[Deprecated]
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			throw new Error("swapChildrenAt()在组件中不可用！");
		}
	}
}
