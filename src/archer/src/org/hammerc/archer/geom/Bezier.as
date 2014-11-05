// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.archer.geom
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * <code>Bezier</code> 类实现了二次贝塞尔曲线.
	 * @author wizardc
	 */
	public class Bezier
	{
		private var _start:Point;
		private var _control:Point;
		private var _end:Point;
		
		/**
		 * 创建一个 <code>Bezier</code> 对象.
		 * @param start 开始点.
		 * @param control 控制点.
		 * @param end 结束点.
		 */
		public function Bezier(start:Point = null, control:Point = null, end:Point = null)
		{
			_start = new Point();
			_control = new Point();
			_end = new Point();
			this.start = start;
			this.control = control;
			this.end = end;
		}
		
		/**
		 * 设置或获取开始点.
		 */
		public function set start(value:Point):void
		{
			if(value != null && !_start.equals(value))
			{
				_start.copyFrom(value);
			}
		}
		public function get start():Point
		{
			return _start;
		}
		
		/**
		 * 设置或获取控制点.
		 */
		public function set control(value:Point):void
		{
			if(value != null && !_control.equals(value))
			{
				_control.copyFrom(value);
			}
		}
		public function get control():Point
		{
			return _control;
		}
		
		/**
		 * 设置或获取结束点.
		 */
		public function set end(value:Point):void
		{
			if(value != null && !_end.equals(value))
			{
				_end.copyFrom(value);
			}
		}
		public function get end():Point
		{
			return _end;
		}
		
		/**
		 * 获取指定点的位置.
		 * @param percent 线段百分比.
		 * @return 指定点的位置.
		 */
		public function getPoint(percent:Number):Point
		{
			var point:Point = new Point();
			const f:Number = 1 - percent;
			point.x = _start.x * f * f + _control.x * 2 * percent * f + _end.x * percent * percent;
			point.y = _start.y * f * f + _control.y * 2 * percent * f + _end.y * percent * percent;
			return point;
		}
		
		/**
		 * 获取指定点的切线角度.
		 * @param percent 线段百分比.
		 * @return 指定点的切线角度.
		 */
		public function getTangentAngle(percent:Number = 0):Number
		{
			const t0X:Number = _start.x + (_control.x - _start.x) * percent;
			const t0Y:Number = _start.y + (_control.y - _start.y) * percent;
			const t1X:Number = _control.x + (_end.x - _control.x) * percent;
			const t1Y:Number = _control.y + (_end.y - _control.y) * percent;
			const distanceX:Number = t1X - t0X;
			const distanceY:Number = t1Y - t0Y;
			return Math.atan2(distanceY, distanceX);
		}
		
		/**
		 * 绘制本曲线.
		 * @param graphics 绘制对象.
		 */
		public function draw(graphics:Graphics):void
		{
			graphics.moveTo(_start.x, _start.y);
			graphics.curveTo(_control.x, _control.y, _end.x, _end.y);
		}
		
		/**
		 * 返回一个新对象, 它是与当前对象完全相同的副本.
		 * @return 一个新对象, 是当前对象的副本.
		 */
		public function clone():Bezier
		{
			return new Bezier(this.start, this.control, this.end);
		}
		
		/**
		 * 返回当前对象的字符串表示形式.
		 * @return 当前对象的字符串表示形式.
		 */
		public function toString():String
		{
			return "[Bezier (start:" + _start.toString() + ", control:" + _control.toString() + ", end:" + _end.toString() + ")]";
		}
	}
}
