/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.hammerc.events.MoveEvent;
	import org.hammerc.events.PropertyChangeEvent;
	import org.hammerc.events.ResizeEvent;
	import org.hammerc.events.UIEvent;
	import org.hammerc.managers.ILayoutManagerClient;
	import org.hammerc.managers.ISystemManager;
	import org.hammerc.managers.IToolTipManagerClient;
	import org.hammerc.managers.ToolTipManager;
	
	use namespace hammerc_internal;
	
	/**
	 * @eventType org.hammerc.events.ResizedEvent.MOVE
	 */
	[Event(name="move", type="org.hammerc.events.MoveEvent")]
	
	/**
	 * @eventType org.hammerc.events.ResizeEvent.RESIZE
	 */
	[Event(name="resize", type="org.hammerc.events.ResizeEvent")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.INITIALIZE
	 */
	[Event(name="initialize", type="org.hammerc.events.UIEvent")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.CREATION_COMPLETE
	 */
	[Event(name="creationComplete", type="org.hammerc.events.UIEvent")]
	
	/**
	 * @eventType org.hammerc.events.UIEvent.UPDATE_COMPLETE
	 */
	[Event(name="updateComplete", type="org.hammerc.events.UIEvent")]
	
	/**
	 * @eventType org.hammerc.events.ToolTipEvent.TOOL_TIP_SHOW
	 */
	[Event(name="toolTipShow", type="org.hammerc.events.ToolTipEvent")]
	
	/**
	 * @eventType org.hammerc.events.ToolTipEvent.TOOL_TIP_HIDE
	 */
	[Event(name="toolTipHide", type="org.hammerc.events.ToolTipEvent")]
	
	/**
	 * @eventType org.hammerc.eventsDragEvent.DRAG_START
	 */
	[Event(name="dragStart", type="org.hammerc.events.DragEvent")]
	
	/**
	 * @eventType org.hammerc.eventsDragEvent.DRAG_COMPLETE
	 */
	[Event(name="dragComplete", type="org.hammerc.events.DragEvent")]
	
	/**
	 * @eventType org.hammerc.eventsDragEvent.DRAG_ENTER
	 */
	[Event(name="dragEnter", type="org.hammerc.events.DragEvent")]
	
	/**
	 * @eventType org.hammerc.eventsDragEvent.DRAG_OVER
	 */
	[Event(name="dragOver", type="org.hammerc.events.DragEvent")]
	
	/**
	 * @eventType org.hammerc.eventsDragEvent.DRAG_EXIT
	 */
	[Event(name="dragExit", type="org.hammerc.events.DragEvent")]
	
	/**
	 * @eventType org.hammerc.eventsDragEvent.DRAG_DROP
	 */
	[Event(name="dragDrop", type="org.hammerc.events.DragEvent")]
	
	/**
	 * <code>UIComponent</code> 类为所有组件的基类, 定义了组件的基本属性及方法.
	 * @author wizardc
	 */
	public class UIComponent extends Sprite implements IUIComponent, IInvalidating, ILayoutManagerClient, ILayoutElement, IToolTipManagerClient
	{
		/**
		 * 是否已经初始化.
		 */
		private var _initializeCalled:Boolean = false;
		private var _initialized:Boolean = false;
		
		private var _hasParent:Boolean = false;
		private var _owner:Object;
		
		private var _explicitWidth:Number = NaN;
		private var _explicitHeight:Number = NaN;
		
		private var _isPopUp:Boolean;
		
		private var _systemManager:ISystemManager;
		
		private var _enabled:Boolean = true;
		private var _focusEnabled:Boolean = false;
		
		private var _nestLevel:int = 0;
		private var _updateCompletePendingFlag:Boolean = false;
		
		hammerc_internal var _invalidatePropertiesFlag:Boolean = false;
		hammerc_internal var _invalidateSizeFlag:Boolean = false;
		hammerc_internal var _invalidateDisplayListFlag:Boolean = false;
		hammerc_internal var _validateNowFlag:Boolean = false;
		
		hammerc_internal var _width:Number;
		hammerc_internal var _height:Number;
		
		hammerc_internal var _oldX:Number;
		hammerc_internal var _oldY:Number;
		hammerc_internal var _oldWidth:Number;
		hammerc_internal var _oldHeight:Number;
		
		private var _measuredWidth:Number = 0;
		private var _measuredHeight:Number = 0;
		
		/**
		 * 上一次测量的首选宽度.
		 */
		hammerc_internal var _oldPreferWidth:Number;
		
		/**
		 * 上一次测量的首选高度.
		 */
		hammerc_internal var _oldPreferHeight:Number;
		
		hammerc_internal var _includeInLayout:Boolean = true;
		
		/**
		 * 父级布局管理器设置了组件的宽度标志, 尺寸设置优先级: 自动布局 -> 显式设置 -> 自动测量.
		 */
		hammerc_internal var _layoutWidthExplicitlySet:Boolean = false;
		
		/**
		 * 父级布局管理器设置了组件的高度标志, 尺寸设置优先级: 自动布局 -> 显式设置 -> 自动测量.
		 */
		hammerc_internal var _layoutHeightExplicitlySet:Boolean = false;
		
		private var _top:Number;
		private var _bottom:Number;
		private var _left:Number;
		private var _right:Number;
		private var _horizontalCenter:Number;
		private var _verticalCenter:Number;
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		
		private var _minWidth:Number = 0;
		private var _maxWidth:Number = 10000;
		private var _minHeight:Number = 0;
		private var _maxHeight:Number = 10000;
		
		private var _toolTip:Object;
		private var _toolTipRenderer:Class;
		private var _toolTipOffset:Point;
		private var _toolTipPosition:String = "mouse";
		
		/**
		 * 创建一个 <code>UIComponent</code> 对象.
		 */
		public function UIComponent()
		{
			super();
			this.focusRect = false;
			if(HammercGlobals.stage == null)
			{
				if(stage != null)
				{
					_hasParent = true;
					addedToStageHandler();
				}
				else
				{
					this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
				}
			}
			this.addEventListener(Event.ADDED, addedHandler);
		}
		
		private function addedToStageHandler(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			HammercGlobals.initlize(stage);
			checkInvalidateFlag();
		}
		
		private function addedHandler(event:Event):void
		{
			if(event.target == this)
			{
				this.removeEventListener(Event.ADDED, addedHandler);
				this.addEventListener(Event.REMOVED, removedHandler);
				_hasParent = true;
				checkInvalidateFlag();
				initialize();
			}
		}
		
		private function removedHandler(event:Event):void
		{
			if(event.target == this)
			{
				this.removeEventListener(Event.REMOVED, removedHandler);
				this.addEventListener(Event.ADDED, addedHandler);
				_nestLevel = 0;
				_hasParent = false;
				this.systemManager = null;
			}
		}
		
		private function initialize():void
		{
			if(_initializeCalled)
			{
				return;
			}
			_initializeCalled = true;
			this.dispatchEvent(new UIEvent(UIEvent.INITIALIZE));
			this.createChildren();
			this.childrenCreated();
		}
		
		/**
		 * 创建子项, 子类覆盖此方法以完成组件子项的初始化操作, 请务必调用 <code>super.createChildren()</code> 以完成父类组件的初始化.
		 */
		protected function createChildren():void
		{
		}
		
		/**
		 * 子项创建完成时调用.
		 */
		protected function childrenCreated():void
		{
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get owner():Object
		{
			return _owner? _owner : parent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function ownerChanged(value:Object):void
		{
			_owner = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set systemManager(value:ISystemManager):void
		{
			_systemManager = value;
			for(var i:int = 0, length:int = this.numChildren; i < length; i++)
			{
				var ui:IUIComponent = this.getChildAt(i) as IUIComponent;
				if(ui)
				{
					ui.systemManager = value;
				}
			}
		}
		public function get systemManager():ISystemManager
		{
			if(_systemManager == null)
			{
				if(this is ISystemManager)
				{
					_systemManager = ISystemManager(this);
				}
				else
				{
					var o:DisplayObjectContainer = this.parent;
					while(o)
					{
						var ui:IUIComponent = o as IUIComponent;
						if(ui)
						{
							_systemManager = ui.systemManager;
							break;
						}
						else if(o is ISystemManager)
						{
							_systemManager = o as ISystemManager;
							break;
						}
						o = o.parent;
					}
				}
			}
			return _systemManager;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			if(_enabled != value)
			{
				_enabled = value;
				this.dispatchEvent(new Event("enabledChanged"));
			}
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set doubleClickEnabled(value:Boolean):void
		{
			super.doubleClickEnabled = value;
			for(var i:int = 0, length:int = this.numChildren; i < length; i++)
			{
				var child:InteractiveObject = this.getChildAt(i) as InteractiveObject;
				if(child)
				{
					child.doubleClickEnabled = value;
				}
			}
		}
		override public function get doubleClickEnabled():Boolean
		{
			return super.doubleClickEnabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set focusEnabled(value:Boolean):void
		{
			_focusEnabled = value;
		}
		public function get focusEnabled():Boolean
		{
			return _focusEnabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set isPopUp(value:Boolean):void
		{
			_isPopUp = value;
		}
		public function get isPopUp():Boolean
		{
			return _isPopUp;
		}
		
		/**
		 * 设置或获取组件的默认宽度 (以像素为单位).
		 * <p>此值由 <code>measure()</code> 方法设置.</p>
		 */
		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;
		}
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		/**
		 * 设置或获取组件的默认高度 (以像素为单位).
		 * <p>此值由 <code>measure()</code> 方法设置.</p>
		 */
		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		/**
		 * 抛出属性值改变事件.
		 * @param prop 改变的属性名.
		 * @param oldValue 属性的原始值.
		 * @param value 属性的新值.
		 */
		protected function dispatchPropertyChangeEvent(property:String, oldValue:*, value:*):void
		{
			if(this.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
				this.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, value, oldValue, this, property));
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function setActualSize(newWidth:Number, newHeight:Number):void
		{
			var change:Boolean = false;
			if(_width != newWidth)
			{
				_width = newWidth;
				change = true;
			}
			if(_height != newHeight)
			{
				_height = newHeight;
				change = true;
			}
			if(change)
			{
				this.invalidateDisplayList();
				dispatchResizeEvent();
			}
		}
		
		/**
		 * 抛出尺寸改变事件.
		 */
		private function dispatchResizeEvent():void
		{
			if(this.hasEventListener(ResizeEvent.RESIZE))
			{
				var resizeEvent:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE, _oldWidth, _oldHeight);
				this.dispatchEvent(resizeEvent);
			}
			_oldWidth = _width;
			_oldHeight = _height;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setFocus():void
		{
			if(HammercGlobals.stage != null)
			{
				HammercGlobals.stage.focus = this;
			}
		}
		
		/**
		 * 检查属性失效标记并应用.
		 */
		private function checkInvalidateFlag():void
		{
			if(HammercGlobals.layoutManager == null)
			{
				return;
			}
			if(_invalidatePropertiesFlag)
			{
				HammercGlobals.layoutManager.invalidateProperties(this);
			}
			if(_invalidateSizeFlag)
			{
				HammercGlobals.layoutManager.invalidateSize(this);
			}
			if(_invalidateDisplayListFlag)
			{
				HammercGlobals.layoutManager.invalidateDisplayList(this);
			}
			if(_validateNowFlag)
			{
				HammercGlobals.layoutManager.validateClient(this);
				_validateNowFlag = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateProperties():void
		{
			if(!_invalidatePropertiesFlag)
			{
				_invalidatePropertiesFlag = true;
				if(_hasParent && HammercGlobals.layoutManager)
				{
					HammercGlobals.layoutManager.invalidateProperties(this);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateProperties():void
		{
			if(_invalidatePropertiesFlag)
			{
				commitProperties();
				_invalidatePropertiesFlag = false;
			}
		}
		
		/**
		 * 提交属性, 子类在调用完 <code>invalidateProperties()</code> 方法后, 应覆盖此方法以应用属性.
		 */
		protected function commitProperties():void
		{
			if(_oldWidth != _width || _oldHeight != _height)
			{
				dispatchResizeEvent();
			}
			if(_oldX != x || _oldY != y)
			{
				dispatchMoveEvent();
			}
		}
		
		/**
		 * 抛出移动事件.
		 */
		private function dispatchMoveEvent():void
		{
			if(this.hasEventListener(MoveEvent.MOVE))
			{
				var moveEvent:MoveEvent = new MoveEvent(MoveEvent.MOVE, _oldX, _oldY);
				this.dispatchEvent(moveEvent);
			}
			_oldX = this.x;
			_oldY = this.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateSize():void
		{
			if(!_invalidateSizeFlag)
			{
				_invalidateSizeFlag = true;
				if(_hasParent && HammercGlobals.layoutManager)
				{
					HammercGlobals.layoutManager.invalidateSize(this);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateSize(recursive:Boolean = false):void
		{
			if(recursive)
			{
				for(var i:int = 0; i < this.numChildren; i++)
				{
					var child:DisplayObject = this.getChildAt(i);
					if(child is ILayoutManagerClient)
					{
						(child as ILayoutManagerClient).validateSize(true);
					}
				}
			}
			if(_invalidateSizeFlag)
			{
				var changed:Boolean = measureSizes();
				if(changed)
				{
					this.invalidateDisplayList();
					this.invalidateParentSizeAndDisplayList();
				}
				_invalidateSizeFlag = false;
			}
		}
		
		/**
		 * 测量组件尺寸.
		 * @return 尺寸是否发生变化.
		 */
		private function measureSizes():Boolean
		{
			var changed:Boolean = false;
			if(!_invalidateSizeFlag)
			{
				return changed;
			}
			if(!this.canSkipMeasurement())
			{
				this.measure();
				if(this.measuredWidth < this.minWidth)
				{
					this.measuredWidth = this.minWidth;
				}
				if(this.measuredWidth > this.maxWidth)
				{
					this.measuredWidth = this.maxWidth;
				}
				if(this.measuredHeight < this.minHeight)
				{
					this.measuredHeight = this.minHeight;
				}
				if(this.measuredHeight > this.maxHeight)
				{
					this.measuredHeight = this.maxHeight;
				}
			}
			if(isNaN(_oldPreferWidth))
			{
				_oldPreferWidth = this.preferredWidth;
				_oldPreferHeight = this.preferredHeight;
				changed = true;
			}
			else
			{
				if(this.preferredWidth != _oldPreferWidth || this.preferredHeight != _oldPreferHeight)
				{
					changed = true;
				}
				_oldPreferWidth = this.preferredWidth;
				_oldPreferHeight = this.preferredHeight;
			}
			return changed;
		}
		
		/**
		 * 是否可以跳过测量尺寸阶段, 返回 true 则不执行 <code>measure()</code> 方法.
		 */
		protected function canSkipMeasurement():Boolean
		{
			return !isNaN(_explicitWidth) && !isNaN(_explicitHeight);
		}
		
		/**
		 * 测量组件尺寸.
		 */
		protected function measure():void
		{
			_measuredHeight = 0;
			_measuredWidth = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateDisplayList():void
		{
			if(!_invalidateDisplayListFlag)
			{
				_invalidateDisplayListFlag = true;
				if(_hasParent && HammercGlobals.layoutManager)
				{
					HammercGlobals.layoutManager.invalidateDisplayList(this);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateDisplayList():void
		{
			if(_invalidateDisplayListFlag)
			{
				var unscaledWidth:Number = 0;
				var unscaledHeight:Number = 0;
				if(_layoutWidthExplicitlySet)
				{
					unscaledWidth = _width;
				}
				else if(!isNaN(explicitWidth))
				{
					unscaledWidth = _explicitWidth;
				}
				else
				{
					unscaledWidth = this.measuredWidth;
				}
				if(_layoutHeightExplicitlySet)
				{
					unscaledHeight = _height;
				}
				else if(!isNaN(explicitHeight))
				{
					unscaledHeight = _explicitHeight;
				}
				else
				{
					unscaledHeight = this.measuredHeight;
				}
				if(isNaN(unscaledWidth))
				{
					unscaledWidth = 0;
				}
				if(isNaN(unscaledHeight))
				{
					unscaledHeight = 0;
				}
				this.setActualSize(unscaledWidth, unscaledHeight);
				this.updateDisplayList(unscaledWidth, unscaledHeight);
				_invalidateDisplayListFlag = false;
			}
		}
		
		/**
		 * 更新显示列表.
		 * @param unscaledWidth 组件的宽度.
		 * @param unscaledHeight 组件的高度.
		 */
		protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
		}
		
		/**
		 * 标记父级容器的尺寸和显示列表为失效.
		 */
		protected function invalidateParentSizeAndDisplayList():void
		{
			if(!_hasParent || !_includeInLayout)
			{
				return;
			}
			var p:IInvalidating = this.parent as IInvalidating;
			if(p != null)
			{
				p.invalidateSize();
				p.invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateNow(skipDisplayList:Boolean = false):void
		{
			if(!_validateNowFlag && HammercGlobals.layoutManager != null)
			{
				HammercGlobals.layoutManager.validateClient(this, skipDisplayList);
			}
			else
			{
				_validateNowFlag = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set initialized(value:Boolean):void
		{
			if(_initialized != value)
			{
				_initialized = value;
				this.dispatchEvent(new UIEvent(UIEvent.CREATION_COMPLETE));
			}
		}
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasParent():Boolean
		{
			return _hasParent || this.parent != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set nestLevel(value:int):void
		{
			_nestLevel = value;
			for(var i:int = this.numChildren - 1; i >= 0; i--)
			{
				var child:ILayoutManagerClient = getChildAt(i) as ILayoutManagerClient;
				if(child != null)
				{
					child.nestLevel = _nestLevel + 1;
				}
			}
		}
		public function get nestLevel():int
		{
			return _nestLevel;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			this.addingChild(child);
			return super.addChild(child);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			this.addingChild(child);
			return super.addChildAt(child,index);
		}
		
		/**
		 * 即将添加一个子项.
		 * @param child 要被添加的子项.
		 */
		hammerc_internal function addingChild(child:DisplayObject):void
		{
			if(child is ILayoutManagerClient)
			{
				(child as ILayoutManagerClient).nestLevel = _nestLevel + 1;
			}
			if(child is InteractiveObject)
			{
				if(doubleClickEnabled)
				{
					InteractiveObject(child).doubleClickEnabled = true;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set updateCompletePendingFlag(value:Boolean):void
		{
			_updateCompletePendingFlag = value;
		}
		public function get updateCompletePendingFlag():Boolean
		{
			return _updateCompletePendingFlag;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set x(value:Number):void
		{
			if(x != value)
			{
				super.x = value;
				this.invalidateProperties();
				if(_includeInLayout && parent != null && parent is UIComponent)
				{
					UIComponent(parent).childXYChanged();
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set y(value:Number):void
		{
			if(y != value)
			{
				super.y = value;
				this.invalidateProperties();
				if(_includeInLayout && parent != null && parent is UIComponent)
				{
					UIComponent(parent).childXYChanged();
				}
			}
		}
		
		/**
		 * 子项的位置发生改变.
		 */
		hammerc_internal function childXYChanged():void
		{
		}
		
		/**
		 * 设置或获取组件宽度.
		 */
		override public function set width(value:Number):void
		{
			if(_width == value && _explicitWidth == value)
			{
				return;
			}
			_width = value;
			_explicitWidth = value;
			this.invalidateProperties();
			this.invalidateDisplayList();
			this.invalidateParentSizeAndDisplayList();
			if(isNaN(value))
			{
				this.invalidateSize();
			}
		}
		override public function get width():Number
		{
			return escapeNaN(_width);
		}
		
		/**
		 * 设置或获取组件高度.
		 */
		override public function set height(value:Number):void
		{
			if(_height == value && _explicitHeight == value)
			{
				return;
			}
			_height = value;
			_explicitHeight = value;
			this.invalidateProperties();
			this.invalidateDisplayList();
			this.invalidateParentSizeAndDisplayList();
			if(isNaN(value))
			{
				this.invalidateSize();
			}
		}
		override public function get height():Number
		{
			return escapeNaN(_height);
		}
		
		private function escapeNaN(number:Number):Number
		{
			if(isNaN(number))
			{
				return 0;
			}
			return number;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleX(value:Number):void
		{
			if(super.scaleX != value)
			{
				super.scaleX = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleY(value:Number):void
		{
			if(super.scaleY != value)
			{
				super.scaleY = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set includeInLayout(value:Boolean):void
		{
			if(_includeInLayout != value)
			{
				_includeInLayout = true;
				this.invalidateParentSizeAndDisplayList();
				_includeInLayout = value;
			}
		}
		public function get includeInLayout():Boolean
		{
			return _includeInLayout;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set top(value:Number):void
		{
			if(_top != value)
			{
				_top = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		public function get top():Number
		{
			return _top;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set bottom(value:Number):void
		{
			if(_bottom != value)
			{
				_bottom = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		public function get bottom():Number
		{
			return _bottom;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set left(value:Number):void
		{
			if(_left != value)
			{
				_left = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		public function get left():Number
		{
			return _left;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set right(value:Number):void
		{
			if(_right != value)
			{
				_right = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		public function get right():Number
		{
			return _right;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set horizontalCenter(value:Number):void
		{
			if(_horizontalCenter != value)
			{
				_horizontalCenter = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set verticalCenter(value:Number):void
		{
			if(_verticalCenter != value)
			{
				_verticalCenter = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set percentWidth(value:Number):void
		{
			if(_percentWidth != value)
			{
				_percentWidth = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		public function get percentWidth():Number
		{
			return _percentWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set percentHeight(value:Number):void
		{
			if(_percentHeight != value)
			{
				_percentHeight = value;
				this.invalidateParentSizeAndDisplayList();
			}
		}
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredX():Number
		{
			return super.x;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredY():Number
		{
			return super.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get layoutBoundsX():Number
		{
			return super.x;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get layoutBoundsY():Number
		{
			return super.y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredWidth():Number
		{
			var w:Number = isNaN(_explicitWidth) ? this.measuredWidth : _explicitWidth;
			if(isNaN(w))
			{
				return 0;
			}
			return w * this.scaleX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number
		{
			var h:Number = isNaN(_explicitHeight) ? this.measuredHeight : _explicitHeight;
			if(isNaN(h))
			{
				return 0;
			}
			return h * this.scaleY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get layoutBoundsWidth():Number
		{
			var w:Number =  0;
			if(_layoutWidthExplicitlySet)
			{
				w = _width;
			}
			else if(!isNaN(explicitWidth))
			{
				w = _explicitWidth;
			}
			else
			{
				w = this.measuredWidth;
			}
			return escapeNaN(w * this.scaleX);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get layoutBoundsHeight():Number
		{
			var h:Number =  0
			if(_layoutHeightExplicitlySet)
			{
				h = _height;
			}
			else if(!isNaN(explicitHeight))
			{
				h = _explicitHeight;
			}
			else
			{
				h = this.measuredHeight;
			}
			return escapeNaN(h * this.scaleY);
		}
		
		/**
		 * @inheritDoc
		 */
		public function set maxWidth(value:Number):void
		{
			if(_maxWidth != value)
			{
				_maxWidth = value;
				this.invalidateSize();
			}
		}
		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minWidth(value:Number):void
		{
			if(_minWidth != value)
			{
				_minWidth = value;
				this.invalidateSize();
			}
		}
		public function get minWidth():Number
		{
			return _minWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set maxHeight(value:Number):void
		{
			if(_maxHeight != value)
			{
				_maxHeight = value;
				this.invalidateSize();
			}
		}
		public function get maxHeight():Number
		{
			return _maxHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set minHeight(value:Number):void
		{
			if(_minHeight != value)
			{
				_minHeight = value;
				this.invalidateSize();
			}
		}
		public function get minHeight():Number
		{
			return _minHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutBoundsSize(layoutWidth:Number, layoutHeight:Number):void
		{
			layoutWidth /= this.scaleX;
			layoutHeight /= this.scaleY;
			if(isNaN(layoutWidth))
			{
				_layoutWidthExplicitlySet = false;
				layoutWidth = this.preferredWidth;
			}
			else
			{
				_layoutWidthExplicitlySet = true;
			}
			if(isNaN(layoutHeight))
			{
				_layoutHeightExplicitlySet = false;
				layoutHeight = this.preferredHeight;
			}
			else
			{
				_layoutHeightExplicitlySet = true;
			}
			this.setActualSize(layoutWidth, layoutHeight);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutBoundsPosition(x:Number, y:Number):void
		{
			var changed:Boolean = false;
			if(this.x != x)
			{
				super.x = x;
				changed = true;
			}
			if(this.y != y)
			{
				super.y = y;
				changed = true;
			}
			if(changed)
			{
				dispatchMoveEvent();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTip(value:Object):void
		{
			if(value != _toolTip)
			{
				var oldValue:Object = _toolTip;
				_toolTip = value;
				ToolTipManager.registerToolTip(this, oldValue, value);
				dispatchEvent(new Event("toolTipChanged"));
			}
		}
		public function get toolTip():Object
		{
			return _toolTip;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTipRenderer(value:Class):void
		{
			if(value != _toolTipRenderer)
			{
				_toolTipRenderer = value;
			}
		}
		public function get toolTipRenderer():Class
		{
			return _toolTipRenderer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTipPosition(value:String):void
		{
			_toolTipPosition = value;
		}
		public function get toolTipPosition():String
		{
			return _toolTipPosition;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set toolTipOffset(value:Point):void
		{
			_toolTipOffset = value;
		}
		public function get toolTipOffset():Point
		{
			return _toolTipOffset;
		}
	}
}
