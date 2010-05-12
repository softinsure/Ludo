package org.ludo.containers.base
{
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.ludo.components.custom.DynaLinkBar;
	import org.ludo.navigators.LinkBarNavigator;
	import org.ludo.utils.LudoUtils;
	
	import spark.components.SkinnableContainer;

	public class Navigation extends SkinnableContainer
	{
		//private var navigator:LinkBarNavigator;
		protected var menuClicked:DynaLinkBar;
		public var menu_itemclicked:Function;
		public var transMenu:Boolean=false;//this is used to identify if this is quote transaction
		private var nonavigator:Boolean=true;
		private var curNavigatorID:String="";
		//private var transDesc:String="";
		public var menuWidth:int=-1;
		
		public function Navigation()
		{
			super();
		}
		protected function confirmResponse(event:CloseEvent):void
		{
			if (event.detail == Alert.YES)
			{
				changeContainer();
			}
		}
		protected function setConfirmChange(confirmchange:String):void
		{
			if (confirmchange == "true")
			{
				menuClicked.confirmchange=true;
			}
			else
			{
				menuClicked.confirmchange=false;
			}
		}
		protected function changeContainer():void
		{
			menuClicked.lastSelect=menuClicked.currSelect;
			LudoUtils.containerController.loadContainer(menuClicked.container);
		}
		/*
		public function addNavigation(navigator:IVisualElement):void
		{
			this.removeAllElements();
			this.addElement(navigator);
		}
		*/
		public function removeNavigator():void
		{
			this.removeAllElements();
			nonavigator=true;
			this.visible=false;
			curNavigatorID="";
		}
		override public function set width(value:Number):void
		{
			super.width=value;
			if(value!=0) menuWidth=width;
		}
		private function getMenuXml(navigatorid:String):XML
		{
			if(this.transMenu)
			{
				return LudoUtils.navController.quoteTransLeftMenuXml(navigatorid);
			}
			else
			{
				return LudoUtils.dataStore.getFromXmlContainer("navigation").panel.(@id == navigatorid)[0];
			}
		}
		private function get transDesc():String
		{
			if(this.transMenu)
			{
				return LudoUtils.modelController.quote.currentActivity;
			}
			else
			{
				return "";
			}
		}
		public function addNavigator(navigatorid:String,refresh:Boolean=false):LinkBarNavigator
		{
			var navigator:LinkBarNavigator=LudoUtils.navController.allNavigators[navigatorid] as LinkBarNavigator;
			if(curNavigatorID!=navigatorid)
			{
				this.removeAllElements();
				this.nonavigator=true;
			}
			if(navigator==null)
			{
				navigator=new LinkBarNavigator();
				var xml:XML=getMenuXml(navigatorid);//LudoUtils.dataStore.getFromXmlContainer("navigation").panel.(@id == navigatorid)[0];
				
				if(xml == null)
				{
					throw new Error("Missing navigation xml for navigator "+navigatorid);
				}
				navigator.menuXML=xml;
				navigator.menuWidth=this.menuWidth;
				navigator.menu_itemclicked=this.menu_itemclicked;
				navigator.currentTransaction=transDesc;
				this.removeAllElements();
				LudoUtils.navController.allNavigators[navigatorid]=navigator;
			}
			else
			{
				if(refresh){navigator.currentTransaction=transDesc;navigator.generateNavigationByXml(getMenuXml(navigatorid));}
			}
			if(nonavigator)
			{
				this.addElement(navigator);
				nonavigator=false;
				this.visible=true;
				curNavigatorID=navigatorid;
			}			
			return navigator;
		}
	}
}