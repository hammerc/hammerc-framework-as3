/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.rect
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.hammerc.display.IRepaint;
	import org.hammerc.managers.RepaintManager;
	import org.hammerc.utils.DisplayUtil;
	
	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * <code>RectangleEditor</code> 类定义了一个矩形区域编辑类.
	 * @author wizardc
	 */
	public class RectangleEditor extends Sprite implements IRepaint
	{
		private static const DEFAULT_STYLE:Object = {
			anchorSize:5, 
			anchorColor:0x00AEFF, 
			anchorAlpha:1, 
			lineColor:0x00AEFF, 
			lineAlpha:1, 
			fillColor:0x00AEFF, 
			fillAlpha:0.3
		};
		
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		private var _width:Number = 10;
		private var _height:Number = 10;
		
		private var _content:DisplayObject;
		private var _scaleContent:Boolean = true;
		
		private var _enabled:Boolean = true;
		
		private var _useInteger:Boolean;
		private var _shapeScale:Number;
		private var _style:Object;
		
		private var _dragIndex:int;
		private var _beginX:Number;
		private var _beginY:Number;
		private var _beginRect:Rectangle;
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		/**
		 * 交互区域列表.
		 */
		protected var _interactionList:Vector.<Sprite>;
		
		/**
		 * 区域绘制对象.
		 */
		protected var _rectShape:Shape;
		
		/**
		 * 锚点绘制对象列表.
		 */
		protected var _anchorShapeList:Vector.<Shape>;
		
		/**
		 * 创建一个 <code>RectangleEditor</code> 对象.
		 * @param useInteger 拖拽时是否使用整数.
		 * @param shapeScale 样式缩放系数.
		 * @param style 样式描述对象.
		 */
		public function RectangleEditor(useInteger:Boolean = false, shapeScale:Number = 1, style:Object = null)
		{
			RepaintManager.getInstance().register(this);
			_useInteger = useInteger;
			this.shapeScale = shapeScale;
			_interactionList = new Vector.<Sprite>(9, true);
			_anchorShapeList = new Vector.<Shape>(8, true);
			_style = new Object();
			for(var key:String in DEFAULT_STYLE)
			{
				if(style != null && style.hasOwnProperty(key))
				{
					_style[key] = style[key];
				}
				else
				{
					_style[key] = DEFAULT_STYLE[key];
				}
			}
			this.createShapes();
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set x(value:Number):void
		{
			super.x = _useInteger ? Math.ceil(value) : value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set y(value:Number):void
		{
			super.y = _useInteger ? Math.ceil(value) : value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if(_width != value)
			{
				_width = _useInteger ? Math.ceil(value) : value;
				if(_content != null && _scaleContent)
				{
					_content.width = this.width;
				}
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
				_height = _useInteger ? Math.ceil(value) : value;
				if(_content != null && _scaleContent)
				{
					_content.height = this.height;
				}
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
		override public function set scaleX(value:Number):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleY(value:Number):void
		{
		}
		
		/**
		 * 设置或获取显示内容对象.
		 */
		public function set content(value:DisplayObject):void
		{
			if(_content != value)
			{
				if(_content != null)
				{
					this.removeChild(_content);
				}
				_content = value;
				if(_content != null)
				{
					this.addChildAt(_content, 0);
					if(_scaleContent)
					{
						_content.width = this.width;
						_content.height = this.height;
					}
				}
			}
		}
		public function get content():DisplayObject
		{
			return _content;
		}
		
		/**
		 * 设置或获取是否按比例缩放内容对象.
		 */
		public function set scaleContent(value:Boolean):void
		{
			if(_scaleContent != value)
			{
				_scaleContent = value;
				if(_content != null && _scaleContent)
				{
					_content.width = this.width;
					_content.height = this.height;
				}
			}
		}
		public function get scaleContent():Boolean
		{
			return _scaleContent;
		}
		
		/**
		 * 设置或获取是否启用该对象.
		 */
		public function set enabled(value:Boolean):void
		{
			if(_enabled != value)
			{
				_enabled = value;
				this.mouseEnabled = _enabled;
				this.mouseChildren = _enabled;
			}
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * 获取拖拽时是否使用整数.
		 */
		public function get useInteger():Boolean
		{
			return _useInteger;
		}
		
		/**
		 * 设置或获取样式缩放系数.
		 */
		public function set shapeScale(value:Number):void
		{
			if(_shapeScale != value)
			{
				_shapeScale = value;
				this.callRedraw();
			}
		}
		public function get shapeScale():Number
		{
			return _shapeScale;
		}
		
		/**
		 * 获取样式描述对象.
		 */
		public function get style():Object
		{
			return _style;
		}
		
		/**
		 * 创建所有绘制对象.
		 */
		protected function createShapes():void
		{
			var i:int;
			var size:int = this.style.anchorSize;
			_rectShape = new Shape();
			drawShape(_rectShape.graphics, size, this.style.fillColor, this.style.fillAlpha, false, true, this.style.lineColor, this.style.lineAlpha);
			this.addChild(_rectShape);
			for(i = 0; i < 8; i++)
			{
				_anchorShapeList[i] = new Shape();
				drawShape(_anchorShapeList[i].graphics, size, this.style.anchorColor, this.style.anchorAlpha, true);
				this.addChild(_anchorShapeList[i]);
			}
			for(i = 0; i < 9; i++)
			{
				_interactionList[i] = new Sprite();
				drawShape(_interactionList[i].graphics, size, 0x000000, 0, true);
				this.addChild(_interactionList[i]);
			}
			DisplayUtil.toTop(_interactionList[1]);
			DisplayUtil.toTop(_interactionList[3]);
			DisplayUtil.toTop(_interactionList[6]);
			DisplayUtil.toTop(_interactionList[8]);
		}
		
		private function drawShape(graphics:Graphics, size:int, color:uint, alpha:Number, center:Boolean = false, drawLine:Boolean = false, lineColor:uint = 0, lineAlpha:Number = NaN):void
		{
			if(drawLine)
			{
				graphics.lineStyle(0, lineColor, lineAlpha);
			}
			graphics.beginFill(color, alpha);
			if(center)
			{
				graphics.drawRect(-size / 2, -size / 2, size, size);
			}
			else
			{
				graphics.drawRect(0, 0, size, size);
			}
			graphics.endFill();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			var target:Sprite = event.target as Sprite;
			var index:int = _interactionList.indexOf(target);
			if(target != null && index != -1)
			{
				_dragIndex = index;
				_beginX = this.parent.mouseX;
				_beginY = this.parent.mouseY;
				_beginRect = new Rectangle(this.x, this.y, this.width, this.height);
				_offsetX = this.x - _beginX;
				_offsetY = this.y - _beginY;
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			}
		}
		
		private function stageMouseMoveHandler(event:MouseEvent):void
		{
			var distX:Number = this.parent.mouseX - _beginX;
			var distY:Number = this.parent.mouseY - _beginY;
			switch(_dragIndex)
			{
				case 0:
					this.x = _offsetX + _beginX + distX;
					this.y = _offsetY + _beginY + distY;
					break;
				case 1:
					dragTop(distY);
					dragLeft(distX);
					break;
				case 2:
					dragTop(distY);
					break;
				case 3:
					dragTop(distY);
					dragRight(distX);
					break;
				case 4:
					dragLeft(distX);
					break;
				case 5:
					dragRight(distX);
					break;
				case 6:
					dragBottom(distY);
					dragLeft(distX);
					break;
				case 7:
					dragBottom(distY);
					break;
				case 8:
					dragBottom(distY);
					dragRight(distX);
					break;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
			event.updateAfterEvent();
		}
		
		private function dragTop(dist:Number):void
		{
			var ty:Number = _beginRect.y + dist;
			if(_useInteger)
			{
				ty = Math.ceil(ty);
			}
			if(ty <= _beginRect.bottom)
			{
				this.y = ty;
			}
			else
			{
				this.y = _beginRect.bottom;
			}
			this.height = Math.abs(_beginRect.bottom - ty);
		}
		
		private function dragLeft(dist:Number):void
		{
			var tx:Number = _beginRect.x + dist;
			if(_useInteger)
			{
				tx = Math.ceil(tx);
			}
			if(tx <= _beginRect.right)
			{
				this.x = tx;
			}
			else
			{
				this.x = _beginRect.right;
			}
			this.width = Math.abs(_beginRect.right - tx);
		}
		
		private function dragBottom(dist:Number):void
		{
			var tHeight:Number = _beginRect.height + dist;
			if(_useInteger)
			{
				tHeight = Math.ceil(tHeight);
			}
			if(tHeight >= 0)
			{
				this.y = _beginRect.y;
				this.height = tHeight;
			}
			else
			{
				this.y = _beginRect.y + tHeight;
				this.height = -tHeight;
			}
		}
		
		private function dragRight(dist:Number):void
		{
			var tWidth:Number = _beginRect.width + dist;
			if(_useInteger)
			{
				tWidth = Math.ceil(tWidth);
			}
			if(tWidth >= 0)
			{
				this.x = _beginRect.x;
				this.width = tWidth;
			}
			else
			{
				this.x = _beginRect.x + tWidth;
				this.width = -tWidth;
			}
		}
		
		private function stageMouseUpHandler(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
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
			adjustShape();
			adjustInteraction();
		}
		
		private function adjustShape():void
		{
			for each(var shape:Shape in _anchorShapeList)
			{
				shape.scaleX = _shapeScale;
				shape.scaleY = _shapeScale;
			}
			_rectShape.width = this.width;
			_rectShape.height = this.height;
			var halfWidth:Number = this.width / 2;
			var halfHeight:Number = this.height / 2;
			_anchorShapeList[1].x = halfWidth;
			_anchorShapeList[2].x = this.width;
			_anchorShapeList[3].y = halfHeight;
			_anchorShapeList[4].x = this.width;
			_anchorShapeList[4].y = halfHeight;
			_anchorShapeList[5].y = this.height;
			_anchorShapeList[6].x = halfWidth;
			_anchorShapeList[6].y = this.height;
			_anchorShapeList[7].x = this.width;
			_anchorShapeList[7].y = this.height;
		}
		
		private function adjustInteraction():void
		{
			for(var i:int = 1; i < 9; i++)
			{
				var sprite:Sprite = _interactionList[i];
				sprite.scaleX = _shapeScale;
				sprite.scaleY = _shapeScale;
			}
			var halfWidth:Number = this.width / 2;
			var halfHeight:Number = this.height / 2;
			_interactionList[0].x = halfWidth;
			_interactionList[0].y = halfHeight;
			_interactionList[0].width = this.width;
			_interactionList[0].height = this.height;
			_interactionList[2].x = halfWidth;
			_interactionList[2].width = this.width;
			_interactionList[3].x = this.width;
			_interactionList[4].y = halfHeight;
			_interactionList[4].height = this.height;
			_interactionList[5].x = this.width;
			_interactionList[5].y = halfHeight;
			_interactionList[5].height = this.height;
			_interactionList[6].y = this.height;
			_interactionList[7].x = halfWidth;
			_interactionList[7].y = this.height;
			_interactionList[7].width = this.height;
			_interactionList[8].x = this.width;
			_interactionList[8].y = this.height;
		}
	}
}
