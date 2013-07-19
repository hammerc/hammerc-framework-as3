/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.data
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import org.hammerc.collections.HashMap;
	import org.hammerc.collections.IMap;
	import org.hammerc.events.LocalDataEvent;
	
	/**
	 * @eventType org.hammerc.events.PropertyChangeEvent.LOCAL_DATA_CANNOT_SAVE
	 */
	[Event(name="localDataCannotSave", type="org.hammerc.events.LocalDataEvent")]
	
	/**
	 * @eventType org.hammerc.events.PropertyChangeEvent.LOCAL_DATA_SAVE_SUCCESS
	 */
	[Event(name="localDataSaveSuccess", type="org.hammerc.events.LocalDataEvent")]
	
	/**
	 * @eventType org.hammerc.events.PropertyChangeEvent.LOCAL_DATA_PENDING
	 */
	[Event(name="localDataPending", type="org.hammerc.events.LocalDataEvent")]
	
	/**
	 * @eventType org.hammerc.events.PropertyChangeEvent.LOCAL_DATA_PENDING_OK
	 */
	[Event(name="localDataPendingOK", type="org.hammerc.events.LocalDataEvent")]
	
	/**
	 * @eventType org.hammerc.events.PropertyChangeEvent.LOCAL_DATA_PENDING_CANCEL
	 */
	[Event(name="localDataPendingCancel", type="org.hammerc.events.LocalDataEvent")]
	
	/**
	 * <code>LocalData</code> 类可以在用户计算机上读取和存储有限的数据, 类似网页的 Cookies.
	 * @author wizardc
	 */
	public class LocalData extends EventDispatcher implements IMap
	{
		private static const ATTRIBUTE_NAME:String = "hammerc_local_data_attribute_19891108";
		
		/**
		 * 本地存储对象.
		 */
		protected var _sharedObject:SharedObject;
		
		/**
		 * 记录对象的哈希表.
		 */
		protected var _hashMap:HashMap;
		
		/**
		 * 创建一个 <code>LocalData</code> 对象.
		 * @param name 数据名称.
		 * @param localPath 数据的路径.
		 * @param secure 确定对此共享对象的访问是否只限于通过 HTTPS 连接传递的 SWF 文件.
		 */
		public function LocalData(name:String = null, path:String = null, secure:Boolean = false)
		{
			registerClassAlias("org.hammerc.utils.HashMap", HashMap);
			this.open(name, path, secure);
		}
		
		/**
		 * 打开或创建一个本地记录数据.
		 * @param name 数据名称.
		 * @param localPath 数据的路径.
		 * @param secure 确定对此共享对象的访问是否只限于通过 HTTPS 连接传递的 SWF 文件.
		 */
		public function open(name:String, localPath:String = null, secure:Boolean = false):void
		{
			if(name == null)
			{
				return;
			}
			_sharedObject = SharedObject.getLocal(name, localPath, secure);
			if(_sharedObject.data.hasOwnProperty(ATTRIBUTE_NAME))
			{
				var bytes:ByteArray = _sharedObject.data[ATTRIBUTE_NAME] as ByteArray;
				if(bytes != null)
				{
					try
					{
						bytes.uncompress();
					}
					catch(error:Error)
					{
					}
					_hashMap = bytes.readObject() as HashMap;
				}
			}
			if(_hashMap == null)
			{
				_hashMap = new HashMap();
			}
		}
		
		/**
		 * @inheritDoc
		 * @throws ArgumentError 当指定的键对象为 <code>null</code> 或 <code>undefined</code> 时会抛出该异常.
		 */
		public function put(key:*, value:*):*
		{
			if(_hashMap != null)
			{
				_hashMap.put(key, value);
			}
		}
		
		/**
		 * 将一个已存在的哈希表的所有映射存储到该本地记录数据中.
		 * @param hashMap 要复制的已存在的本地记录数据.
		 */
		public function putAll(hashMap:HashMap):void
		{
			if(_hashMap != null)
			{
				_hashMap.putAll(hashMap);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get(key:*):*
		{
			if(_hashMap != null)
			{
				return _hashMap.get(key);
			}
			return null;
		}
		
		/**
		 * 获取该本地记录数据中的所有键的集合.
		 * @return 该本地记录数据中的所有键的集合.
		 */
		public function keys():Array
		{
			if(_hashMap != null)
			{
				return _hashMap.keys();
			}
			return null;
		}
		
		/**
		 * 获取该本地记录数据中的所有值的集合.
		 * @return 该本地记录数据中的所有值的集合.
		 */
		public function values():Array
		{
			if(_hashMap != null)
			{
				return _hashMap.values();
			}
			return null;
		}
		
		/**
		 * 对该本地记录数据中的每一个键执行函数.
		 * @param callback 要对每一个键运行的函数.
		 * @param thisObject 用作函数的 this 的对象.
		 */
		public function eachKey(callback:Function, thisObject:* = null):void
		{
			if(_hashMap != null)
			{
				_hashMap.eachKey(callback, thisObject);
			}
		}
		
		/**
		 * 对该本地记录数据中的每一个值执行函数.
		 * @param callback 要对每一个值运行的函数.
		 * @param thisObject 用作函数的 this 的对象.
		 */
		public function eachValue(callback:Function, thisObject:* = null):void
		{
			if(_hashMap != null)
			{
				_hashMap.eachValue(callback, thisObject);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove(key:*):*
		{
			if(_hashMap != null)
			{
				return _hashMap.remove(key);
			}
			return null;
		}
		
		/**
		 * 判断一个指定键是否已经在该本地记录数据中映射过.
		 * @param key 需要被判断的一个指定键.
		 * @return 该键是否已经在该本地记录数据中映射过, 已经被映射过返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function containsKey(key:*):Boolean
		{
			if(_hashMap != null)
			{
				return _hashMap.containsKey(key);
			}
			return false;
		}
		
		/**
		 * 判断一个指定值是否已经在该本地记录数据中被映射过.
		 * @param value 需要被判断的一个指定值.
		 * @return 该值是否已经在该本地记录数据中被映射过, 已经被映射过返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function containsValue(value:*):Boolean
		{
			if(_hashMap != null)
			{
				return _hashMap.containsValue(value);
			}
			return false;
		}
		
		/**
		 * 获取该本地记录数据是否为空表.
		 * @return 如果为空表返回 <code>true</code>, 否则返回 <code>false</code>.
		 */
		public function isEmpty():Boolean
		{
			if(_hashMap != null)
			{
				return _hashMap.isEmpty();
			}
			return true;
		}
		
		/**
		 * 获取该本地记录数据的个数.
		 * @return 该本地记录数据的个数.
		 */
		public function size():int
		{
			if(_hashMap != null)
			{
				return _hashMap.size();
			}
			return 0;
		}
		
		/**
		 * 将该本地记录数据用字符串的形式进行返回.
		 * @return 该本地记录数据的字符串形式.
		 */
		override public function toString():String
		{
			if(_hashMap != null)
			{
				return _hashMap.toString();
			}
			return "LocalData is not open.";
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void
		{
			if(_hashMap != null)
			{
				_hashMap.clear();
			}
		}
		
		/**
		 * 将数据永久共享对象立即写入本地文件.
		 * @param minDiskSpace 必须分配给此对象的最小磁盘空间 (以字节为单位).
		 */
		public function save(minDiskSpace:int = 0):void
		{
			if(_sharedObject != null)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(_hashMap);
				bytes.compress();
				_sharedObject.data[ATTRIBUTE_NAME] = bytes;
				try
				{
					switch(_sharedObject.flush(minDiskSpace))
					{
						case SharedObjectFlushStatus.PENDING:
							_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
							this.dispatchEvent(new LocalDataEvent(LocalDataEvent.LOCAL_DATA_PENDING));
							break;
						case SharedObjectFlushStatus.FLUSHED:
							this.dispatchEvent(new LocalDataEvent(LocalDataEvent.LOCAL_DATA_SAVE_SUCCESS));
							break;
					}
				}
				catch(error:Error)
				{
					this.dispatchEvent(new LocalDataEvent(LocalDataEvent.LOCAL_DATA_CANNOT_SAVE));
				}
			}
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			_sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			switch(event.info["code"])
			{
				case "SharedObject.Flush.Success":
					this.dispatchEvent(new LocalDataEvent(LocalDataEvent.LOCAL_DATA_PENDING_OK));
					break;
				case "SharedObject.Flush.Failed":
					this.dispatchEvent(new LocalDataEvent(LocalDataEvent.LOCAL_DATA_PENDING_CANCEL));
					break;
			}
		}
		
		/**
		 * 获取该本地记录数据的占用硬盘大小.
		 * @return 该本地记录数据的占用硬盘大小.
		 */
		public function localSize():uint
		{
			if(_sharedObject != null)
			{
				return _sharedObject.size;
			}
			return 0;
		}
		
		/**
		 * 关闭本数据对象.
		 */
		public function close():void
		{
			_sharedObject = null;
			_hashMap = null;
		}
	}
}
