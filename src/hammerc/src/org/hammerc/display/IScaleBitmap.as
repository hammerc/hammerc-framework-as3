/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.display
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * <code>IScaleBitmap</code> 接口定义了支持位图九切片显示的对象应有的属性和方法.
	 * @author wizardc
	 */
	public interface IScaleBitmap extends IRepaint
	{
		/**
		 * 设置或获取当前显示的位图对象.
		 */
		function set bitmapData(value:BitmapData):void;
		function get bitmapData():BitmapData;
		
		/**
		 * 设置或获取位图的宽度.
		 */
		function set width(value:Number):void;
		function get width():Number;
		
		/**
		 * 设置或获取位图的高度.
		 */
		function set height(value:Number):void;
		function get height():Number;
		
		/**
		 * 设置或获取九切片的数据.
		 */
		function set scale9Grid(value:Rectangle):void;
		function get scale9Grid():Rectangle;
		
		/**
		 * 设置或获取绘制模式.
		 */
		function set drawMode(value:int):void;
		function get drawMode():int;
		
		/**
		 * 设置或获取是否使用延时渲染.
		 */
		function set useDelay(value:Boolean):void;
		function get useDelay():Boolean;
		
		/**
		 * 根据设定绘制位图并进行显示.
		 */
		function drawBitmap():void;
	}
}
