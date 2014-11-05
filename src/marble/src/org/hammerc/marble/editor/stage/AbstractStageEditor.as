// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.editor.stage
{
	import flash.display.DisplayObject;
	
	import org.hammerc.marble.editor.common.AbstractScopeEditor;
	
	/**
	 * <code>AbstractStageEditor</code> 类定义了一个抽象舞台编辑类.
	 * @author wizardc
	 */
	public class AbstractStageEditor extends AbstractScopeEditor implements IStageEditor
	{
		/**
		 * 记录层名称表对象.
		 */
		protected var _nameMap:Object;
		
		/**
		 * <code>AbstractStageEditor</code> 类为抽象类, 不能被实例化.
		 */
		public function AbstractStageEditor()
		{
			_nameMap = new Object();
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numLayers():int
		{
			return _container.numChildren;
		}
		
		/**
		 * @inheritDoc
		 */
		public function showLayer(name:String, hideOther:Boolean = false):void
		{
			if(hideOther)
			{
				this.hideAllLayers();
			}
			var layer:IStageLayer = this.getLayerByName(name);
			layer.show = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function showAllLayers():void
		{
			for each(var layer:IStageLayer in _nameMap)
			{
				layer.show = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hideLayer(name:String, showOther:Boolean = false):void
		{
			if(showOther)
			{
				this.showAllLayers();
			}
			var layer:IStageLayer = this.getLayerByName(name);
			layer.show = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hideAllLayers():void
		{
			for each(var layer:IStageLayer in _nameMap)
			{
				layer.show = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function lockLayer(name:String, unlockOther:Boolean = false):void
		{
			if(unlockOther)
			{
				this.unlockAllLayers();
			}
			var layer:IStageLayer = this.getLayerByName(name);
			layer.lock = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function lockAllLayers():void
		{
			for each(var layer:IStageLayer in _nameMap)
			{
				layer.lock = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function unlockLayer(name:String, lockOther:Boolean = false):void
		{
			if(lockOther)
			{
				this.lockAllLayers();
			}
			var layer:IStageLayer = this.getLayerByName(name);
			layer.lock = false;
		}
		
		/**
		 * @inheritDoc
		 */
		public function unlockAllLayers():void
		{
			for each(var layer:IStageLayer in _nameMap)
			{
				layer.lock = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function addLayer(layer:IStageLayer):void
		{
			if(_nameMap.hasOwnProperty(layer.name))
			{
				throw new Error("层名称\"" + layer.name + "\"已存在！");
			}
			_nameMap[layer.name] = layer;
			_container.addChild(layer as DisplayObject);
			layer.onAdd();
		}
		
		/**
		 * @inheritDoc
		 */
		public function addLayerAt(layer:IStageLayer, index:int):void
		{
			if(_nameMap.hasOwnProperty(layer.name))
			{
				throw new Error("层名称\"" + layer.name + "\"已存在！");
			}
			_nameMap[layer.name] = layer;
			_container.addChildAt(layer as DisplayObject, index);
			layer.onAdd();
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasLayer(name:String):Boolean
		{
			return _nameMap.hasOwnProperty(name);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLayerAt(index:int):IStageLayer
		{
			return _container.getChildAt(index) as IStageLayer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLayerByName(name:String):IStageLayer
		{
			return _nameMap[name];
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayerIndex(name:String, index:int):void
		{
			var layer:IStageLayer = this.getLayerByName(name);
			_container.setChildIndex(layer as DisplayObject, index);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeLayer(name:String):IStageLayer
		{
			var layer:IStageLayer = this.getLayerByName(name);
			_container.removeChild(layer as DisplayObject);
			layer.onRemove();
			return layer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeLayerAt(index:int):IStageLayer
		{
			var layer:IStageLayer = this.getLayerAt(index);
			_container.removeChildAt(index);
			layer.onRemove();
			return layer;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllLayer():void
		{
			_container.removeChildren();
			for each(var layer:IStageLayer in _nameMap)
			{
				layer.onRemove();
			}
			_nameMap = new Object();
		}
		
		/**
		 * @inheritDoc
		 */
		public function swapLayers(name1:String, name2:String):void
		{
			var layer1:IStageLayer = this.getLayerByName(name1);
			var layer2:IStageLayer = this.getLayerByName(name2);
			_container.swapChildren(layer1 as DisplayObject, layer2 as DisplayObject);
		}
	}
}
