package org.ludo.controllers
{
	import mx.controls.Alert;
	
	import org.frest.collections.DataContainer;
	import org.ludo.sparks.components.mxml.PopupFinder;
	import org.ludo.views.AdminBox;
	import org.ludo.views.AgentInfoBox;
	import org.ludo.views.DebugBox;
	import org.ludo.views.HomeBox;
	import org.ludo.views.PageHolder;
	import org.ludo.views.PermissionBox;
	import org.ludo.views.QuoteBox;
	import org.ludo.views.SearchBox;

	//import views.UserSearchBox;
	//import views.WorkBox;
	
	//add class instance here here to get by name
	public dynamic class InstanceController
	{
		private static var classcontainer:DataContainer=new DataContainer();
		private static var getInstanceFromChild:Function;

 		public static function set setMyFunction(func:Function):void
		{                                                                   
         	getInstanceFromChild = func;
     	} 		
 		public static function getNewInstanceByNameFromChild(dynamicClass:String):*
        {
        	if(getInstanceFromChild!=null)
        	{
        		return getInstanceFromChild(dynamicClass);
        	}
        	else
        	{
				MessageController.popUpMessage("Instance Controller",dynamicClass+" not available in InstanceManager. Please add there to use!!");
				throw new Error(dynamicClass+" not available in InstanceManager. Please add there to use!!");
        	}
        }		
		/*
		private static factory:Factory;
		public function Factory()
		{
		}
        public static function getInstance():Factory
        {
            if (factory == null)
            {
                factory = new Factory();
                classcontainer=new DataContainer();
            }
            return factory;
        }
        public function Factory()
		{
			if (factory!=null)
			{
                throw new Error("Only one Factory instance may be instantiated.");
            }
        }
        */
        public static function addToInstanceContainer(className:String,object:Object):void
        {
        	classcontainer.put(className,object);
        }
        public static function getNewInstanceByName(dynamicClass:String):*
        {
        	switch(dynamicClass.toLowerCase())//do a lowercase
        	{
        		case "homebox":
        			return new HomeBox();
        			break;
/*
        		case "mainleftnavbar":
        			return new MainLeftNavBar();
        			break;
        		case "topnavbar":
        			return new TopNavBar();
        			break;
        		case "toprightbar":
        			return new TopRightBar();
        			break;
        		case "noleftnavbar":
        			return new NoLeftNavBar();
        			break;
        		case "transleftnavbar":
        			return new TransLeftNavBar();
        			break;
*/
        		//case "workbox":
        		//	return new WorkBox();
        		//	break;
        		case "quotebox":
        			return new QuoteBox();
        			break;
        		case "errorbox":
        		/*
        			return new ErrorBox();
        			break;
        			*/
        		case "debugbox":
        			return new DebugBox();
        			break;
        		case "agentinfobox":
        			return new AgentInfoBox();
        			break;
        		case "adminbox":
        			return new AdminBox();
        			break;
        		case "searchbox":
        			return new SearchBox();
        			break;
				case "permissionbox":
					return new PermissionBox();
					break;
        		case "popupfinder":
        			return new PopupFinder();
        			break;
        		/*
        		case "activitymenu":
        			return new ActivityMenu();
        			break;
        		*/
        		case "pageholder":
        			return new PageHolder();
        			break;
        		default:
        			return getNewInstanceByNameFromChild(dynamicClass);
        			break;
        	}
        }
        private static function destroyObject(obj:*):void
        {
        	obj=null;        	
        }
        public static function refreshInstanceWithNewByName(dynamicClass:String):*
        {
        	dynamicClass=dynamicClass.toLowerCase();
        	var clazz:Object=classcontainer.get(dynamicClass);
        	if(clazz!=null)
        	{
        		destroyObject(clazz);
        	}
			clazz=getNewInstanceByName(dynamicClass);
        	classcontainer.put(dynamicClass,clazz);
        	return clazz;
        }
        public static function getCurrentInstanceByName(dynamicClass:String):*
        {
        	dynamicClass=dynamicClass.toLowerCase();
        	var clazz:Object=classcontainer.get(dynamicClass);
        	if(clazz==null)
        	{
        		clazz=getNewInstanceByName(dynamicClass);
        		classcontainer.put(dynamicClass,clazz);
        	}
        	return clazz;
        }
	}
}