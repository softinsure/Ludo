package org.ludo.controllers
{
	import mx.controls.buttonBarClasses.*;
	
	import org.ludo.components.custom.CViewStack;
	import org.ludo.containers.MainContainer;
	import org.ludo.layouts.VLayout;
	import org.ludo.navigators.base.Navigator;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.XMLMapper;
	import org.ludo.views.DebugBox;
	import org.ludo.views.PageHolder;
	import org.ludo.views.QuoteBox;

	//import views.UserSearchBox;
	//import views.WorkBox;
	
	[Bindable]
    public class NavController
	{
        private static var navManager:NavController;
        public var leftMenu:Navigator;
  		public var topMenu:Navigator;
  		public var activityMenu:Navigator;
  		public var quoteBox:QuoteBox;
  		//public var quoteDefaultBox:DataEntryVBox;
  		public var pageHolder:PageHolder;
        public var mainContainer:MainContainer;
        public var startBox:VLayout;
        public var debugPanel:DebugBox;
        //public var appstack:ViewStack;
		public var appstack:CViewStack;
        
        //default menu id
        public var leftMenuID:String='homeleft';
        public var topMenuID:String='topmenu';
       //public var activityNavKey:String='activitynavigation';
        public var topRightMenuID:String='toprightmenu';
        
        public var allMenus:Array=[];
        public var allNavigators:Array=[];
        
        public static function getInstance():NavController
        {
            if (navManager == null)
            {
                navManager = new NavController();
            }
            return navManager;
        }
        public function NavController()
		{
			if (navManager!=null)
			{
                throw new Error("Only one NavManager instance may be instantiated.");
            }
        }
        public function get activityMenuID():String
        {
        	var ret:String=LudoUtils.transController.activityMenuID;
        	return ret==""?"activitymenu":ret;
        }
        public function get activityNavKey():String
        {
        	var ret:String=LudoUtils.transController.getProperty("activitynavkey");
        	return ret==""?"activitynavigation":ret;
        }
        public function get activityManuItems():XMLList
		{
			return LudoUtils.dataStore.getFromXmlContainer(activityNavKey).panel.(@id == activityMenuID).menu;
		}
        public function get mainLeftManuItems():XMLList
		{
			return LudoUtils.dataStore.getFromXmlContainer("navigation").panel.(@id == leftMenuID).menu;
		}
		public function quoteTransLeftMenuXml(navigatorid:String):XML
		{
			//if(LudoUtils.modelController.quote.xmlstore.menu_xml==null || (LudoUtils.modelController.quote.xmlstore.menu_xml is  XMLList) || LudoUtils.modelController.quote.xmlstore.menu_xml.length()<=0)
			if(LudoUtils.modelController.quote.xmlstore.menu_xml==null || LudoUtils.modelController.quote.xmlstore.menu_xml.length()<=0)
			{
				LudoUtils.modelController.quote.xmlstore.menu_xml=LudoUtils.dataStore.getFromXmlContainer("navigation").panel.(@id == navigatorid)[0];
			}
			else
			{
				ifMenuTemplateChanged(LudoUtils.dataStore.getFromXmlContainer("navigation").panel.(@id == navigatorid)[0],LudoUtils.modelController.quote.xmlstore.menu_xml);
			}
			return LudoUtils.modelController.quote.xmlstore.menu_xml;
		}

		private function ifMenuTemplateChanged(menuTemplate:XML, menuStored:XML):void
		{
			for each (var menuParent:XML in menuTemplate.children())
			{
				var menuid:String=String(menuParent.@id);
				if(menuid.length>0)
				{
					//check in stored
					var node:XML=XMLMapper.getNodeByXpathAndRootNode(menuStored,"/panel/menu[@id='"+menuid+"']")[0];
					if(node!=null)
					{
						for each (var menu:XML in menuParent.children())
						{
							var pageid:String=String(menu.@pageid);
							var prevMenu:XML;
							if(pageid.length>0)
							{
								//check if menus is there in node
								//var checkmenu:XML=XMLMapper.getNodeByXpathAndRootNode(menuStored,"/panel/menu[@id='"+menuid+"']/menuitem[@pageid='"+pageid+"']")[0];
								var checkmenu:XML=XMLMapper.getNodeByXpathAndRootNode(node,"menuitem[@pageid='"+pageid+"']")[0];
								if(checkmenu==null)
								{
									//missing so add
									var idx:int=prevMenu.childIndex();
									var menuToAdd:XML=menu.copy();
									if(idx+1<node.children().length())
									{
										if(String(node.children()[idx+1][0].@enabled)=="true")
										{
											menuToAdd.@enabled="true";
										}
									}
									node.insertChildAfter(prevMenu,menuToAdd);
								}
								else
								{
									prevMenu=checkmenu;
								}
							}
						}
					}
				}
			}
		}
		public function selectTopMenuIndex(idx:int):void
		{
			topMenu.enableItem(idx);
			topMenu.selectMenuIndex(idx);
		}
		public function selectActivityMenuIndex(idx:int):void
		{
			if(activityMenu)
			{
				//activityMenu.enableItem(idx);
				activityMenu.selectMenuIndex(idx);
			}
		}
		public function resetToDefaultLeftMenuID():void
		{
			leftMenuID="homeleft";
		}
		public function selectLeftMenuIndex(idx:int):void
		{
			if(leftMenu)
			{
				leftMenu.enableItem(idx);
				leftMenu.selectMenuIndex(idx);
			}
		}
		public function disableTopManuItem(idx:int):void
		{
			topMenu.disableItem(idx);
		}
		public function disableActivityManuItem(idx:int):void
		{
			activityMenu.disableItem(idx);
		}
	}
	
}