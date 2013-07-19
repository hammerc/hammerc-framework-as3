/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import org.hammerc.events.IExtendEventDispatcher;
	
	/**
	 * <code>NewObjectPool</code> 类提供对象池的基本操作外对于注册过类型并添加到对象池中的对象在取出时进行一次还原, 还原后的对象与新生成的对象一致.
	 * @author wizardc
	 */
	public class NewObjectPool extends ObjectPool
	{
		/**
		 * 记录对象的默认属性.
		 */
		protected var _defaultAttribute:Dictionary;
		
		/**
		 * 创建一个 <code>NewObjectPool</code> 对象.
		 */
		public function NewObjectPool()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function register(type:Class):void
		{
			super.register(type);
			_defaultAttribute = ReflectionUtil.getAllDefaultAttribute(_type);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function join(object:*):*
		{
			if(object == null || (_type != null && !(object is _type)))
			{
				return null;
			}
			for(var key:* in _defaultAttribute)
			{
				if(object[key] != _defaultAttribute[key])
				{
					object[key] = _defaultAttribute[key];
				}
			}
			if(object is DisplayObjectContainer)
			{
				DisplayUtil.removeChildren(object);
			}
			if(object is IExtendEventDispatcher)
			{
				(object as IExtendEventDispatcher).removeAllEventListeners();
			}
			_record.push(object);
			return object;
		}
	}
}
