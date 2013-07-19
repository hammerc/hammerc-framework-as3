/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.managers.ILayoutManagerClient;
	import org.hammerc.managers.ISystemManager;
	import org.hammerc.managers.IToolTipManagerClient;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>UIComponent</code> 
	 * @author wizardc
	 */
	public class UIComponent extends Sprite implements IUIComponent, IInvalidating, 
		ILayoutManagerClient, ILayoutElement, IToolTipManagerClient
	{
		/**
		 * 
		 */
		public function UIComponent()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():Object
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function ownerChanged(value:Object):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set systemManager(value:ISystemManager):void
		{
			
		}
		public function get systemManager():ISystemManager
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			
		}
		public function get enabled():Boolean
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focusEnabled(value:Boolean):void
		{
			
		}
		public function get focusEnabled():Boolean
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get explicitWidth():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get explicitHeight():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set isPopUp(value:Boolean):void
		{
			
		}
		public function get isPopUp():Boolean
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setActualSize(newWidth:Number, newHeight:Number):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setFocus():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateProperties():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateSize():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateDisplayList():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateNow(skipDisplayList:Boolean = false):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set initialized(value:Boolean):void
		{
			
		}
		public function get initialized():Boolean
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasParent():Boolean
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set nestLevel(value:int):void
		{
			
		}
		public function get nestLevel():int
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set updateCompletePendingFlag(value:Boolean):void
		{
			
		}
		public function get updateCompletePendingFlag():Boolean
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateProperties():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateSize(recursive:Boolean = false):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateDisplayList():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set includeInLayout(value:Boolean):void
		{
			
		}
		public function get includeInLayout():Boolean
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set top(value:Number):void
		{
			
		}
		public function get top():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bottom(value:Number):void
		{
			
		}
		public function get bottom():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set left(value:Number):void
		{
			
		}
		public function get left():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set right(value:Number):void
		{
			
		}
		public function get right():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set horizontalCenter(value:Number):void
		{
			
		}
		public function get horizontalCenter():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set verticalCenter(value:Number):void
		{
			
		}
		public function get verticalCenter():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set percentWidth(value:Number):void
		{
			
		}
		public function get percentWidth():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set percentHeight(value:Number):void
		{
			
		}
		public function get percentHeight():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredX():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredY():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get layoutBoundsX():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get layoutBoundsY():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredWidth():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get layoutBoundsWidth():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get layoutBoundsHeight():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scaleX():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function get scaleY():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set maxWidth(value:Number):void
		{
			
		}
		public function get maxWidth():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minWidth(value:Number):void
		{
			
		}
		public function get minWidth():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set maxHeight(value:Number):void
		{
			
		}
		public function get maxHeight():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minHeight(value:Number):void
		{
			
		}
		public function get minHeight():Number
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutBoundsSize(width:Number,height:Number):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutBoundsPosition(x:Number,y:Number):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTip(value:Object):void
		{
			
		}
		public function get toolTip():Object
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTipRenderer(value:Class):void
		{
			
		}
		public function get toolTipRenderer():Class
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTipPosition(value:String):void
		{
			
		}
		public function get toolTipPosition():String
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTipOffset(value:Point):void
		{
			
		}
		public function get toolTipOffset():Point
		{
			
		}
	}
}
