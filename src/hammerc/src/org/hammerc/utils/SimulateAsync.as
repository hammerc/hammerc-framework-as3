// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.utils
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import org.hammerc.events.SimulateAsyncEvent;
	
	/**
	 * @eventType org.hammerc.events.SimulateAsyncEvent.SNIPPET_DONE
	 */
	[Event(name="snippetDone",type="org.hammerc.events.SimulateAsyncEvent")]
	
	/**
	 * @eventType org.hammerc.events.SimulateAsyncEvent.SNIPPET_RUNNING_ERROR
	 */
	[Event(name="snippetRunningError",type="org.hammerc.events.SimulateAsyncEvent")]
	
	/**
	 * @eventType org.hammerc.events.SimulateAsyncEvent.COMPLETE
	 */
	[Event(name="complete",type="org.hammerc.events.SimulateAsyncEvent")]
	
	/**
	 * <code>SimulateAsync</code> 类提供模拟异步处理的功能.
	 * <p>主要用来解决处理大量数据时的界面卡死问题, 核心思想是把大段的代码分隔为多个小段的代码分别在多个帧上运行.</p>
	 * @author wizardc
	 */
	public class SimulateAsync extends EventDispatcher
	{
		private var _interval:int;
		private var _throwError:Boolean;
		
		private var _snippetList:Vector.<Snippet>;
		private var _running:Boolean = false;
		
		private var _shape:Shape;
		private var _runTime:int;
		
		/**
		 * 创建一个 <code>SimulateAsync</code> 对象.
		 * @param interval 代码段的执行间隔.
		 * @param throwError 代码段执行时发生错误是否将该错误抛出.
		 */
		public function SimulateAsync(interval:int = 0, throwError:Boolean = true)
		{
			super();
			_interval = interval;
			_throwError = throwError;
			_snippetList = new Vector.<Snippet>();
			_shape = new Shape();
		}
		
		/**
		 * 设置或获取代码段的执行间隔. 单位为毫秒, 最少会间隔一帧执行.
		 */
		public function set interval(value:int):void
		{
			_interval = value;
		}
		public function get interval():int
		{
			return _interval;
		}
		
		/**
		 * 获取当前是否正在运行.
		 */
		public function get running():Boolean
		{
			return _running;
		}
		
		/**
		 * 添加一个代码段.
		 * @param id 代码段的标示 ID.
		 * @param snippet 代码段.
		 * @param params 传递到代码段的参数.
		 */
		public function appendCodeSnippet(id:String, snippet:Function, params:Array = null):void
		{
			if(_running)
			{
				throw new Error("运行已经开始，无法继续添加新的代码段！");
			}
			if(snippet != null)
			{
				_snippetList.push(new Snippet(id, snippet, params));
			}
		}
		
		/**
		 * 开始执行.
		 */
		public function start():void
		{
			if(_running)
			{
				throw new Error("运行已经开始！");
			}
			if(_snippetList.length == 0)
			{
				this.dispatchEvent(new SimulateAsyncEvent(SimulateAsyncEvent.COMPLETE));
				return;
			}
			_running = true;
			_runTime = getTimer();
			_shape.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			if(getTimer() - _runTime > _interval)
			{
				_shape.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				runNextSnippet();
			}
		}
		
		private function runNextSnippet():void
		{
			if(_snippetList.length == 0)
			{
				this.dispatchEvent(new SimulateAsyncEvent(SimulateAsyncEvent.COMPLETE));
			}
			else
			{
				var snippet:Snippet = _snippetList.shift();
				try
				{
					var time:int = getTimer();
					snippet.method.apply(null, snippet.params);
					this.dispatchEvent(new SimulateAsyncEvent(SimulateAsyncEvent.SNIPPET_DONE, getTimer() - time, snippet.id));
				}
				catch(error:Error)
				{
					if(_throwError)
					{
						throw error;
					}
					else
					{
						this.dispatchEvent(new SimulateAsyncEvent(SimulateAsyncEvent.SNIPPET_RUNNING_ERROR, 0, snippet.id, error));
					}
				}
				_runTime = getTimer();
				_shape.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		/**
		 * 关闭执行并清除数据.
		 */
		public function close():void
		{
			if(_shape.hasEventListener(Event.ENTER_FRAME))
			{
				_shape.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			_snippetList.length = 0;
			_running = false;
		}
	}
}

/**
 * <code>Snippet</code> 类记录一个代码段的数据.
 */
class Snippet
{
	/**
	 * 代码段的标示 ID.
	 */
	public var id:String;
	
	/**
	 * 代码段对应的方法.
	 */
	public var method:Function;
	
	/**
	 * 传递到代码段的参数.
	 */
	public var params:Array;
	
	/**
	 * 创建一个 <code>Snippet</code> 对象.
	 * @param id 代码段的标示 ID.
	 * @param method 代码段对应的方法.
	 * @param params 传递到代码段的参数.
	 */
	public function Snippet(id:String, method:Function, params:Array)
	{
		this.id = id;
		this.method = method;
		this.params = params;
	}
}
