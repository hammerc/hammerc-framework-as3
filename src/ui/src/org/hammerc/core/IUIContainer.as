// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.core
{
	/**
	 * <code>IUIContainer</code> 接口定义了的组件容器的通用方法及属性.
	 * @author wizardc
	 */
	public interface IUIContainer
	{
		/**
		 * 获取此容器中的组件数量. 组件即实现 <code>IUIComponent</code> 接口的类的.
		 */
		function get numElements():int;
		
		/**
		 * 将组件添加到此容器中. 如果添加的组件已有一个不同的容器作为父项, 则该组件将会从
		 * 其他容器中删除.
		 * @param element 要添加为此容器的子项的组件.
		 * @return 添加为此容器的子项的组件.
		 */
		function addElement(element:IUIComponent):IUIComponent;
		
		/**
		 * 将组件添加到此容器中的指定的索引位置.
		 * @param element 要添加为此容器的子项的组件.
		 * @param index 添加到的索引位置.
		 * @return 添加为此容器的子项的组件.
		 */
		function addElementAt(element:IUIComponent, index:int):IUIComponent;
		
		/**
		 * 从此容器的子列表中删除指定的组件.
		 * @param element 要从容器中删除的组件.
		 * @return 删除的组件.
		 */
		function removeElement(element:IUIComponent):IUIComponent;
		
		/**
		 * 从此容器的子列表中删除指定索引位置的组件.
		 * @param index 要删除的组件的索引.
		 * @return 删除的组件.
		 */
		function removeElementAt(index:int):IUIComponent;
		
		/**
		 * 从容器中删除所有的组件.
		 */
		function removeAllElements():void;
		
		/**
		 * 确定指定的组件是否为容器实例的子代或该实例本身. 即, 如果此组件是该容器的子代, 孙代, 曾孙代等, 它将返回 true.
		 * @param element 要测试的组件.
		 * @return 容器是否包含该组件.
		 */
		function containsElement(element:IUIComponent):Boolean;
		
		/**
		 * 返回组件的索引位置. 若不存在, 则返回 -1.
		 * @param element 组件.
		 * @return 组件的索引位置.
		 */
		function getElementIndex(element:IUIComponent):int;
		
		/**
		 * 在可视容器中更改现有组件的索引位置.
		 * @param element 组件.
		 * @param index 组件的最终索引编号.
		 * @throws RangeError 如果在子列表中不存在该索引位置则抛出该异常.
		 */
		function setElementIndex(element:IUIComponent, index:int):void;
		
		/**
		 * 返回指定索引处的组件.
		 * @param index 组件的索引编号.
		 * @return 指定索引的组件.
		 * @throws RangeError 如果在子列表中不存在该索引位置则抛出该异常.
		 */
		function getElementAt(index:int):IUIComponent;
		
		/**
		 * 交换两个指定组件的索引.
		 * @param element1 第一个组件.
		 * @param element2 第二个组件.
		 */
		function swapElements(element1:IUIComponent, element2:IUIComponent):void;
		
		/**
		 * 交换容器中位于两个指定索引位置的组件.
		 * @param index1 第一个组件的索引.
		 * @param index2 第二个组件的索引.
		 * @throws RangeError 如果在子列表中不存在该索引位置则抛出该异常.
		 */
		function swapElementsAt(index1:int, index2:int):void;
	}
}
