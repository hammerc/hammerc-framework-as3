/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.wing
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * <code>WingEffectUtil</code> 类为 Wing 主题提供显示特效的工具类.
	 * @author wizardc
	 */
	public class WingEffectUtil
	{
		private static var _grayFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		
		/**
		 * 添加灰度滤镜.
		 * @param target 目标对象.
		 */
		public static function setGray(target:DisplayObject):void
		{
			if(!hasGray(target))
			{
				var filters:Array = target.filters;
				filters.push(_grayFilter);
				target.filters = filters;
			}
		}
		
		/**
		 * 判断对象是否已经使用了灰度滤镜.
		 * @param target 目标对象.
		 * @return 目标对象是否已经使用了灰度滤镜.
		 */
		public static function hasGray(target:DisplayObject):Boolean
		{
			for each(var item:Object in target.filters)
			{
				if(item is ColorMatrixFilter)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 移除灰度滤镜.
		 * @param target 目标对象.
		 */
		public static function clearGray(target:DisplayObject):void
		{
			if(hasGray(target))
			{
				var filters:Array = target.filters;
				for(var i:int = 0; i < filters.length; i++)
				{
					if(filters[i] is ColorMatrixFilter)
					{
						filters.splice(i, 1);
						break;
					}
				}
				target.filters = filters;
			}
		}
		
		/**
		 * 添加文本描边.
		 * @param target 目标对象.
		 * @param color 描边颜色.
		 */
		public static function setTextGlow(target:DisplayObject, color:uint = 0x000000):void
		{
			if(!hasTextGlow(target))
			{
				var filters:Array = target.filters;
				filters.push(new GlowFilter(color, 1, 2, 2, 6));
				target.filters = filters;
			}
		}
		
		/**
		 * 判断对象是否已经使用了文本描边.
		 * @param target 目标对象.
		 * @return 目标对象是否已经使用了文本描边.
		 */
		public static function hasTextGlow(target:DisplayObject):Boolean
		{
			for each(var item:Object in target.filters)
			{
				if(item is GlowFilter)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 移除文本描边.
		 * @param target 目标对象.
		 */
		public static function clearTextGlow(target:DisplayObject):void
		{
			if(hasTextGlow(target))
			{
				var filters:Array = target.filters;
				for(var i:int = 0; i < filters.length; i++)
				{
					if(filters[i] is GlowFilter)
					{
						filters.splice(i, 1);
						break;
					}
				}
				target.filters = filters;
			}
		}
	}
}
