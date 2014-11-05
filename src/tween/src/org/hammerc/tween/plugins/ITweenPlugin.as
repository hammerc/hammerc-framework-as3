// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.tween.plugins
{
	/**
	 * <code>ITweenPlugin</code> 接口定义了缓动补丁的所有方法.
	 * @author wizardc
	 */
	public interface ITweenPlugin
	{
		/**
		 * 获取该补丁关联的键名.
		 */
		function get key():String;
		
		/**
		 * 检测目标对象是否被该补丁支持.
		 * @param target 目标对象.
		 * @return 目标对象是否被该补丁支持.
		 */
		function checkSupport(target:Object):Boolean;
		
		/**
		 * 初始化补丁.
		 * @param target 目标对象.
		 * @param variables 具体的目标状态属性.
		 * @param moveMode 移动模式.
		 */
		function initPlugin(target:Object, variables:Object, moveMode:int):void;
		
		/**
		 * 每进入一帧都会调用该方法进行更新.
		 * @param baseValue 缓动的基数.
		 */
		function update(baseValue:Number):void;
		
		/**
		 * 更新补丁对象的缓动项目.
		 * @param variables 具体的目标状态属性.
		 * @param moveMode 移动模式.
		 */
		function updateVariables(variables:Object, moveMode:int):void;
		
		/**
		 * 移除补丁对象的缓动项目.
		 * @param variables 要移除的目标属性. 如果移除一个属性并希望设置该属性的值 <code>{a:100}</code> 这样属性 a 会在被移除的同时设置为 100, 如果希望该属性回到缓动前的值 <code>{a:false}</code> 这样属性 a 会在被移除的同时设置回缓动前的值, 如果希望该属性停留在移除前的缓动值 <code>{a:true}</code> 这样属性 a 会停止进行缓动.
		 */
		function removeVariables(variables:Object):void;
	}
}
