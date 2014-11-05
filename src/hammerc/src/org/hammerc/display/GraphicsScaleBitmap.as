// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.display
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.hammerc.managers.RepaintManager;
	
	/**
	 * <code>GraphicsScaleBitmap</code> 类支持位图九切片显示, 提供和 <code>ScaleBitmap</code> 类一致的功能但是本类占用内存更小, 实际运用时应该更多的考虑使用本类.
	 * <p>与 <code>ScaleBitmap</code> 类的创建新位图不同, <code>GraphicsScaleBitmap</code> 类使用矢量填充来实现位图九切片, 因此更加节省内存.</p>
	 * @author wizardc
	 */
	public class GraphicsScaleBitmap extends Shape implements IScaleBitmap
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
		protected var _bitmapData:BitmapData;
		
		/**
		 * 记录九切片的数据.
		 */
		protected var _scale9Grid:Rectangle;
		
		/**
		 * 记录是否对位图进行平滑处理.
		 */
		protected var _smoothing:Boolean;
		
		/**
		 * 记录是否使用延时渲染.
		 */
		protected var _useDelay:Boolean;
		
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		/**
		 * 创建一个 <code>GraphicsScaleBitmap</code> 对象.
		 * @param bitmapData 要显示的位图数据对象.
		 * @param scale9Grid 九切片的数据.
		 * @param drawMode 绘制模式.
		 * @param smoothing 在缩放时是否对位图进行平滑处理.
		 * @param useDelay 是否使用延时渲染.
		 */
		public function GraphicsScaleBitmap(bitmapData:BitmapData = null, scale9Grid:Rectangle = null, drawMode:int = 3, smoothing:Boolean = false, useDelay:Boolean = true)
		{
			RepaintManager.getInstance().register(this);
			this.bitmapData = bitmapData;
			this.scale9Grid = scale9Grid;
			this.drawMode = drawMode;
			this.smoothing = smoothing;
			this.useDelay = useDelay;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bitmapData(value:BitmapData):void
		{
			if(_bitmapData != value)
			{
				_bitmapData = value;
				if(_bitmapData != null)
				{
					_width = _bitmapData.width;
					_height = _bitmapData.height;
				}
				else
				{
					_width = 0;
					_height = 0;
				}
				this.callRedraw();
			}
		}
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		/**
		 * @inheritDoc
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
		 * @inheritDoc
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
		 * @inheritDoc
		 */
		override public function set scale9Grid(value:Rectangle):void
		{
			if(	_scale9Grid == value || 
				(_scale9Grid != null && value != null && _scale9Grid.equals(value)) || 
				(value != null && _bitmapData != null && value.right > _bitmapData.width) || 
				(value != null && _bitmapData != null && value.bottom > _bitmapData.height))
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
		 * @inheritDoc
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
		 * 设置或获取在缩放时是否对位图进行平滑处理.
		 */
		public function set smoothing(value:Boolean):void
		{
			if(_smoothing != value)
			{
				_smoothing = value;
				this.callRedraw();
			}
		}
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		/**
		 * @inheritDoc
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
		 * @inheritDoc
		 */
		public function drawBitmap():void
		{
			this.graphics.clear();
			//存在源图片同时宽度高度有效时绘制
			if(_bitmapData != null && _width > 0 && _height > 1)
			{
				var matrix:Matrix = new Matrix();
				var originW:Number = _bitmapData.width, originH:Number = _bitmapData.height;
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
						this.graphics.beginBitmapFill(_bitmapData, null, false, _smoothing);
						this.graphics.drawRect(0, 0, Math.min(originW, _width), Math.min(originH, _height));
						this.graphics.endFill();
						break;
					case ScaleBitmapDrawMode.NORMAL:
						matrix.scale(_width / originW, _height / originH);
						this.graphics.beginBitmapFill(_bitmapData, matrix, false, _smoothing);
						this.graphics.drawRect(0, 0, _width, _height);
						this.graphics.endFill();
						break;
					case ScaleBitmapDrawMode.TILE:
						this.graphics.beginBitmapFill(_bitmapData, null, true, _smoothing);
						this.graphics.drawRect(0, 0, _width, _height);
						this.graphics.endFill();
						break;
					case ScaleBitmapDrawMode.SCALE_9_GRID:
					case ScaleBitmapDrawMode.TILE_SCALE_9_GRID:
						var tileRect:Rectangle;
						var m:int, n:int;
						var oRow:Array = new Array(0, _scale9Grid.top, _scale9Grid.bottom, originH);
						var oCol:Array = new Array(0, _scale9Grid.left, _scale9Grid.right, originW);
						var dRow:Array = new Array(0, _scale9Grid.top, _height - (originH - _scale9Grid.bottom), _height);
						var dCol:Array = new Array(0, _scale9Grid.left, _width - (originW - _scale9Grid.right), _width);
						var origin:Rectangle;									//源位图的区域
						var draw:Rectangle;										//需要绘制的区域
						for(i = 0; i < 3; i++)
						{
							for(j = 0; j < 3; j++)
							{
								origin = new Rectangle(oCol[i], oRow[j], oCol[i + 1] - oCol[i], oRow[j + 1] - oRow[j]);
								draw = new Rectangle(dCol[i], dRow[j], dCol[i + 1] - dCol[i], dRow[j + 1] - dRow[j]);
								matrix.identity();								//矩阵重置
								if(_drawMode == ScaleBitmapDrawMode.SCALE_9_GRID)
								{
									matrix.a = draw.width / origin.width;
									matrix.d = draw.height / origin.height;
									matrix.tx = draw.x - origin.x * matrix.a;
									matrix.ty = draw.y - origin.y * matrix.d;
									this.graphics.beginBitmapFill(_bitmapData, matrix, false, _smoothing);
									this.graphics.drawRect(draw.x, draw.y, draw.width, draw.height);
									this.graphics.endFill();
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
											this.graphics.beginBitmapFill(_bitmapData, matrix, false, _smoothing);
											this.graphics.drawRect(tileRect.x, tileRect.y, tileRect.width, tileRect.height);
											this.graphics.endFill();
										}
									}
								}
							}
						}
						break;
				}
			}
		}
	}
}
