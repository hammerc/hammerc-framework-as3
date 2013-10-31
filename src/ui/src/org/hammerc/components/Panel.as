/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.components
{
	import org.hammerc.core.IText;
	
	/**
	 * <code>Panel</code> 类实现了带有标题和内容区域的面板组件.
	 * @author wizardc
	 */
	public class Panel extends SkinnableContainer
	{
		/**
		 * 皮肤子件, 标题显示对象.
		 */
		public var titleDisplay:IText;
		
		private var _title:String = "";
		
		/**
		 * 创建一个 <code>Panel</code> 对象.
		 */
		public function Panel()
		{
			super();
			this.mouseEnabled = false;
			/*
			 * 当面板覆盖在会运动的场景上时, 将会导致不断被触发重绘, 而如果含有较多矢量子项, 
			 * 就会消耗非常多的渲染时间, 设置位图缓存将能极大提高这种情况下的性能.
			 */
			this.cacheAsBitmap = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get hostComponentKey():Object
		{
			return Panel;
		}
		
		/**
		 * 设置或获取标题文本内容.
		 */
		public function set title(value:String):void 
		{
			_title = value;
			if(titleDisplay != null)
			{
				titleDisplay.text = title;
			}
		}
		public function get title():String 
		{
			return _title;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == titleDisplay)
			{
				titleDisplay.text = this.title;
			}
		}
	}
}
