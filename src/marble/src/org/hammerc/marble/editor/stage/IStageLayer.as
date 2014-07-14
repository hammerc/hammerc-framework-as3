/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.stage
{
	import org.hammerc.display.IRepaint;
	
	/**
	 * <code>IStageLayer</code> 接口定义了舞台层应有的属性和方法.
	 * @author wizardc
	 */
	public interface IStageLayer extends IRepaint
	{
		/**
		 * 设置或获取层名称.
		 */
		function set name(value:String):void;
		function get name():String;
		
		/**
		 * 设置或获取是否显示层对象.
		 */
		function set show(value:Boolean):void;
		function get show():Boolean;
		
		/**
		 * 设置或获取是否锁定层对象.
		 */
		function set lock(value:Boolean):void;
		function get lock():Boolean;
		
		/**
		 * 层对象被添加到舞台时调用该方法.
		 */
		function onAdd():void;
		
		/**
		 * 层对象被从舞台移除时调用该方法.
		 */
		function onRemove():void;
	}
}
