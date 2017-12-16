// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.tools.packer
{
	/**
	 * <code>MaxRectsPacker</code> 类实现 MaxRects 图片排列算法, 可以将多个大小不同的图片尽量多的压入指定大小的整图中.
	 * <p>算法实现来自 <b>maxrects-packer</b> 地址: <a href="https://github.com/soimy/maxrects-packer">https://github.com/soimy/maxrects-packer</a>.</p>
	 * @author wizardc
	 */
	public class MaxRectsPacker
	{
		private var _maxWidth:int;
		private var _maxHeight:int;
		private var _padding:int;
		private var _smart:Boolean;
		private var _pot:Boolean;
		private var _square:Boolean;
		
		private var _oversizedBins:Vector.<OversizedElementBin>;
		private var _bins:Vector.<BinaryTreeBin>;
		
		/**
		 * 创建一个 <code>MaxRectsPacker</code> 对象.
		 * @param maxWidth 图集最大宽度.
		 * @param maxHeight 图集最大高度.
		 * @param padding 图集间隔.
		 * @param smart 是否尽可能的使图集尺寸最小.
		 * @param pot 输出的图集是否为 2 的 n 次方.
		 * @param square 输出的图集是否为正方形.
		 */
		public function MaxRectsPacker(maxWidth:int, maxHeight:int, padding:int = 1, smart:Boolean = true, pot:Boolean = true, square:Boolean = false)
		{
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			_padding = padding;
			_smart = smart;
			_pot = pot;
			_square = square;
			_bins = new Vector.<BinaryTreeBin>();
			_oversizedBins = new Vector.<OversizedElementBin>();
		}
		
		/**
		 * 获取超出尺寸的不能合并的区域.
		 */
		public function get oversizedBins():Vector.<OversizedElementBin>
		{
			return this._oversizedBins;
		}
		
		/**
		 * 获取已经合并到图集中的所有图集对象.
		 * 需要多张图集时会输出多个元素.
		 * 数据格式如下: [ { width: int, height: int, maxWidth: int, maxHeight: int, rects: [ { x: int, y: int, width: int, height: int, data: Object }, ... ], freeRects: [ { x: int, y: int, width: int, height: int }, ... ] }, ... ].
		 */
		public function get bins():Vector.<BinaryTreeBin>
		{
			return this._bins;
		}
		
		/**
		 * 添加一个图片区域.
		 * @param width 宽度.
		 * @param height 高度.
		 * @param data 自定义数据.
		 */
		public function add(width:int, height:int, data:Object):void
		{
			if(width > _maxWidth || height > _maxHeight)
			{
				_oversizedBins.push(new OversizedElementBin(width, height, data));
			}
			else
			{
				for(var i:int = 0; i < _bins.length; i++)
				{
					var item: Object = _bins[i];
					if(item.add(width, height, data))
					{
						return;
					}
				}
				var bin:BinaryTreeBin = new BinaryTreeBin(_maxWidth, _maxHeight, _padding, _smart, _pot, _square);
				bin.add(width, height, data);
				_bins.push(bin);
			}
		}
		
		/**
		 * 添加多个数据.
		 * 建议只使用一次该方法添加所有的数据, 添加的数据会先进行排序再进行单个添加, 这样可以得到尽可能小的图集.
		 * @param rects 支持的格式 [ { width: number, height: number, data: Object }, ... ].
		 */
		public function addArray(rects:Array):void
		{
			sort(rects).forEach(function(rect:Object, index:Number, array:Array):void
				{
					add(rect.width, rect.height, rect.data);
				});
		}
		
		private function sort(rects:Array):Array
		{
			return rects.slice().sort(function(a:Object, b:Object):Number
				{
					return Math.max(b.width, b.height) - Math.max(a.width, a.height);
				});
		}
	}
}
