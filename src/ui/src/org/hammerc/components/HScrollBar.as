// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

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
	 * <code>HScrollBar</code> 类实现了水平滚动条组件.
	 * @author wizardc
	 */
	public class HScrollBar extends ScrollBarBase
	{
		/**
		 * 创建一个 <code>HScrollBar</code> 对象.
		 */
		public function HScrollBar()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return HScrollBar;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get defaultStyleName():String
		{
			return "HScrollBar";
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
				this.removeEventListener(MouseEvent.MOUSE_WHEEL, this.hsb_mouseWheelHandler, true);
			}
			super.viewport = newViewport;
			if(newViewport != null)
			{
				updateMaximumAndPageSize();
				this.value = newViewport.horizontalScrollPosition;
				newViewport.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler, false, -50);
				this.addEventListener(MouseEvent.MOUSE_WHEEL, this.hsb_mouseWheelHandler, true); 
			}
		}
		
		/**
		 * 更新最大值和分页大小.
		 */
		private function updateMaximumAndPageSize():void
		{
			var hsp:Number = viewport.horizontalScrollPosition;
			var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
			var cWidth:Number = viewport.contentWidth;
			this.maximum = (cWidth == 0) ? hsp : cWidth - viewportWidth;
			this.pageSize = viewportWidth;
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
			var r:Number = track.layoutBoundsWidth - thumb.layoutBoundsWidth;
			return this.minimum + ((r != 0) ? (x / r) * (this.maximum - this.minimum) : 0);
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
			var trackSize:Number = track.layoutBoundsWidth;
			var range:Number = this.maximum - this.minimum;
			var thumbPos:Point;
			var thumbPosTrackX:Number = 0;
			var thumbPosParentX:Number = 0;
			var thumbSize:Number = trackSize;
			if(range > 0)
			{
				if(fixedThumbSize === false)
				{
					thumbSize = Math.min((this.pageSize / (range + this.pageSize)) * trackSize, trackSize)
					thumbSize = Math.max(thumb.minWidth, thumbSize);
				}
				else
				{
					thumbSize = thumb ? thumb.width : 0;
				}
				thumbPosTrackX = (value - this.minimum) * ((trackSize - thumbSize) / range);
			}
			if(this.fixedThumbSize === false)
			{
				thumb.width = Math.ceil(thumbSize);
			}
			if(this.autoThumbVisibility === true)
			{
				thumb.visible = thumbSize < trackSize;
			}
			thumbPos = track.localToGlobal(new Point(thumbPosTrackX, 0));
			thumbPosParentX = thumb.parent.globalToLocal(thumbPos).x;
			thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX), thumb.layoutBoundsY);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function setValue(value:Number):void
		{
			super.setValue(value);
			if(this.viewport != null)
			{
				this.viewport.horizontalScrollPosition = value;
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
				this.pageSize = Math.abs(this.viewport.getHorizontalScrollPositionDelta((increase) ? NavigationUnit.PAGE_RIGHT : NavigationUnit.PAGE_LEFT));
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
				this.stepSize = Math.abs(this.viewport.getHorizontalScrollPositionDelta((increase) ? NavigationUnit.RIGHT : NavigationUnit.LEFT));
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
				thumb.left = undefined;
				thumb.right = undefined;
				thumb.horizontalCenter = undefined;
			}
			super.partAdded(partName, instance);
		}
		
		/**
		 * @inheritDoc
		 */
		override hammerc_internal function viewport_horizontalScrollPositionChangeHandler(event:PropertyChangeEvent):void
		{
			if(this.viewport != null)
			{
				this.value = this.viewport.horizontalScrollPosition;
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
		override hammerc_internal function viewport_contentWidthChangeHandler(event:PropertyChangeEvent):void
		{
			if(this.viewport != null)
			{
				var viewportWidth:Number = isNaN(this.viewport.width) ? 0 : this.viewport.width;        
				this.maximum = this.viewport.contentWidth - viewportWidth;
			}
		}
		
		/**
		 * 根据 event.delta 滚动指定步数的距离. 这个事件处理函数优先级比垂直滚动条的低.
		 */
		hammerc_internal function mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = this.viewport;
			if(event.isDefaultPrevented() || vp == null || !vp.visible || !this.visible)
			{
				return;
			}
			var nSteps:uint = _useMouseWheelDelta ? Math.abs(event.delta) : 1;
			var navigationUnit:uint;
			navigationUnit = (event.delta < 0) ? NavigationUnit.RIGHT : NavigationUnit.LEFT;
			for(var hStep:int = 0; hStep < nSteps; hStep++)
			{
				var hspDelta:Number = vp.getHorizontalScrollPositionDelta(navigationUnit);
				if(!isNaN(hspDelta))
				{
					vp.horizontalScrollPosition += hspDelta;
					if(vp is IInvalidating)
					{
						IInvalidating(vp).validateNow();
					}
				}
			}
			event.preventDefault();
		}
		
		private function hsb_mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = this.viewport;
			if(event.isDefaultPrevented() || vp == null || !vp.visible)
			{
				return;
			}
			event.stopImmediatePropagation();
			vp.dispatchEvent(event);
		}
	}
}
