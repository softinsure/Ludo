package org.ludo.navigators.base
{
	import mx.events.FlexEvent;
	
	import org.ludo.components.base.INavigationBar;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.XMLMapper;
	
	import spark.components.VGroup;
	
	public class Navigator extends VGroup implements INavigator
	{
		public var menuXML:XML;
		public var menuWidth:int=-1;
		protected var firstManuId:String="";
		public var menu_itemclicked:Function;
		protected var allManues:Array=[];
		protected var allPanels:Array=[];
		public var currentTransaction:String="";
		public var navigatorid:String;

		public function Navigator()
		{
			super();
			this.gap=1;
		}
		public function selectItemByPageID(pageid:String):void
		{
			this.getMenu(aplicationFlowMenuID).selectMenuByPageId(pageid);
		}
		public function enableItemByPageID(pageid:String):void
		{
			var menuindex:int=this.getMenu(aplicationFlowMenuID).getMenuIndexByPageId(pageid);
			if(menuindex!=-1)
			{
				this.enableItem(menuindex,aplicationFlowMenuID);
				updateEnableTransactionMenuXml(menuindex);
			}
		}
		private function get aplicationFlowMenuID():String
		{
			return String(LudoUtils.transController.getProperty("applicationflowmenu"));
		}
		private function updateEnableTransactionMenuXml(idx:int):void
		{
			var pageid:String="";
			var xpath:String="";
			var menutoenable:String=aplicationFlowMenuID;
			if(menutoenable!="")
			{
				pageid=this.getMenu(menutoenable).getPageIDIfAny(idx);
				xpath="/panel/menu[@id='"+menutoenable+"']/menuitem[@pageid='"+pageid+"']";
			}
			else
			{
				pageid=this.getFirstMenu().getPageIDIfAny(idx);
				xpath="/panel/menu[0]/menuitem[@pageid='"+pageid+"']";
			}
			if(pageid!="")
			{
				var node:XML=XMLMapper.getNodeByXpathAndRootNode(this.menuXML,xpath)[0];
				if(node!=null)
				{
					if(node.@enabled!='true')
					{
						node.@enabled="true";
						//refreshTransLeftNav();
					}
				}
			}
		}
		protected override function createChildren():void
		{
			navigatorid=String(menuXML.@id);
			super.createChildren();
        	this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
			generateNavigation();
        }
		public function generateNavigationByXml(xml:XML):void
		{
			menuXML=xml;
        	generateNavigation();
		}
		
		public function selectMenuIndex(idx:int, menuid:String=""):void
		{
			var menuTop:INavigationBar=getMenu(menuid);
			if (menuTop)
			{
				menuTop.selectItem=idx;
				menuTop.lastSelect=idx;
				//var obj:Object=topmenu.menubar.dataProvider[idx];
				var obj:Object=menuTop.getItemObject(idx);
				if (obj.hasOwnProperty("confirmchange"))
				{
					menuTop.confirmchange=String(obj["confirmchange"])=="true"?true:false;
				}
			}
		}
		public function enableItem(idx:int,menuid:String=""):void
		{
			if(getMenu(menuid))
			{
				getMenu(menuid).enableItem(idx, true);
			}
		}

		public function disableItem(idx:int,menuid:String=""):void
		{
			if(getMenu(menuid))
			{
				getMenu(menuid).enableItem(idx, false);
			}
		}
        protected function creationComplete(event:Object):void
        {
        }
		protected function getMenu(menuid:String):INavigationBar
		{
			if(menuid!="") return allManues[navigatorid+"::"+menuid];
			return getFirstMenu();
		}
		protected function getFirstMenu():INavigationBar
		{
			return allManues[firstManuId];
		}
		protected function generateNavigation():void
		{
        }
	}
}