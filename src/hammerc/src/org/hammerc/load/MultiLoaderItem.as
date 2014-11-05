// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.load
{
	import flash.system.LoaderContext;
	
	/**
	 * <code>MultiLoaderItem</code> 类记录一个多项下载的下载项信息.
	 * @author wizardc
	 */
	public class MultiLoaderItem
	{
		/**
		 * 记录下载项的标示 id, 可以是任意对象.
		 */
		protected var _id:Object;
		
		/**
		 * 记录要下载的文件地址.
		 */
		protected var _url:String;
		
		/**
		 * 记录文件要被解析为的类型.
		 */
		protected var _parseType:String;
		
		/**
		 * 记录该下载项的载入上下文对象.
		 */
		protected var _context:LoaderContext;
		
		/**
		 * 记录下载后的数据.
		 */
		protected var _data:*;
		
		/**
		 * 创建一个 <code>MultiLoaderItem</code> 对象.
		 * @param url 要下载的文件地址.
		 * @param id 下载项的标示 id, 可以是任意对象.
		 * @param parseType 文件要被解析为的类型.
		 * @param context 该下载项的载入上下文对象.
		 */
		public function MultiLoaderItem(url:String, id:Object = null, parseType:String = "Bytes", context:LoaderContext = null)
		{
			_url = url;
			_id = id;
			_parseType = parseType;
			_context = context;
		}
		
		/**
		 * 设置或获取下载项的标示 id, 可以是任意对象.
		 */
		public function set id(value:Object):void
		{
			_id = value;
		}
		public function get id():Object
		{
			return _id;
		}
		
		/**
		 * 设置或获取要下载的文件地址.
		 */
		public function set url(value:String):void
		{
			_url = value;
		}
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * 设置或获取文件要被解析为的类型.
		 */
		public function set parseType(value:String):void
		{
			_parseType = value;
		}
		public function get parseType():String
		{
			return _parseType;
		}
		
		/**
		 * 设置或获取该下载项的载入上下文对象.
		 */
		public function set context(value:LoaderContext):void
		{
			_context = value;
		}
		public function get context():LoaderContext
		{
			return _context;
		}
		
		/**
		 * 设置或获取下载后的数据.
		 */
		 public function set data(value:*):void
		{
			_data = value;
		}
		public function get data():*
		{
			return _data;
		}
	}
}
