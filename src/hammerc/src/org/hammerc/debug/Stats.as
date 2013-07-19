/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.debug
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import org.hammerc.utils.SystemUtil;
	
	/**
	 * <code>Stats</code> 类提供查看当前程序的帧频及内存使用情况的功能.
	 * @author wizardc
	 */
	public final class Stats extends Sprite
	{
		private static const VIEWER_WIDTH:int = 100;
		private static const TEXT_HEIGHT:int = 16;
		private static const DIAGRAM_HEIGHT:int = 50;
		
		private static const BG_COLOR:uint = 0xff000000;
		private static const BG_AlPHA:Number = .6;
		private static const FPS_COLOR:uint = 0xffffffff;
		private static const MEM_COLOR:uint = 0xff00ff00;
		private static const MAX_COLOR:uint = 0xffffff00;
		private static const DIAGRAM_COLOR:uint = 0x20ffffff;
		
		private var _fps:TextField;
		private var _mem:TextField;
		private var _max:TextField;
		private var _diagram:BitmapData;
		
		private var _frameCount:int = 0;
		private var _previousTime:uint = 0;
		
		private var _diagramTime:uint = 0;
		
		/**
		 * 创建一个 <code>Stats</code> 对象.
		 */
		public function Stats()
		{
			this.mouseEnabled = this.mouseChildren = false;
			//绘制背景
			this.graphics.beginFill(BG_COLOR, BG_AlPHA);
			this.graphics.drawRect(0, 0, VIEWER_WIDTH, TEXT_HEIGHT * 3 + DIAGRAM_HEIGHT);
			//创建文本框
			_fps = createTextField(FPS_COLOR, 0);
			this.addChild(_fps);
			_mem = createTextField(MEM_COLOR, TEXT_HEIGHT);
			this.addChild(_mem);
			_max = createTextField(MAX_COLOR, TEXT_HEIGHT * 2);
			this.addChild(_max);
			//创建图表对象
			_diagram = new BitmapData(VIEWER_WIDTH, DIAGRAM_HEIGHT, true, DIAGRAM_COLOR);
			var bitmap:Bitmap = new Bitmap(_diagram);
			bitmap.y = TEXT_HEIGHT * 3;
			this.addChild(bitmap);
			//添加侦听
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedToStageHandler);
		}
		
		private function createTextField(color:uint, y:Number):TextField
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 10;
			textFormat.color = color;
			var textField:TextField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.selectable = false;
			textField.width = VIEWER_WIDTH;
			textField.y = y;
			return textField;
		}
		
		private function addedToStageHandler(event:Event):void
		{
			_fps.text = "FPS: " + this.stage.frameRate.toFixed(2) + "/" + this.stage.frameRate.toFixed(2);
			_mem.text = "MEM: 0B";
			_max.text = "MAX: 0B";
			_previousTime = _diagramTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function removedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			_frameCount++;
			if(_frameCount >= this.stage.frameRate)
			{
				_fps.text = "FPS: " + Number(1000 / (getTimer() - _previousTime) * this.stage.frameRate).toFixed(2) + "/" + this.stage.frameRate.toFixed(2);
				_previousTime = getTimer();
				_frameCount = 0;
			}
			_mem.text = "MEM: " + formatSize(SystemUtil.getUsedMemory());
			_max.text = "MAX: " + formatSize(System.totalMemory);
			//绘制可视图例
			_diagram.scroll(1, 0);
			_diagram.fillRect(new Rectangle(0, 0, 1, DIAGRAM_HEIGHT), DIAGRAM_COLOR);
			var frameRate:Number = 1000 / (getTimer() - _diagramTime);
			var f:Number = frameRate > this.stage.frameRate ? 1 : (frameRate / stage.frameRate);
			_diagramTime = getTimer();
			_diagram.setPixel32(0, DIAGRAM_HEIGHT * (1 - f), FPS_COLOR);
			var maxMemory:uint = getMaxMemory();
			var m:Number = (SystemUtil.getUsedMemory()) / maxMemory;
			_diagram.setPixel32(0, DIAGRAM_HEIGHT * (1 - m), MEM_COLOR);
			m = System.totalMemory / maxMemory;
			_diagram.setPixel32(0, DIAGRAM_HEIGHT * (1 - m), MAX_COLOR);
		}
		
		private function getMaxMemory():uint
		{
			var totalMemory:uint = System.totalMemory;
			if(totalMemory < 10485760)
			{
				return 10485760;
			}
			else if(totalMemory < 104857600)
			{
				return 104857600;
			}
			else if(totalMemory < 1073741824)
			{
				return 1073741824;
			}
			else
			{
				return 4294967296;
			}
		}
		
		private function formatSize(size:uint):String
		{
			if(size < 1024)
			{
				return size.toString() + "B";
			}
			else if(size < 1048576)
			{
				return (size / 1024).toFixed(2) + "KB";
			}
			else if(size < 1073741824)
			{
				return (size / 1048576).toFixed(2) + "MB";
			}
			else
			{
				return (size / 1073741824).toFixed(2) + "GB";
			}
		}
	}
}
