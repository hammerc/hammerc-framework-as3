/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.hammerc.collections.WeakHashMap;
	import org.hammerc.core.UIComponent;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.display.GraphicsScaleBitmap;
	import org.hammerc.display.IScaleBitmap;
	import org.hammerc.display.ScaleBitmapDrawMode;
	import org.hammerc.skins.SkinBase;
	import org.hammerc.utils.StringUtil;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>WingSkin</code> 类定义了 Wing 主题的皮肤基类.
	 * @author wizardc
	 */
	public class WingSkin extends SkinBase
	{
		/**
		 * 创建的位图是否平滑.
		 */
		public static var smoothing:Boolean = false;
		
		/**
		 * 位图弱引用缓存数据表.
		 */
		hammerc_internal static const bitmapDataCache:WeakHashMap = new WeakHashMap();
		
		/**
		 * 显示对象容器.
		 */
		protected var _container:UIComponent;
		
		/**
		 * 记录是否使用文本发光滤镜.
		 */
		protected var _useTextFilter:Boolean;
		
		/**
		 * 记录文本发光滤镜的颜色.
		 */
		protected var _textFilterColor:uint;
		
		/**
		 * 记录 9 切片数据.
		 */
		protected var _scale9Grid:Rectangle;
		
		/**
		 * 创建一个 <code>WingSkin</code> 对象.
		 */
		public function WingSkin()
		{
			super();
			this.states = ["normal", "disabled"];
			this.styleProperties = ["fontFamily", "fontSize", "fontColor", "fontItalic", "fontBold", "useTextFilter", "textFilterColor", "scale9Grid"];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			_container = new UIComponent();
			this.addElement(_container);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentState():void
		{
			this.invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitCurrentStyle(styleProperty:String, hasSet:Boolean, value:* = null):void
		{
			super.commitCurrentStyle(styleProperty, hasSet, value);
			if(!hasSet)
			{
				return;
			}
			switch(styleProperty)
			{
				case "useTextFilter":
					_useTextFilter = value;
					this.textFilterColorChanged();
					break;
				case "textFilterColor":
					_textFilterColor = value;
					this.textFilterColorChanged();
					break;
				case "scale9Grid":
					_scale9Grid = value;
					this.scale9GridChanged();
					break;
			}
		}
		
		/**
		 * 文本发光滤镜改变时会调用该方法.
		 */
		protected function textFilterColorChanged():void
		{
		}
		
		/**
		 * 9 切片数据改变时会调用该方法.
		 */
		protected function scale9GridChanged():void
		{
		}
		
		/**
		 * 获取皮肤显示对象.
		 * @param skin 皮肤类, 可以是类对象或完全限定类名字符串.
		 * @return 对应的显示对象.
		 */
		protected function getSkinObject(skin:*):DisplayObject
		{
			var className:String;
			if(skin is String)
			{
				className = String(skin);
				skin = getDefinitionByName(className);
			}
			if(skin != null && skin is Class)
			{
				if(className == null)
				{
					className = getQualifiedClassName(skin);
				}
				//需要进行缓存的位图类
				if(StringUtil.endsWith(className, "_c"))
				{
					var bitmapData:BitmapData = bitmapDataCache.get(className);
					if(bitmapData == null)
					{
						bitmapData = new skin() as BitmapData;
						if(bitmapData == null)
						{
							throw new Error("创建的UI资源名称后缀带有\"_c\"的必须是位图类型！");
						}
						bitmapDataCache.put(className, bitmapData);
					}
					return new GraphicsScaleBitmap(bitmapData, null, ScaleBitmapDrawMode.SCALE_9_GRID, smoothing, false);
				}
				else
				{
					var skinObject:* = new skin();
					if(skinObject is DisplayObject)
					{
						return skinObject as DisplayObject;
					}
					else if(skinObject is BitmapData)
					{
						return new Bitmap(skinObject as BitmapData, PixelSnapping.AUTO, smoothing);
					}
				}
			}
			return null;
		}
		
		/**
		 * 获取 9 切片位图显示对象.
		 * @param skin 皮肤类, 可以是类对象或完全限定类名字符串.
		 * @param x 9 切片 x.
		 * @param y 9 切片 y.
		 * @param width 9 切片 width.
		 * @param height 9 切片 height.
		 * @return 对应的显示对象.
		 */
		protected function getScaleBitmap(skin:*, x:Number, y:Number, width:Number, height:Number):DisplayObject
		{
			var display:DisplayObject = this.getSkinObject(skin);
			display.scale9Grid = new Rectangle(x, y, width, height);
			return display;
		}
		
		/**
		 * 如果皮肤对象是 9 切片位图对象则进行绘制.
		 * @param skin 皮肤对象.
		 */
		protected function drawScaleBitmap(skin:Object):void
		{
			if(skin != null && skin is IScaleBitmap)
			{
				(skin as IScaleBitmap).drawBitmap();
			}
		}
	}
}
