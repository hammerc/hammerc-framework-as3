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
	import flash.utils.Dictionary;
	
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
	 * <code>MultiLoaderStreet</code> 类支持多个文件按顺序进行下载, 与 <code>MultiLoaderQueue</code> 类不同的是, 可指定同一时刻进行下载的线程数, 同时取消事件中的下载速度检测计算.
	 * <p>同一时刻进行下载的线程越多下载速度越快同时系统的开销也相应越大, 一般建议同时下载线程数在 2 ~ 3 个之间最好.</p>
	 * @author wizardc
	 */
	public class MultiLoaderStreet extends EventDispatcher
	{
		/**
		 * 记录所有下载项的列表.
		 */
		protected var _loaderItemList:Vector.<MultiLoaderItem>;
		
		/**
		 * 记录进行下载和解析操作的对象列表.
		 */
		protected var _loaderList:Vector.<ResourceLoader>;
		
		/**
		 * 记录当前是否正在下载.
		 */
		protected var _loading:Boolean = false;
		
		/**
		 * 记录当前下载到的列表索引.
		 */
		protected var _loadIndex:int = 0;
		
		/**
		 * 记录当前下载完毕的数量.
		 */
		protected var _numLoaded:int = 0;
		
		/**
		 * 记录下载项和下载类对应关系的表.
		 */
		protected var _loaderItemMap:Dictionary;
		
		/**
		 * 创建一个 <code>MultiLoaderStreet</code> 对象.
		 * @param numLoader 指定同一时刻下载线程的数量, 有效值为 [2-16].
		 */
		public function MultiLoaderStreet(numLoader:int = 3)
		{
			_loaderItemList = new Vector.<MultiLoaderItem>();
			numLoader = Math.max(2, Math.min(16, numLoader));
			_loaderList = new Vector.<ResourceLoader>(numLoader, true);
			for(var i:int = 0; i < numLoader; i++)
			{
				var loader:ResourceLoader = new ResourceLoader();
				loader.addEventListener(Event.OPEN, loaderEventHandler);
				loader.addEventListener(ProgressEvent.PROGRESS, loaderEventHandler);
				loader.addEventListener(Event.COMPLETE, loaderEventHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loaderEventHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderEventHandler);
				_loaderList[i] = loader;
			}
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
			var len:int = Math.min(_loaderList.length, _loaderItemList.length);
			_loadIndex = len;
			_numLoaded = 0;
			_loading = true;
			_loaderItemMap = new Dictionary();
			for(var i:int = 0; i < len; i++)
			{
				_loaderList[i].load(new URLRequest(_loaderItemList[i].url), _loaderItemList[i].parseType, _loaderItemList[i].context);
				_loaderItemMap[_loaderList[i]] = _loaderItemList[i];
			}
			this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_START, _loaderItemList[_loadIndex], _loadIndex, _loaderItemList.length));
		}
		
		private function loaderEventHandler(event:Event):void
		{
			var loader:ResourceLoader = event.target as ResourceLoader;
			var loaderItem:MultiLoaderItem = _loaderItemMap[loader] as MultiLoaderItem;
			var loadIndex:int = _loaderItemList.indexOf(loaderItem);
			switch(event.type)
			{
				case Event.OPEN:
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_ITEM_START, loaderItem, loadIndex, _loaderItemList.length, loader.bytesLoaded, loader.bytesTotal));
					break;
				case ProgressEvent.PROGRESS:
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_PROGRESS, loaderItem, loadIndex, _loaderItemList.length, (event as ProgressEvent).bytesLoaded, (event as ProgressEvent).bytesTotal));
					break;
				case Event.COMPLETE:
					loaderItem.data = loader.data;
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_ITEM_COMPLETE, loaderItem, loadIndex, _loaderItemList.length, loader.bytesLoaded, loader.bytesTotal));
					loadNextItem(loader);
					break;
				case IOErrorEvent.IO_ERROR:
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_ITEM_IO_ERROR, loaderItem, loadIndex, _loaderItemList.length));
					loadNextItem(loader);
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_ITEM_SECURITY_ERROR, loaderItem, loadIndex, _loaderItemList.length));
					loadNextItem(loader);
					break;
			}
		}
		
		private function loadNextItem(loader:ResourceLoader):void
		{
			_numLoaded++;
			if(_numLoaded == _loaderItemList.length)
			{
				_loading = false;
				_loaderItemMap = null;
				this.dispatchEvent(new MultiLoaderEvent(MultiLoaderEvent.MULTI_LOAD_COMPLETE, null, _loadIndex, _loaderItemList.length));
			}
			if(_loadIndex != _loaderItemList.length)
			{
				loader.load(new URLRequest(_loaderItemList[_loadIndex].url), _loaderItemList[_loadIndex].parseType, _loaderItemList[_loadIndex].context);
				_loaderItemMap[loader] = _loaderItemList[_loadIndex];
				_loadIndex++;
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
			for each(var loader:ResourceLoader in _loaderList)
			{
				loader.close();
			}
			_loadIndex = 0;
			_loadIndex = 0;
			_loading = false;
			_loaderItemMap = null;
		}
	}
}
