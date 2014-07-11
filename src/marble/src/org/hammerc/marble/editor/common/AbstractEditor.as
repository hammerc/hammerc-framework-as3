/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.common
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.display.IRepaint;
	import org.hammerc.managers.RepaintManager;
	import org.hammerc.marble.display.CheckerboardShape;
	
	/**
	 * <code>AbstractEditor</code> 类定义了一个抽象编辑类.
	 * @author wizardc
	 */
	public class AbstractEditor extends Sprite implements IRepaint
	{
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		/**
		 * 遮罩对象.
		 */
		protected var _mask:Shape;
		
		/**
		 * 记录编辑器的宽度.
		 */
		protected var _width:Number = 200;
		
		/**
		 * 记录编辑器的高度.
		 */
		protected var _height:Number = 200;
		
		/**
		 * 记录编辑区域原点相对于本对象的 x 轴坐标.
		 */
		protected var _originX:Number = 0;
		
		/**
		 * 记录编辑区域原点相对于本对象的 y 轴坐标.
		 */
		protected var _originY:Number = 0;
		
		/**
		 * 记录编辑区域的缩放系数.
		 */
		protected var _scale:Number = 1;
		
		/**
		 * 记录当前是否正在拖动.
		 */
		protected var _moving:Boolean = false;
		
		/**
		 * 记录拖动的 x 轴坐标.
		 */
		protected var _moveX:Number = 0;
		
		/**
		 * 记录拖动的 y 轴坐标.
		 */
		protected var _moveY:Number = 0;
		
		/**
		 * 记录背景色.
		 */
		protected var _backgroundColor:uint = 0xc8c8c8;
		
		/**
		 * 记录画布的类型.
		 */
		protected var _canvasType:int = CanvasType.PURE_COLOR;
		
		/**
		 * 记录画布的颜色.
		 */
		protected var _canvasColor:uint = 0xffffff;
		
		/**
		 * 显示背景底色的对象.
		 */
		protected var _background:Shape;
		
		/**
		 * 显示画布的对象.
		 */
		protected var _canvas:Sprite;
		
		/**
		 * 显示棋盘格子对象.
		 */
		protected var _checkerboardShape:CheckerboardShape;
		
		/**
		 * 容纳所有添加到编辑器的需要编辑的对象.
		 */
		protected var _container:Sprite;
		
		/**
		 * <code>AbstractEditor</code> 类为抽象类, 不能被实例化.
		 */
		public function AbstractEditor()
		{
			AbstractEnforcer.enforceConstructor(this, AbstractEditor);
			RepaintManager.getInstance().register(this);
			//创建遮罩
			_mask = new Shape();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0, 0, 1, 1);
			_mask.graphics.endFill();
			this.addChild(_mask);
			this.mask = _mask;
			//创建各种层对象
			_background = new Shape();
			this.addChild(_background);
			_canvas = new Sprite();
			_canvas.mouseEnabled = _canvas.mouseChildren = false;
			this.addChild(_canvas);
			_checkerboardShape = new CheckerboardShape();
			_canvas.addChild(_checkerboardShape);
			_container = new Sprite();
			this.addChild(_container);
			//调用初始化方法
			this.init();
		}
		
		/**
		 * 初始化时会调用该方法.
		 */
		protected function init():void
		{
		}
		
		/**
		 * 设置或获取本对象宽度.
		 */
		override public function set width(value:Number):void
		{
			if(_width != value)
			{
				_width = value;
				this.sizeChanged();
				this.callRedraw();
			}
		}
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * 设置或获取本对象高度.
		 */
		override public function set height(value:Number):void
		{
			if(_height != value)
			{
				_height = value;
				this.sizeChanged();
				this.callRedraw();
			}
		}
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * 尺寸改变时调用该方法.
		 */
		protected function sizeChanged():void
		{
		}
		
		/**
		 * 设置或获取编辑区域原点相对于本对象的 x 轴坐标.
		 */
		public function set originX(value:Number):void
		{
			if(_originX != value)
			{
				_originX = value;
				this.originMoved();
			}
		}
		public function get originX():Number
		{
			return _originX;
		}
		
		/**
		 * 设置或获取编辑区域原点相对于本对象的 y 轴坐标.
		 */
		public function set originY(value:Number):void
		{
			if(_originY != value)
			{
				_originY = value;
				this.originMoved();
			}
		}
		public function get originY():Number
		{
			return _originY;
		}
		
		/**
		 * 设置或获取编辑区域的缩放系数.
		 */
		public function set scale(value:Number):void
		{
			if(value < .01 && value > 32 && _scale == value)
			{
				return;
			}
			//记录变化的范围
			var range:Number = value / _scale;
			//修正原点坐标
			if(this.originX < 0)
			{
				this.originX *= range;
			}
			if(this.originY < 0)
			{
				this.originY *= range;
			}
			//设置缩放系数
			_scale = value;
			this.callRedraw();
		}
		public function get scale():Number
		{
			return _scale;
		}
		
		/**
		 * 设置或获取背景色.
		 */
		public function set backgroundColor(value:uint):void
		{
			if(_backgroundColor != value)
			{
				_backgroundColor = value;
				this.callRedraw();
			}
		}
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		/**
		 * 设置或获取画布的类型.
		 */
		public function set canvasType(value:int):void
		{
			if(_canvasType != value)
			{
				_canvasType = value;
				this.callRedraw();
			}
		}
		public function get canvasType():int
		{
			return _canvasType;
		}
		
		/**
		 * 设置或获取画布的颜色.
		 */
		public function set canvasColor(value:uint):void
		{
			if(_canvasColor != value)
			{
				_canvasColor = value;
				this.callRedraw();
			}
		}
		public function get canvasColor():uint
		{
			return _canvasColor;
		}
		
		/**
		 * 移动编辑器.
		 */
		protected function moveBegin():void
		{
			_moving = true;
			_moveX = this.mouseX;
			_moveY = this.mouseY;
		}
		
		/**
		 * 移动中调用.
		 */
		protected function doMoving():void
		{
			if(_moving)
			{
				var dx:int = this.mouseX - _moveX;
				var dy:int = this.mouseY - _moveY;
				_originX += dx;
				_originY += dy;
				this.originMoved();
				_moveX = this.mouseX;
				_moveY = this.mouseY;
			}
		}
		
		/**
		 * 结束移动编辑器.
		 */
		protected function moveEnd():void
		{
			_moving = false;
			_moveX = 0;
			_moveY = 0;
		}
		
		/**
		 * 内部的画布移动时调用该方法.
		 */
		protected function originMoved():void
		{
			_container.x = _originX;
			_container.y = _originY;
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
		 * 绘制编辑器.
		 */
		protected function redraw():void
		{
			//遮罩
			_mask.width = _width;
			_mask.height = _height;
			//绘制背景
			_background.graphics.clear();
			_background.graphics.beginFill(_backgroundColor);
			_background.graphics.drawRect(0, 0, _width, _height);
			_background.graphics.endFill();
			//容器
			_container.scaleX = this.scale;
			_container.scaleY = this.scale;
		}
	}
}
