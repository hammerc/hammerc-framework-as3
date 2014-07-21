/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.rect
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.display.IRepaint;
	import org.hammerc.managers.RepaintManager;
	
	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * <code>TriangleEditor</code> 类定义了一个三角形区域编辑类.
	 * @author wizardc
	 */
	public class TriangleEditor extends Sprite implements IRepaint
	{
		private static const DEFAULT_STYLE:Object = {
			anchorSize : 5, 
			anchorColor : 0x00AEFF, 
			anchorAlpha : 1, 
			lineColor : 0x00AEFF, 
			lineAlpha : 1, 
			fillColor : 0x00AEFF, 
			fillAlpha : 0.3
		};
		
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		private var _enabled:Boolean = true;
		
		private var _point1:Point;
		private var _point2:Point;
		private var _point3:Point;
		
		private var _useInteger:Boolean;
		private var _shapeScale:Number;
		private var _style:Object;
		
		private var _dragIndex:int;
		private var _beginX:Number;
		private var _beginY:Number;
		private var _beginPoint1:Point;
		private var _beginPoint2:Point;
		private var _beginPoint3:Point;
		
		/**
		 * 交互对象列表.
		 */
		protected var _interactionList:Vector.<Sprite>;
		
		/**
		 * 创建一个 <code>TriangleEditor</code> 对象.
		 * @param useInteger 拖拽时是否使用整数.
		 * @param shapeScale 样式缩放系数.
		 * @param style 样式描述对象.
		 */
		public function TriangleEditor(useInteger:Boolean = false, shapeScale:Number = 1, style:Object = null)
		{
			RepaintManager.getInstance().register(this);
			_point1 = new Point(0, 0);
			_point2 = new Point(10, 0);
			_point3 = new Point(0, 10);
			_useInteger = useInteger;
			this.shapeScale = shapeScale;
			_interactionList = new Vector.<Sprite>(4, true);
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
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set y(value:Number):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
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
		 * 设置或获取第一个点的位置.
		 */
		public function set point1(value:Point):void
		{
			if(_point1.x != value.x || _point1.y != value.y)
			{
				_point1.x = _useInteger ? Math.ceil(value.x) : value.x;
				_point1.y = _useInteger ? Math.ceil(value.y) : value.y;
				this.callRedraw();
			}
		}
		public function get point1():Point
		{
			return _point1;
		}
		
		/**
		 * 设置或获取第二个点的位置.
		 */
		public function set point2(value:Point):void
		{
			if(_point2.x != value.x || _point2.y != value.y)
			{
				_point2.x = _useInteger ? Math.ceil(value.x) : value.x;
				_point2.y = _useInteger ? Math.ceil(value.y) : value.y;
				this.callRedraw();
			}
		}
		public function get point2():Point
		{
			return _point2;
		}
		
		/**
		 * 设置或获取第三个点的位置.
		 */
		public function set point3(value:Point):void
		{
			if(_point3.x != value.x || _point3.y != value.y)
			{
				_point3.x = _useInteger ? Math.ceil(value.x) : value.x;
				_point3.y = _useInteger ? Math.ceil(value.y) : value.y;
				this.callRedraw();
			}
		}
		public function get point3():Point
		{
			return _point3;
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
			_interactionList[0] = new Sprite();
			this.addChild(_interactionList[0]);
			for(var i:int = 1; i <= 3; i++)
			{
				_interactionList[i] = new Sprite();
				drawShape(_interactionList[i].graphics, this.style.anchorSize, this.style.anchorColor, this.style.anchorAlpha);
				this.addChild(_interactionList[i]);
			}
		}
		
		private function drawShape(graphics:Graphics, size:int, color:uint, alpha:Number):void
		{
			graphics.beginFill(color, alpha);
			graphics.drawRect(-size / 2, -size / 2, size, size);
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
				_beginPoint1 = _point1.clone();
				_beginPoint2 = _point2.clone();
				_beginPoint3 = _point3.clone();
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			}
		}
		
		private function stageMouseMoveHandler(event:MouseEvent):void
		{
			var dist:Point = new Point(this.parent.mouseX - _beginX, this.parent.mouseY - _beginY);
			switch(_dragIndex)
			{
				case 0:
					this.point1 = _beginPoint1.add(dist);
					this.point2 = _beginPoint2.add(dist);
					this.point3 = _beginPoint3.add(dist);
					break;
				case 1:
					this.point1 = _beginPoint1.add(dist);
					break;
				case 2:
					this.point2 = _beginPoint2.add(dist);
					break;
				case 3:
					this.point3 = _beginPoint3.add(dist);
					break;
			}
			this.dispatchEvent(new Event(Event.CHANGE, true));
			event.updateAfterEvent();
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
		 * 绘制图像.
		 */
		protected function redraw():void
		{
			_interactionList[0].graphics.clear();
			_interactionList[0].graphics.lineStyle(0, this.style.lineColor, this.style.lineAlpha);
			_interactionList[0].graphics.beginFill(this.style.fillColor, this.style.fillAlpha);
			_interactionList[0].graphics.moveTo(_point1.x, _point1.y);
			_interactionList[0].graphics.lineTo(_point2.x, _point2.y);
			_interactionList[0].graphics.lineTo(_point3.x, _point3.y);
			_interactionList[0].graphics.lineTo(_point1.x, _point1.y);
			_interactionList[0].graphics.endFill();
			_interactionList[1].x = _point1.x;
			_interactionList[1].y = _point1.y;
			_interactionList[1].scaleX = _shapeScale;
			_interactionList[1].scaleY = _shapeScale;
			_interactionList[2].x = _point2.x;
			_interactionList[2].y = _point2.y;
			_interactionList[2].scaleX = _shapeScale;
			_interactionList[2].scaleY = _shapeScale;
			_interactionList[3].x = _point3.x;
			_interactionList[3].y = _point3.y;
			_interactionList[3].scaleX = _shapeScale;
			_interactionList[3].scaleY = _shapeScale;
		}
	}
}
