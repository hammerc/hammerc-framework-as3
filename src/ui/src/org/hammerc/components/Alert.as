/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.events.MouseEvent;
	
	import org.hammerc.core.IText;
	import org.hammerc.events.CloseEvent;
	import org.hammerc.managers.PopUpManager;
	
	/**
	 * <code>Alert</code> 类实现了弹出对话框.
	 * @author wizardc
	 */
	public class Alert extends TitleWindow
	{
		/**
		 * 是按钮标志.
		 */
		public static const YES:uint = 0x0001;
		
		/**
		 * 否按钮标志.
		 */
		public static const NO:uint = 0x0002;
		
		/**
		 * 确定按钮标志.
		 */
		public static const OK:uint = 0x0004;
		
		/**
		 * 取消按钮标志.
		 */
		public static const CANCEL:uint= 0x0008;
		
		private static var _yesLabel:String;
		private static var _noLabel:String;
		private static var _okLabel:String;
		private static var _cancelLabel:String;
		
		/**
		 * 设置或获取是按钮标签.
		 */
		public static function set yesLabel(value:String):void
		{
			_yesLabel = value;
		}
		public static function get yesLabel():String
		{
			if(_yesLabel == null || _yesLabel == "")
			{
				return "是";
			}
			return _yesLabel;
		}
		
		/**
		 * 设置或获取否按钮标签.
		 */
		public static function set noLabel(value:String):void
		{
			_noLabel = value;
		}
		public static function get noLabel():String
		{
			if(_noLabel == null || _noLabel == "")
			{
				return "否";
			}
			return _noLabel;
		}
		
		/**
		 * 设置或获取确定按钮标签.
		 */
		public static function set okLabel(value:String):void
		{
			_okLabel = value;
		}
		public static function get okLabel():String
		{
			if(_okLabel == null || _okLabel == "")
			{
				return "确定";
			}
			return _okLabel;
		}
		
		/**
		 * 设置或获取取消按钮标签.
		 */
		public static function set cancelLabel(value:String):void
		{
			_cancelLabel = value;
		}
		public static function get cancelLabel():String
		{
			if(_cancelLabel == null || _cancelLabel == "")
			{
				return "取消";
			}
			return _cancelLabel;
		}
		
		/**
		 * 弹出窗口.
		 * @param text 要显示的文本内容字符串.
		 * @param title 对话框标题.
		 * @param flags 显示的按钮标志位.
		 * @param closeHandler 按下窗口上的任意按钮时的回调函数. 示例: <code>closeHandler(event:CloseEvent):void</code>.
		 * @param modal 是否启用模态.
		 * @param center 是否居中.
		 * @return 弹出的对话框实例的引用.
		 */
		public static function show(text:String, title:String = "", flags:uint = 0x0004, closeHandler:Function = null, modal:Boolean = true, center:Boolean = true):Alert
		{
			var alert:Alert = new Alert();
			alert.contentText = text;
			alert.title = title;
			alert._buttonFlags = flags;
			alert._closeHandler = closeHandler;
			PopUpManager.addPopUp(alert, modal, center);
			return alert;
		}
		
		/**
		 * 皮肤子件, 文本内容显示对象.
		 */
		public var contentDisplay:IText;
		
		/**
		 * 皮肤子件, 是按钮.
		 */
		public var yesButton:Button;
		
		/**
		 * 皮肤子件, 否按钮.
		 */
		public var noButton:Button;
		
		/**
		 * 皮肤子件, 确定按钮.
		 */
		public var okButton:Button;
		
		/**
		 * 皮肤子件, 取消按钮.
		 */
		public var cancelButton:Button;
		
		private var _contentText:String = "";
		
		private var _buttonFlags:uint;
		
		private var _closeHandler:Function;
		
		/**
		 * 创建一个 <code>Alert</code> 对象.
		 */
		public function Alert()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Alert;
		}
		
		/**
		 * 设置或获取文本内容.
		 */
		public function set contentText(value:String):void
		{
			if(_contentText == value)
			{
				return;
			}
			_contentText = value;
			if(contentDisplay != null)
			{
				contentDisplay.text = value;
			}
		}
		public function get contentText():String
		{
			return _contentText;
		}
		
		private function onClose(event:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
			if(_closeHandler != null)
			{
				var closeEvent:CloseEvent;
				switch(event.currentTarget)
				{
					case yesButton:
						closeEvent = new CloseEvent(CloseEvent.CLOSE, false, false, YES);
						break;
					case noButton:
						closeEvent = new CloseEvent(CloseEvent.CLOSE, false, false, NO);
						break;
					case okButton:
						closeEvent = new CloseEvent(CloseEvent.CLOSE, false, false, OK);
						break;
					case cancelButton:
						closeEvent = new CloseEvent(CloseEvent.CLOSE, false, false, CANCEL);
						break;
				}
				_closeHandler(closeEvent);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function closeButton_clickHandler(event:MouseEvent):void
		{
			super.closeButton_clickHandler(event);
			PopUpManager.removePopUp(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == contentDisplay)
			{
				contentDisplay.text = _contentText;
			}
			else if(instance == yesButton)
			{
				yesButton.label = yesLabel;
				yesButton.addEventListener(MouseEvent.CLICK, onClose);
				yesButton.includeInLayout = yesButton.visible = (_buttonFlags & YES);
			}
			else if(instance == noButton)
			{
				noButton.label = noLabel;
				noButton.addEventListener(MouseEvent.CLICK, onClose);
				noButton.includeInLayout = noButton.visible = (_buttonFlags & NO);
			}
			else if(instance == okButton)
			{
				okButton.label = okLabel;
				okButton.addEventListener(MouseEvent.CLICK, onClose);
				okButton.includeInLayout = okButton.visible = (_buttonFlags & OK);
			}
			else if(instance == cancelButton)
			{
				cancelButton.label = cancelLabel;
				cancelButton.addEventListener(MouseEvent.CLICK, onClose);
				cancelButton.includeInLayout = cancelButton.visible = (_buttonFlags & CANCEL);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName,instance);
			if(instance == yesButton)
			{
				yesButton.removeEventListener(MouseEvent.CLICK, onClose);
			}
			else if(instance == noButton)
			{
				noButton.removeEventListener(MouseEvent.CLICK, onClose);
			}
			else if(instance == okButton)
			{
				okButton.removeEventListener(MouseEvent.CLICK, onClose);
			}
			else if(instance == cancelButton)
			{
				cancelButton.removeEventListener(MouseEvent.CLICK, onClose);
			}
		}
	}
}
