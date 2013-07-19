/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.load
{
	/**
	 * <code>ResourceParserType</code> 类枚举了类库默认支持的资源解析类型.
	 * @author wizardc
	 */
	public class ResourceParserType
	{
		/**
		 * 纯文本类型, 获取 <code>String</code> 类型数据.
		 */
		public static const TEXT:String = "Text";
		
		/**
		 * JSON 数据类型, 获取 <code>Object</code> 类型数据.
		 */
		public static const JSON:String = "JSON";
		
		/**
		 * XML 数据类型, 获取 <code>XML</code> 类型数据.
		 */
		public static const XML:String = "XML";
		
		/**
		 * URL 编码变量形式的数据, 获取 <code>Object</code> 类型数据.
		 */
		public static const VARIABLES:String = "Variables";
		
		/**
		 * 二进制数据, 获取 <code>ByteArray</code> 类型数据.
		 */
		public static const BYTES:String = "Bytes";
		
		/**
		 * AMF3 数据类型, 获取 <code>Object</code> 类型数据.
		 */
		public static const AMF3:String = "AMF3";
		
		/**
		 * 图片格式类型, 获取 <code>Bitmap</code> 类型数据.
		 */
		public static const PICTURE:String = "Picture";
		
		/**
		 * MP3 音效格式类型, 获取 <code>Sound</code> 类型数据.
		 */
		public static const SOUND:String = "Sound";
		
		/**
		 * SWF 文件格式类型, 获取 <code>Loader</code> 类型数据.
		 */
		public static const SWF:String = "SWF";
		
		/**
		 * 共享脚本库类型, 获取 <code>Loader</code> 类型数据.
		 */
		public static const RSL:String = "RSL";
	}
}
