/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.plugins
{
	import org.hammerc.core.hammerc_internal;
	import org.hammerc.tween.Tween;
	
	use namespace hammerc_internal;
	
	/**
	 * <code>TweenPluginManager</code> 类管理缓动中使用到的所有补丁对象.
	 * @author wizardc
	 */
	public class TweenPluginManager
	{
		/**
		 * 激活一个补丁对象.
		 * @param plugin 要被激活的补丁类对象.
		 */
		public static function activePlugin(plugin:Class):void
		{
			if(plugin == null)
			{
				return;
			}
			var instance:ITweenPlugin = new plugin() as ITweenPlugin;
			if(instance == null)
			{
				return;
			}
			if(!Tween.hammerc_internal::pluginKeyMap.hasOwnProperty(instance.key))
			{
				Tween.hammerc_internal::pluginKeyMap[instance.key] = plugin;
			}
		}
		
		/**
		 * 激活多个补丁对象.
		 * @param plugins 要被激活的补丁类对象列表.
		 */
		public static function activePlugins(plugins:Vector.<Class>):void
		{
			for each(var plugin:Class in plugins)
			{
				activePlugin(plugin);
			}
		}
		
		/**
		 * 判断指定的键名是否被补丁支持.
		 * @param key 指定的键名.
		 * @return 指定的键名是否被补丁支持.
		 */
		public static function isPluginSupport(key:String):Boolean
		{
			return Tween.hammerc_internal::pluginKeyMap.hasOwnProperty(key);
		}
	}
}
