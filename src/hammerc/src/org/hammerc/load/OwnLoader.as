/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.load
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	/**
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * <code>OwnLoader</code> 类提供侦测主 swf 文件的下载情况.
	 * @author wizardc
	 */
	public class OwnLoader extends EventDispatcher
	{
		private var _root:DisplayObject;
		
		/**
		 * 创建一个 <code>OwnLoader</code> 对象.
		 * @param root 需要进行具体侦听的顶级显示对象.
		 */
		public function OwnLoader(root:DisplayObject)
		{
			_root = root;
			_root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, eventsHandler);
			_root.loaderInfo.addEventListener(Event.COMPLETE, eventsHandler);
		}
		
		/**
		 * 开始侦听.
		 */
		public function start():void
		{
			if(_root.loaderInfo.bytesLoaded == _root.loaderInfo.bytesTotal)
			{
				_root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, eventsHandler);
				_root.loaderInfo.removeEventListener(Event.COMPLETE, eventsHandler);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function eventsHandler(event:Event):void
		{
			if(event.type == Event.COMPLETE)
			{
				_root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, eventsHandler);
				_root.loaderInfo.removeEventListener(Event.COMPLETE, eventsHandler);
			}
			this.dispatchEvent(event);
		}
	}
}
