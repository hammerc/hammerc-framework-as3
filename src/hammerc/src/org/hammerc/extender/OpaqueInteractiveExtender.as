// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.extender
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	/**
	 * <code>OpaqueInteractiveExtender</code> 类提供支持位图不透明部分鼠标交互的功能扩展, 透明部分的鼠标交互事件会被忽略.
	 * <p>本类用来扩展指定对象并使其拥有特定的功能, 可采用复合的方式在需要该功能的类的子类中使用.</p>
	 * @author wizardc
	 */
	public class OpaqueInteractiveExtender
	{
		/**
		 * 记录要扩展的目标对象.
		 */
		protected var _target:DisplayObject;
		
		/**
		 * 记录透明度的阀值, 像素点的透明度小于等于该值则该点不进行交互.
		 */
		protected var _threshold:int;
		
		/**
		 * 记录用来进行测试的位图数据.
		 */
		protected var _bitmapData:BitmapData;
		
		/**
		 * 创建一个 <code>OpaqueInteractiveExtender</code> 对象.
		 * @param target 要扩展的目标对象.
		 * @param threshold 透明度的阀值.
		 */
		public function OpaqueInteractiveExtender(target:DisplayObject, threshold:int = 127)
		{
			_target = target;
			this.threshold = threshold;
		}
		
		/**
		 * 获取要扩展的目标对象.
		 */
		public function get target():DisplayObject
		{
			return _target;
		}
		
		/**
		 * 设置或获取透明度的阀值, 像素点的透明度小于等于该值则该点不进行交互, 有效范围 [0~255].
		 */
		public function set threshold(value:int):void
		{
			_threshold = value > 255 ? 255 : (value < 0 ? 0 : value);
		}
		public function get threshold():int
		{
			return _threshold;
		}
		
		/**
		 * 设置或获取用来进行测试的位图数据.
		 */
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		/**
		 * 检测指定的本地坐标点是否和扩展的对象能进行鼠标交互.
		 * @param mouseX 本地 x 轴坐标.
		 * @param mouseY 本地 y 轴坐标.
		 * @return 指定的屏幕坐标点是否和扩展的对象能进行鼠标交互.
		 */
		public function checkPoint(mouseX:Number, mouseY:Number):Boolean
		{
			if(_target.stage != null && _target.visible && _bitmapData != null)
			{
				var alpha:uint = _bitmapData.getPixel32(mouseX, mouseY) >> 24;
				return alpha <= _threshold;
			}
			return false;
		}
	}
}
