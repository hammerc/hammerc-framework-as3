/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.supportClasses
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import org.hammerc.components.Label;
	import org.hammerc.components.SkinnableComponent;
	import org.hammerc.core.HammercGlobals;
	import org.hammerc.core.IText;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.UIEvent;
	import org.hammerc.layouts.VerticalAlign;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.UIEvent.BUTTON_DOWN
	 */
	[Event(name="buttonDown", type="org.hammerc.events.UIEvent")]
	
	/**
	 * <code>ButtonBase</code> 类为按钮组件基类.
	 * @author wizardc
	 */
	public class ButtonBase extends SkinnableComponent
	{
		/**
		 * 皮肤子件, 按钮上的文本标签.
		 */
		public var labelDisplay:IText;
		
		/**
		 * 已经开始过不断抛出 buttonDown 事件的标志.
		 */
		private var _downEventFired:Boolean = false;
		
		/**
		 * 重发 buttonDown 事件计时器.
		 */
		private var _autoRepeatTimer:Timer;
		
		private var _autoRepeat:Boolean = false;
		private var _repeatDelay:Number = 500;
		private var _repeatInterval:Number = 35;
		
		private var _hovered:Boolean = false;    
		
		private var _keepDown:Boolean = false;
		
		private var _label:String = "";
		
		private var _mouseCaptured:Boolean = false; 
		
		private var _stickyHighlighting:Boolean = false;
		
		private var _createLabelIfNeed:Boolean = true;
		private var _createLabelIfNeedChanged:Boolean = false;
		
		/**
		 * 创建过 label 的标志.
		 */
		private var _hasCreatedLabel:Boolean = false;
		
		/**
		 * 创建一个 <code>ButtonBase</code> 对象.
		 */
		public function ButtonBase()
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.focusEnabled = true;
			this.autoMouseEnabled = false;
			this.addHandlers();
		}
		
		/**
		 * 设置或获取指定在用户按住鼠标按键时是否重复分派 buttonDown 事件.
		 */
		public function set autoRepeat(value:Boolean):void
		{
			if(value == _autoRepeat)
			{
				return;
			}
			_autoRepeat = value;
			checkAutoRepeatTimerConditions(isDown());
		}
		public function get autoRepeat():Boolean
		{
			return _autoRepeat;
		}
		
		/**
		 * 设置或获取在第一个 buttonDown 事件之后, 以及相隔每个 <code>repeatInterval</code> 重复一次 buttonDown 事件之前, 需要等待的毫秒数.
		 */
		public function set repeatDelay(value:Number):void
		{
			_repeatDelay = value;
		}
		public function get repeatDelay():Number
		{
			return _repeatDelay;
		}
		
		/**
		 * 设置或获取用户在按钮上按住鼠标时, buttonDown 事件之间相隔的毫秒数.
		 */
		public function set repeatInterval(value:Number):void
		{
			_repeatInterval = value;
		}
		public function get repeatInterval():Number
		{
			return _repeatInterval;
		}
		
		/**
		 * 设置或获取指示鼠标指针是否位于按钮上.
		 */
		protected function set hovered(value:Boolean):void
		{
			if(value == _hovered)
			{
				return;
			}
			_hovered = value;
			this.invalidateSkinState();
			checkButtonDownConditions();
		}
		protected function get hovered():Boolean
		{
			return _hovered;
		}
		
		/**
		 * 强制让按钮停在鼠标按下状态, 此方法不会导致重复抛出 buttonDown 事件, 仅影响皮肤 State.
		 * @param down 是否按下.
		 */
		hammerc_internal function keepDown(down:Boolean):void
		{
			if(_keepDown == down)
			{
				return;
			}
			_keepDown = down;
			this.invalidateSkinState();
		}
		
		/**
		 * 设置或获取要在按钮上显示的文本.
		 */
		public function set label(value:String):void
		{
			_label = value;
			if(labelDisplay != null)
			{
				labelDisplay.text = value;
			}
		}
		public function get label():String          
		{
			if(labelDisplay != null)
			{
				return labelDisplay.text;
			}
			else
			{
				return _label;
			}
		}
		
		/**
		 * 设置或获取指示第一次分派 MouseEvent.MOUSE_DOWN 时, 是否按下鼠标以及鼠标指针是否在按钮上.
		 */
		protected function set mouseCaptured(value:Boolean):void
		{
			if(value == _mouseCaptured)
			{
				return;
			}
			_mouseCaptured = value;
			this.invalidateSkinState();
			if(!value)
			{
				removeStageMouseHandlers();
			}
			checkButtonDownConditions();
		}
		protected function get mouseCaptured():Boolean
		{
			return _mouseCaptured;
		}
		
		/**
		 * 设置或获取鼠标拖离时是显示鼠标按下时的外观还是鼠标移入时的外观.
		 */
		public function set stickyHighlighting(value:Boolean):void
		{
			if(value == _stickyHighlighting)
			{
				return;
			}
			_stickyHighlighting = value;
			this.invalidateSkinState();
			checkButtonDownConditions();
		}
		public function get stickyHighlighting():Boolean
		{
			return _stickyHighlighting
		}
		
		/**
		 * 开始抛出 buttonDown 事件.
		 */
		private function checkButtonDownConditions():void
		{
			var isCurrentlyDown:Boolean = isDown();
			if(_downEventFired != isCurrentlyDown)
			{
				if(isCurrentlyDown)
				{
					this.dispatchEvent(new UIEvent(UIEvent.BUTTON_DOWN));
				}
				_downEventFired = isCurrentlyDown;
				checkAutoRepeatTimerConditions(isCurrentlyDown);
			}
		}
		
		/**
		 * 添加鼠标事件监听.
		 */
		protected function addHandlers():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseEventHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, this.mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, this.mouseEventHandler);
			this.addEventListener(MouseEvent.CLICK, this.mouseEventHandler);
		}
		
		/**
		 * 添加舞台鼠标弹起事件监听.
		 */
		private function addStageMouseHandlers():void
		{
			HammercGlobals.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
			HammercGlobals.stage.addEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler, false, 0, true);
		}
		
		/**
		 * 移除舞台鼠标弹起事件监听.
		 */
		private function removeStageMouseHandlers():void
		{
			HammercGlobals.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			HammercGlobals.stage.removeEventListener(Event.MOUSE_LEAVE, stage_mouseUpHandler);
		}
		
		/**
		 * 获取按钮是否是按下的状态.
		 */
		private function isDown():Boolean
		{
			if(!this.enabled)
			{
				return false;
			}
			if(this.mouseCaptured && (this.hovered || this.stickyHighlighting))
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 检查需要启用还是关闭重发计时器.
		 * @param buttonDown 鼠标是否按下.
		 */
		private function checkAutoRepeatTimerConditions(buttonDown:Boolean):void
		{
			var needsTimer:Boolean = this.autoRepeat && buttonDown;
			var hasTimer:Boolean = _autoRepeatTimer != null;
			if(needsTimer == hasTimer)
			{
				return;
			}
			if(needsTimer)
			{
				startTimer();
			}
			else
			{
				stopTimer();
			}
		}
		
		/**
		 * 启动重发计时器.
		 */
		private function startTimer():void
		{
			_autoRepeatTimer = new Timer(1);
			_autoRepeatTimer.delay = _repeatDelay;
			_autoRepeatTimer.addEventListener(TimerEvent.TIMER, autoRepeat_timerDelayHandler);
			_autoRepeatTimer.start();
		}
		
		/**
		 * 停止重发计时器.
		 */
		private function stopTimer():void
		{
			_autoRepeatTimer.stop();
			_autoRepeatTimer = null;
		}
		
		/**
		 * 鼠标事件处理.
		 * @param event 对应的事件.
		 */
		protected function mouseEventHandler(event:Event):void
		{
			var mouseEvent:MouseEvent = event as MouseEvent;
			switch(event.type)
			{
				case MouseEvent.ROLL_OVER:
				{
					if(mouseEvent.buttonDown && !this.mouseCaptured)
					{
						return;
					}
					this.hovered = true;
					break;
				}
				case MouseEvent.ROLL_OUT:
				{
					this.hovered = false;
					break;
				}
				case MouseEvent.MOUSE_DOWN:
				{
					addStageMouseHandlers();
					this.mouseCaptured = true;
					break;
				}
				case MouseEvent.MOUSE_UP:
				{
					if(event.target == this)
					{
						this.hovered = true;
						if(this.mouseCaptured)
						{
							this.buttonReleased();
							this.mouseCaptured = false;
						}
					}
					break;
				}
				case MouseEvent.CLICK:
				{
					if(!this.enabled)
					{
						event.stopImmediatePropagation();
					}
					else
					{
						this.clickHandler(MouseEvent(event));
					}
					return;
				}
			}
		}
		
		/**
		 * 按钮弹起事件.
		 */
		protected function buttonReleased():void
		{
		}
		
		/**
		 * 按钮点击事件.
		 * @param event 对应的事件.
		 */
		protected function clickHandler(event:MouseEvent):void
		{
		}
		
		/**
		 * 舞台上鼠标弹起事件.
		 * @param event 对应的事件.
		 */
		private function stage_mouseUpHandler(event:Event):void
		{
			if(event.target == this)
			{
				return;
			}
			this.mouseCaptured = false;
		}
		
		/**
		 * 自动重发计时器首次延迟结束事件.
		 * @param event 对应的事件.
		 */
		private function autoRepeat_timerDelayHandler(event:TimerEvent):void
		{
			_autoRepeatTimer.reset();
			_autoRepeatTimer.removeEventListener(TimerEvent.TIMER, autoRepeat_timerDelayHandler);
			_autoRepeatTimer.delay = _repeatInterval;
			_autoRepeatTimer.addEventListener(TimerEvent.TIMER, autoRepeat_timerHandler);
			_autoRepeatTimer.start();
		}
		
		/**
		 * 自动重发 buttonDown 事件.
		 * @param event 对应的事件.
		 */
		private function autoRepeat_timerHandler(event:TimerEvent):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.BUTTON_DOWN));
		}
		
		/**
		 * 如果皮肤不提供 labelDisplay 子项, 自己是否创建一个, 默认为 true.
		 */
		public function set createLabelIfNeed(value:Boolean):void
		{
			if(value == _createLabelIfNeed)
			{
				return;
			}
			_createLabelIfNeed = value;
			_createLabelIfNeedChanged = true;
			this.invalidateProperties();
		}
		public function get createLabelIfNeed():Boolean
		{
			return _createLabelIfNeed;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			if(!this.enabled)
			{
				return super.getCurrentSkinState();
			}
			if(isDown() || _keepDown)
			{
				return "down";
			}
			if(this.hovered || this.mouseCaptured)
			{
				return "over";
			}
			return "up";
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == labelDisplay)
			{
				labelDisplay.text = _label;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_createLabelIfNeedChanged)
			{
				_createLabelIfNeedChanged = false;
				if(this.createLabelIfNeed)
				{
					this.createSkinParts();
					this.invalidateSize();
					this.invalidateDisplayList();
				}
				else
				{
					this.removeSkinParts();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function createSkinParts():void
		{
			if(_hasCreatedLabel || !_createLabelIfNeed)
			{
				return;
			}
			_hasCreatedLabel = true;
			var text:Label = new Label();
			text.textAlign = TextFormatAlign.CENTER;
			text.verticalAlign = VerticalAlign.MIDDLE;
			text.maxDisplayedLines = 1;
			text.left = 10;
			text.right = 10;
			text.top = 2;
			text.bottom = 2;
			this.addToDisplayList(text);
			labelDisplay = text;
			this.partAdded("labelDisplay", labelDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function removeSkinParts():void
		{
			if(!_hasCreatedLabel)
			{
				return;
			}
			_hasCreatedLabel = false;
			if(labelDisplay == null)
			{
				return;
			}
			_label = labelDisplay.text;
			this.partRemoved("labelDisplay", labelDisplay);
			this.removeFromDisplayList(labelDisplay as DisplayObject);
			labelDisplay = null;
		}
	}
}
