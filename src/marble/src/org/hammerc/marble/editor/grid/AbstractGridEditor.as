/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.editor.grid
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import org.hammerc.core.AbstractEnforcer;
	
	import org.hammerc.managers.RepaintManager;
	import org.hammerc.marble.editor.grid.tools.GridToolFactory;
	import org.hammerc.marble.editor.grid.tools.IGridTool;
	
	/**
	 * <code>AbstractGridEditor</code> 类为抽象类, 定义了用于编辑格子的编辑器.
	 * @author wizardc
	 */
	public class AbstractGridEditor extends Sprite implements IGridEditor
	{
		private static const DEFAULT_STYLE:Object = {
			showDrawAreaBorder : true, 
			drawAreaBorderColor : 0xffffff, 
			showDrawAreaFill : false, 
			drawAreaFillColor : 0xffffff, 
			drawAreaFillAlpha : 0.3, 
			showUnselectedBorder : true, 
			unselectedBorderColor : 0x999999, 
			showUnselectedFill : false, 
			unselectedFillColor : 0x000000, 
			unselectedFillAlpha : 0.3, 
			showSelectedBorder : true, 
			selectedBorderColor : 0x0099ff, 
			showSelectedFill : true, 
			selectedFillColor : 0x0099ff, 
			selectedFillAlpha : 0.3, 
			rulerLineColor : 0x0099ff
		};
		private static const MIN_DRAW_AREA:Point = new Point(1, 1);
		
		private var _gridWidth:int;
		private var _gridHeight:int;
		private var _row:int;
		private var _column:int;
		private var _undoStep:int;
		private var _style:Object;
		
		private var _selectMode:Boolean = true;
		private var _drawType:int = GridDrawType.NONE;
		private var _drawArea:Point = new Point(1, 1);
		private var _useMinDrawArea:Boolean = false;
		
		/**
		 * 记录在下一次重绘方法被调用时是否需要进行重绘.
		 */
		protected var _changed:Boolean = false;
		
		/**
		 * 记录存放所有格子的容器.
		 */
		protected var _gridContainer:Sprite;
		
		/**
		 * 记录所有的格子数据, 使用不透明的位图来对应, 纯白表示未选中, 纯黑表示选中.
		 */
		protected var _gridData:BitmapData;
		
		/**
		 * 撤销指针.
		 */
		protected var _undoIndex:int = 0;
		
		/**
		 * 撤销数据记录列表.
		 */
		protected var _gridDataRecordList:Vector.<BitmapData>;
		
		/**
		 * 格子对象记录列表.
		 */
		protected var _gridCellList:Vector.<IGridCell>;
		
		/**
		 * 绘制区域显示对象.
		 */
		protected var _gridDrawArea:IGridDrawArea;
		
		/**
		 * 记录当前的绘制工具对象.
		 */
		protected var _gridTool:IGridTool;
		
		/**
		 * <code>AbstractGridEditor</code> 类为抽象类, 不能被实例化.
		 * @param gridWidth 格子宽度.
		 * @param gridHeight 格子高度.
		 * @param row 行数.
		 * @param column 列数.
		 * @param undoStep 可撤销的步骤数.
		 * @param style 编辑器样式描述对象.
		 */
		public function AbstractGridEditor(gridWidth:int, gridHeight:int, row:int, column:int, undoStep:int = 3, style:Object = null)
		{
			AbstractEnforcer.enforceConstructor(this, AbstractGridEditor);
			RepaintManager.getInstance().register(this);
			_gridWidth = gridWidth;
			_gridHeight = gridHeight;
			_row = row;
			_column = column;
			_undoStep = undoStep;
			_style = new Object();
			for(var key:String in DEFAULT_STYLE)
			{
				if(style != null && style.hasOwnProperty(key))
				{
					_style[key] = style[key];
				}
				else
				{
					_style[key] = DEFAULT_STYLE[key];
				}
			}
			createGrids();
			this.saveFirstRecord();
			this.init();
			this.callRedraw();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleX(value:Number):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleY(value:Number):void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function get gridWidth():int
		{
			return _gridWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get gridHeight():int
		{
			return _gridHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get row():int
		{
			return _row;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get column():int
		{
			return _column;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get undoStep():int
		{
			return _undoStep;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get style():Object
		{
			return _style;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set selectMode(value:Boolean):void
		{
			_selectMode = value;
		}
		public function get selectMode():Boolean
		{
			return _selectMode;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set drawType(value:int):void
		{
			if(_drawType == value)
			{
				_drawType = value;
				if(_gridTool != null)
				{
					_gridTool.removeEventListener(GridDrawEvent.DRAW_BEGIN, drawBeginHandler);
					_gridTool.removeEventListener(GridDrawEvent.DRAW_END, drawEndHandler);
					_gridTool.onRemove();
				}
				_gridTool = GridToolFactory.getGridTool(_drawType, this);
				if(_gridTool != null)
				{
					_gridTool.addEventListener(GridDrawEvent.DRAW_BEGIN, drawBeginHandler);
					_gridTool.addEventListener(GridDrawEvent.DRAW_END, drawEndHandler);
					_gridTool.onRegister();
				}
			}
		}
		public function get drawType():int
		{
			return _drawType;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set drawArea(value:Point):void
		{
			_drawArea.copyFrom(value);
			_drawArea.x = _drawArea.x < 1 ? 1 : int(_drawArea.x);
			_drawArea.y = _drawArea.y < 1 ? 1 : int(_drawArea.y);
		}
		public function get drawArea():Point
		{
			if(this.useMinDrawArea)
			{
				return MIN_DRAW_AREA;
			}
			return _drawArea;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set useMinDrawArea(value:Boolean):void
		{
			_useMinDrawArea = value;
		}
		public function get useMinDrawArea():Boolean
		{
			return _useMinDrawArea;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get gridContainer():Sprite
		{
			return _gridContainer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get gridData():BitmapData
		{
			return _gridData;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get gridCellList():Vector.<IGridCell>
		{
			return _gridCellList;
		}
		
		private function createGrids():void
		{
			_gridContainer = new Sprite();
			_gridContainer.addEventListener(MouseEvent.MOUSE_OVER, containerMouseOverHandler);
			_gridContainer.addEventListener(MouseEvent.ROLL_OUT, containerRollOutHandler);
			this.addChild(_gridContainer);
			_gridData = new BitmapData(column, row, false, GridColor.UNSELECTED_COLOR);
			_undoIndex = 0;
			_gridDataRecordList = new Vector.<BitmapData>();
			_gridCellList = new Vector.<IGridCell>(row * column, true);
			for(var i:int = 0; i < row; i++)
			{
				for(var j:int = 0; j < column; j++)
				{
					var cell:IGridCell = this.createGridCell(i, j);
					_gridCellList[i * column + j] = cell;
					this.alignGridCell(DisplayObject(cell), i, j);
					_gridContainer.addChild(DisplayObject(cell));
				}
			}
			_gridDrawArea = this.createGridDrawArea();
			_gridContainer.addChild(DisplayObject(_gridDrawArea));
		}
		
		private function containerMouseOverHandler(event:MouseEvent):void
		{
			if(event.target != event.currentTarget)
			{
				var target:IGridCell = IGridCell(event.target);
				_gridDrawArea.targetChanged(target);
				DisplayObject(_gridDrawArea).visible = true;
			}
		}
		
		private function containerRollOutHandler(event:MouseEvent):void
		{
			DisplayObject(_gridDrawArea).visible = false;
		}
		
		/**
		 * 创建具体的格子对象.
		 * @param row 行数.
		 * @param column 列数.
		 * @return 格子对象.
		 */
		protected function createGridCell(row:int, column:int):IGridCell
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * 对齐指定格子的位置.
		 * @param cell 格子对象.
		 * @param row 行数.
		 * @param column 列数.
		 */
		protected function alignGridCell(cell:DisplayObject, row:int, column:int):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 创建具体的绘制区域对象.
		 * @return 绘制区域对象.
		 */
		protected function createGridDrawArea():IGridDrawArea
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * 初始化时会调用该方法.
		 */
		protected function init():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDrawArea(target:IGridCell):Vector.<IGridCell>
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLineArea(gridCell1:IGridCell, gridCell2:IGridCell):Vector.<IGridCell>
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getGridCell(row:int, column:int):IGridCell
		{
			return _gridCellList[row * _column + column];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setGridCellSelect(row:int, column:int, selected:Boolean):void
		{
			_gridData.setPixel(column, row, selected ? GridColor.SELECTED_COLOR : GridColor.UNSELECTED_COLOR);
			this.callRedraw();
		}
		
		/**
		 * 开始绘制时会调用该方法.
		 * @param event 对应的事件.
		 */
		protected function drawBeginHandler(event:GridDrawEvent):void
		{
		}
		
		/**
		 * 绘制结束时会调用该方法.
		 * @param event 对应的事件.
		 */
		protected function drawEndHandler(event:GridDrawEvent):void
		{
			var bitmapData:BitmapData = _gridData.clone();
			if(_gridDataRecordList.length == this.undoStep)
			{
				//队列已满, 移除第一个位图
				_gridDataRecordList.shift();
				_gridDataRecordList.push(bitmapData);
			}
			else
			{
				//队列未满, 后面可能存在 redo 位图, 需要清除掉
				_gridDataRecordList.length = _undoIndex + 1;
				_gridDataRecordList.push(bitmapData);
				_undoIndex++;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function undo():Boolean
		{
			if(_undoIndex == 0)
			{
				return false;
			}
			_undoIndex--;
			_gridData = _gridDataRecordList[_undoIndex];
			this.callRedraw();
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function redo():Boolean
		{
			if(_undoIndex == _gridDataRecordList.length - 1)
			{
				return false;
			}
			_undoIndex++;
			_gridData = _gridDataRecordList[_undoIndex];
			this.callRedraw();
			return true;
		}
		
		/**
		 * 记录第一个用于撤销的数据.
		 */
		protected function saveFirstRecord():void
		{
			_undoIndex = 0;
			_gridDataRecordList.length = 0;
			_gridDataRecordList.push(_gridData);
		}
		
		/**
		 * @inheritDoc
		 */
		public function callRedraw():void
		{
			_changed = true;
			RepaintManager.getInstance().callRepaint(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function repaint():void
		{
			if(_changed)
			{
				this.redraw();
				_changed = false;
			}
		}
		
		/**
		 * 绘制编辑器.
		 */
		protected function redraw():void
		{
			for(var i:int = 0; i < this.row; i++)
			{
				for(var j:int = 0; j < this.column; j++)
				{
					var cell:IGridCell = _gridCellList[i * column + j];
					cell.drawCell(_gridData.getPixel(j, i) == GridColor.SELECTED_COLOR);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function readFromBytes(bytes:ByteArray):void
		{
			_gridData.lock();
			for(var i:int = 0; i < this.row; i++)
			{
				for(var j:int = 0; j < this.column; j++)
				{
					var selected:Boolean = bytes.readBoolean();
					_gridData.setPixel(j, i, selected ? GridColor.SELECTED_COLOR : GridColor.UNSELECTED_COLOR);
				}
			}
			_gridData.unlock();
			this.saveFirstRecord();
			this.callRedraw();
		}
		
		/**
		 * @inheritDoc
		 */
		public function writeToBytes():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			for(var i:int = 0; i < this.row; i++)
			{
				for(var j:int = 0; j < this.column; j++)
				{
					var selected:Boolean = _gridData.getPixel(j, i) == GridColor.SELECTED_COLOR;
					bytes.writeBoolean(selected);
				}
			}
			return bytes;
		}
	}
}
