// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.skins
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * <code>DefaultSkinAdapter</code> 类实现了默认的皮肤适配器.
	 * @author wizardc
	 */
	public class DefaultSkinAdapter implements ISkinAdapter
	{
		/**
		 * 创建一个 <code>DefaultSkinAdapter</code> 对象.
		 */
		public function DefaultSkinAdapter()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getSkin(skinName:Object, compFunc:Function, oldSkin:DisplayObject = null):void
		{
			if(skinName is Class)
			{
				compFunc(new skinName(), skinName);
			}
			else if(skinName is String || skinName is ByteArray)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event):void
				{
					compFunc(skinName, skinName);
				});
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					if(loader.content is Bitmap)
					{
						var bitmapData:BitmapData = (loader.content as Bitmap).bitmapData;
						compFunc(new Bitmap(bitmapData, PixelSnapping.AUTO, true), skinName);
					}
					else
					{
						compFunc(loader.content, skinName);
					}
				});
				if(skinName is String)
				{
					loader.load(new URLRequest(skinName as String));
				}
				else
				{
					loader.loadBytes(skinName as ByteArray);
				}
			}
			else if(skinName is BitmapData)
			{
				var skin:Bitmap;
				if(oldSkin is Bitmap)
				{
					skin = oldSkin as Bitmap;
					skin.bitmapData = skinName as BitmapData;
				}
				else
				{
					skin = new Bitmap(skinName as BitmapData, PixelSnapping.AUTO, true);
				}
				compFunc(skin, skinName);
			}
			else
			{
				compFunc(skinName, skinName);
			}
		}
	}
}
