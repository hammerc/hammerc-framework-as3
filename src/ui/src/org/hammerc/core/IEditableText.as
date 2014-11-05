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
	 * <code>IEditableText</code> 接口定义了可编辑文本组件的接口.
	 * @author wizardc
	 */
	public interface IEditableText extends IText
	{
		/**
		 * 设置或获取文本颜色.
		 */
		function set textColor(value:uint):void;
		function get textColor():uint;
		
		/**
		 * 设置或获取指定文本字段是否是密码文本字段.
		 */
		function set displayAsPassword(value:Boolean):void;
		function get displayAsPassword():Boolean;
		
		/**
		 * 设置或获取文本是否可编辑的标志.
		 */
		function set editable(value:Boolean):void;
		function get editable():Boolean;
		
		/**
		 * 设置或获取文本字段中最多可包含的字符数.
		 */
		function set maxChars(value:int):void;
		function get maxChars():int;
		
		/**
		 * 设置或获取字段是否为多行文本字段.
		 */
		function set multiline(value:Boolean):void;
		function get multiline():Boolean;
		
		/**
		 * 设置或获取用户可输入到文本字段中的字符集.
		 */
		function set restrict(value:String):void;
		function get restrict():String;
		
		/**
		 * 设置或获取文本字段是否可选.
		 */
		function set selectable(value:Boolean):void;
		function get selectable():Boolean;
		
		/**
		 * 获取当前所选内容中第一个字符从零开始的字符索引值. 如果未选定任何文本, 此属性为 <code>caretIndex</code> 的值.
		 */
		function get selectionBeginIndex():int;
		
		/**
		 * 设置或获取当前所选内容中最后一个字符从零开始的字符索引值. 如果未选定任何文本, 此属性为 <code>caretIndex</code> 的值.
		 */
		function get selectionEndIndex():int;
		
		/**
		 * 获取插入点位置的索引.
		 */
		function get caretIndex():int;
		
		/**
		 * 设置或获取控件的默认宽度 (使用字号为单位测量). 若同时设置了 <code>maxChars</code> 属性, 将会根据两者测量结果的最小值作为测量宽度.
		 */
		function set widthInChars(value:Number):void;
		function get widthInChars():Number;
		
		/**
		 * 设置或获取控件的默认高度 (以行为单位测量). 若设置了 <code>multiline</code> 属性为 false, 则忽略此属性.
		 */
		function set heightInLines(value:Number):void;
		function get heightInLines():Number;
		
		/**
		 * 可视区域水平方向起始点.
		 */
		function set horizontalScrollPosition(value:Number):void;
		function get horizontalScrollPosition():Number;
		
		/**
		 * 可视区域竖直方向起始点.
		 */
		function set verticalScrollPosition(value:Number):void;
		function get verticalScrollPosition():Number;
		
		/**
		 * 将第一个字符和最后一个字符的索引值指定的文本设置为所选内容.
		 * @param beginIndex 所选内容中第一个字符从零开始的索引值.
		 * @param endIndex 所选内容中最后一个字符从零开始的索引值.
		 */
		function setSelection(beginIndex:int, endIndex:int):void;
		
		/**
		 * 选中所有文本.
		 */
		function selectAll():void;
	}
}
