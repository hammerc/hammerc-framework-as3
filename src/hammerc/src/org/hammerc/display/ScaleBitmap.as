/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.hammerc.managers.RepaintManager;
	
	/**
	 * <code>ScaleBitmap</code> 类支持位图九切片显示.
	 * @author wizardc
	 */
	public class ScaleBitmap extends Bitmap implements IRepaint
	{
		/**
		 * 位图的宽度.
		 */
		protected var _width:Number = 0;
		
		/**
		 * 位图的高度.
		 */
		protected var _height:Number = 0;
		
		/**
		 * 记录当前使用的绘制模式.
		 */
		protected var _drawMode:int;
		
		/**
		 * 记录原始的位图.
		 */
		protected var _originalBitmapData:BitmapData;
		
		/**
		 * 记录九切片的数据.
		 */
		protected var _scale9Grid:Rectangle;
		
		/**
		 * 记录是否使用延时渲染.
		 */
		protected var _useDelay:Boolean;
		
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		/**
		 * 创建一个 <code>ScaleBitmap</code> 对象.
		 * @param bitmapData 要显示的位图数据对象.
		 * @param scale9Grid 九切片的数据.
		 * @param drawMode 绘制模式.
		 * @param pixelSnapping 对象是否贴紧至最近的像素.
		 * @param smoothing 在缩放时是否对位图进行平滑处理.
		 * @param useDelay 是否使用延时渲染.
		 */
		public function ScaleBitmap(bitmapData:BitmapData = null, scale9Grid:Rectangle = null, drawMode:int = 3, pixelSnapping:String = "auto", smoothing:Boolean = false, useDelay:Boolean = true)
		{
			super(bitmapData, pixelSnapping, smoothing);
			RepaintManager.getInstance().register(this);
			_originalBitmapData = bitmapData;
			this.scale9Grid = scale9Grid;
			this.drawMode = drawMode;
			this.useDelay = useDelay;
		}
		
		/**
		 * 设置或获取当前显示的位图对象.
		 */
		override public function set bitmapData(value:BitmapData):void
		{
			if(value == null)
			{
				_originalBitmapData = null;
				_width = 0;
				_height = 0;
				if(super.bitmapData)
				{
					super.bitmapData.dispose();
				}
				super.bitmapData = null;
			}
			else if(_originalBitmapData != value)
			{
				_originalBitmapData = value;
				_width = value.width;
				_height = value.height;
				this.callRedraw();
			}
		}
		override public function get bitmapData():BitmapData
		{
			return _originalBitmapData;
		}
		
		/**
		 * 获取当前显示被拉伸后的位图数据.
		 */
		public function get currentBitmapData():BitmapData
		{
			return super.bitmapData;
		}
		
		/**
		 * 设置或获取位图的宽度.
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
		 * 设置或获取位图的高度.
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
		 * 设置或获取九切片的数据.
		 */
		override public function set scale9Grid(value:Rectangle):void
		{
			if(	_scale9Grid == value || 
				(_scale9Grid != null && value != null && _scale9Grid.equals(value)) || 
				(value != null && _originalBitmapData != null && value.right > _originalBitmapData.width) || 
				(value != null && _originalBitmapData != null && value.bottom > _originalBitmapData.height))
			{
				return;
			}
			if(value == null)
			{
				_scale9Grid = null;
			}
			else
			{
				_scale9Grid = value.clone();
			}
			this.callRedraw();
		}
		override public function get scale9Grid():Rectangle
		{
			if(_scale9Grid != null)
			{
				return _scale9Grid.clone();
			}
			return null;
		}
		
		/**
		 * 设置或获取绘制模式.
		 */
		public function set drawMode(value:int):void
		{
			if(value < 0 || value > 4)
			{
				value = ScaleBitmapDrawMode.SCALE_9_GRID;
			}
			if(_drawMode != value)
			{
				_drawMode = value;
				this.callRedraw();
			}
		}
		public function get drawMode():int
		{
			return _drawMode;
		}
		
		/**
		 * 设置或获取是否使用延时渲染.
		 */
		public function set useDelay(value:Boolean):void
		{
			if(_useDelay != value)
			{
				_useDelay = value;
			}
		}
		public function get useDelay():Boolean
		{
			return _useDelay;
		}
		
		/**
		 * 侦听下次显示列表的绘制.
		 */
		protected function callRedraw():void
		{
			if(_useDelay)
			{
				_changed = true;
				RepaintManager.getInstance().callRepaint(this);
			}
			else
			{
				this.drawBitmap();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function repaint():void
		{
			if(_changed)
			{
				this.drawBitmap();
				_changed = false;
			}
		}
		
		/**
		 * 根据设定绘制位图并进行显示.
		 */
		protected function drawBitmap():void
		{
			//源图片不存在或者宽度高度小于 1 时则不绘制
			if(_originalBitmapData == null || _width < 1 || _height < 1)
			{
				return;
			}
			//创建位图数据
			var bitmapData:BitmapData = new BitmapData(_width, _height, true, 0x00000000);
			var matrix:Matrix = new Matrix();
			var originW:Number = _originalBitmapData.width, originH:Number = _originalBitmapData.height;
			var repeatW:int, repeatH:int;
			var i:int, j:int;
			//在九切片为空且在需要九切片对象的绘制模式下将绘制模式改为拉伸绘制
			var drawMode:int = _drawMode;
			if(_scale9Grid == null && (drawMode == ScaleBitmapDrawMode.SCALE_9_GRID || drawMode == ScaleBitmapDrawMode.TILE_SCALE_9_GRID))
			{
				drawMode = ScaleBitmapDrawMode.NORMAL;
			}
			//根据绘制方式分别处理
			switch(drawMode)
			{
				case ScaleBitmapDrawMode.NONE:
					bitmapData.draw(_originalBitmapData, null, null, null, null, smoothing);
					break;
				case ScaleBitmapDrawMode.NORMAL:
					matrix.a = _width / originW;
					matrix.d = _height / originH;
					bitmapData.draw(_originalBitmapData, matrix, null, null, null, smoothing);
					break;
				case ScaleBitmapDrawMode.TILE:
					repeatW = Math.ceil(_width / originW);
					repeatH = Math.ceil(_height / originH);
					for(i = 0; i < repeatW; i++)
					{
						for(j = 0; j < repeatH; j++)
						{
							matrix.tx = i * originW;
							matrix.ty = j * originH;
							bitmapData.draw(_originalBitmapData, matrix, null, null, null, smoothing);
						}
					}
					break;
				case ScaleBitmapDrawMode.SCALE_9_GRID:
				case ScaleBitmapDrawMode.TILE_SCALE_9_GRID:
					var tileRect:Rectangle;
					var m:int, n:int;
					var oRow:Array = new Array(0, _scale9Grid.top, _scale9Grid.bottom, originH);
					var oCol:Array = new Array(0, _scale9Grid.left, _scale9Grid.right, originW);
					var dRow:Array = new Array(0, _scale9Grid.top, _height - (originH - _scale9Grid.bottom), _height);
					var dCol:Array = new Array(0, _scale9Grid.left, _width - (originW - _scale9Grid.right), _width);
					var origin:Rectangle;										//源位图的区域
					var draw:Rectangle;											//需要绘制的区域
					for(i = 0; i < 3; i++)
					{
						for(j = 0; j < 3; j++)
						{
							origin = new Rectangle(oCol[i], oRow[j], oCol[i + 1] - oCol[i], oRow[j + 1] - oRow[j]);
							draw = new Rectangle(dCol[i], dRow[j], dCol[i + 1] - dCol[i], dRow[j + 1] - dRow[j]);
							matrix.identity();									//矩阵重置
							if(_drawMode == ScaleBitmapDrawMode.SCALE_9_GRID)
							{
								matrix.a = draw.width / origin.width;
								matrix.d = draw.height / origin.height;
								matrix.tx = draw.x - origin.x * matrix.a;
								matrix.ty = draw.y - origin.y * matrix.d;
								bitmapData.draw(_originalBitmapData, matrix, null, null, draw, smoothing);
							}
							else
							{
								//在该区域内横向需要重复绘制几次
								repeatW = Math.ceil(draw.width / origin.width);
								//在该区域内纵向需要重复绘制几次
								repeatH = Math.ceil(draw.height / origin.height);
								for(m = 0; m < repeatW; m++)
								{
									for(n = 0; n < repeatH; n++)
									{
										//计算原图需要移动的距离, 相对于 bitmap 对象
										matrix.tx = (draw.left - origin.left) + m * origin.width;
										matrix.ty = (draw.top - origin.top) + n * origin.height;
										//计算裁剪区域需要移动的距离, 注意该区域不是相对于原图而是相对于 bitmap 对象
										tileRect = origin.clone();
										tileRect.x += matrix.tx;
										tileRect.y += matrix.ty;
										//重复绘制时如果超出区域需要缩小裁剪区域
										if(draw.width < (m + 1) * origin.width)
										{
											tileRect.width = draw.width - m * origin.width;
										}
										if(draw.height < (n + 1) * origin.height)
										{
											tileRect.height = draw.height - n * origin.height;
										}
										bitmapData.draw(_originalBitmapData, matrix, null, null, tileRect, smoothing);
									}
								}
							}
						}
					}
					break;
			}
			//更新显示的对象
			if(super.bitmapData)
			{
				super.bitmapData.dispose();
			}
			super.bitmapData = bitmapData;
		}
	}
}
