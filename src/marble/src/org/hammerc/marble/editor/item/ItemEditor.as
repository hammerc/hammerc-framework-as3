// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.item
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.hammerc.display.IRepaint;
	import org.hammerc.managers.RepaintManager;
	
	/**
	 * @eventType flash.events.Event.CHANGE
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * <code>ItemEditor</code> 类定义了一个物件编辑类.
	 * <p>支持拖拽, 绘制内容尺寸区域, 编辑注册点和百分比缩放.</p>
	 * @author wizardc
	 */
	public class ItemEditor extends Sprite implements IRepaint
	{
		private static const DEFAULT_STYLE:Object = {
			pivot : 0x00AEFF, 
			pivotAlpha : 1, 
			showRect : true, 
			lineColor : 0x00AEFF, 
			lineAlpha : 1, 
			fillColor : 0x00AEFF, 
			fillAlpha : 0.3
		};
		
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		private var _container:Sprite;
		
		private var _content:DisplayObject;
		
		private var _enabled:Boolean = true;
		private var _selected:Boolean = false;
		private var _pivotX:Number = 0;
		private var _pivotY:Number = 0;
		
		private var _useInteger:Boolean;
		private var _shapeScale:Number;
		private var _style:Object;
		
		private var _isDragPivot:Boolean;
		private var _beginX:Number;
		private var _beginY:Number;
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		/**
		 * 注册点对象.
		 */
		protected var _pivot:Sprite;
		
		/**
		 * 创建一个 <code>ItemEditor</code> 对象.
		 * @param useInteger 拖拽时是否使用整数.
		 * @param shapeScale 样式缩放系数.
		 * @param showPivot 是否显示注册点.
		 * @param style 样式描述对象.
		 */
		public function ItemEditor(useInteger:Boolean = false, shapeScale:Number = 1, showPivot:Boolean = true, style:Object = null)
		{
			RepaintManager.getInstance().register(this);
			_useInteger = useInteger;
			this.shapeScale = shapeScale;
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
			_container = new Sprite();
			_container.mouseChildren = false;
			this.addChild(_container);
			this.createPivot(showPivot);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_pivot.addEventListener(MouseEvent.MOUSE_DOWN, pivotMouseDownHandler);
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
			if(_container.scaleX != value)
			{
				_container.scaleX = value;
				this.callRedraw();
			}
		}
		override public function get scaleX():Number
		{
			return _container.scaleX;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleY(value:Number):void
		{
			if(_container.scaleY != value)
			{
				_container.scaleY = value;
				this.callRedraw();
			}
		}
		override public function get scaleY():Number
		{
			return _container.scaleY;
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
		 * 设置或获取显示内容对象.
		 */
		public function set content(value:DisplayObject):void
		{
			if(_content != value)
			{
				if(_content != null)
				{
					_container.removeChild(_content);
				}
				_content = value;
				if(_content != null)
				{
					_content.x = -_pivotX;
					_content.y = -_pivotY;
					_container.addChild(_content);
				}
				this.callRedraw();
			}
		}
		public function get content():DisplayObject
		{
			return _content;
		}
		
		/**
		 * 设置或获取当前是否选中本对象.
		 */
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				this.callRedraw();
			}
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 * 设置或获取注册点的 x 轴坐标.
		 */
		public function set pivotX(value:Number):void
		{
			var newValue:Number = _useInteger ? Math.ceil(value) : value;
			if(_pivotX != newValue)
			{
				var dist:Number = newValue - _pivotX;
				this.x += dist * this.scaleX;
				_pivot.x = 0;
				_pivotX = newValue;
				if(_content != null)
				{
					_content.x = -_pivotX;
				}
				this.callRedraw();
			}
		}
		public function get pivotX():Number
		{
			return _pivotX;
		}
		
		/**
		 * 设置或获取注册点的 y 轴坐标.
		 */
		public function set pivotY(value:Number):void
		{
			var newValue:Number = _useInteger ? Math.ceil(value) : value;
			if(_pivotY != newValue)
			{
				var dist:Number = newValue - _pivotY;
				this.y += dist * this.scaleY;
				_pivot.y = 0;
				_pivotY = newValue;
				if(_content != null)
				{
					_content.y = -_pivotY;
				}
				this.callRedraw();
			}
		}
		public function get pivotY():Number
		{
			return _pivotY;
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
		 * 设置或获取是否要显示注册点.
		 */
		public function set showPivot(value:Boolean):void
		{
			_pivot.visible = value;
		}
		public function get showPivot():Boolean
		{
			return _pivot.visible;
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
		 * @param showPivot 是否显示注册点.
		 */
		protected function createPivot(showPivot:Boolean):void
		{
			_pivot = new Sprite();
			if(this.style.pivot is Number)
			{
				_pivot.graphics.beginFill(this.style.pivot);
				_pivot.graphics.drawRect(-2, -2, 5, 5);
				_pivot.graphics.endFill();
			}
			else if(this.style.pivot is BitmapData)
			{
				var bitmapData:BitmapData = this.style.pivot as BitmapData;
				var tx:int = -Math.floor(bitmapData.width / 2);
				var ty:int = -Math.floor(bitmapData.height / 2);
				var matrix:Matrix = new Matrix();
				matrix.translate(tx, ty);
				_pivot.graphics.beginBitmapFill(bitmapData, matrix);
				_pivot.graphics.drawRect(tx, ty, bitmapData.width, bitmapData.height);
				_pivot.graphics.endFill();
			}
			else
			{
				throw new Error("样式\"pivot\"设置错误！");
			}
			_pivot.alpha = this.style.pivotAlpha;
			_pivot.visible = showPivot;
			this.addChild(_pivot);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			if(event.target != _pivot)
			{
				_isDragPivot = false;
				_beginX = this.parent.mouseX;
				_beginY = this.parent.mouseY;
				_offsetX = this.x - _beginX;
				_offsetY = this.y - _beginY;
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			}
		}
		
		private function pivotMouseDownHandler(event:MouseEvent):void
		{
			_isDragPivot = true;
			_beginX = this.mouseX;
			_beginY = this.mouseY;
			_offsetX = _pivot.x - _beginX;
			_offsetY = _pivot.y - _beginY;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}
		
		private function stageMouseMoveHandler(event:MouseEvent):void
		{
			var distX:Number, distY:Number;
			if(_isDragPivot)
			{
				distX = this.mouseX - _beginX;
				distY = this.mouseY - _beginY;
				_pivot.x = _offsetX + _beginX + distX;
				_pivot.y = _offsetY + _beginY + distY;
			}
			else
			{
				distX = this.parent.mouseX - _beginX;
				distY = this.parent.mouseY - _beginY;
				this.x = _offsetX + _beginX + distX;
				this.y = _offsetY + _beginY + distY;
				this.dispatchEvent(new Event(Event.CHANGE, true));
			}
			event.updateAfterEvent();
		}
		
		private function stageMouseUpHandler(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			this.pivotX += _pivot.x / this.scaleX;
			this.pivotY += _pivot.y / this.scaleY;
			this.dispatchEvent(new Event(Event.CHANGE, true));
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
			_pivot.scaleX = _shapeScale;
			_pivot.scaleY = _shapeScale;
			this.graphics.clear();
			if(this.style.showRect && this.content != null && this.selected)
			{
				var rect:Rectangle = _container.getRect(this);
				this.graphics.lineStyle(0, this.style.lineColor, this.style.lineAlpha);
				this.graphics.beginFill(this.style.fillColor, this.style.fillAlpha);
				this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				this.graphics.endFill();
			}
		}
	}
}
