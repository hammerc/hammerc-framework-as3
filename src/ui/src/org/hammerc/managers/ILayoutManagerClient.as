/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	/**
	 * 
	 * @author wizardc
	 */
	public interface ILayoutManagerClient
	{
		/**
		 * 
		 */
		function set initialized(value:Boolean):void;
		function get initialized():Boolean;
		
		/**
		 * 
		 */
		function get hasParent():Boolean;
		
		/**
		 * 
		 */
		function set nestLevel(value:int):void;
		function get nestLevel():int;
		
		/**
		 * 
		 */
		function set updateCompletePendingFlag(value:Boolean):void;
		function get updateCompletePendingFlag():Boolean;
		
		/**
		 * 
		 */
		function validateProperties():void;
		
		/**
		 * 
		 * @param recursive 
		 */
		function validateSize(recursive:Boolean = false):void;
		
		/**
		 * 
		 */
		function validateDisplayList():void;
	}
}
