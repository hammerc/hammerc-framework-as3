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
	public interface IInvalidating
	{
		/**
		 * 
		 */
		function invalidateProperties():void;
		
		/**
		 * 
		 */
		function invalidateSize():void;
		
		/**
		 * 
		 */
		function invalidateDisplayList():void;
		
		/**
		 * 
		 */
		function validateNow(skipDisplayList:Boolean = false):void;
	}
}
