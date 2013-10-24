/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.hammerc.components.supportClasses.ScrollBarBase;
	import org.hammerc.core.IInvalidating;
	import org.hammerc.core.IViewport;
	import org.hammerc.core.NavigationUnit;
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.events.PropertyChangeEvent;
	import org.hammerc.events.ResizeEvent;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>VScrollBar</code> 实现了垂直滚动条组件.
	 * @author wizardc
	 */
	public class VScrollBar extends ScrollBarBase
	{
		/**
		 * 创建一个 <code>VScrollBar</code> 对象.
		 */
		public function VScrollBar()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return VScrollBar;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set viewport(newViewport:IViewport):void
		{
			const oldViewport:IViewport = super.viewport;
			if(oldViewport == newViewport)
			{
				return;
			}
			if(oldViewport != null)
			{
				oldViewport.removeEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
				this.removeEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
			}
			super.viewport = newViewport;
			if(newViewport != null)
			{
				updateMaximumAndPageSize();
				this.value = newViewport.verticalScrollPosition;
				newViewport.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
				this.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
			}
		}
		
		/**
		 * 更新最大值和分页大小.
		 */
		private function updateMaximumAndPageSize():void
		{
			var vsp:Number = this.viewport.verticalScrollPosition;
			var viewportHeight:Number = isNaN(this.viewport.height) ? 0 : this.viewport.height;
			var cHeight:Number = this.viewport.contentHeight;
			this.maximum = (cHeight == 0) ? vsp : cHeight - viewportHeight;
			this.pageSize = viewportHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function pointToValue(x:Number, y:Number):Number
		{
			if(thumb == null || track == null)
			{
				return 0;
			}
			var r:Number = track.layoutBoundsHeight - thumb.layoutBoundsHeight;
			return this.minimum + ((r != 0) ? (y / r) * (this.maximum - this.minimum) : 0); 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateSkinDisplayList():void
		{
			if(thumb == null || track == null)
			{
				return;
			}
			var trackSize:Number = track.layoutBoundsHeight;
			var range:Number = this.maximum - this.minimum;
			var thumbPos:Point;
			var thumbPosTrackY:Number = 0;
			var thumbPosParentY:Number = 0;
			var thumbSize:Number = trackSize;
			if(range > 0)
			{
				if(this.fixedThumbSize === false)
				{
					thumbSize = Math.min((this.pageSize / (range + this.pageSize)) * trackSize, trackSize)
					thumbSize = Math.max(thumb.minHeight, thumbSize);
				}
				else
				{
					thumbSize = thumb ? thumb.height : 0;
				}
				thumbPosTrackY = (this.value - this.minimum) * ((trackSize - thumbSize) / range);
			}
			if(this.fixedThumbSize === false)
			{
				thumb.height = Math.ceil(thumbSize);
			}
			if(this.autoThumbVisibility === true)
			{
				thumb.visible = thumbSize < trackSize;
			}
			thumbPos = track.localToGlobal(new Point(0, thumbPosTrackY));
			thumbPosParentY = thumb.parent.globalToLocal(thumbPos).y;
			thumb.setLayoutBoundsPosition(thumb.layoutBoundsX, Math.round(thumbPosParentY));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setValue(value:Number):void
		{
			super.setValue(value);
			if(this.viewport != null)
			{
				this.viewport.verticalScrollPosition = value;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function changeValueByPage(increase:Boolean = true):void
		{
			var oldPageSize:Number;
			if(this.viewport != null)
			{
				oldPageSize = this.pageSize;
				this.pageSize = Math.abs(this.viewport.getVerticalScrollPositionDelta((increase) ? NavigationUnit.PAGE_DOWN : NavigationUnit.PAGE_UP));
			}
			super.changeValueByPage(increase);
			if(this.viewport != null)
			{
				this.pageSize = oldPageSize;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function changeValueByStep(increase:Boolean = true):void
		{
			var oldStepSize:Number;
			if(this.viewport != null)
			{
				oldStepSize = this.stepSize;
				this.stepSize = Math.abs(this.viewport.getVerticalScrollPositionDelta((increase) ? NavigationUnit.DOWN : NavigationUnit.UP));
			}
			super.changeValueByStep(increase);
			if(this.viewport != null)
			{
				this.stepSize = oldStepSize;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(instance == thumb)
			{
				thumb.top = undefined;
				thumb.bottom = undefined;
				thumb.verticalCenter = undefined;
			}
			super.partAdded(partName, instance);
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function viewport_verticalScrollPositionChangeHandler(event:PropertyChangeEvent):void
		{
			if(this.viewport != null)
			{
				this.value = this.viewport.verticalScrollPosition;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function viewport_resizeHandler(event:ResizeEvent):void
		{
			if(this.viewport != null)
			{
				updateMaximumAndPageSize();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function viewport_contentHeightChangeHandler(event:PropertyChangeEvent):void
		{
			if(this.viewport != null)
			{
				var viewportHeight:Number = isNaN(this.viewport.height) ? 0 : this.viewport.height;
				this.maximum = this.viewport.contentHeight - this.viewport.height;
			}
		}
		
		/**
		 * 根据 event.delta 滚动指定步数的距离.
		 */
		hammerc_internal function mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = viewport;
			if(event.isDefaultPrevented() || vp == null || !vp.visible || !this.visible)
			{
				return;
			}
			var nSteps:uint = Math.abs(event.delta);
			var navigationUnit:uint;
			navigationUnit = (event.delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
			for(var vStep:int = 0; vStep < nSteps; vStep++)
			{
				var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
				if(!isNaN(vspDelta))
				{
					vp.verticalScrollPosition += vspDelta;
					if(vp is IInvalidating)
					{
						IInvalidating(vp).validateNow();
					}
				}
			}
			event.preventDefault();
		}
	}
}
