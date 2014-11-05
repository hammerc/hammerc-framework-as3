// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components
{
	import flash.display.Graphics;
	
	import org.hammerc.core.UIComponent;
	import org.hammerc.utils.GraphicsUtil;
	
	/**
	 * <code>Rect</code> 类实现了矩形绘图元素.
	 * @author wizardc
	 */
	public class Rect extends UIComponent
	{
		private var _fillColor:uint = 0xffffff;
		private var _fillAlpha:Number = 1;
		
		private var _strokeColor:uint = 0x444444;
		private var _strokeAlpha:Number = 1;
		private var _strokeWeight:Number = 1;
		
		private var _radius:Number = 0;
		
		private var _topLeftRadius:Number = 0;
		private var _topRightRadius:Number = 0;
		private var _bottomLeftRadius:Number = 0;
		private var _bottomRightRadius:Number = 0;
		
		/**
		 * 创建一个 <code>Rect</code> 对象.
		 */
		public function Rect()
		{
			super();
		}
		
		/**
		 * 设置或获取填充颜色.
		 */
		public function set fillColor(value:uint):void
		{
			if(_fillColor != value)
			{
				_fillColor = value;
				this.invalidateDisplayList();
			}
		}
		public function get fillColor():uint
		{
			return _fillColor;
		}
		
		/**
		 * 设置或获取填充透明度.
		 */
		public function set fillAlpha(value:Number):void
		{
			if(_fillAlpha != value)
			{
				_fillAlpha = value;
				this.invalidateDisplayList();
			}
		}
		public function get fillAlpha():Number
		{
			return _fillAlpha;
		}
		
		/**
		 * 设置或获取边框颜色.
		 */
		public function set strokeColor(value:uint):void
		{
			if(_strokeColor != value)
			{
				_strokeColor = value;
				this.invalidateDisplayList();
			}
		}
		public function get strokeColor():uint
		{
			return _strokeColor;
		}
		
		/**
		 * 设置或获取边框透明度.
		 */
		public function set strokeAlpha(value:Number):void
		{
			if(_strokeAlpha != value)
			{
				_strokeAlpha = value;
				this.invalidateDisplayList();
			}
		}
		public function get strokeAlpha():Number
		{
			return _strokeAlpha;
		}
		
		/**
		 * 设置或获取边框粗细.
		 */
		public function set strokeWeight(value:Number):void
		{
			if(_strokeWeight != value)
			{
				_strokeWeight = value;
				this.invalidateDisplayList();
			}
		}
		public function get strokeWeight():Number
		{
			return _strokeWeight;
		}
		
		/**
		 * 设置或获取四个角的为相同的圆角半径.
		 * <p>但若此属性不为 0, 则分别设置每个角的半径无效.</p>
		 */
		public function set radius(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			if(_radius != value)
			{
				_radius = value;
				this.invalidateDisplayList();
			}
		}
		public function get radius():Number
		{
			return _radius;
		}
		
		/**
		 * 设置或获取左上角圆角半径.
		 */
		public function set topLeftRadius(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			if(_topLeftRadius != value)
			{
				_topLeftRadius = value;
				this.invalidateDisplayList();
			}
		}
		public function get topLeftRadius():Number
		{
			return _topLeftRadius;
		}
		
		/**
		 * 设置或获取右上角圆角半径.
		 */
		public function set topRightRadius(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			if(_topRightRadius != value)
			{
				_topRightRadius = value;
				this.invalidateDisplayList();
			}
		}
		public function get topRightRadius():Number
		{
			return _topRightRadius;
		}
		
		/**
		 * 设置或获取左下角圆角半径.
		 */
		public function set bottomLeftRadius(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			if(_bottomLeftRadius != value)
			{
				_bottomLeftRadius = value;
				this.invalidateDisplayList();
			}
		}
		public function get bottomLeftRadius():Number
		{
			return _bottomLeftRadius;
		}
		
		/**
		 * 设置或获取右下角圆角半径.
		 */
		public function set bottomRightRadius(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			if(_bottomRightRadius != value)
			{
				_bottomRightRadius = value;
				this.invalidateDisplayList();
			}
		}
		public function get bottomRightRadius():Number
		{
			return _bottomRightRadius;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function measure():void
		{
			super.measure();
			this.measuredWidth = 50;
			this.measuredHeight = 50;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledWidth);
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(_fillColor, _fillAlpha);
			if(_strokeAlpha > 0)
			{
				g.lineStyle(_strokeWeight, _strokeColor, _strokeAlpha, true, "normal", "square", "miter");
			}
			if(_radius > 0)
			{
				var ellipseSize:Number = _radius * 2;
				g.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, ellipseSize, ellipseSize);
			}
			else if(_topLeftRadius > 0 || _topRightRadius > 0 || _bottomLeftRadius > 0 || _bottomRightRadius > 0)
			{
				GraphicsUtil.drawRoundRectComplex(g, 0, 0, unscaledWidth, unscaledHeight, _topLeftRadius, _topRightRadius, _bottomLeftRadius, _bottomRightRadius);
			}
			else
			{
				g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			}
			g.endFill();
		}
	}
}
