// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.display
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import org.hammerc.display.IRepaint;
	import org.hammerc.managers.RepaintManager;
	
	/**
	 * <code>CheckerboardShape</code> 类定义了显示类似于棋盘图像的显示对象.
	 * @author wizardc
	 */
	public class CheckerboardShape extends Shape implements IRepaint
	{
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		/**
		 * 记录图像的宽度.
		 */
		protected var _width:Number = 0;
		
		/**
		 * 记录图像的高度.
		 */
		protected var _height:Number = 0;
		
		/**
		 * 记录第一种颜色.
		 */
		protected var _color1:uint = 0xdddddd;
		
		/**
		 * 记录第二种颜色.
		 */
		protected var _color2:uint = 0xffffff;
		
		/**
		 * 记录棋盘小格子的宽度.
		 */
		protected var _sizeX:Number = 8;
		
		/**
		 * 记录棋盘小格子的高度.
		 */
		protected var _sizeY:Number = 8;
		
		/**
		 * 创建一个 <code>CheckerboardShape</code> 对象.
		 */
		public function CheckerboardShape()
		{
			RepaintManager.getInstance().register(this);
		}
		
		/**
		 * 设置或获取该对象的宽度.
		 */
		override public function set width(value:Number):void
		{
			if(_width != value)
			{
				_width = value;
				this.callRedraw();
			}
		}
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * 设置或获取该对象的高度.
		 */
		override public function set height(value:Number):void
		{
			if(_height != value)
			{
				_height = value;
				this.callRedraw();
			}
		}
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * 设置或获取第一种颜色.
		 */
		public function set color1(value:uint):void
		{
			if(_color1 != value)
			{
				_color1 = value;
				this.callRedraw();
			}
		}
		public function get color1():uint
		{
			return _color1;
		}
		
		/**
		 * 设置或获取第二种颜色.
		 */
		public function set color2(value:uint):void
		{
			if(_color2 != value)
			{
				_color2 = value;
				this.callRedraw();
			}
		}
		public function get color2():uint
		{
			return _color2;
		}
		
		/**
		 * 设置或获取棋盘小格子的宽度.
		 */
		public function set sizeX(value:Number):void
		{
			if(_sizeX != value)
			{
				_sizeX = value;
				this.callRedraw();
			}
		}
		public function get sizeX():Number
		{
			return _sizeX;
		}
		
		/**
		 * 设置或获取棋盘小格子的高度.
		 */
		public function set sizeY(value:Number):void
		{
			if(_sizeY != value)
			{
				_sizeY = value;
				this.callRedraw();
			}
		}
		public function get sizeY():Number
		{
			return _sizeY;
		}
		
		/**
		 * 侦听下次显示列表的绘制.
		 */
		protected function callRedraw():void
		{
			_changed = true;
			RepaintManager.getInstance().callRepaint(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function repaint():void
		{
			if(_changed)
			{
				this.redraw();
				_changed = false;
			}
		}
		
		/**
		 * 绘制棋盘图像.
		 */
		protected function redraw():void
		{
			this.graphics.clear();
			if(_width > 0 && _height > 0 && _sizeX > 0 && _sizeY > 0)
			{
				//创建棋盘位图
				var bitmapData:BitmapData = new BitmapData(2, 2, false, _color2);
				bitmapData.setPixel(0, 0, _color1);
				bitmapData.setPixel(1, 1, _color1);
				//填充整个区域
				var matrix:Matrix = new Matrix();
				matrix.scale(_sizeX, _sizeY);
				this.graphics.beginBitmapFill(bitmapData, matrix);
				this.graphics.drawRect(0, 0, _width, _height);
				this.graphics.endFill();
			}
		}
	}
}
