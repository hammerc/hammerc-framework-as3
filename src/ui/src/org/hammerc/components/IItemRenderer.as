// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components
{
	import org.hammerc.core.IUIComponent;
	
	/**
	 * <code>IItemRenderer</code> 接口定义了列表类组件的项呈示器接口.
	 * @author wizardc
	 */
	public interface IItemRenderer extends IUIComponent
	{
		/**
		 * 要在项呈示器中显示的字符串.
		 */
		function set label(value:String):void;
		function get label():String;
		
		/**
		 * 设置或获取要呈示或编辑的数据.
		 * <p>刷新数据时也通过赋值完成, 所以内部不要作如下判断: <code>if(_data == value)return;</code>.</p>
		 */
		function set data(value:Object):void;
		function get data():Object;
		
		/**
		 * 设置或获取如果项呈示器可以将其自身显示为已选中, 则为 true.
		 */
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		
		/**
		 * 设置或获取项呈示器的主机组件的数据提供程序中的项目索引.
		 */
		function set itemIndex(value:int):void;
		function get itemIndex():int;
	}
}
