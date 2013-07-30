/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.core
{
	/**
	 * <code>ILayoutElement</code> 接口定义了可布局元素的接口.
	 * @author wizardc
	 */
	public interface ILayoutElement
	{
		/**
		 * 设置或获取此组件是否包含在父容器的布局中. 若为 false, 则父级容器在测量和布局阶段都忽略此组件.
		 * <p>注意: <code>visible</code> 属性与此属性不同, 设置 <code>visible</code> 为 false, 父级容器仍会对其布局.</p>
		 */
		function set includeInLayout(value:Boolean):void;
		function get includeInLayout():Boolean;
		
		/**
		 * 设置或获取距父级容器顶部距离.
		 */
		function set top(value:Number):void;
		function get top():Number;
		
		/**
		 * 设置或获取距父级容器底部距离.
		 */
		function set bottom(value:Number):void;
		function get bottom():Number;
		
		/**
		 * 设置或获取距父级容器离左边距离.
		 */
		function set left(value:Number):void;
		function get left():Number;
		
		/**
		 * 设置或获取距父级容器右边距离.
		 */
		function set right(value:Number):void;
		function get right():Number;
		
		/**
		 * 设置或获取在父级容器中距水平中心位置的距离.
		 */
		function set horizontalCenter(value:Number):void;
		function get horizontalCenter():Number;
		
		/**
		 * 设置或获取在父级容器中距竖直中心位置的距离.
		 */
		function set verticalCenter(value:Number):void;
		function get verticalCenter():Number;
		
		/**
		 * 设置或获取相对父级容器宽度的百分比.
		 */
		function set percentWidth(value:Number):void;
		function get percentWidth():Number;
		
		/**
		 * 设置或获取相对父级容器高度的百分比.
		 */
		function set percentHeight(value:Number):void;
		function get percentHeight():Number;
		
		/**
		 * 获取组件的首选 x 坐标, 常用于父级的 <code>measure()</code> 方法中.
		 */
		function get preferredX():Number;
		
		/**
		 * 获取组件的首选 y 坐标, 常用于父级的 <code>measure()</code> 方法中.
		 */
		function get preferredY():Number;
		
		/**
		 * 获取组件水平方向起始坐标.
		 */
		function get layoutBoundsX():Number;
		
		/**
		 * 获取组件竖直方向起始坐标.
		 */
		function get layoutBoundsY():Number;
		
		/**
		 * 获取组件的首选宽度, 常用于父级的 <code>measure()</code> 方法中.
		 * <p>按照: 外部显式设置宽度 -> 测量宽度的优先级顺序返回宽度.</p>
		 * <p>注意: 此数值已经包含了 <code>scaleX</code> 的值</p>
		 */
		function get preferredWidth():Number;
		
		/**
		 * 获取组件的首选高度, 常用于父级的 <code>measure()</code> 方法中.
		 * <p>按照: 外部显式设置高度 -> 测量高度的优先级顺序返回宽度.</p>
		 * <p>注意: 此数值已经包含了 <code>scaleY</code> 的值</p>
		 */
		function get preferredHeight():Number;
		
		/**
		 * 获取组件的布局宽度, 常用于父级的 <code>updateDisplayList()</code> 方法中.
		 * <p>按照: 布局宽度 -> 外部显式设置宽度 -> 测量宽度的优先级顺序返回宽度.</p>
		 * <p>注意: 此数值已经包含了 <code>scaleX</code> 的值</p>
		 */
		function get layoutBoundsWidth():Number;
		
		/**
		 * 获取组件的布局高度, 常用于父级的 <code>updateDisplayList()</code> 方法中.
		 * <p>按照: 布局高度 -> 外部显式设置高度 -> 测量高度的优先级顺序返回宽度.</p>
		 * <p>注意: 此数值已经包含了 <code>scaleY</code> 的值</p>
		 */
		function get layoutBoundsHeight():Number;
		
		/**
		 * 获取水平缩放比例.
		 */
		function get scaleX():Number;
		
		/**
		 * 获取垂直缩放比例.
		 */
		function get scaleY():Number;
		
		/**
		 * 设置或获取组件的最大测量宽度.
		 * <p>注意: 若设置了 <code>percentWidth</code>, 或同时设置 <code>left</code> 和 <code>right</code>, 则此属性无效.</p>
		 */
		function set maxWidth(value:Number):void;
		function get maxWidth():Number;
		
		/**
		 * 设置或获取组件的最小测量宽度.
		 * <p>注意: 若设置了 <code>percentWidth</code>, 或同时设置 <code>left</code> 和 <code>right</code>, 则此属性无效.</p>
		 * <p>注意: 若此属性设置为大于 <code>maxWidth</code> 的值时, 则也无效.</p>
		 */
		function set minWidth(value:Number):void;
		function get minWidth():Number;
		
		/**
		 * 设置或获取组件的最大测量高度.
		 * <p>注意: 若设置了 <code>percentHeight</code>, 或同时设置 <code>top</code> 和 <code>bottom</code>, 则此属性无效.</p>
		 */
		function set maxHeight(value:Number):void;
		function get maxHeight():Number;
		
		/**
		 * 设置或获取组件的最小测量高度.
		 * <p>注意: 若设置了 <code>percentHeight</code>, 或同时设置 <code>top</code> 和 <code>bottom</code>, 则此属性无效.</p>
		 * <p>注意: 若此属性设置为大于 <code>maxHeight</code> 的值时, 则也无效.</p>
		 */
		function set minHeight(value:Number):void;
		function get minHeight():Number;
		
		/**
		 * 设置组件的布局宽高, 此值应已包含 <code>scaleX</code>, <code>scaleY</code> 的值.
		 * @param width 宽度.
		 * @param height 高度.
		 */
		function setLayoutBoundsSize(width:Number, height:Number):void;
		
		/**
		 * 设置组件的布局位置.
		 * @param x x 坐标.
		 * @param y y 坐标.
		 */
		function setLayoutBoundsPosition(x:Number, y:Number):void;
	}
}
