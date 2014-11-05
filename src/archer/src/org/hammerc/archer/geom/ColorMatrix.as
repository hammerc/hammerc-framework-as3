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
	/**
	 * <code>ColorMatrix</code> 类实现了可以调整颜色的功能.
	 * <p>该类修改自 Grant Skinner 的 com.gskinner.geom.ColorMatrix 类.</p>
	 * @example 使用方法如下: 
	 * <listing version="3.0">
	 * var colorMatrix = new ColorMatrix();
	 * colorMatrix.adjustColor(20, 20, 20, 20);
	 * displayObject.filters = [new ColorMatrixFilter(colorMatrix)];
	 * </listing>
	 * @author wizardc
	 */
	public dynamic class ColorMatrix extends Array
	{
		private static const DELTA_INDEX:Array = [
			0, 0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1, 0.11, 
			0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24, 
			0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42, 
			0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 
			0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98, 
			1.0, 1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54, 
			1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0, 2.12, 2.25, 
			2.37, 2.50, 2.62, 2.75, 2.87, 3.0, 3.2, 3.4, 3.6, 3.8, 
			4.0, 4.3, 4.7, 4.9, 5.0, 5.5, 6.0, 6.5, 6.8, 7.0, 
			7.3, 7.5, 7.8, 8.0, 8.4, 8.7, 9.0, 9.4, 9.6, 9.8, 
			10.0
		];
		
		private static const IDENTITY_MATRIX:Array = [
			1, 0, 0, 0, 0, 
			0, 1, 0, 0, 0, 
			0, 0, 1, 0, 0, 
			0, 0, 0, 1, 0, 
			0, 0, 0, 0, 1
		];
		
		private static const LENGTH:Number = IDENTITY_MATRIX.length;
		
		/**
		 * 创建一个 <code>ColorMatrix</code> 对象.
		 * @param matrix 颜色矩阵.
		 */
		public function ColorMatrix(matrix:Array = null)
		{
			matrix = this.fixMatrix(matrix);
			this.copyMatrix((matrix.length == LENGTH ? matrix : IDENTITY_MATRIX));
		}
		
		/**
		 * 调整颜色.
		 * @param brightness 亮度.
		 * @param contrast 对比度.
		 * @param saturation 饱和度.
		 * @param hue 色相.
		 */
		public function adjustColor(brightness:Number, contrast:Number, saturation:Number, hue:Number):void
		{
			this.adjustHue(hue);
			this.adjustContrast(contrast);
			this.adjustBrightness(brightness);
			this.adjustSaturation(saturation);
		}
		
		/**
		 * 调整亮度.
		 * @param value 调整的值.
		 */
		public function adjustBrightness(value:Number):void
		{
			value = this.cleanValue(value, 100);
			if(value == 0 || isNaN(value))
			{
				return;
			}
			this.multiplyMatrix([
				1, 0, 0, 0, value, 
				0, 1, 0, 0, value, 
				0, 0, 1, 0, value, 
				0, 0, 0, 1, 0, 
				0, 0, 0, 0, 1
			]);
		}
		
		/**
		 * 调整对比度.
		 * @param value 调整的值.
		 */
		public function adjustContrast(value:Number):void
		{
			value = this.cleanValue(value, 100);
			if(value == 0 || isNaN(value))
			{
				return;
			}
			var x:Number;
			if(value < 0)
			{
				x = 127 + value / 100 * 127;
			}
			else
			{
				x = value % 1;
				if(x == 0)
				{
					x = DELTA_INDEX[value];
				}
				else
				{
					x = DELTA_INDEX[(value << 0)] * (1 - x) + DELTA_INDEX[(value << 0) + 1] * x;
				}
				x = x * 127 + 127;
			}
			this.multiplyMatrix([
				x / 127, 0, 0, 0, 0.5 *(127- x), 
				0, x / 127, 0, 0, 0.5 * (127 - x), 
				0, 0, x / 127, 0, 0.5 * (127 - x), 
				0, 0, 0, 1, 0, 
				0, 0, 0, 0, 1
			]);
		}
		
		/**
		 * 调整饱和度.
		 * @param value 调整的值.
		 */
		public function adjustSaturation(value:Number):void
		{
			value = this.cleanValue(value, 100);
			if(value == 0 || isNaN(value))
			{
				return;
			}
			var x:Number = 1 + ((value > 0) ? 3 * value / 100 : value / 100);
			var lumR:Number = 0.3086;
			var lumG:Number = 0.6094;
			var lumB:Number = 0.0820;
			this.multiplyMatrix([
				lumR * (1 - x) + x, lumG * (1 - x), lumB * (1 - x), 0, 0, 
				lumR * (1 - x), lumG * (1 - x) + x, lumB * (1 - x), 0, 0, 
				lumR * (1 - x), lumG * (1 - x), lumB * (1 - x) + x, 0, 0, 
				0, 0, 0, 1, 0, 
				0, 0, 0, 0, 1
			]);
		}
		
		/**
		 * 调整色相.
		 * @param value 调整的值.
		 */
		public function adjustHue(value:Number):void
		{
			value = this.cleanValue(value, 180) / 180 * Math.PI;
			if(value == 0 || isNaN(value))
			{
				return;
			}
			var cosVal:Number = Math.cos(value);
			var sinVal:Number = Math.sin(value);
			var lumR:Number = 0.213;
			var lumG:Number = 0.715;
			var lumB:Number = 0.072;
			this.multiplyMatrix([
				lumR + cosVal * (1 - lumR) + sinVal * (-lumR), lumG + cosVal * (-lumG) + sinVal * (-lumG), lumB + cosVal * (-lumB) + sinVal * (1 - lumB), 0, 0, 
				lumR + cosVal * (-lumR) + sinVal * (0.143), lumG + cosVal * (1 - lumG) + sinVal * (0.140), lumB + cosVal * (-lumB) + sinVal * (-0.283), 0, 0, 
				lumR + cosVal * (-lumR) + sinVal * (-(1 - lumR)), lumG + cosVal * (-lumG) + sinVal * (lumG), lumB + cosVal * (1 - lumB) + sinVal * (lumB), 0, 0, 
				0, 0, 0, 1, 0, 
				0, 0, 0, 0, 1
			]);
		}
		
		/**
		 * 连接另一个颜色矩阵.
		 * @param matrix 矩阵.
		 */
		public function concat(matrix:Array):void
		{
			matrix = this.fixMatrix(matrix);
			if(matrix.length != LENGTH)
			{
				return;
			}
			this.multiplyMatrix(matrix);
		}
		
		/**
		 * 确保矩阵的长度为 25.
		 * @param matrix 需要修复的矩阵.
		 * @return 修复完成的矩阵.
		 */
		protected function fixMatrix(matrix:Array = null):Array
		{
			if(matrix == null)
			{
				return IDENTITY_MATRIX;
			}
			if(matrix is ColorMatrix)
			{
				matrix = matrix.slice(0);
			}
			if(matrix.length < LENGTH)
			{
				matrix = matrix.slice(0, matrix.length).concat(IDENTITY_MATRIX.slice(matrix.length, LENGTH));
			}
			else if(matrix.length > LENGTH)
			{
				matrix = matrix.slice(0, LENGTH);
			}
			return matrix;
		}
		
		/**
		 * 复制矩阵.
		 * @param matrix 矩阵.
		 */
		protected function copyMatrix(matrix:Array):void
		{
			var l:Number = LENGTH;
			for(var i:uint = 0; i < l; i++)
			{
				this[i] = matrix[i];
			}
		}
		
		/**
		 * 乘以另一个矩阵.
		 * @param matrix 矩阵.
		 */
		protected function multiplyMatrix(matrix:Array):void
		{
			var col:Array = [];
			for(var i:uint = 0; i < 5; i++)
			{
				for(var j:uint = 0; j < 5; j++)
				{
					col[j] = this[j + i * 5];
				}
				for(j = 0; j < 5; j++)
				{
					var value:Number = 0;
					for(var k:Number = 0; k < 5; k++)
					{
						value += matrix[j + k * 5] * col[k];
					}
					this[j + i * 5] = value;
				}
			}
		}
		
		/**
		 * 确保数据在指定范围内.
		 * @param value 当前值.
		 * @param limit 最大值和最小值的绝对值.
		 * @return 在指定范围内的值.
		 */
		protected function cleanValue(value:Number, limit:Number):Number
		{
			return Math.min(limit, Math.max(-limit, value));
		}
		
		/**
		 * 获取对应的数组数据.
		 * @return 数组数据.
		 */
		public function toArray():Array
		{
			return slice(0, 20);
		}
		
		/**
		 * 重置数据.
		 */
		public function reset():void
		{
			for(var i:uint = 0; i < LENGTH; i++)
			{
				this[i] = IDENTITY_MATRIX[i];
			}
		}
		
		/**
		 * 返回一个新对象, 它是与当前对象完全相同的副本.
		 * @return 一个新对象, 是当前对象的副本.
		 */
		public function clone():ColorMatrix
		{
			return new ColorMatrix(this);
		}
		
		/**
		 * 返回当前对象的字符串表示形式.
		 * @return 包含属性的值的字符串.
		 */
		public function toString():String
		{
			return "ColorMatrix [ " + this.join(" , ") + " ]";
		}
	}
}
