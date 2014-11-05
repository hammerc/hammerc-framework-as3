// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.components.supportClasses
{
	import org.hammerc.components.SkinnableComponent;
	
	/**
	 * <code>Range</code> 类为范围选取组件.
	 * @author wizardc
	 */
	public class Range extends SkinnableComponent
	{
		private var _minimum:Number = 0;
		private var _minChanged:Boolean = false;
		
		private var _maximum:Number = 100;
		private var _maxChanged:Boolean = false;
		
		private var _stepSize:Number = 1;
		private var _stepSizeChanged:Boolean = false;
		
		private var _value:Number = 0;
		private var _changedValue:Number = 0;
		private var _valueChanged:Boolean = false;
		
		private var _snapInterval:Number = 1;
		private var _snapIntervalChanged:Boolean = false;
		
		private var _explicitSnapInterval:Boolean = false;
		
		/**
		 * 创建一个 <code>Range</code> 对象.
		 */
		public function Range()
		{
			super();
			this.focusEnabled = true;
		}
		
		/**
		 * 设置或获取最小有效值.
		 */
		public function set minimum(value:Number):void
		{
			if(value == _minimum)
			{
				return;
			}
			_minimum = value;
			_minChanged = true;
			this.invalidateProperties();
		}
		public function get minimum():Number
		{
			return _minimum;
		}
		
		/**
		 * 设置或获取最大有效值.
		 */
		public function set maximum(value:Number):void
		{
			if(value == _maximum)
			{
				return;
			}
			_maximum = value;
			_maxChanged = true;
			this.invalidateProperties();
		}
		public function get maximum():Number
		{
			return _maximum;
		}
		
		/**
		 * 设置或获取更改的单步大小.
		 * <p>除非 <code>snapInterval</code> 为 0, 否则它必须是 <code>snapInterval</code> 的倍数.<br/>
		 * 如果 <code>stepSize</code> 不是倍数, 则会将它近似到大于或等于 <code>snapInterval</code> 的最近的倍数.</p>
		 */
		public function set stepSize(value:Number):void
		{
			if(value == _stepSize)
			{
				return;
			}
			_stepSize = value;
			_stepSizeChanged = true;
			this.invalidateProperties();
		}
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		/**
		 * 设置或获取此范围的当前值.
		 */
		public function set value(newValue:Number):void
		{
			if(newValue == value)
			{
				return;
			}
			_changedValue = newValue;
			_valueChanged = true;
			this.invalidateProperties();
		}
		public function get value():Number
		{
			return (_valueChanged) ? _changedValue : _value;
		}
		
		/**
		 * 设置或获取值的间隔.
		 * <p>如果为非零, 则有效值为 <code>minimum</code> 与此属性的整数倍数之和, 且小于或等于 <code>maximum</code>. 例如, 如果 <code>minimum</code> 为 10, <code>maximum</code> 为 20, 而此属性为 3, 则可能的有效值为 10, 13, 16, 19 和 20.<br/>
		 * 如果此属性的值为零, 则仅会将有效值约束到介于 <code>minimum</code> 和 <code>maximum</code> 之间（包括两者）.<br/>
		 * 此属性还约束 <code>stepSize</code> 属性（如果设置）的有效值.如果未显式设置此属性, 但设置了 <code>stepSize</code>, 则 <code>snapInterval</code> 将默认为 <code>stepSize</code>.</p>
		 */
		public function set snapInterval(value:Number):void
		{
			_explicitSnapInterval = true;
			if(value == _snapInterval)
			{
				return;
			}
			if(isNaN(value))
			{
				_snapInterval = 1;
				_explicitSnapInterval = false;
			}
			else
			{
				_snapInterval = value;
			}
			_snapIntervalChanged = true;
			_stepSizeChanged = true;
			this.invalidateProperties();
		}
		public function get snapInterval():Number
		{
			return _snapInterval;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(this.minimum > this.maximum)
			{
				if(!_maxChanged)
				{
					_minimum = _maximum;
				}
				else
				{
					_maximum = _minimum;
				}
			}
			if(_valueChanged || _maxChanged || _minChanged || _snapIntervalChanged)
			{
				var currentValue:Number = _valueChanged ? _changedValue : _value;
				_valueChanged = false;
				_maxChanged = false;
				_minChanged = false;
				_snapIntervalChanged = false;
				this.setValue(this.nearestValidValue(currentValue, snapInterval));
			}
			if(_stepSizeChanged)
			{
				if(_explicitSnapInterval)
				{
					_stepSize = this.nearestValidSize(_stepSize);
				}
				else
				{
					_snapInterval = _stepSize;
					this.setValue(this.nearestValidValue(_value, snapInterval));
				}
				_stepSizeChanged = false;
			}
		}
		
		/**
		 * 修正 stepSize 到最接近 snapInterval 的整数倍.
		 */
		private function nearestValidSize(size:Number):Number
		{
			var interval:Number = this.snapInterval;
			if(interval == 0)
			{
				return size;
			}
			var validSize:Number = Math.round(size / interval) * interval;
			return (Math.abs(validSize) < interval) ? interval : validSize;
		}
		
		/**
		 * 修正输入的值为有效值.
		 * @param value 输入值.
		 * @param interval snapInterval 的值, 或 snapInterval 的整数倍数.
		 */
		protected function nearestValidValue(value:Number, interval:Number):Number
		{
			if(interval == 0)
			{
				return Math.max(this.minimum, Math.min(this.maximum, value));
			}
			var maxValue:Number = this.maximum - this.minimum;
			var scale:Number = 1;
			value -= this.minimum;
			if(interval != Math.round(interval))
			{
				const parts:Array = (new String(1 + interval)).split(".");
				scale = Math.pow(10, parts[1].length);
				maxValue *= scale;
				value = Math.round(value * scale);
				interval = Math.round(interval * scale);
			}
			var lower:Number = Math.max(0, Math.floor(value / interval) * interval);
			var upper:Number = Math.min(maxValue, Math.floor((value + interval) / interval) * interval);
			var validValue:Number = ((value - lower) >= ((upper - lower) / 2)) ? upper : lower;
			return (validValue / scale) + minimum;
		}
		
		/**
		 * 设置当前值. 此方法假定调用者已经使用了 nearestValidValue() 方法来约束 value 参数.
		 * @param value 新值.
		 */
		protected function setValue(value:Number):void
		{
			if(_value == value)
			{
				return;
			}
			if(isNaN(value))
			{
				value = 0;
			}
			if(!isNaN(this.maximum) && !isNaN(this.minimum) && (this.maximum > this.minimum))
			{
				_value = Math.min(this.maximum, Math.max(this.minimum, value));
			}
			else
			{
				_value = value;
			}
			_valueChanged = false;
		}
		
		/**
		 * 按 stepSize增大或减小当前值.
		 * @param increase 若为 true, 则向 value 增加 stepSize, 否则减去它.
		 */
		public function changeValueByStep(increase:Boolean = true):void
		{
			if(stepSize == 0)
			{
				return;
			}
			var newValue:Number = (increase) ? this.value + this.stepSize : this.value - this.stepSize;
			this.setValue(nearestValidValue(newValue, this.snapInterval));
		}
	}
}
