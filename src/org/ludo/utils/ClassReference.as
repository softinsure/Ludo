package org.ludo.utils
{
	import flash.utils.getDefinitionByName;
	
	import mx.utils.ObjectUtil;
	
	import org.ludo.controllers.ActionController;
	import org.ludo.staticfunctions.DatagridLabel;
	
	//class to be referenced
	
	
	
	public dynamic class ClassReference
	{
		protected var actioncontroller:ActionController;
		protected var datagridlabel:DatagridLabel;
		public static function getClassReferenceByName(className:String):Class
		{
			var ret:Class=null;
			try
			{
				ret=getDefinitionByName(className) as Class;
			}
			catch(e:Error)
			{
				throw new Error("Invalid Class Path ");
			}
			return ret;
		}
		public static function getFunctionReferenceByName(className:String,funcName:String):Function
		{
			var ret:Function=null;
			try
			{
				ret=(getDefinitionByName(className) as Class)[funcName];
			}
			catch(e:Error)
			{
				throw new Error("Invalid Class of Function Path ");
			}
			return ret;
			//return (getDefinitionByName(className) as Class)[funcName];
		}
		public static function getFunctionReferenceByFullPath(funcName:String):Function
		{
			//string after last index of '.' is function name and before is class full path
			var func:String=funcName.substring(funcName.lastIndexOf(".")+1,funcName.length);
			var className:String=funcName.substring(0,funcName.lastIndexOf("."));
			if(func.length>0 && className.length>0)
			{
				try
				{
					return (getDefinitionByName(className) as Class)[func];
				}
				catch(e:Error)
				{
					throw new Error("Invalid Function Path: "+funcName+"->"+ObjectUtil.toString(e));
				}
			}
			else
			{
				throw new Error("Invalid Function Path");
			}
			return null;
		}
	}
}