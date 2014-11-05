// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.core
{
	/**
	 * <code>IViewport</code> 接口为支持视区的组件接口.
	 * @author wizardc
	 */
	public interface IViewport extends IUIComponent
	{
		/**
		 * 视域的内容的宽度.
		 */
		function get contentWidth():Number;
		
		/**
		 * 视域的内容的高度.
		 */
		function get contentHeight():Number;
		
		/**
		 * 可视区域水平方向起始点.
		 */
		function set horizontalScrollPosition(value:Number):void;
		function get horizontalScrollPosition():Number;
		
		/**
		 * 可视区域竖直方向起始点.
		 */
		function set verticalScrollPosition(value:Number):void;
		function get verticalScrollPosition():Number;
		
		/**
		 * 返回要添加到视域的当前 horizontalScrollPosition 的数量, 以按请求的滚动单位进行滚动.
		 * @param navigationUnit 要滚动的数量.
		 * @return 滚动的单位.
		 */
		function getHorizontalScrollPositionDelta(navigationUnit:uint):Number;
		
		/**
		 * 返回要添加到视域的当前 verticalScrollPosition 的数量, 以按请求的滚动单位进行滚动.
		 * @param navigationUnit 要滚动的数量.
		 * @return 滚动的单位.
		 */
		function getVerticalScrollPositionDelta(navigationUnit:uint):Number;
		
		/**
		 * 设置或获取超出可视区域的子对象是否隐藏.
		 */
		function set clipAndEnableScrolling(value:Boolean):void;
		function get clipAndEnableScrolling():Boolean;
	}
}
