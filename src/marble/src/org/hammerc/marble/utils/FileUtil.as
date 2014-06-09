/**
 * Copyright (c) 2011-2014 hammerc.org
 * See LICENSE.txt for full license information.
 */
package org.hammerc.marble.utils
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	/**
	 * <code>FileUtil</code> 类包含了文件处理的方法.
	 * @author wizardc
	 */
	public class FileUtil
	{
		/**
		 * 系统路径分隔符.
		 */
		public static const SEPARATOR:String = File.separator;
		
		/**
		 * 系统换行符.
		 */
		public static const LINE_SEPARATOR:String = File.lineEnding;
		
		/**
		 * 保存数据到指定文件.
		 * @param path 文件完整路径名.
		 * @param data 要保存的数据.
		 * @return 是否保存成功.
		 */
		public static function save(path:String, data:Object):Boolean
		{
			path = escapeUrl(path);
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(file.exists)
			{
				//如果存在, 先删除, 防止出现文件名大小写不能覆盖的问题
				deletePath(file.nativePath);
			}
			if(file.isDirectory)
			{
				return false;
			}
			var fs:FileStream = new FileStream;
			try
			{
				fs.open(file, FileMode.WRITE);
				if(data is ByteArray)
				{
					fs.writeBytes(data as ByteArray);
				}
				else if(data is String)
				{
					fs.writeUTFBytes(data as String);
				}
				else
				{
					fs.writeObject(data);
				}
			}
			catch(error:Error)
			{
				return false;
			}
			finally
			{
				fs.close();
			}
			return true;
		}
		
		/**
		 * 打开文件的简便方法.
		 * @param path 要打开的文件路径.
		 * @return 成功返回打开的 <code>FileStream</code> 对象, 失败返回 null.
		 */
		public static function open(path:String):FileStream
		{
			path = escapeUrl(path);
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			var fs:FileStream = new FileStream;
			try
			{
				fs.open(file, FileMode.READ);
			}
			catch(error:Error)
			{
				return null;
			}
			return fs;
		}
		
		/**
		 * 打开文件字节流的简便方法.
		 * @param path 要打开的文件路径.
		 * @return 打开的字节流数据, 失败返回 null.
		 */
		public static function openAsByteArray(path:String):ByteArray
		{
			path = escapeUrl(path);
			var fs:FileStream = open(path);
			if(fs == null)
			{
				return null;
			}
			fs.position = 0;
			var bytes:ByteArray = new ByteArray();
			fs.readBytes(bytes);
			fs.close();
			return bytes;
		}
		
		/**
		 * 打开文本文件的简便方法.
		 * @param path 要打开的文件路径.
		 * @return 打开文本的内容, 失败返回 "".
		 */
		public static function openAsString(path:String):String
		{
			path = escapeUrl(path);
			var fs:FileStream = open(path);
			if(fs == null)
			{
				return "";
			}
			fs.position = 0;
			var content:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return content;
		}
		
		/**
		 * 打开浏览文件对话框.
		 * @param onSelect 打开文件后的回调函数. 单个文件或单个目录: <code>onSelect(file:File)</code>; 多个文件: <code>onSelect(fileList:Array)</code>.
		 * @param type 浏览类型. 1: 选择单个文件, 2: 选择多个文件, 3: 选择目录.
		 * @param typeFilter 文件类型过滤数组.
		 * @param title 对话框标题.
		 * @param defaultPath 默认路径.
		 */
		public static function browseForOpen(onSelect:Function, type:int = 1, typeFilter:Array = null, title:String = "浏览文件", defaultPath:String = null):void
		{
			defaultPath = escapeUrl(defaultPath);
			var file:File;
			if(defaultPath == null)
			{
				file = new File;
			}
			else
			{
				file = File.applicationDirectory.resolvePath(defaultPath);
			}
			switch(type)
			{
				case 1:
					file.addEventListener(Event.SELECT, function(event:Event):void{
						onSelect(event.target as File);
					});
					file.browseForOpen(title, typeFilter);
					break;
				case 2:
					file.addEventListener(FileListEvent.SELECT_MULTIPLE, function(event:FileListEvent):void{
						onSelect(event.files);
					});
					file.browseForOpenMultiple(title, typeFilter);
					break;
				case 3:
					file.addEventListener(Event.SELECT, function(event:Event):void{
						onSelect(event.target as File);
					});
					file.browseForDirectory(title);
					break;
			}
		}
		
		/**
		 * 打开保存文件对话框, 选择要保存的路径.
		 * @param onSelect 保存文件后回调函数: <code>onSelect(file:File)</code>.
		 * @param defaultPath 默认路径.
		 * @param title 对话框标题.
		 */
		public static function browseForSave(onSelect:Function, defaultPath:String = null, title:String = "保存文件"):void
		{
			defaultPath = escapeUrl(defaultPath);
			var file:File;
			if(defaultPath == null)
			{
				file = new File;
			}
			else
			{
				file = File.applicationDirectory.resolvePath(defaultPath);
			}
			file.addEventListener(Event.SELECT, function(event:Event):void{
				onSelect(event.target as File);
			});
			file.browseForSave(title);
		}
		
		/**
		 * 打开保存文件对话框, 并保存数据.
		 * @param data 要保存的数据.
		 * @param defaultPath 默认路径.
		 * @param title 对话框标题.
		 */
		public static function browseAndSave(data:Object, defaultPath:String = null, title:String = "保存文件"):void
		{
			defaultPath = escapeUrl(defaultPath);
			var file:File;
			if(defaultPath == null)
			{
				file = new File;
			}
			else
			{
				file = File.applicationDirectory.resolvePath(defaultPath);
			}
			file.addEventListener(Event.SELECT, function(event:Event):void{
				save(file.nativePath, data);
			});
			file.browseForSave(title);
		}
		
		/**
		 * 移动文件或目录.
		 * @param source 文件源路径.
		 * @param dest 文件要移动到的目标路径.
		 * @param overwrite 是否覆盖同名文件.
		 * @return 是否移动成功.
		 */
		public static function moveTo(source:String, dest:String, overwrite:Boolean = false):Boolean
		{
			source = escapeUrl(source);
			dest = escapeUrl(dest);
			if(source == dest)
			{
				return true;
			}
			var file:File = new File(File.applicationDirectory.resolvePath(source).nativePath);
			//必须创建绝对位置的 File 才能移动成功
			var destFile:File = new File(File.applicationDirectory.resolvePath(dest).nativePath);
			if(destFile.exists)
			{
				deletePath(destFile.nativePath);
			}
			try
			{
				file.moveTo(destFile, overwrite);
			}
			catch(error:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 复制文件或目录.
		 * @param source 文件源路径.
		 * @param dest 文件要移动到的目标路径.
		 * @param overwrite 是否覆盖同名文件.
		 * @return 是否复制成功.
		 */
		public static function copyTo(source:String, dest:String, overwrite:Boolean = false):Boolean
		{
			source = escapeUrl(source);
			dest = escapeUrl(dest);
			if(source == dest)
			{
				return true;
			}
			var file:File = File.applicationDirectory.resolvePath(source);
			//必须创建绝对位置的 File 才能移动成功
			var destFile:File = new File(File.applicationDirectory.resolvePath(dest).nativePath);
			if(destFile.exists)
			{
				deletePath(destFile.nativePath);
			}
			try
			{
				file.copyTo(destFile, overwrite);
			}
			catch(error:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 删除文件或目录.
		 * @param path 要删除的文件源路径.
		 * @param moveToTrash 是否只是移动到回收站.
		 * @return 是否删除成功.
		 */
		public static function deletePath(path:String, moveToTrash:Boolean = false):Boolean
		{
			path = escapeUrl(path);
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			if(moveToTrash)
			{
				try
				{
					file.moveToTrash();
				}
				catch(error:Error)
				{
					return false;
				}
			}
			else
			{
				if(file.isDirectory)
				{
					try
					{
						file.deleteDirectory(true);
					}
					catch(error:Error)
					{
						return false;
					}
				}
				else
				{
					try
					{
						file.deleteFile();
					}
					catch(error:Error)
					{
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 获取文件的文件夹路径.
		 * @param path 指定文件.
		 * @return 文件夹路径, 已包含分隔符.
		 */
		public static function getDirectory(path:String):String
		{
			path = escapeUrl(path);
			var endIndex:int = path.lastIndexOf("/");
			if(endIndex == -1)
			{
				return "";
			}
			return path.substr(0, endIndex + 1);
		}
		
		/**
		 * 获取路径的文件名 (不含扩展名) 或文件夹名.
		 * @param path 要处理的地址.
		 * @return 对应的文件名 (不含扩展名) 或文件夹名.
		 */
		public static function getFileName(path:String):String
		{
			if(path == null || path == "")
			{
				return "";
			}
			path = escapeUrl(path);
			var startIndex:int = path.lastIndexOf("/");
			var endIndex:int;
			if(startIndex > 0 && startIndex == path.length - 1)
			{
				path = path.substring(0, path.length - 1);
				startIndex = path.lastIndexOf("/");
				endIndex = path.length;
				return path.substring(startIndex + 1, endIndex);
			}
			endIndex = path.lastIndexOf(".");
			if(endIndex == -1)
			{
				endIndex = path.length;
			}
			return path.substring(startIndex + 1, endIndex);
		}
		
		/**
		 * 搜索指定文件夹及其子文件夹下所有的文件.
		 * @param dir 要搜索的文件夹.
		 * @param extension 要搜索的文件扩展名, 例如: "png". 不设置表示获取所有类型文件. 若设置了 <code>filterFunc</code>, 则忽略此参数.
		 * @param filterFunc 过滤函数: <code>filterFunc(file:File):Boolean</code>, 参数为遍历过程中的每一个文件夹或文件, 返回 true 则加入结果列表或继续向下查找.
		 * @return 符合条件的文件列表.
		 */
		public static function search(dir:String, extension:String = null, filterFunc:Function = null):Array
		{
			dir = escapeUrl(dir);
			var file:File = File.applicationDirectory.resolvePath(dir);
			var result:Array = [];
			if(!file.isDirectory)
			{
				return result;
			}
			extension = extension != null ? extension.toLowerCase() : null;
			findFiles(file, result, extension, filterFunc);
			return result;
		}
		
		private static function findFiles(dir:File, result:Array, extension:String = null, filterFunc:Function = null):void
		{
			var fileList:Array = dir.getDirectoryListing();
			for each(var file:File in fileList)
			{
				if(file.isDirectory)
				{
					if(filterFunc != null)
					{
						if(filterFunc(file))
						{
							findFiles(file, result, extension, filterFunc);
						}
					}
					else
					{
						findFiles(file, result, extension, filterFunc);
					}
				}
				else if(filterFunc != null)
				{
					if(filterFunc(file))
					{
						result.push(file);
					}
				}
				else if(extension != null)
				{
					if(file.extension != null && file.extension.toLowerCase() == extension)
					{
						result.push(file);
					}
				}
				else
				{
					result.push(file);
				}
			}
		}
		
		/**
		 * 将 url 转换为本地路径.
		 * @param url 需要处理的 url.
		 * @return 本地路径.
		 */
		public static function url2Path(url:String):String
		{
			url = escapeUrl(url);
			var path:String = File.applicationDirectory.resolvePath(url).nativePath;
			return escapeUrl(path);
		}
		
		/**
		 * 将本地路径转换为 url.
		 * @param path 本地路径.
		 * @return url.
		 */
		public static function path2Url(path:String):String
		{
			path = escapeUrl(path);
			return File.applicationDirectory.resolvePath(path).url;
		}
		
		/**
		 * 指定路径的文件或文件夹是否存在.
		 * @param path 指定路径的文件或文件夹.
		 * @return 指定的文件或文件夹是否存在.
		 */
		public static function exists(path:String):Boolean
		{
			path = escapeUrl(path);
			var file:File = File.applicationDirectory.resolvePath(path);
			return file.exists;
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
		 * 格式化路径为当前系统可使用的路径, 去掉末尾的路径分隔符.
		 * @param path 带格式化的路径.
		 * @return 格式化的路径.
		 */
		public static function formatPath(path:String):String
		{
			path = path.replace(/\\\\/g, SEPARATOR);
			path = path.replace(/\//g, SEPARATOR);
			var index:int = path.lastIndexOf(SEPARATOR);
			if(index == path.length - 1)
			{
				path = path.substring(0, path.length - 1);
			}
			return path;
		}
		
		/**
		 * 统一换行符为系统默认的换行符.
		 * @param source 带处理文本.
		 * @return 处理后的文本.
		 */
		public static function unifyEnter(source:String):String
		{
			source = source.replace(/\r\n/g, "\r");
			source = source.replace(/\n/g, "\r");
			source = source.replace(/\r/g, LINE_SEPARATOR);
			return source;
		}
	}
}
