// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.utils
{
	import flash.filesystem.File;
	
	/**
	 * <code>PathUtil</code> 类包含了多个处理文件路径的方法.
	 * @author wizardc
	 */
	public class PathUtil
	{
		/**
		 * 获取不包含文件名称的路径.
		 * @param path 文件或文件夹的路径.
		 * @return 不包含文件名称的路径.
		 */
		public static function getPathWithoutName(path:String):String
		{
			path = escapeUrl(path);
			return path.substr(0, path.lastIndexOf("/") + 1);
		}
		
		/**
		 * 从一个路径中取出文件名.
		 * @param path 包含文件名的路径.
		 * @param extension 是否保留文件的扩展名.
		 * @return 文件名.
		 */
		public static function getNameByPath(path:String, extension:Boolean = true):String
		{
			path = escapeUrl(path);
			var fileName:String = path.substr(path.lastIndexOf("/") + 1);
			if(extension)
			{
				return fileName;
			}
			var index:int = fileName.lastIndexOf(".");
			if(index == -1)
			{
				return fileName;
			}
			return fileName.substring(0, index);
		}
		
		/**
		 * 取出路径中的文件扩展名.
		 * @param path 文件的路径.
		 * @return 文件的扩展名, 没有扩展名则返回 <code>null</code>.
		 */
		public static function getExtension(path:String):String
		{
			var fileName:String = getNameByPath(path);
			var index:int = fileName.lastIndexOf(".");
			if(index == -1)
			{
				return null;
			}
			return fileName.substr(index + 1);
		}
		
		/**
		 * 转换 url 中的反斜杠为斜杠.
		 * @param url 需要处理的 url.
		 * @return 转换后的 url.
		 */
		public static function escapeUrl(url:String):String
		{
			return url == null ? "" : url.split("\\").join("/");
		}
		
		/**
		 * 获取一个目录下的所有文件夹或文件列表.
		 * @param directory 指定的文件夹或文件. 如果是文件路径则取该文件所在的文件夹为根目录.
		 * @param subdirectories 是否要遍历子目录.
		 * @param includeFolder 返回的列表是否包含文件夹.
		 * @param includeFile 返回的列表是否包含文件.
		 * @return 指定目录下的所有文件夹或文件列表.
		 */
		public static function getAllFiles(directory:File, subdirectories:Boolean = false, includeFolder:Boolean = false, includeFile:Boolean = true):Vector.<File>
		{
			var fileList:Vector.<File> = new Vector.<File>();
			if(!includeFolder && !includeFile)
			{
				return fileList;
			}
			if(!directory.isDirectory)
			{
				directory.nativePath = getPathWithoutName(directory.nativePath);
			}
			if(directory.exists && directory.isDirectory)
			{
				getAllFilesImpl(fileList, directory, subdirectories, includeFolder, includeFile);
			}
			return fileList;
		}
		
		private static function getAllFilesImpl(fileList:Vector.<File>, directory:File, subdirectories:Boolean, includeFolder:Boolean, includeFile:Boolean):void
		{
			var files:Array = directory.getDirectoryListing();
			for each(var file:File in files)
			{
				if(file.isDirectory)
				{
					if(includeFolder)
					{
						fileList.push(file);
					}
					if(subdirectories)
					{
						getAllFilesImpl(fileList, file, subdirectories, includeFolder, includeFile);
					}
				}
				else
				{
					if(includeFile)
					{
						fileList.push(file);
					}
				}
			}
		}
		
		/**
		 * 获取指定路径下不重复的文件名称.
		 * <p>新文件名为: 测试的文件名+前缀+编号+后缀+.+文件扩展名. 如：测试的文件名为 test.txt, 
		 * 目录下文件 test.txt 和 test(1).txt 都存在, 则返回 test(2).txt.</p>
		 * @param directory 指定的文件夹或文件. 如果是文件路径则取该文件所在的文件夹为指定的目录.
		 * @param fileName 要进行测试的文件名.
		 * @param prefix 如果测试的文件名已经存在则新文件名编号的前缀.
		 * @param suffix 如果测试的文件名已经存在则新文件名编号的后缀.
		 * @return 可以使用的指定路径下不重复的文件名称.
		 */
		public static function getNotRepeatName(directory:File, fileName:String, prefix:String = "(", suffix:String = ")"):String
		{
			if(!directory.isDirectory)
			{
				directory.nativePath = getPathWithoutName(directory.nativePath);
			}
			var fileList:Vector.<File> = getAllFiles(directory);
			var fileNameList:Vector.<String> = new Vector.<String>();
			for each(var file:File in fileList)
			{
				fileNameList.push(getNameByPath(file.nativePath));
			}
			var name:String = getNameByPath(fileName, false);
			var extension:String = getExtension(fileName);
			var index:int = 1;
			var testName:String = fileName;
			while(fileNameList.indexOf(testName) != -1)
			{
				testName = name + prefix + index + suffix;
				if(extension != null)
				{
					testName += "." + extension;
				}
				index++;
			}
			return testName;
		}
	}
}
