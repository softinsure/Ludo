package org.ludo.controllers
{
	import mx.core.IVisualElement;
	
	import org.frest.collections.DataContainer;
	import org.ludo.containers.ActivityDetail;
	import org.ludo.containers.ActivityNavigation;
	import org.ludo.containers.LeftNavigation;
	import org.ludo.containers.RightHelpContainer;
	import org.ludo.containers.RightTopContainer;
	import org.ludo.containers.TopNavigation;
	import org.ludo.containers.TopUserNavigation;
	import org.ludo.layouts.ApplicationRight;
	import org.ludo.utils.ConfigLoder;
	import org.ludo.utils.LudoUtils;
	import org.ludo.views.SearchBox;

    public class ContainerController
	{
		private static var containerManager:ContainerController;
        
		public var detailContainer:ActivityDetail;
		public var topNavContainer:TopNavigation;
		public var leftNavContainer:LeftNavigation;
		public var activityNavigation:ActivityNavigation;
		public var rightHelpContainer:RightHelpContainer;
		public var applicationRight:ApplicationRight;
		public var rightTopContainer:RightTopContainer;
		public var topRightNavContainer:TopUserNavigation;
		private var currentactivity:*;
		private var containerXML:XML;
		private var refreshLeftNav:Boolean=false;
		private var refreshTopNav:Boolean=false;
		private var showAppRight:Boolean=false;
		private static var rightTopContainerCache:DataContainer;
		private var currentContainerName:String;
		//private static var containerMap:XML;
		
        public static function getInstance():ContainerController
        {
            if (containerManager == null)
            {
                containerManager = new ContainerController();
                rightTopContainerCache=new DataContainer();
                //containerMap=LudoUtils.dataStore.getFromXmlContainer("containermap");
            }
            return containerManager;
        }
        public function ContainerController()
		{
			if (containerManager!=null)
			{
                throw new Error("Only one ContainerManager instance may be instantiated.");
            }
        }
        private function addToRightTopContainerCache(container:IVisualElement):void
        {
        	//actionPanel=bar;
        	rightTopContainerCache.put("right"+currentContainerName,container);
        }
		private function getCurrentRightTopContainerFromCache() : IVisualElement
		{
			return rightTopContainerCache.get("right"+currentContainerName);
		}
        private function get conntainermap():XML
        {
        	return LudoUtils.dataStore.getFromXmlContainer("containermap");
        }
		public function get currentActivityDetail():*
		{
			return currentactivity;
		}
		public function get loadedContainerName():String
		{
			return currentContainerName;
		}
        public function loadContainer(containerName:String,refreshLeftNavigation:Boolean=false,refreshTopNavigation:Boolean=false):void
        {
        	//get current map
        	currentContainerName=containerName;
			refreshLeftNav=refreshLeftNavigation;
			refreshTopNav=refreshTopNavigation;
        	containerXML=XML(conntainermap.container.(@name == containerName));
	        if(containerXML!=null)
	        {
				//check for if xmls toload
				var xmlstoload:String=getProperty(containerXML,"xmlstoloadconfig");
				if(xmlstoload!="")
				{
					new ConfigLoder().loadXmlxByConfig(xmlstoload,startLoad);
		            //var xmlloader:XmlLoder=new XmlLoder();
		            //xmlloader.setFuncToBeCalledAfterLoad(startLoad);
		            //xmlloader.loadXmlxByConfig(xmlstoload);
		            //xmlloader=null;        			
				}
				else
				{
					startLoad();
				}
	        }
	        else
	        {
				ErrorController.showErrorMeassage("Invalid Container Name Specified");
			}
        }
        private function startLoad():void
        {
        	try
        	{
        		//check if we need to set and transaction "transactiontouse" for any container
        		var transactiontouse:String=getProperty(containerXML,"transactiontouse");
        		if(transactiontouse!="")
        		{
        			LudoUtils.transController.setCurrentTransaction=transactiontouse;
        		}
				if(topRightNavContainer!=null)
				{
        			topRightNavContainer.addNavigator(LudoUtils.getConfigValue("toprightmenu"));//InstanceManager.getCurrentInstanceByName("toprightbar"));
				}
	        	if(containerXML!=null)
	        	{
	        		//check if xmls to load for this container
	        		var refresh:String="false"
	        		showAppRight=false;
	        		//right top container
	        		var righttopcontainer:String=getProperty(containerXML,"righttopcontainer");
					if(rightTopContainer!=null)
					{
		        		if(righttopcontainer!="")
		        		{
		        			var rightObj:IVisualElement;
							if(containerXML.righttopcontainer.hasOwnProperty("@refresh"))
							{
								refresh=containerXML.righttopcontainer.@refresh.toString();
							}
							if(refresh!="true")
							{
								rightObj=getCurrentRightTopContainerFromCache();
							}
			        		//load agent info box
		        			if(rightObj==null)//not their in cache
		        			{
		        				rightObj=refresh!="true"?InstanceController.getCurrentInstanceByName(righttopcontainer):InstanceController.refreshInstanceWithNewByName(righttopcontainer);
			        			addToRightTopContainerCache(rightObj);
			        		}
			        		if(rightObj!=null)
			        		{
			        			rightTopContainer.addElement(rightObj);
			        			rightTopContainer.visible=true;
			        			showAppRight=true;
			        		}
			        		
			        		//applicationRight.addElement(rightTopContainer);
		        			
		     				//rightTopContainer.addToContainer(InstanceController.getCurrentInstanceByName("righttopcontainer"));
		        		}
		        		else
		        		{
		        			rightTopContainer.visible=false;
		        			rightTopContainer.removeAllElements();
		        		}
					}
					if(rightHelpContainer!=null)
					{
		        		var righthelpcontainer:String=getProperty(containerXML,"righthelpcontainer");
		        		if(righthelpcontainer!="")
		        		{
							if(containerXML.righthelpcontainer.hasOwnProperty("@refresh"))
							{
								refresh=containerXML.righthelpcontainer.@refresh.toString();
							}
			        		rightHelpContainer.visible=true;
		        			//load agent info box
			        		rightHelpContainer.addToContainer(refresh!="true"?InstanceController.getCurrentInstanceByName(righthelpcontainer):InstanceController.refreshInstanceWithNewByName(righthelpcontainer));
		     				showAppRight=true;
		     				//rightTopContainer.addToContainer(InstanceController.getCurrentInstanceByName("righttopcontainer"));
		        		}
		        		else
		        		{
		        			rightHelpContainer.visible=false;
		        			rightHelpContainer.removeAllElements();
		        		}
					}
	        		//load top menu
	        		var topmenu:String=getProperty(containerXML,"topnavigation");
	        		if(topmenu!="" && topNavContainer!=null)
	        		{
						if(containerXML.topnavigation.hasOwnProperty("@refresh"))
						{
							refresh=containerXML.topnavigation.@refresh.toString();
						}
						if(refreshTopNav)
						{
							refresh="true";
							refreshTopNav=false;
						}
						LudoUtils.navController.topMenu=topNavContainer.addNavigator(topmenu,LudoUtils.booleanValue(refresh));
						//topNavContainer.addNavigator(topmenu,LudoUtils.booleanValue(refresh));
	        			
	        			//topNavContainer.addNavigation(refresh!="true"?InstanceManager.getCurrentInstanceByName(topmenu):InstanceManager.refreshInstanceWithNewByName(topmenu));
	        			refresh="false";
	        		}
	         		//load left menu
					if(leftNavContainer!=null)
					{
		        		var leftmenu:String=getProperty(containerXML,"leftnavigation");
		        		var leftnavigationwidth:String=LudoUtils.getConfigValue("leftnavigationwidth");
		        		if(leftnavigationwidth!="") leftNavContainer.width=int(leftnavigationwidth);
		         		if(leftmenu!="")
		        		{
		        			//var transmenu:String="false";
							if(leftmenu.toLowerCase()=="noleftnavbar")
							{
								leftNavContainer.removeNavigator();
								leftNavContainer.width=0;
			        	
							}
							else
							{
								if(containerXML.leftnavigation.hasOwnProperty("@refresh"))
								{
									refresh=containerXML.leftnavigation.@refresh.toString();
								}
								if(String(containerXML.leftnavigation.@transmenu)=="true")
								{
									leftNavContainer.transMenu=true;
								}
								else
								{
									leftNavContainer.transMenu=false;
								}
								if(refreshTopNav)
								{
									refresh="true";
									refreshTopNav=false;
								}
								LudoUtils.navController.leftMenu=leftNavContainer.addNavigator(leftmenu,LudoUtils.booleanValue(refresh));
								//leftNavContainer.addNavigation(refresh!="true"?InstanceManager.getCurrentInstanceByName(leftmenu):InstanceManager.refreshInstanceWithNewByName(leftmenu));
			        			refresh="false";
		     				}
		        			//leftNavContainer.addNavigation(Factory.getCurrentInstanceByName(leftmenu));
		        		}
		        		/*
		         		if(leftmenu!="")
		        		{
		        			var transmenu:String="false";
							if(containerXML.leftnavigation.hasOwnProperty("@transmenu"))
							{
								transmenu=containerXML.leftnavigation.@transmenu.toString();
							}
							if(transmenu!="true")
							{
								navManger.transLeftMenu=null;
							}
							if(containerXML.leftnavigation.hasOwnProperty("@refresh"))
							{
								refresh=containerXML.leftnavigation.@refresh.toString();
							}
							var curLeftMenuID:String=navManger.leftMenuID;
							if(containerXML.leftnavigation.hasOwnProperty("@id"))
							{
								navManger.leftMenuID=containerXML.leftnavigation.@id.toString();
							}
							else
							{
								navManger.resetToDefaultLeftMenuID();
							}
							if(curLeftMenuID!=navManger.leftMenuID)
							{
								refresh="true";
							}
							if(leftmenu.toLowerCase()=="noleftnavbar")
							{
								leftnavigationwidth="0";
							}
							leftNavContainer.width=int(leftnavigationwidth);
		        		
							leftNavContainer.addNavigation(refresh!="true"?InstanceManager.getCurrentInstanceByName(leftmenu):InstanceManager.refreshInstanceWithNewByName(leftmenu));
		        			refresh="false";
		        			//leftNavContainer.addNavigation(Factory.getCurrentInstanceByName(leftmenu));
		        		}
		        		*/
		        		else
		        		{
		        			leftNavContainer.width=0;
		        		}
					}
	        		//load body
					if(detailContainer!=null)
					{
		        		var activitydetail:String=getProperty(containerXML,"activitydetail");
		          		if(activitydetail!="")
		        		{
		        			var activitymenu:String="";
							if(containerXML.activitydetail.hasOwnProperty("@refresh"))
							{
								refresh=containerXML.activitydetail.@refresh.toString();
							}
							if(containerXML.activitydetail.hasOwnProperty("@menu"))
							{
								activitymenu=containerXML.activitydetail.@menu.toString();
							}
							if(activitymenu!="")
							{
								LudoUtils.navController.activityMenu=activityNavigation.addNavigator(activitymenu,LudoUtils.booleanValue(refresh));
								//detailContainer.addHeader(refresh!="true"?InstanceController.getCurrentInstanceByName(activitymenu):InstanceController.refreshInstanceWithNewByName(activitymenu));
								detailContainer.addHeader(activityNavigation);
							}
							else
							{
								detailContainer.hideHeader();
								LudoUtils.navController.activityMenu=null;
							}
							if(activitydetail=="searchbox")
							{
								//speacial search logic
								var searchconfig:String="basesearch";
								var searchid:String="";
								if(containerXML.activitydetail.hasOwnProperty("@searchconfig"))
								{
									searchconfig=containerXML.activitydetail.@searchconfig.toString();
								}
								if(containerXML.activitydetail.hasOwnProperty("@searchid"))
								{
									searchid=containerXML.activitydetail.@searchid.toString();
								}
								if(searchid!="")
								{
									//get searchbox from container
									var searchbox:SearchBox;
									if(refresh!="true")
									{
										searchbox=LudoUtils.dataStore.getFromsearchBoxContainer(searchid);
									}
									if(searchbox==null)
									{
										//get a new one
										//searchbox=refresh!="true"?InstanceManager.getCurrentInstanceByName(activitydetail):InstanceManager.refreshInstanceWithNewByName(activitydetail);
										searchbox=InstanceController.refreshInstanceWithNewByName(activitydetail);
									}
									searchbox.initiateSearch(searchid,searchconfig);
									currentactivity=searchbox;
									//add to container by searchid
									LudoUtils.dataStore.addToSearchBoxContainer(searchid,searchbox);
									detailContainer.addActivity(searchbox);
								}
								else
								{
									ErrorController.showErrorMeassage("Missing search id! Please add searchid in container map..");
								}
							}
							else
							{
								currentactivity=refresh!="true"?InstanceController.getCurrentInstanceByName(activitydetail):InstanceController.refreshInstanceWithNewByName(activitydetail);
		        				detailContainer.addActivity(currentactivity);
								//detailContainer.addActivity(refresh!="true"?InstanceController.getCurrentInstanceByName(activitydetail):InstanceController.refreshInstanceWithNewByName(activitydetail));
							}
		        			refresh="false";
		        		//	detailContainer. (Factory.getCurrentInstanceByName(activitydetail));
		        		}
					}
	     		}
	        	else
	        	{
	        		throw new Error("Invalid Container passed!");
	        	}
	        	var applicationrightwidth:String=LudoUtils.getConfigValue("applicationrightwidth");
	        	if(!showAppRight)
	        	{
	        		applicationrightwidth="0";
	        	}
	         	if(applicationRight!=null)
	        	{
	        		//applicationRight.rightTop=rightTopContainer;
	        		applicationRight.visible=showAppRight;
	        		/*
	        		if(!showAppRight)
	        		{
	        			applicationRight.removeAllElements();
	        			
	        		}
	        		*/
	        		applicationRight.width=int(applicationrightwidth);
	        	}
        	}
        	catch (e:Error)
        	{
        		ErrorController.logError(e,"load","loadContainer");
        	}
        }
       public function loadActivityDetail(activitydetail:String,refresh:Boolean=false):*
       {
		   if(detailContainer!=null)
	       {
				var object:*=refresh!=true?InstanceController.getCurrentInstanceByName(activitydetail):InstanceController.refreshInstanceWithNewByName(activitydetail);
	       		//detailContainer.addActivity(refresh!=true?InstanceController.getCurrentInstanceByName(activitydetail):InstanceController.refreshInstanceWithNewByName(activitydetail));
				detailContainer.addActivity(object);
				currentactivity=object;
				return object;
			}
		   return null;
        }
       private function getProperty(container:XML,prop:String):*
        {
        	return container[prop];
        }
   	}
}