// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.display
{
	import flash.display.BitmapData;
	
	/**
	 * <code>BitmapFrame</code> 类记录位图剪辑一帧上的信息.
	 * @author wizardc
	 */
	public class BitmapFrame
	{
		/**
		 * 无帧脚本.
		 */
		public static const NO_SCRIPT:int = -1;
		
		/**
		 * 播放的帧脚本.
		 */
		public static const PLAY_SCRIPT:int = 0;
		
		/**
		 * 停止的帧脚本.
		 */
		public static const STOP_SCRIPT:int = 1;
		
		/**
		 * 跳转并播放的帧脚本.
		 */
		public static const GOTO_AND_PLAY_SCRIPT:int = 2;
		
		/**
		 * 跳转并停止的帧脚本.
		 */
		public static const GOTO_AND_STOP_SCRIPT:int = 3;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _bitmapData:BitmapData;
		private var _currentFrameLabel:String;
		private var _currentLabel:String;
		private var _currentLabels:Array;
		private var _scriptType:int = -1;
		private var _scriptGotoFrame:int = 1;
		
		/**
		 * 创建一个 <code>BitmapFrame</code> 对象.
		 * @param x 记录本帧在 x 轴上的位移.
		 * @param y 记录本帧在 y 轴上的位移.
		 * @param bitmapData 记录本帧对应的位图对象.
		 * @param currentFrameLabel 记录时间轴中当前帧上的标签.
		 * @param currentLabel 记录时间轴中播放头所在的当前标签.
		 * @param currentLabels 记录当前的 FrameLabel 对象组成的数组.
		 */
		public function BitmapFrame(x:Number = 0, y:Number = 0, bitmapData:BitmapData = null, currentFrameLabel:String = null, currentLabel:String = null, currentLabels:Array = null)
		{
			_x = x;
			_y = y;
			_bitmapData = bitmapData;
			_currentFrameLabel = currentFrameLabel;
			_currentLabel = currentLabel;
			_currentLabels = currentLabels;
		}
		
		/**
		 * 设置或获取本帧在 x 轴上的位移.
		 */
		public function set x(value:Number):void
		{
			_x = value;
		}
		public function get x():Number
		{
			return _x;
		}
		
		/**
		 * 设置或获取记录本帧在 y 轴上的位移.
		 */
		public function set y(value:Number):void
		{
			_y = value;
		}
		public function get y():Number
		{
			return _y;
		}
		
		/**
		 * 设置或获取本帧对应的位图对象.
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
		 * 设置或获取时间轴中当前帧上的标签.
		 */
		public function set currentFrameLabel(value:String):void
		{
			_currentFrameLabel = value;
		}
		public function get currentFrameLabel():String
		{
			return _currentFrameLabel;
		}
		
		/**
		 * 设置或获取时间轴中播放头所在的当前标签.
		 */
		public function set currentLabel(value:String):void
		{
			_currentLabel = value;
		}
		public function get currentLabel():String
		{
			return _currentLabel;
		}
		
		/**
		 * 设置或获取当前的 <code>FrameLabel</code> 对象组成的数组.
		 */
		public function set currentLabels(value:Array):void
		{
			_currentLabels = value;
		}
		public function get currentLabels():Array
		{
			return _currentLabels;
		}
		
		/**
		 * 设置或获取当前帧的脚本类型.
		 */
		public function set scriptType(value:int):void
		{
			_scriptType = value;
		}
		public function get scriptType():int
		{
			return _scriptType;
		}
		
		/**
		 * 设置或获取当前帧跳转的帧数.
		 */
		public function set scriptGotoFrame(value:int):void
		{
			_scriptGotoFrame = value;
		}
		public function get scriptGotoFrame():int
		{
			return _scriptGotoFrame;
		}
	}
}
