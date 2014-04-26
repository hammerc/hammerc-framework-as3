/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.struct
{
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import org.hammerc.core.AbstractEnforcer;
	
	/**
	 * <code>Struct</code> 类是可以写入字节流和从字节流中读取的自定义数据类.
	 * @author wizardc
	 */
	public class Struct implements IExternalizable
	{
		/**
		 * 自定义数据类的编码字节序.
		 */
		public static var STRUCT_ENDIAN:String = Endian.BIG_ENDIAN;
		
		/**
		 * 创建一个 <code>Struct</code> 对象.
		 */
		public function Struct()
		{
		}
		
		/**
		 * 将该类序列化为字节数组.
		 * @param output 输出流对象.
		 */
		final public function writeExternal(output:IDataOutput):void
		{
			output.endian = STRUCT_ENDIAN;
			this.writeToBytes(output);
		}
		
		/**
		 * 编码本对象.
		 * @param output 输出流对象.
		 */
		protected function writeToBytes(output:IDataOutput):void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * 从字节数组中读取该类.
		 * @param input 输入流对象.
		 */
		final public function readExternal(input:IDataInput):void
		{
			input.endian = STRUCT_ENDIAN;
			this.readFromBytes(input);
		}
		
		/**
		 * 解码本对象.
		 * @param input 输入流对象.
		 */
		protected function readFromBytes(input:IDataInput):void
		{
			AbstractEnforcer.enforceMethod();
		}
	}
}
