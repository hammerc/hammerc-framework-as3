/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.hammerc.extender.OpaqueInteractiveExtender;
	
	/**
	 * <code>OpaqueInteractiveSprite</code> 类提供支持位图不透明部分鼠标交互的功能扩展.
	 * <p>比如向该对象添加了一个或多个带有透明通道的图片后, 鼠标仅对不透明图像部分进行交互. 如果该对象内部是矢量图形则使用本对象无意义.</p>
	 * @author wizardc
	 */
	public class OpaqueInteractiveSprite extends Sprite
	{
		/**
		 * 支持位图不透明部分鼠标交互的扩展对象.
		 */
		protected var _opaqueInteractiveExtender:OpaqueInteractiveExtender;
		
		/**
		 * 记录当前鼠标指向的点是否可以当做透明处理.
		 */
		protected var _transparent:Boolean = false;
		
		/**
		 * 记录此对象是否接收鼠标消息.
		 */
		protected var _mouseEnabled:Boolean = true;
		
		/**
		 * 创建一个 <code>OpaqueInteractiveSprite</code> 对象.
		 * @param threshold 透明度的阀值.
		 */
		public function OpaqueInteractiveSprite(threshold:int = 127)
		{
			_opaqueInteractiveExtender = new OpaqueInteractiveExtender(this, threshold);
			this.addMouseEventListener();
		}
		
		/**
		 * 设置或获取此对象是否接收鼠标消息.
		 */
		override public function set mouseEnabled(value:Boolean):void
		{
			_mouseEnabled = value;
			if(_mouseEnabled)
			{
				this.addMouseEventListener();
				super.mouseEnabled = true;
			}
			else
			{
				this.removeMouseEventListener();
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				super.mouseEnabled = false;
			}
		}
		override public function get mouseEnabled():Boolean
		{
			return _mouseEnabled;
		}
		
		/**
		 * 设置或获取透明度的阀值, 像素点的透明度小于等于该值则该点不进行交互, 有效范围 [0~255].
		 */
		public function set threshold(value:int):void
		{
			_opaqueInteractiveExtender.threshold = value;
		}
		public function get threshold():int
		{
			return _opaqueInteractiveExtender.threshold;
		}
		
		/**
		 * 将本对象的图像渲染到一个位图数据中, 用来进行像素级的碰撞检测.
		 * <p>如果本对象的内部元素发生了改动则应立即调用本方法更新数据.</p>
		 */
		public function randerOpaqueArea():void
		{
			var bounds:Rectangle = this.getBounds(this);
			if(!bounds.isEmpty())
			{
				var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
				var matrix:Matrix = new Matrix();
				matrix.translate(-bounds.left, -bounds.top);
				bitmapData.draw(this, matrix);
				_opaqueInteractiveExtender.bitmapData = bitmapData;
			}
			else
			{
				_opaqueInteractiveExtender.bitmapData = null;
			}
		}
		
		/**
		 * 添加鼠标移动时的事件侦听.
		 */
		protected function addMouseEventListener():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler, false, int.MAX_VALUE, false);
			this.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler, false, int.MAX_VALUE, false);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler, false, int.MAX_VALUE, false);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler, false, int.MAX_VALUE, false);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler, false, int.MAX_VALUE, false);
		}
		
		private function mouseEventHandler(event:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, int.MAX_VALUE, false);
			enterFrameHandler();
			//如果当前指向点是透明的则截断事件流
			if(_transparent)
			{
				event.stopImmediatePropagation();
			}
		}
		
		/**
		 * 移除鼠标移动时的事件侦听.
		 */
		protected function removeMouseEventListener():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			this.removeEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
		}
		
		private function enterFrameHandler(event:Event = null):void
		{
			var bounds:Rectangle = this.getBounds(this);
			_transparent = _opaqueInteractiveExtender.checkPoint(this.mouseX - bounds.left, this.mouseY - bounds.top);
			if(_transparent)
			{
				super.mouseEnabled = false;
			}
			else
			{
				super.mouseEnabled = true;
				/*
				 * 在碰到不透明的像素后才移除事件侦听, 此时所有事件由 Flash 自己管理;
				 * 事件移除必须放在此处, 如果在接收到鼠标移入事件时就移除所有事件, 会
				 * 导致鼠标移入透明区域时播放部分事件导致出错.
				 */
				this.removeMouseEventListener();
			}
			//如果鼠标离开了本对象就移除进入帧事件
			if(!bounds.contains(this.mouseX, this.mouseY))
			{
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				super.mouseEnabled = true;
				this.addMouseEventListener();
			}
		}
		
		/**
		 * 添加一个子显示对象.
		 * @param child 要添加的子显示对象.
		 * @return 添加的子显示对象.
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var temp:DisplayObject = super.addChild(child);
			this.randerOpaqueArea();
			return temp;
		}
		
		/**
		 * 添加一个子显示对象到指定的索引.
		 * @param child 要添加的子显示对象.
		 * @param index 指定的索引.
		 * @return 添加的子显示对象.
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var temp:DisplayObject = super.addChildAt(child, index);
			this.randerOpaqueArea();
			return temp;
		}
		
		/**
		 * 移除一个子显示对象.
		 * @param child 要移除的子显示对象.
		 * @return 移除的子显示对象.
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var temp:DisplayObject = super.removeChild(child);
			this.randerOpaqueArea();
			return temp;
		}
		
		/**
		 * 移除指定索引上的子显示对象.
		 * @param index 要移除的指定索引.
		 * @return 移除的子显示对象.
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			var temp:DisplayObject = super.removeChildAt(index);
			this.randerOpaqueArea();
			return temp;
		}
		
		/**
		 * 移除指定索引区域内的所有子显示对象.
		 * @param beginIndex 开始的索引.
		 * @param endIndex 结束的索引.
		 */
		override public function removeChildren(beginIndex:int = 0, endIndex:int = 0x7fffffff):void
		{
			super.removeChildren(beginIndex, endIndex);
			this.randerOpaqueArea();
		}
	}
}
