/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.core
{
	import flash.display.IBitmapDrawable;
	import flash.events.IEventDispatcher;
	
	/**
	 * <code>IVisualElement</code> 
	 * @author wizardc
	 */
	public interface IVisualElement extends IEventDispatcher, IBitmapDrawable
	{
		/**
		 * 
		 */
		function get owner():Object;
		
		/**
		 * 
		 * @param value 
		 */
		function ownerChanged(value:Object):void;
	}
}
