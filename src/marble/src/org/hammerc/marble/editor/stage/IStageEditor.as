/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.stage
{
	/**
	 * <code>IStageEditor</code> 接口定义了舞台编辑器应有的属性和方法.
	 * @author wizardc
	 */
	public interface IStageEditor
	{
		/**
		 * 获取当前的层的数量.
		 */
		function get numLayers():int;
		
		/**
		 * 显示一个层.
		 * @param name 舞台层对象名称.
		 * @param hideOther 是否隐藏其它层.
		 */
		function showLayer(name:String, hideOther:Boolean = false):void;
		
		/**
		 * 显示所有层.
		 */
		function showAllLayers():void;
		
		/**
		 * 隐藏一个层.
		 * @param name 舞台层对象名称.
		 * @param showOther 是否显示其它层.
		 */
		function hideLayer(name:String, showOther:Boolean = false):void;
		
		/**
		 * 隐藏所有层.
		 */
		function hideAllLayers():void;
		
		/**
		 * 锁定一个层.
		 * @param name 舞台层对象名称.
		 * @param unlockOther 是否解锁其它层.
		 */
		function lockLayer(name:String, unlockOther:Boolean = false):void;
		
		/**
		 * 锁定所有层.
		 */
		function lockAllLayers():void;
		
		/**
		 * 解锁一个层.
		 * @param name 舞台层对象名称.
		 * @param lockOther 是否锁定其它层.
		 */
		function unlockLayer(name:String, lockOther:Boolean = false):void;
		
		/**
		 * 解锁所有层.
		 */
		function unlockAllLayers():void;
		
		/**
		 * 添加一个层.
		 * @param layer 舞台层对象.
		 */
		function addLayer(layer:IStageLayer):void;
		
		/**
		 * 添加一个层到指定的索引.
		 * @param layer 舞台层对象.
		 * @param index 指定的索引.
		 */
		function addLayerAt(layer:IStageLayer, index:int):void;
		
		/**
		 * 判断指定层是否被添加到本舞台.
		 * @param name 舞台层对象名称.
		 * @return 指定层是否被添加到本舞台.
		 */
		function hasLayer(name:String):Boolean;
		
		/**
		 * 获取指定索引的层.
		 * @param index 指定的索引.
		 * @return 该索引处的层.
		 */
		function getLayerAt(index:int):IStageLayer;
		
		/**
		 * 获取指定名称的层.
		 * @param name 层名称.
		 * @return 对应的层对象.
		 */
		function getLayerByName(name:String):IStageLayer;
		
		/**
		 * 设置指定层的索引.
		 * @param name 舞台层对象名称.
		 * @param index 要设置到的索引.
		 */
		function setLayerIndex(name:String, index:int):void;
		
		/**
		 * 移除指定层对象.
		 * @param name 舞台层对象名称.
		 * @return 移除的层对象.
		 */
		function removeLayer(name:String):IStageLayer;
		
		/**
		 * 移除指定索引层对象.
		 * @param index 指定的索引.
		 * @return 移除的层对象.
		 */
		function removeLayerAt(index:int):IStageLayer;
		
		/**
		 * 移除所有层对象.
		 */
		function removeAllLayer():void;
		
		/**
		 * 交换两个层的索引.
		 * @param name1 第一个层的名称.
		 * @param name2 第二个层的名称.
		 */
		function swapLayers(name1:String, name2:String):void;
	}
}
