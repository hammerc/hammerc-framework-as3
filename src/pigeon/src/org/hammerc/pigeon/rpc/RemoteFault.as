// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.pigeon.rpc
{
	/**
	 * <code>RemoteFault</code> 类记录了远程调用失败的详细信息.
	 * @author wizardc
	 */
	public class RemoteFault extends Error
	{
		/**
		 * 错误码.
		 */
		protected var _faultCode:String;
		
		/**
		 * 错误信息.
		 */
		protected var _faultString:String;
		
		/**
		 * 错误细节.
		 */
		protected var _faultDetail:String;
		
		/**
		 * 创建一个 <code>RemoteFault</code> 对象.
		 * @param faultCode 设置错误码.
		 * @param faultString 设置错误信息.
		 * @param faultDetail 设置错误细节.
		 */
		public function RemoteFault(faultCode:String, faultString:String, faultDetail:String = null)
		{
			super("faultCode:" + faultCode + " faultString:'" + faultString + "' faultDetail:'" + faultDetail + "'");
			_faultCode = faultCode;
			_faultString = faultString ? faultString : "";
			_faultDetail = faultDetail;
		}
		
		/**
		 * 获取错误码.
		 */
		public function get faultCode():String
		{
			return _faultCode;
		}
		
		/**
		 * 获取错误信息.
		 */
		public function get faultString():String
		{
			return _faultString;
		}
		
		/**
		 * 获取错误细节.
		 */
		public function get faultDetail():String
		{
			return _faultDetail;
		}
		
		/**
		 * 获取该错误的字符串表示.
		 * @return 该错误的字符串表示.
		 */
		public function toString():String
		{
			return "[RPC Fault: faultCode=\"" + faultCode + "\" faultString=\"" + faultString + "\"" + " faultDetail=\"" + faultDetail + "\"]";
		}
	}
}
