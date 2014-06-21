/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.themes.hi
{
	import flash.filters.DropShadowFilter;
	
	import org.hammerc.core.hammerc_internal;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>Style</code> 类提供了 Hi 主题的多种样式.
	 * @author wizardc
	 */
	public class Style
	{
		/**
		 * 使用明亮的样式.
		 */
		public static function useLightStyle():void
		{
			HiSkin._textOverFilter = [new DropShadowFilter(1, 270, 0, 0.3, 1, 1)];
			HiSkin._borderColors = [0xD4D4D4, 0x518CC6, 0x686868];
			HiSkin._bottomLineColors = [0xBCBCBC, 0x2A65A0, 0x656565];
			HiSkin._cornerRadius = 3;
			HiSkin._fillColors = [0xFAFAFA, 0xEAEAEA, 0x589ADB, 0x3173B4, 0x777777, 0x9B9B9B];
			HiSkin._themeColors = [0x333333, 0xFFFFFF, 0x000000];
			HiSkin._otherColors = [0xe4e4e4, 0xf9f9f9, 0x787878, 0xa4a4a4, 0xf6f8f8, 0xe9eeee, 0xdddddd, 0xeeeeee, 0xcccccc, 0x555555, 0xcccccc, 0x666666, 0x333333];
		}
		
		/**
		 * 使用灰暗的样式.
		 */
		public static function useDarkStyle():void
		{
			HiSkin._textOverFilter = [new DropShadowFilter(1, 270, 0, 0.3, 1, 1)];
			HiSkin._borderColors = [0xBBBBBB, 0x666666, 0x686868];
			HiSkin._bottomLineColors = [0xBBBBBB, 0x393939, 0x656565];
			HiSkin._cornerRadius = 3;
			HiSkin._fillColors = [0xCCCCCC, 0xBBBBBB, 0x666666, 0x393939, 0x777777, 0x777777];
			HiSkin._themeColors = [0x222222, 0xCCCCCC, 0xCCCCCC];
			HiSkin._otherColors = [0xCCCCCC, 0x999999, 0x888888, 0x666666, 0x666666, 0x999999, 0x888888, 0x999999, 0xcccccc, 0x555555, 0xcccccc, 0x666666, 0x333333];
		}
	}
}
