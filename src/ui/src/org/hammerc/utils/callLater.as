/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.utils
{
	/**
	 * 在下一次屏幕绘制时触发注册的方法.
	 * @param method 下一次屏幕绘制时会被触发的方法.
	 * @param delay 方法调用的延迟, 0 表示使用 <code>Event.RENDER</code> 事件在本帧结束时调用注册方法, 大于 0 则表示使用 <code>Event.ENTER_FRAME</code> 事件延迟指定帧数调用注册方法.
	 * @param args 传递给该方法的参数.
	 */
	public function callLater(method:Function, delay:int = 0, ...args):void
	{
		DelayCaller.getInstance().callLater.apply(null, [method, delay].concat(args));
	}
}

import flash.display.Shape;
import flash.events.Event;

import org.hammerc.core.HammercGlobals;

/**
 * <code>DelayCaller</code> 类为单例类, 实现了延迟调用方法的功能.
 * @author wizardc
 */
class DelayCaller extends Shape
{
	private static var _instance:DelayCaller;
	
	/**
	 * 获取本类的唯一实例.
	 * @return 本类的唯一实例.
	 */
	public static function getInstance():DelayCaller
	{
		if(!_instance)
		{
			_instance = new DelayCaller();
		}
		return _instance;
	}
	
	private var _methodList:Vector.<MethodInfo>;
	private var _listenForEnterFrame:Boolean = false;
	private var _listenForRender:Boolean = false;
	
	/**
	 * 创建一个 <code>DelayCaller</code> 对象.
	 */
	public function DelayCaller()
	{
		_methodList = new Vector.<MethodInfo>();
	}
	
	/**
	 * 在下一次屏幕绘制时触发注册的方法.
	 * @param method 下一次屏幕绘制时会被触发的方法.
	 * @param delay 方法调用的延迟, 0 表示使用 <code>Event.RENDER</code> 事件在本帧结束时调用注册方法, 大于 0 则表示使用 <code>Event.ENTER_FRAME</code> 事件延迟指定帧数调用注册方法.
	 * @param args 传递给该方法的参数.
	 */
	public function callLater(method:Function, delay:int = 0, ...args):void
	{
		var methodInfo:MethodInfo = new MethodInfo(method, delay, args);
		_methodList.push(methodInfo);
		if(!_listenForEnterFrame && !methodInfo.useRender)
		{
			this.addEventListener(Event.ENTER_FRAME, callbackHandler, false, int.MIN_VALUE, false);
			_listenForEnterFrame = true;
		}
		if(methodInfo.useRender)
		{
			if(!_listenForRender && HammercGlobals.stage != null)
			{
				HammercGlobals.stage.addEventListener(Event.RENDER, callbackHandler, false, int.MIN_VALUE, false);
				HammercGlobals.stage.invalidate();
				_listenForRender = true;
			}
		}
	}
	
	private function callbackHandler(event:Event):void
	{
		var onRender:Boolean = event.type == Event.RENDER;
		var methodInfo:MethodInfo;
		for(var i:int = 0; i < _methodList.length; i++)
		{
			methodInfo = _methodList[i];
			if(onRender && !methodInfo.useRender)
			{
				continue;
			}
			if(!methodInfo.useRender)
			{
				methodInfo.delay--;
			}
			if(methodInfo.delay > 0)
			{
				continue;
			}
			_methodList.splice(i, 1);
			i--;
			methodInfo.method.apply(null, methodInfo.args);
		}
		if(onRender && _listenForRender)
		{
			HammercGlobals.stage.removeEventListener(Event.RENDER, callbackHandler);
			_listenForRender = false;
		}
		if(!onRender && _methodList.length == 0 && _listenForEnterFrame)
		{
			this.removeEventListener(Event.ENTER_FRAME, callbackHandler);
			_listenForEnterFrame = false;
		}
	}
}

/**
 * <code>MethodInfo</code> 类记录一个要延迟运行的方法的信息.
 * @author wizardc
 */
class MethodInfo
{
	/**
	 * 记录要延迟运行的方法.
	 */
	protected var _method:Function;
	
	/**
	 * 记录要延迟的帧数.
	 */
	protected var _delay:int;
	
	/**
	 * 记录要传递到方法中的所有参数.
	 */
	protected var _args:*;
	
	/**
	 * 记录是否使用 <code>Event.RENDER</code> 事件.
	 */
	protected var _useRender:Boolean;
	
	/**
	 * 创建一个 <code>MethodInfo</code> 对象.
	 * @param method 要延迟运行的方法.
	 * @param delay 要延迟的帧数.
	 * @param args 要传递到方法中的所有参数.
	 */
	public function MethodInfo(method:Function, delay:int, args:*)
	{
		_method = method;
		_delay = Math.abs(delay);
		_args = args;
		_useRender = _delay == 0;
	}
	
	/**
	 * 获取要延迟运行的方法.
	 */
	public function get method():Function
	{
		return _method;
	}
	
	/**
	 * 设置或获取要延迟的帧数.
	 */
	public function set delay(value:int):void
	{
		_delay = value;
	}
	public function get delay():int
	{
		return _delay;
	}
	
	/**
	 * 获取要传递到方法中的所有参数.
	 */
	public function get args():*
	{
		return _args;
	}
	
	/**
	 * 获取是否使用 <code>Event.RENDER</code> 事件.
	 */
	public function get useRender():Boolean
	{
		return _useRender;
	}
}
