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
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * 用浏览器打开一个地址.
	 * @param url 需要打开的地址.
	 * @param target 打开的方式.
	 * <p>
	 * 可以输入某个特定窗口的名称, 或使用以下值之一:
	 * <ul>
	 * <li><code>_self</code>, 指定当前窗口中的当前帧.</li>
	 * <li><code>_blank</code>, 指定一个新窗口.</li>
	 * <li><code>_parent</code>, 指定当前帧的父级.</li>
	 * <li><code>_top</code>, 指定当前窗口中的顶级帧.</li>
	 * </ul>
	 * </p>
	 */
	public function openURL(url:String, target:String = "_self"):void
	{
		navigateToURL(new URLRequest(url), target);
	}
}
