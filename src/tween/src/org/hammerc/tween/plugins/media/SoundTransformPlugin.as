/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.tween.plugins.media
{
	import flash.media.SoundTransform;
	import flash.utils.getQualifiedClassName;
	
	import org.hammerc.tween.plugins.AbstractPropertyPlugin;
	
	/**
	 * <code>SoundTransformPlugin</code> 类定义了支持声音转换的补丁.
	 * @author wizardc
	 */
	public class SoundTransformPlugin extends AbstractPropertyPlugin
	{
		/**
		 * 作用于目标对象上的属性名称.
		 */
		public static const PROPERTY_KEY:String = "soundTransform";
		
		/**
		 * 补丁对象的键名.
		 */
		public static const PLUGIN_KEY:String = "soundTransform";
		
		/**
		 * 缓动属性的列表.
		 */
		public static const TWEEN_KEYS:Vector.<String> = new <String>["leftToLeft", "leftToRight", "pan", "rightToLeft", "rightToRight", "volume"];
		
		/**
		 * 用来设置的键名列表.
		 */
		public static const SETTING_KEYS:Vector.<String> = new <String>[];
		
		/**
		 * 创建一个 <code>SoundTransformPlugin</code> 对象.
		 */
		public function SoundTransformPlugin()
		{
			super(PROPERTY_KEY, PLUGIN_KEY, TWEEN_KEYS, SETTING_KEYS);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function checkSupport(target:Object):Boolean
		{
			if(target.hasOwnProperty(PROPERTY_KEY) && getQualifiedClassName(target[PROPERTY_KEY]) == "flash.media::SoundTransform")
			{
				return true;
			}
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getDefaultInstance():Object
		{
			return new SoundTransform();
		}
	}
}
