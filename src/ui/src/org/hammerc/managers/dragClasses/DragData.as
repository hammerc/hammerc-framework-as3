// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.managers.dragClasses
{
	/**
	 * <code>DragData</code> 类包含被拖动的数据.
	 * @author wizardc
	 */
	public class DragData
	{
		private var _dataHolder:Object = new Object();
		private var _formatHandlers:Object = new Object();
		private var _formats:Array  = new Array();
		
		/**
		 * 创建一个 <code>DragData</code> 对象.
		 */
		public function DragData()
		{
			super();
		}
		
		/**
		 * 获取包含拖动数据的格式, 以字符串数组的形式表示.
		 */
		public function get formats():Array
		{
			return _formats;
		}
		
		/**
		 * 向拖动源添加数据和相应的格式名称.
		 * @param data 用于指定拖动数据的对象.
		 * @param format 描述此数据格式的字符串.
		 */
		public function addData(data:Object, format:String):void
		{
			_formats.push(format);
			_dataHolder[format] = data;
		}
		
		/**
		 * 添加一个处理函数, 当请求指定格式的数据时将调用此处理函数. 当拖动大量数据时, 此函数非常有用. 仅当请求数据时才调用该处理函数.
		 * @param handler 一个函数, 用于指定请求数据时需要调用的处理函数. 此函数必须返回指定格式的数据.
		 * @param format 用于指定此数据的格式的字符串.
		 */
		public function addHandler(handler:Function, format:String):void
		{
			_formats.push(format);
			_formatHandlers[format] = handler;
		}
		
		/**
		 * 如果数据源中包含所请求的格式, 则返回 true, 否则返回 false.
		 * @param format 描述此数据格式的字符串.
		 */
		public function hasFormat(format:String):Boolean
		{
			var len:int = _formats.length;
			for(var i:int = 0; i < len; i++)
			{
				if(_formats[i] == format)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 检索指定格式的数据. 如果此数据是使用 <code>addData()</code> 方法添加的, 则可以直接返回此数据. 如果此数据是使用 <code>addHandler()</code> 方法添加的, 则需调用处理程序函数来返回此数据.
		 * @param format 描述此数据格式的字符串.
		 */
		public function dataForFormat(format:String):Object
		{
			var data:Object = _dataHolder[format];
			if(data)
			{
				return data;
			}
			if(_formatHandlers[format])
			{
				return _formatHandlers[format]();
			}
			return null;
		}
	}
}
