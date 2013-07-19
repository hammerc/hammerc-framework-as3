/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.core
{
	/**
	 * 
	 * @author wizardc
	 */
	public interface ILayoutElement
	{
		/**
		 * 
		 */
		function set includeInLayout(value:Boolean):void;
		function get includeInLayout():Boolean;
		
		/**
		 * 
		 */
		function set top(value:Number):void;
		function get top():Number;
		
		/**
		 * 
		 */
		function set bottom(value:Number):void;
		function get bottom():Number;
		
		/**
		 * 
		 */
		function set left(value:Number):void;
		function get left():Number;
		
		/**
		 * 
		 */
		function set right(value:Number):void;
		function get right():Number;
		
		/**
		 * 
		 */
		function set horizontalCenter(value:Number):void;
		function get horizontalCenter():Number;
		
		/**
		 * 
		 */
		function set verticalCenter(value:Number):void;
		function get verticalCenter():Number;
		
		/**
		 * 
		 */
		function set percentWidth(value:Number):void;
		function get percentWidth():Number;
		
		/**
		 * 
		 */
		function set percentHeight(value:Number):void;
		function get percentHeight():Number;
		
		/**
		 * 
		 */
		function get preferredX():Number;
		
		/**
		 * 
		 */
		function get preferredY():Number;
		
		/**
		 * 
		 */
		function get layoutBoundsX():Number;
		
		/**
		 * 
		 */
		function get layoutBoundsY():Number;
		
		/**
		 * 
		 */
		function get preferredWidth():Number;
		
		/**
		 * 
		 */
		function get preferredHeight():Number;
		
		/**
		 * 
		 */
		function get layoutBoundsWidth():Number;
		
		/**
		 * 
		 */
		function get layoutBoundsHeight():Number;
		
		/**
		 * 
		 */
		function get scaleX():Number;
		
		/**
		 * 
		 */
		function get scaleY():Number;
		
		/**
		 * 
		 */
		function set maxWidth(value:Number):void;
		function get maxWidth():Number;
		
		/**
		 * 
		 */
		function set minWidth(value:Number):void;
		function get minWidth():Number;
		
		/**
		 * 
		 */
		function set maxHeight(value:Number):void;
		function get maxHeight():Number;
		
		/**
		 * 
		 */
		function set minHeight(value:Number):void;
		function get minHeight():Number;
		
		/**
		 * 
		 */
		function setLayoutBoundsSize(width:Number,height:Number):void;
		
		/**
		 * 
		 */
		function setLayoutBoundsPosition(x:Number,y:Number):void;
	}
}
