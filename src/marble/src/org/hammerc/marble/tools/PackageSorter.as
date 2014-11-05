// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.tools
{
	import org.hammerc.marble.utils.FileUtil;
	import org.hammerc.utils.StringUtil;
	
	/**
	 * <code>PackageSorter</code> 类为导入包格式化类, 用于代码生成工具中.
	 * @author wizardc
	 */
	public class PackageSorter
	{
		/**
		 * 包名记录列表.
		 */
		protected var _packageList:Vector.<String>;
		
		/**
		 * 创建一个 <code>PackageSorter</code> 对象.
		 */
		public function PackageSorter()
		{
			_packageList = new Vector.<String>();
		}
		
		/**
		 * 获取长度.
		 */
		public function get length():int
		{
			return _packageList.length;
		}
		
		/**
		 * 添加一个包名.
		 * @param value 包名.
		 */
		public function addPackage(value:String):void
		{
			if(_packageList.indexOf(value) == -1)
			{
				_packageList.push(value);
			}
		}
		
		/**
		 * 判断指定包名是否存在.
		 * @param value 包名.
		 * @return 指定包名是否存在.
		 */
		public function hasPackage(value:String):Boolean
		{
			return _packageList.indexOf(value) != -1;
		}
		
		/**
		 * 移除一个包名.
		 * @param value 包名.
		 */
		public function removePackage(value:String):void
		{
			var index:int = _packageList.indexOf(value);
			if(index != -1)
			{
				_packageList.splice(index, 1);
			}
		}
		
		/**
		 * 获取格式化的导入包文本.
		 * @param useSpace 每个包名前面是使用空格还是使用 Tab.
		 * @param numSpace 每个包名前面使用的空格或 Tab 的个数.
		 * @param useSeparatorLine 是否根据包的根目录添加空行.
		 * @param lineSeparator 使用的换行符, 设置为 null 使用系统默认的换行符.
		 * @return 格式化的导入包文本.
		 */
		public function getPackageString(useSpace:Boolean = false, numSpace:int = 1, useSeparatorLine:Boolean = true, lineSeparator:String = null):String
		{
			if(_packageList.length == 0)
			{
				return "";
			}
			if(lineSeparator == null)
			{
				lineSeparator = FileUtil.LINE_SEPARATOR;
			}
			var packageList:Vector.<String> = new Vector.<String>();
			for each(var item:String in _packageList)
			{
				item = item.replace(/;/g, "");
				item = StringUtil.trim(item);
				item = item.replace(/\s{2,}/g, " ");
				packageList.push(item);
			}
			packageList.sort(0);
			if(useSeparatorLine)
			{
				var list:Vector.<String> = new Vector.<String>();
				var lastName:String, nowName:String;
				lastName = getFristPackageName(packageList[0]);
				for each(item in packageList)
				{
					nowName = getFristPackageName(item);
					if(lastName != nowName)
					{
						list.push("");
						lastName = nowName;
					}
					list.push(item);
				}
				packageList = list;
			}
			var space:String = "";
			while(numSpace > 0)
			{
				space += useSpace ? " " : "\t";
				--numSpace;
			}
			var result:String = "";
			var useLineSeparator:Boolean = false;
			for each(item in packageList)
			{
				if(item.length > 0)
				{
					item = item + ";";
				}
				if(useLineSeparator)
				{
					result += lineSeparator + space + item;
				}
				else
				{
					result += space + item;
				}
				useLineSeparator = true;
			}
			return result;
		}
		
		private function getFristPackageName(value:String):String
		{
			var index1:int = value.indexOf(" ");
			var index2:int = value.indexOf(".");
			return value.substring(index1, index2);
		}
		
		/**
		 * 清除所有包名.
		 */
		public function clear():void
		{
			_packageList.length = 0;
		}
		
		/**
		 * 返回一个新对象, 它是与当前对象完全相同的副本.
		 * @return 一个新对象, 是当前对象的副本.
		 */
		public function clone():PackageSorter
		{
			var result:PackageSorter = new PackageSorter();
			result._packageList = _packageList.concat();
			return result;
		}
	}
}
