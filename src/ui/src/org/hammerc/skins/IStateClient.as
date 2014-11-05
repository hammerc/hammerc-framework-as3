// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.skins
{
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>IStateClient</code> 接口定义了具有视图状态组件的接口.
	 * @author wizardc
	 */
	public interface IStateClient extends IEventDispatcher
	{
		/**
		 * 设置或获取组件的当前视图状态.
		 * <p>将其设置为 "" 或 null 可将组件重置回其基本状态.</p>
		 */
		function set currentState(value:String):void;
		function get currentState():String;
		
		/**
		 * 设置或获取此组件定义的视图状态.
		 */
		function set states(value:Array):void;
		function get states():Array;
		
		/**
		 * 返回是否含有指定名称的视图状态.
		 * @param stateName 要检测的视图状态名称.
		 */
		function hasState(stateName:String):Boolean;
	}
}
