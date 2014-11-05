// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.grid
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import org.hammerc.display.IRepaint;
	
	/**
	 * <code>IGridEditor</code> 接口定义了格子编辑器应有的属性和方法.
	 * @author wizardc
	 */
	public interface IGridEditor extends IRepaint
	{
		/**
		 * 获取格子宽度.
		 */
		function get gridWidth():int;
		
		/**
		 * 获取格子高度.
		 */
		function get gridHeight():int;
		
		/**
		 * 获取行数.
		 */
		function get row():int;
		
		/**
		 * 获取列数.
		 */
		function get column():int;
		
		/**
		 * 获取可撤销的步骤数.
		 */
		function get undoStep():int;
		
		/**
		 * 获取编辑器样式描述对象.
		 */
		function get style():Object;
		
		/**
		 * 设置或获取当前的绘制模式是否为绘制选中的格子, 即把鼠标点中的格子是否设置为选中状态.
		 */
		function set selectMode(value:Boolean):void;
		function get selectMode():Boolean;
		
		/**
		 * 设置或获取绘制类型.
		 */
		function set drawType(value:int):void;
		function get drawType():int;
		
		/**
		 * 设置或获取绘制的区域, x 表示笔触的宽度, y 表示笔触的高度.
		 */
		function set drawArea(value:Point):void;
		function get drawArea():Point;
		
		/**
		 * 设置或获取是否使用最小的绘制区域, 设置为 true 后无论 <code>drawArea</code> 设置为多少都使用最小的绘制区域.
		 */
		function set useMinDrawArea(value:Boolean):void;
		function get useMinDrawArea():Boolean;
		
		/**
		 * 获取格子鼠标事件模拟对象.
		 */
		function get gridHitTest():IGridHitTest;
		
		/**
		 * 获取所有的格子数据.
		 */
		function get gridData():BitmapData;
		
		/**
		 * 根据当前的绘制区域获取对应的格子.
		 * @param target 当前选中的格子.
		 * @return 位于绘制区域中的格子.
		 */
		function getDrawArea(target:Point):Vector.<Point>;
		
		/**
		 * 根据两个格子获取该两个格子连成的直线经过的所有格子.
		 * @param gridCell1 第一个格子.
		 * @param gridCell2 第二个格子.
		 * @return 该两个格子连成的直线经过的所有格子.
		 */
		function getLineArea(gridCell1:Point, gridCell2:Point):Vector.<Point>;
		
		/**
		 * 设置指定格子是否被设置为选中.
		 * @param row 行数.
		 * @param column 列数.
		 * @param selected 是否选中.
		 */
		function setGridCellSelect(row:int, column:int, selected:Boolean):void;
		
		/**
		 * 撤销一次操作.
		 * @return 撤销是否成功.
		 */
		function undo():Boolean;
		
		/**
		 * 重做一次操作.
		 * @return 重做是否成功.
		 */
		function redo():Boolean;
		
		/**
		 * 侦听下次显示列表的绘制.
		 */
		function callRedraw():void;
		
		/**
		 * 读取数据.
		 * @param input 输入流对象.
		 */
		function readFromBytes(bytes:ByteArray):void;
		
		/**
		 * 写入数据.
		 * @param output 输出流对象.
		 */
		function writeToBytes():ByteArray;
	}
}
