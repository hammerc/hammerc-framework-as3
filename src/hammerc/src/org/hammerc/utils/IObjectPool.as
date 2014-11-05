// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.utils
{
	/**
	 * <code>IObjectPool</code> 接口定义了对象池对象应有的属性及方法.
	 * @author wizardc
	 */
	public interface IObjectPool
	{
		/**
		 * 注册该对象池内部存放的类型, 且一旦注册不可更改, 不进行注册则该对象池可以存放任意类型对象.
		 * @param type 该对象池保存的对象类型.
		 */
		function register(type:Class):void;
		
		/**
		 * 加入一个对象放入该对象池.
		 * <p>空对象或与注册的类型不不同的对象不会被添加到池中.</p>
		 * @param object 放入的对象.
		 * @return 放入的对象.
		 */
		function join(object:*):*;
		
		/**
		 * 获取一个闲置的对象.
		 * <p>若对象池已空不会创建新对象返回.</p>
		 * @param filter 对象池获取对象的过滤方法. 接收一个当前遍历的对象池中对象的 * 类型参数, 返回布尔值指定是否取出当前的这个对象.
		 * @return 一个闲置的对象, 如果对象池中已经没有对象则返回 <code>null</code>.
		 */
		function find(filter:Function = null):*;
		
		/**
		 * 获取一个闲置的对象.
		 * <p>若对象池已空且注册过类型则创建新对象返回.</p>
		 * @param filter 对象池获取对象的过滤方法. 接收一个当前遍历的对象池中对象的 * 类型参数, 返回布尔值指定是否取出当前的这个对象.
		 * @param args 如果对象池中的对象已空需要创建新对象时, 传递给构造函数的参数.
		 * @return 一个闲置的对象, 如果对象池中已经没有对象则返回新对象或没有注册类型则返回 <code>null</code>.
		 */
		function take(filter:Function = null, ...args):*;
		
		/**
		 * 获取该对象池中的对象的个数.
		 * @return 该对象池中的对象的个数.
		 */
		function size():uint;
		
		/**
		 * 清空该对象池.
		 */
		function clear():void;
	}
}
