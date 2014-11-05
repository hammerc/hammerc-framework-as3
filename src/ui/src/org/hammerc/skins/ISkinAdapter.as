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
	import flash.display.DisplayObject;
	
	/**
	 * <code>ISkinAdapter</code> 接口定义了皮肤适配器的接口.
	 * <p>若项目需要自定义可设置外观组件的解析规则, 需要实现这个接口, 然后调用 <code>Injector.mapClass</code> 注入到框架即可.</p>
	 * @author wizardc
	 */
	public interface ISkinAdapter
	{
		/**
		 * 获取皮肤显示对象.
		 * @param skinName 待解析的新皮肤标识符.
		 * @param compFunc 解析完成回调函数.
		 * <p>示例: <code>compFunc(skin:Object, skinName:Object):void;</code></p>
		 * <p>回调参数 skin 若为显示对象将直接被添加到显示列表, 其他对象根据项目自定义组件的具体规则解析.</p>
		 * @param oldSkin 旧的皮肤显示对象, 传入值有可能为 null. 对于某些类型素材, 例如 <code>Bitmap</code>, 可以重用传入的显示对象, 只修改其数据再返回.
		 */
		function getSkin(skinName:Object, compFunc:Function, oldSkin:DisplayObject = null):void;
	}
}
