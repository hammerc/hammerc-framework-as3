// =================================================================================================
//
//	Hammerc Framework
//	Copyright 2013 hammerc.org All Rights Reserved.
//
//	See LICENSE for full license information.
//
// =================================================================================================

package org.hammerc.marble.project
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import org.hammerc.core.AbstractEnforcer;
	import org.hammerc.marble.utils.FileUtil;
	
	/**
	 * @eventType org.hammerc.marble.project.ProjectEvent.NEW_PROJECT
	 */
	[Event(name="newProject", type="org.hammerc.marble.project.ProjectEvent")]
	
	/**
	 * @eventType org.hammerc.marble.project.ProjectEvent.OPEN_PROJECT
	 */
	[Event(name="openProject", type="org.hammerc.marble.project.ProjectEvent")]
	
	/**
	 * @eventType org.hammerc.marble.project.ProjectEvent.SAVE_PROJECT
	 */
	[Event(name="saveProject", type="org.hammerc.marble.project.ProjectEvent")]
	
	/**
	 * @eventType org.hammerc.marble.project.ProjectEvent.CLOSE_PROJECT
	 */
	[Event(name="closeProject", type="org.hammerc.marble.project.ProjectEvent")]
	
	/**
	 * <code>AbstractProject</code> 类为抽象类, 定义了工程对象.
	 * @author wizardc
	 */
	public class AbstractProject extends EventDispatcher implements IProject
	{
		/**
		 * 当前打开的工程文件的路径.
		 */
		protected var _path:String = "";
		
		/**
		 * 当前是否打开了工程文件.
		 */
		protected var _opened:Boolean;
		
		/**
		 * 当前的文件是否已经存在硬盘上了.
		 */
		protected var _isInDisk:Boolean;
		
		/**
		 * 当前打开的工程文件的数据.
		 */
		protected var _data:*;
		
		/**
		 * <code>AbstractProject</code> 类为抽象类, 不能被实例化.
		 */
		public function AbstractProject()
		{
			AbstractEnforcer.enforceConstructor(this, AbstractProject);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get path():String
		{
			return _path;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get opened():Boolean
		{
			return _opened;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isInDisk():Boolean
		{
			return _isInDisk;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get data():*
		{
			return _data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function newProject():void
		{
			_path = "未命名工程";
			_opened = true;
			_isInDisk = false;
			_data = this.createNewProjectData();
			dispatchEvent(new ProjectEvent(ProjectEvent.NEW_PROJECT));
		}
		
		/**
		 * 创建新工程数据对象.
		 * @return 新工程数据对象.
		 */
		protected function createNewProjectData():*
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * @inheritDoc
		 */
		public function openProject(typeFilter:Array = null, title:String = "浏览文件", defaultPath:String = null):void
		{
			FileUtil.browseForOpen(openSelectHandler, 1, typeFilter, title, defaultPath);
		}
		
		/**
		 * @inheritDoc
		 */
		public function directOpenProject(path:String):void
		{
			openSelectHandler(new File(FileUtil.escapeUrl(path)));
		}
		
		private function openSelectHandler(file:File):void
		{
			_path = file.nativePath;
			_opened = true;
			_isInDisk = true;
			_data = this.getOpenProjectData(file);
			dispatchEvent(new ProjectEvent(ProjectEvent.OPEN_PROJECT));
		}
		
		/**
		 * 获取打开的工程数据对象.
		 * @param file 打开的文件.
		 * @return 工程数据对象.
		 */
		protected function getOpenProjectData(file:File):*
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function saveProject(defaultPath:String = null, title:String = "保存文件"):void
		{
			if(!_opened)
			{
				return;
			}
			if(_isInDisk)
			{
				this.saveProjectData();
			}
			else
			{
				this.saveAsProject(defaultPath, title);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function saveAsProject(defaultPath:String = null, title:String = "保存文件"):void
		{
			if(!_opened)
			{
				return;
			}
			FileUtil.browseForSave(saveSelectHandler, defaultPath, title);
		}
		
		private function saveSelectHandler(file:File):void
		{
			_isInDisk = true;
			_path = file.nativePath;
			this.saveProjectData();
			dispatchEvent(new ProjectEvent(ProjectEvent.SAVE_PROJECT));
		}
		
		/**
		 * 保存工程数据对象.
		 */
		protected function saveProjectData():void
		{
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * @inheritDoc
		 */
		public function closeProject():void
		{
			if(!_opened)
			{
				return;
			}
			_path = "";
			_opened = false;
			_isInDisk = false;
			_data = null;
			dispatchEvent(new ProjectEvent(ProjectEvent.CLOSE_PROJECT));
		}
	}
}
