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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.hammerc.collections.HashMap;
	import org.hammerc.utils.ReflectionUtil;
	
	/**
	 * <code>BitmapClip</code> 类用于优化矢量图组成的影片剪辑.
	 * <p>所有矢量图都会被转换为位图进行显示, 故本对象在拉伸旋转的情况下会出现锯齿现象.</p>
	 * @author wizardc
	 */
	public class BitmapClip extends Sprite
	{
		private static var bitmapClipCache:Dictionary = new Dictionary();
		
		/**
		 * 添加一个位图剪辑的资源缓存.
		 * @param source 要转换的影片剪辑类名称.
		 * @param applicationDomain 要转换的影片剪辑所在的应用程序域.
		 * @return 添加缓存是否成功.
		 */
		public static function addBitmapClipCache(source:String, applicationDomain:ApplicationDomain = null):Boolean
		{
			if(source == null)
			{
				return false;
			}
			if(applicationDomain == null)
			{
				applicationDomain = ApplicationDomain.currentDomain;
			}
			if(bitmapClipCache[applicationDomain] == null)
			{
				bitmapClipCache[applicationDomain] = new HashMap();
			}
			var cache:HashMap = bitmapClipCache[applicationDomain] as HashMap;
			if(!cache.containsKey(source))
			{
				var assetClass:Class = ReflectionUtil.getClass(source, applicationDomain);
				if(assetClass == null)
				{
					return false;
				}
				var movieClip:MovieClip = new assetClass() as MovieClip;
				if(movieClip == null)
				{
					return false;
				}
				var bitmapFrames:Vector.<BitmapFrame> = new Vector.<BitmapFrame>();
				for(var i:int = 0, len:int = movieClip.totalFrames; i < len; i++)
				{
					movieClip.gotoAndStop(i);
					var rect:Rectangle = movieClip.getBounds(movieClip.root);
					if(rect.isEmpty())
					{
						bitmapFrames.push(new BitmapFrame(0, 0, null, movieClip.currentFrameLabel, movieClip.currentLabel, movieClip.currentLabels));
					}
					else
					{
						var bitmapData:BitmapData = new BitmapData(movieClip.width, movieClip.height, true, 0x00000000);
						bitmapData.draw(movieClip, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
						var frame:BitmapFrame = new BitmapFrame(rect.x, rect.y, bitmapData, movieClip.currentFrameLabel, movieClip.currentLabel, movieClip.currentLabels);
						bitmapFrames.push(frame);
					}
				}
				cache.put(source, bitmapFrames);
			}
			return true;
		}
		
		/**
		 * 获取一个位图剪辑的资源缓存.
		 * @param source 要转换的影片剪辑类名称.
		 * @param applicationDomain 要转换的影片剪辑所在的应用程序域.
		 * @return 指定的位图剪辑资源缓存.
		 */
		public static function getBitmapClipCache(source:String, applicationDomain:ApplicationDomain = null):Vector.<BitmapFrame>
		{
			if(source == null)
			{
				return null;
			}
			if(applicationDomain == null)
			{
				applicationDomain = ApplicationDomain.currentDomain;
			}
			if(bitmapClipCache[applicationDomain] == null)
			{
				return null;
			}
			var cache:HashMap = bitmapClipCache[applicationDomain] as HashMap;
			if(!cache.containsKey(source))
			{
				return null;
			}
			return cache.get(source) as Vector.<BitmapFrame>;
		}
		
		/**
		 * 移除一个位图剪辑的资源缓存.
		 * @param source 要转换的影片剪辑类名称.
		 * @param applicationDomain 要转换的影片剪辑所在的应用程序域.
		 * @return 移除缓存是否成功.
		 */
		public static function removeBitmapClipCache(source:String, applicationDomain:ApplicationDomain = null):Boolean
		{
			if(source == null)
			{
				return false;
			}
			if(applicationDomain == null)
			{
				applicationDomain = ApplicationDomain.currentDomain;
			}
			if(bitmapClipCache[applicationDomain] == null)
			{
				return false;
			}
			var cache:HashMap = bitmapClipCache[applicationDomain] as HashMap;
			if(!cache.containsKey(source))
			{
				return false;
			}
			cache.remove(source);
			if(cache.size() == 0)
			{
				delete bitmapClipCache[applicationDomain];
			}
			return true;
		}
		
		/**
		 * 记录源影片剪辑所在的应用程序域.
		 */
		protected var _sourceApplicationDomain:ApplicationDomain;
		
		/**
		 * 记录源影片剪辑类名.
		 */
		protected var _source:String;
		
		/**
		 * 显示位图的对象.
		 */
		protected var _bitmap:Bitmap;
		
		/**
		 * 记录每一帧对应的位图对象索引.
		 */
		protected var _bitmapFrames:Vector.<BitmapFrame>;
		
		/**
		 * 记录当前播放的帧数.
		 */
		protected var _currentFrame:int = 1;
		
		/**
		 * 记录位图剪辑对象的总帧数.
		 */
		protected var _totalFrames:int = 1;
		
		/**
		 * 记录当前是否正在播放.
		 */
		protected var _playing:Boolean = true;
		
		/**
		 * 记录播放的循环次数.
		 */
		protected var _loop:int = -1;
		
		/**
		 * 记录播放结束后是否隐藏本对象.
		 */
		protected var _hide:Boolean = false;
		
		/**
		 * 创建一个 <code>BitmapClip</code> 对象.
		 * @param source 源影片剪辑类名.
		 * @param sourceApplicationDomain 源影片剪辑所在的应用程序域.
		 * @param pixelSnapping 控制是否贴紧至最近的像素.
		 * @param smoothing 控制在缩放时是否对位图进行平滑处理.
		 */
		public function BitmapClip(source:String = null, sourceApplicationDomain:ApplicationDomain = null, pixelSnapping:String = "auto", smoothing:Boolean = false)
		{
			_bitmap = new Bitmap(null, pixelSnapping, smoothing);
			this.addChild(_bitmap);
			this.sourceApplicationDomain = sourceApplicationDomain;
			this.source = source;
			this.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		}
		
		/**
		 * 设置或获取源影片剪辑类名.
		 */
		public function set source(value:String):void
		{
			if(_source != value)
			{
				if(addBitmapClipCache(value, _sourceApplicationDomain))
				{
					_source = value;
					_bitmapFrames = getBitmapClipCache(_source, _sourceApplicationDomain);
					_currentFrame = 1;
					_totalFrames = _bitmapFrames.length;
				}
			}
			if(_source == null)
			{
				this.dispose();
			}
		}
		public function get source():String
		{
			return _source;
		}
		
		/**
		 * 设置或获取源影片剪辑所在的应用程序域.
		 */
		public function set sourceApplicationDomain(value:ApplicationDomain):void
		{
			_sourceApplicationDomain = value;
		}
		public function get sourceApplicationDomain():ApplicationDomain
		{
			return _sourceApplicationDomain;
		}
		
		/**
		 * 设置或获取是否贴紧至最近的像素.
		 */
		public function set pixelSnapping(value:String):void
		{
			_bitmap.pixelSnapping = value;
		}
		public function get pixelSnapping():String
		{
			return _bitmap.pixelSnapping;
		}
		
		/**
		 * 设置或获取在缩放时是否对位图进行平滑处理.
		 */
		public function set smoothing(value:Boolean):void
		{
			_bitmap.smoothing = value;
		}
		public function get smoothing():Boolean
		{
			return _bitmap.smoothing;
		}
		
		/**
		 * 获取当前播放的帧数.
		 */
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		/**
		 * 获取时间轴中当前帧上的标签.
		 */
		public function get currentFrameLabel():String
		{
			return _bitmapFrames[_currentFrame - 1].currentFrameLabel;
		}
		
		/**
		 * 获取时间轴中播放头所在的当前标签.
		 */
		public function get currentLabel():String
		{
			return _bitmapFrames[_currentFrame - 1].currentLabel;
		}
		
		/**
		 * 获取当前的 FrameLabel 对象组成的数组.
		 */
		public function get currentLabels():Array
		{
			return _bitmapFrames[_currentFrame - 1].currentLabels;
		}
		
		/**
		 * 获取位图剪辑对象的总帧数.
		 */
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		/**
		 * 获取当前是否正在播放.
		 */
		public function get isPlaying():Boolean
		{
			return _playing;
		}
		
		/**
		 * 每当进入帧时都会调用本方法, 处理位图剪辑的核心循环方法.
		 * @param event 事件对象.
		 */
		protected function enterFrameHandler(event:Event):void
		{
			if(_bitmapFrames != null && _bitmapFrames.length != 0)
			{
				_bitmap.x = _bitmapFrames[_currentFrame - 1].x;
				_bitmap.y = _bitmapFrames[_currentFrame - 1].y;
				_bitmap.bitmapData = _bitmapFrames[_currentFrame - 1].bitmapData;
				if(_playing)
				{
					if(_currentFrame == _totalFrames)
					{
						if(_loop == 0)
						{
							_playing = false;
							if(_hide)
							{
								this.visible = false;
							}
						}
						else
						{
							if(_loop != -1)
							{
								_loop--;
							}
							_currentFrame = 1;
						}
					}
					else
					{
						_currentFrame++;
						switch(_bitmapFrames[_currentFrame - 1].scriptType)
						{
							case BitmapFrame.STOP_SCRIPT:
							case BitmapFrame.GOTO_AND_STOP_SCRIPT:
								_playing = false;
								break;
							case BitmapFrame.GOTO_AND_PLAY_SCRIPT:
							case BitmapFrame.GOTO_AND_STOP_SCRIPT:
								_currentFrame = _bitmapFrames[_currentFrame - 1].scriptGotoFrame;
								break;
						}
					}
				}
			}
		}
		
		/**
		 * 向指定帧对象添加脚本.
		 * <ul>
		 *   <li>仅支持四种基本的播放跳转控制脚本.</li>
		 *   <li>被设置的帧如果已经存在脚本则新设置的脚本会替换旧脚本.</li>
		 *   <li>帧脚本全局通用, 只要向任一实例添加帧脚本, 指向同样源影片剪辑的所有位图剪辑都将获得同样的帧脚本.</li>
		 * </ul>
		 * @param frame 要添加脚本的帧对象.
		 * @param script 要添加的脚本类型, 设置为 <code>BitmapFrame.NO_SCRIPT</code> 会移除指定帧的脚本.
		 * @param gotoFrame 如果为跳转类型的脚本本参数指定其会跳转到的帧对象.
		 */
		public function addFrameScript(frame:Object, script:int, gotoFrame:Object = null):void
		{
			var currentFrame:int = this.frameToNumber(frame);
			currentFrame = currentFrame < 1 ? 1 : (currentFrame > _totalFrames ? _totalFrames : currentFrame);
			switch(script)
			{
				case BitmapFrame.NO_SCRIPT:
				case BitmapFrame.PLAY_SCRIPT:
				case BitmapFrame.STOP_SCRIPT:
					_bitmapFrames[currentFrame - 1].scriptType = script;
					_bitmapFrames[currentFrame - 1].scriptGotoFrame = 1;
					break;
				case BitmapFrame.GOTO_AND_PLAY_SCRIPT:
				case BitmapFrame.GOTO_AND_STOP_SCRIPT:
					_bitmapFrames[currentFrame - 1].scriptType = script;
					var targetFrame:int = this.frameToNumber(gotoFrame);
					targetFrame = targetFrame < 1 ? 1 : (targetFrame > _totalFrames ? _totalFrames : targetFrame);
					_bitmapFrames[currentFrame - 1].scriptGotoFrame = targetFrame;
					break;
			}
		}
		
		/**
		 * 跳转到指定帧并播放.
		 * @param frame 表示播放头转到的帧编号的数字, 或者表示播放头转到的帧标签的字符串.
		 * @param loop 播放的循环次数, -1 表示无限循环.
		 * @param hide 播放结束后是否隐藏本对象.
		 */
		public function gotoAndPlay(frame:Object, loop:int = -1, hide:Boolean = false):void
		{
			var currentFrame:int = this.frameToNumber(frame);
			currentFrame = currentFrame < 1 ? 1 : (currentFrame > _totalFrames ? _totalFrames : currentFrame);
			_currentFrame = currentFrame;
			if(this.checkScript())
			{
				this.play(loop, hide);
			}
		}
		
		/**
		 * 跳转到指定帧并暂停.
		 * @param frame 表示播放头转到的帧编号的数字, 或者表示播放头转到的帧标签的字符串.
		 */
		public function gotoAndStop(frame:Object):void
		{
			var currentFrame:int = this.frameToNumber(frame);
			currentFrame = currentFrame < 1 ? 1 : (currentFrame > _totalFrames ? _totalFrames : currentFrame);
			_currentFrame = currentFrame;
			if(this.checkScript())
			{
				this.stop();
			}
		}
		
		/**
		 * 转换帧数或帧标签为帧数.
		 * @param frame 表示播放头转到的帧编号的数字, 或者表示播放头转到的帧标签的字符串.
		 * @return 对应的帧数.
		 */
		protected function frameToNumber(frame:Object):int
		{
			if(frame is Number)
			{
				return int(frame);
			}
			else if(frame as String)
			{
				for(var i:int = 0; i < _totalFrames; i++)
				{
					if(_bitmapFrames[i].currentFrameLabel == String(frame))
					{
						return i + 1;
					}
				}
				return 1;
			}
			return 1;
		}
		
		/**
		 * 检测当前帧上的脚本.
		 * @return 如果当前帧上没有任何脚本则返回 <code>true</code>, 否则返回 <code>false</code>;
		 */
		protected function checkScript():Boolean
		{
			var bitmapFrame:BitmapFrame = _bitmapFrames[_currentFrame - 1];
			switch(bitmapFrame.scriptType)
			{
				case BitmapFrame.NO_SCRIPT:
					return true;
				case BitmapFrame.PLAY_SCRIPT:
					_playing = true;
					break;
				case BitmapFrame.STOP_SCRIPT:
					_playing = false;
					break;
				case BitmapFrame.GOTO_AND_PLAY_SCRIPT:
					this.gotoAndPlay(bitmapFrame.scriptGotoFrame);
					break;
				case BitmapFrame.GOTO_AND_STOP_SCRIPT:
					this.gotoAndStop(bitmapFrame.scriptGotoFrame);
					break;
			}
			return false;
		}
		
		/**
		 * 开始播放位图剪辑.
		 * @param loop 播放的循环次数, -1 表示无限循环.
		 * @param hide 播放结束后是否隐藏本对象.
		 */
		public function play(loop:int = -1, hide:Boolean = false):void
		{
			_playing = true;
			_loop = loop < -1 ? -1 : loop;
			_hide = hide;
		}
		
		/**
		 * 暂停播放.
		 */
		public function stop():void
		{
			_playing = false;
		}
		
		/**
		 * 将播放头转到下一帧并停止.
		 */
		public function nextFrame():void
		{
			if(_currentFrame == _totalFrames)
			{
				_currentFrame = 1;
			}
			else
			{
				_currentFrame++;
			}
			if(this.checkScript())
			{
				_playing = false;
			}
		}
		
		/**
		 * 将播放头转到前一帧并停止.
		 */
		public function prevFrame():void
		{
			if(_currentFrame == 0)
			{
				_currentFrame = _totalFrames;
			}
			else
			{
				_currentFrame--;
			}
			if(this.checkScript())
			{
				_playing = false;
			}
		}
		
		/**
		 * 释放本对象的资源.
		 * @param removeCache 是否同时移除源影片剪辑的缓存资源.
		 */
		public function dispose(removeCache:Boolean = false):void
		{
			if(removeCache)
			{
				removeBitmapClipCache(_source, _sourceApplicationDomain);
			}
			_sourceApplicationDomain = null;
			_source = null;
			_bitmap.bitmapData = null;
			_bitmapFrames = null;
			_currentFrame = 1;
			_totalFrames = 1;
			_playing = true;
			_loop = -1;
			_hide = false;
		}
	}
}
