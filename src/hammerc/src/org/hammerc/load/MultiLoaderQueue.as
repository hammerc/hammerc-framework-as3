/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.load
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import org.hammerc.events.MultiLoaderEvent;
	
	/**
	 * @eventType org.hammerc.events.MultiLoaderEvent.MULTI_LOAD_START
	 */
	[Event(name="multiLoadStart",type="org.hammerc.events.MultiLoaderEvent")]
	
	/**
	 * @eventType org.hammerc.events.MultiLoaderEvent.MULTI_LOAD_PROGRESS
	 */
	[Event(name="multiLoadProgress",type="org.hammerc.events.MultiLoaderEvent")]
	
	/**
	 * @eventType org.hammerc.events.MultiLoaderEvent.MULTI_LOAD_ITEM_START
	 */
	[Event(name="multiLoadItemStart",type="org.hammerc.events.MultiLoaderEvent")]
	
	/**
	 * @eventType org.hammerc.events.MultiLoaderEvent.MULTI_LOAD_ITEM_COMPLETE
	 */
	[Event(name="multiLoadItemComplete",type="org.hammerc.events.MultiLoaderEvent")]
	
	/**
	 * @eventType org.hammerc.events.MultiLoaderEvent.MULTI_LOAD_ITEM_IO_ERROR
	 */
	[Event(name="multiLoadItemIOError",type="org.hammerc.events.MultiLoaderEvent")]
	
	/**
	 * @eventType org.hammerc.events.MultiLoaderEvent.MULTI_LOAD_ITEM_SECURITY_ERROR
	 */
	[Event(name="multiLoadItemSecurityError",type="org.hammerc.events.MultiLoaderEvent")]
	
	/**
	 * @eventType org.hammerc.events.MultiLoaderEvent.MULTI_LOAD_COMPLETE
	 */
	[Event(name="multiLoadComplete",type="org.hammerc.events.MultiLoaderEvent")]
	
	/**
	 * <code>MultiLoaderQueue</code> 类支持多个文件按顺序进行下载, 同一时刻只有一个线程执行下载.
	 * @author wizardc
	 */
	public class MultiLoaderQueue extends EventDispatcher
	{
		/**
		 * 记录所有下载项的列表.
		 */
		protected var _loaderItemList:Vector.<MultiLoaderItem>;
		
		/**
		 * 记录进行下载和解析操作的对象.
		 */
		protected var _loader:ResourceLoader;
		
		/**
		 * 记录当前是否正在下载.
		 */
		protected var _loading:Boolean = false;
		
		/**
		 * 记录当前下载到的列表索引.
		 */
		protected var _loadIndex:int = 0;
		
		/**
		 * 记录开始下载的时间.
		 */
		protected var _beginTime:int = 0;
		
		/**
		 * 创建一个 <code>MultiLoaderQueue</code> 对象.
		 */
		public function MultiLoaderQueue()
		{
			_loaderItemList = new Vector.<MultiLoaderItem>();
			_loader = new ResourceLoader();
			_loader.addEventListener(Event.OPEN, loaderEventHandler);
			_loader.addEventListener(ProgressEvent.PROGRESS, loaderEventHandler);
			_loader.addEventListener(Event.COMPLETE, loaderEventHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, loaderEventHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEventHandler);
		}
		
		/**
		 * 获取当前是否正在下载.
		 */
		public function get loading():Boolean
		{
			return _loading;
		}
		
		/**
		 * 获取所有需要下载的下载项列表.
		 */
		public function get loaderItemList():Vector.<MultiLoaderItem>
		{
			return _loaderItemList.concat();
		}
		
		/**
		 * 添加一个下载项.
		 * @param item 要添加的下载项.
		 * @throws Error 如果当前正在下载则会引发该异常.
		 */
		public function appendLoader(item:MultiLoaderItem):void
		{
			if(_loading)
			{
				throw new Error("加载已经开始，无法继续添加新的下载项！");
			}
			if(item != null)
			{
				_loaderItemList.push(item);
			}
		}
		
		/**
		 * 添加多个下载项.
		 * @param item 要添加的下载项列表.
		 * @throws Error 如果当前正在下载则会引发该异常.
		 */
		public function appendLoaders(items:Vector.<MultiLoaderItem>):void
		{
			if(_loading)
			{
				throw new Error("加载已经开始，无法继续添加新的下载项！");
			}
			if(items != null && items.length > 0)
			{
				for each(var item:MultiLoaderItem in items)
				{
					this.appendLoader(item);
				}
			}
		}
		
		/**
		 * 开始下载.
		 */
		public function start():void
		{
			if(_loading)
			{
				throw new Error("加载已经开始！");
			}
			if(_loaderItemList.length == 0)
			{
				this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_COMPLETE, null, 0, 0));
				return;
			}
			_loadIndex = 0;
			_loading = true;
			_loader.load(new URLRequest(_loaderItemList[_loadIndex].url), _loaderItemList[_loadIndex].parseType, _loaderItemList[_loadIndex].context);
			this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_START, _loaderItemList[_loadIndex], _loadIndex, _loaderItemList.length));
		}
		
		private function loaderEventHandler(event:Event):void
		{
			switch(event.type)
			{
				case Event.OPEN:
					_beginTime = getTimer();
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_ITEM_START, _loaderItemList[_loadIndex], _loadIndex, _loaderItemList.length, _loader.bytesLoaded, _loader.bytesTotal));
					break;
				case ProgressEvent.PROGRESS:
					var useTime:Number = (getTimer() - _beginTime) / 1000;
					var bytesLoaded:uint = (event as ProgressEvent).bytesLoaded;
					var networkSpeed:uint = uint(bytesLoaded / useTime);
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_PROGRESS, _loaderItemList[_loadIndex], _loadIndex, _loaderItemList.length, (event as ProgressEvent).bytesLoaded, (event as ProgressEvent).bytesTotal, networkSpeed));
					break;
				case Event.COMPLETE:
					_loaderItemList[_loadIndex].data = _loader.data;
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_ITEM_COMPLETE, _loaderItemList[_loadIndex], _loadIndex, _loaderItemList.length, _loader.bytesLoaded, _loader.bytesTotal));
					loadNextItem();
					break;
				case IOErrorEvent.IO_ERROR:
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_ITEM_IO_ERROR, _loaderItemList[_loadIndex], _loadIndex, _loaderItemList.length));
					loadNextItem();
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_ITEM_SECURITY_ERROR, _loaderItemList[_loadIndex], _loadIndex, _loaderItemList.length));
					loadNextItem();
					break;
			}
		}
		
		private function loadNextItem():void
		{
			_loadIndex++;
			if(_loadIndex == _loaderItemList.length)
			{
				_loading = false;
				this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_COMPLETE, null, _loadIndex, _loaderItemList.length));
			}
			else
			{
				_loader.load(new URLRequest(_loaderItemList[_loadIndex].url), _loaderItemList[_loadIndex].parseType, _loaderItemList[_loadIndex].context);
			}
		}
		
		/**
		 * 获取指定下载项 id 的对应数据.
		 * @param id 指定下载项 id.
		 * @return 对应数据.
		 */
		public function getDataById(id:Object):*
		{
			for each(var item:MultiLoaderItem in _loaderItemList)
			{
				if(item.id == id)
				{
					return item.data;
				}
			}
			return null;
		}
		
		/**
		 * 关闭下载并清除数据.
		 */
		public function close():void
		{
			_loaderItemList.length = 0;
			_loader.close();
			_loadIndex = 0;
			_loading = false;
			_beginTime = 0;
		}
	}
}
