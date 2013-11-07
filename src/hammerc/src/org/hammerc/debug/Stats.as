/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.debug
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import org.hammerc.utils.SystemUtil;
	
	/**
	 * <code>Stats</code> 类提供查看当前程序的帧频及内存使用情况的功能.
	 * <p>可以按下 F7 键对其进行显示或隐藏操作.<br/>一般使用 <code>stage.addChild</code> 方法将其添加到 <code>root</code> 上方即可.<br/>通过设置 <code>scaleX</code> 或 <code>scaleY</code> 可改变尺寸.</p>
	 * @author wizardc
	 */
	public class Stats extends Sprite
	{
		private const BG_COLOR:uint = 0x000000;
		private const BG_AlPHA:Number = 0.5;
		
		private const VIEWER_WIDTH:int = 200;
		private const DIAGRAM_HEIGHT:int = 100;
		private const TEXT_HEIGHT:int = 16;
		
		private const FPS_COLOR:uint = 0x00ff00;
		private const MEM_COLOR:uint = 0xffff00;
		
		private var _diagram:Shape;
		private var _textField:TextField;
		
		private var _frameCount:int = 0;
		private var _previousTime:uint = 0;
		private var _fps:String;
		
		private var _diagramTime:uint = 0;
		private var _fpsList:Vector.<Number>;
		private var _memoryList:Vector.<uint>;
		
		/**
		 * 创建一个 <code>Stats</code> 对象.
		 */
		public function Stats()
		{
			init();
		}
		
		private function init():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			//绘制背景
			this.graphics.beginFill(BG_COLOR, BG_AlPHA);
			this.graphics.drawRect(0, 0, VIEWER_WIDTH, DIAGRAM_HEIGHT + TEXT_HEIGHT);
			//创建图表对象
			_diagram = new Shape();
			this.addChild(_diagram);
			//创建文本框
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 10;
			_textField = new TextField();
			_textField.defaultTextFormat = textFormat;
			_textField.selectable = false;
			_textField.width = VIEWER_WIDTH;
			_textField.height = TEXT_HEIGHT;
			_textField.y = DIAGRAM_HEIGHT;
			this.addChild(_textField);
			//添加侦听
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			var frameReta:String = this.stage.frameRate.toFixed(1);
			_fps = frameReta + "/" + frameReta;
			_previousTime = _diagramTime = getTimer();
			_fpsList = new Vector.<Number>();
			_memoryList = new Vector.<uint>();
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.visible = true;
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		private function removedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
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
		
		private function enterFrameHandler(event:Event):void
		{
			_frameCount++;
			if(_frameCount >= this.stage.frameRate)
			{
				_fps = Number(1000 / (getTimer() - _previousTime) * this.stage.frameRate).toFixed(1) + "/" + this.stage.frameRate.toFixed(1);
				_previousTime = getTimer();
				_frameCount = 0;
			}
			//绘制可视图例
			showDiagramInfo();
			//显示文本
			showTextInfo();
		}
		
		private function showDiagramInfo():void
		{
			//获取帧率百分比
			var frameRate:Number = 1000 / (getTimer() - _diagramTime);
			var fps:Number = frameRate > this.stage.frameRate ? 1 : (frameRate / stage.frameRate);
			_diagramTime = getTimer();
			_fpsList.push(fps);
			if(_fpsList.length > VIEWER_WIDTH)
			{
				_fpsList.shift();
			}
			//获取内存
			var usedMemory:uint = SystemUtil.getUsedMemory();
			_memoryList.push(usedMemory);
			if(_memoryList.length > VIEWER_WIDTH)
			{
				_memoryList.shift();
			}
			//关闭时不进行绘制
			if(!this.visible)
			{
				return;
			}
			//清除线条
			_diagram.graphics.clear();
			//绘制帧率
			var i:int, len:int, beginX:int;
			beginX = VIEWER_WIDTH - _fpsList.length;
			_diagram.graphics.lineStyle(0, FPS_COLOR);
			_diagram.graphics.moveTo(beginX, percentToY(_fpsList[0]));
			for(i = 1, len = _fpsList.length; i < len; i++)
			{
				_diagram.graphics.lineTo(beginX + i, percentToY(_fpsList[i]));
			}
			//绘制内存
			var totalMemory:uint = System.totalMemory;
			beginX = VIEWER_WIDTH - _memoryList.length;
			_diagram.graphics.lineStyle(0, MEM_COLOR);
			_diagram.graphics.moveTo(beginX, percentToY(_memoryList[0] / totalMemory * 0.5));
			for(i = 1, len = _memoryList.length; i < len; i++)
			{
				_diagram.graphics.lineTo(beginX + i, percentToY(_memoryList[i] / totalMemory * 0.5));
			}
		}
		
		private function percentToY(percent:Number):int
		{
			return DIAGRAM_HEIGHT - percent * DIAGRAM_HEIGHT;
		}
		
		private function showTextInfo():void
		{
			if(this.visible)
			{
				_textField.htmlText = "<textFormat tabStops='80'><font color='#" + FPS_COLOR.toString(16) + "'>FPS: " + _fps + "</font><tab/><font color='#" + MEM_COLOR.toString(16) + "'>MEM: " + getMemoryInfo() + "</font></textFormat>";
			}
		}
		
		private function getMemoryInfo():String
		{
			var usedMemory:uint = SystemUtil.getUsedMemory();
			var totalMemory:uint = System.totalMemory;
			if(totalMemory < 1024)
			{
				return usedMemory + "/" + totalMemory.toString() + "B";
			}
			else if(totalMemory < 1048576)
			{
				return (usedMemory / 1024).toFixed(1) + "/" + (totalMemory / 1024).toFixed(1) + "K";
			}
			else if(totalMemory < 1073741824)
			{
				return (usedMemory / 1048576).toFixed(1) + "/" + (totalMemory / 1048576).toFixed(1) + "M";
			}
			return (usedMemory / 1073741824).toFixed(1) + "/" + (totalMemory / 1073741824).toFixed(1) + "G";
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.F7)
			{
				this.visible = !this.visible;
			}
		}
	}
}
