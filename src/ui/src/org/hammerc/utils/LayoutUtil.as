/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	import flash.display.DisplayObjectContainer;
	
	import org.hammerc.core.IUIComponent;
	
	/**
	 * <code>LayoutUtil</code> 类为布局工具类.
	 * @author wizardc
	 */
	public class LayoutUtil
	{
		/**
		 * 根据对象当前的xy坐标调整其相对位置属性, 使其在下一次的父级布局中过程中保持当前位置不变.
		 * @param element 要调整相对位置属性的对象.
		 * @param parent element 的父级容器. 若不设置, 则取 element.parent 的值. 若两者的值都为空, 则放弃调整.
		 */
		public static function adjustRelativeByXY(element:IUIComponent, parent:DisplayObjectContainer = null):void
		{
			if(element == null)
			{
				return;
			}
			if(parent == null)
			{
				parent = element.parent;
			}
			if(parent == null)
			{
				return;
			}
			var x:Number = element.x;
			var y:Number = element.y;
			var h:Number = element.layoutBoundsHeight;
			var w:Number = element.layoutBoundsWidth;
			var parentW:Number = parent.width;
			var parentH:Number = parent.height;
			if(!isNaN(element.left))
			{
				element.left = x;
			}
			if(!isNaN(element.right))
			{
				element.right = parentW - x - w;
			}
			if(!isNaN(element.horizontalCenter))
			{
				element.horizontalCenter = x + w * 0.5 - parentW * 0.5;
			}
			if(!isNaN(element.top))
			{
				element.top = y;
			}
			if(!isNaN(element.bottom))
			{
				element.bottom = parentH - y - h;
			}
			if(!isNaN(element.verticalCenter))
			{
				element.verticalCenter = h * 0.5 - parentH * 0.5 + y;
			}
		}
	}
}
