/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.managers
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	import org.hammerc.core.IUIContainer;
	
	/**
	 * 
	 * @author wizardc
	 */
	public interface ISystemManager extends IEventDispatcher
	{
		/**
		 * 
		 * @return 
		 */
		function get stage():Stage;
		
		/**
		 * 
		 * @return 
		 */
		function get popUpContainer():IUIContainer;
		
		/**
		 * 
		 * @return 
		 */
		function get toolTipContainer():IUIContainer;
		
		/**
		 * 
		 * @return 
		 */
		function get cursorContainer():IUIContainer;
	}
}
