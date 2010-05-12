/*******************************************************************************
 * Copyright  2010-2011 Goutam Malakar. All rights reserved.
 * Author: Goutam 
 * File Name: DynaLinkBar.as 
 * Project Name: Ludo 
 * Created Jan 5, 2010
 ******************************************************************************/
package org.ludo.components.custom
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.Alert;
	import mx.controls.ButtonLabelPlacement;
	import mx.controls.Image;
	import mx.controls.LinkBar;
	import mx.controls.LinkButton;
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.utils.ObjectUtil;
	
	import org.ludo.components.base.INavigationBar;
	import org.ludo.connectors.ImageConnector;
	import org.ludo.controllers.MessageController;
	import org.ludo.utils.CurrentPage;
	import org.ludo.utils.IconLoader;
	import org.ludo.utils.LudoUtils;

	public class DynaLinkBar extends LinkBar implements INavigationBar
	{
		private var lastselect:int=-1;
		private var currselect:int=-1;
		private var confirmcng:Boolean=false;
		private var acontainer:String="default";
		private var trans:String="";
		private var type:String="";
		private var nextpage:String="";
		private var generated:Boolean=false;

		public function set nextPage(value:String):void
		{
			nextpage=value;
		}
		public function get menuGenerated():Boolean
		{
			return generated;
		}
		public function get nextPage():String
		{
			return nextpage;
		}
		public function set currentTransaction(value:String):void
		{
			trans=value;
		}
		public function get currentTransaction():String
		{
			return trans;
		}
		public function set lastSelect(idx:int):void
		{
			lastselect=ifCurrentSelect(idx)==true?idx:-1;
		}
		public function get lastSelect():int
		{
			return lastselect;
		}
		public function set currSelect(idx:int):void
		{
			currselect=idx;
		}
		public function get currSelect():int
		{
			return currselect;
		}
		public function set confirmchange(value:Boolean):void
		{
			confirmcng=value;
		}
		public function get confirmchange():Boolean
		{
			return confirmcng;
		}
		public function set container(value:String):void
		{
			acontainer=value;
		}
		public function get container():String
		{
			return acontainer;
		}
		private function ifCurrentSelect(idx:int):Boolean
		{
			if(this.numElements>idx && idx>-1)
			{
				var obj:Object=getItemObject(idx);
				if(obj.hasOwnProperty("currentselect"))
				{
					if(obj["currentselect"]=="false")
					{
						return false;
					}
				}
			}
			return true;		
		}
		public function selectMenuByPageId(pageid:String):void
		{
			var idx:int=0;
			for each (var obj:Object in this.dataProvider)
			{
				if(obj.hasOwnProperty("pageid"))
				{
					if (pageid == obj.pageid)
					{
						selectItem=idx
						break;
					}
				}
				idx++;
			}
		}
		public function getMenuIndexByPageId(pageid:String):int
		{
			var idx:int=0;
			for each (var obj:Object in this.dataProvider)
			{
				if(obj.hasOwnProperty("pageid"))
				{
					if (pageid == obj.pageid)
					{
						return idx;
						break;
					}
				}
				idx++;
			}
			return -1;
		}
		public function set selectItem(idx:int):void
		{
			if (idx == selectedIndex)
            	return;
           	this.selectedIndex=idx;
           	enableItem(this.lastSelect, true);
			this.lastSelect=idx;
			//enableItem(idx, false);
		}
		public function selectFirstItem():void
		{
			if (this.numElements>0)
			{
				//this.selectedIndex=0;
				this.lastSelect=0;
			}
		}

		public function selectNextItem():void
		{
			if (this.numElements>0)
			{
				var cindex:int=this.selectedIndex;
				if (cindex == this.numElements-1)
				{
					cindex=0;
				}
				else
				{
					cindex=cindex + 1;
				}
				//this.selectedIndex=cindex;
				this.lastSelect=cindex;
			}
		}		
		public function confirmBeforeChangeContainer(event:CloseEvent):void
		{
			if (event.detail == Alert.YES)
			{
				this.changeContainer();
			}
		}
		public function confirmBeforeChangePage(event:CloseEvent):void
		{
			if (event.detail == Alert.YES)
			{
				this.changePage();
			}
			else
			{
				this.noChangePage();
			}
		}
		public function setConfirmChange(confirmchange:String):void
		{
			if (confirmchange == "true")
			{
				this.confirmchange=true;
			}
			else
			{
				this.confirmchange=false;
			}
		}
		public function changeContainer():void
		{
			enableItem(this.lastSelect, true);
			this.lastSelect=this.currSelect;
			LudoUtils.containerController.loadContainer(this.container);
			this.selectedIndex=this.currSelect
		}
		public function changePage():void
		{
			enableItem(this.lastSelect, true);
			this.lastSelect=this.currSelect;
			CurrentPage.ID=this.nextPage;
			LudoUtils.formBuilder.PaintPage();
			//this.callLater(this.callLaterSelectCurrentIndex,[idx, enable]);
			this.selectedIndex=this.currSelect
			callLaterSelectCurrentIndex()
		}
		private function callLaterSelectCurrentIndex():void
		{
			this.callLater(this.callLaterenableItem,[this.currSelect,false]);
		}
		public function noChangePage():void
		{
			this.currSelect=this.lastselect;
			this.nextPage=CurrentPage.ID;
			this.selectItem=this.currSelect;
		}

		public function DynaLinkBar(menuXML:XML)
		{
			this.menuXML=menuXML;
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
			generateNavigation();
		}
		private var disableMenuIndex:Array=[];
		private var iconIndex:Array=[];
		private var menuXML:XML;
		public var menu_itemclicked:Function;
		public var title:String="";

		private function menu_itemclickedMain(event:ItemClickEvent):void
		{
			if(menu_itemclicked!=null)
			{
				menu_itemclicked(event);
			}
    		else
    		{
				MessageController.popUpMessage("Menu Item Clicked","ItemClicked function is not available!");
			}
		}
		public function refreshNavigation():void
		{
			this.removeAllElements();
			this.removeEventListener(ItemClickEvent.ITEM_CLICK, menu_itemclickedMain);
			this.disableMenuIndex=[];
			this.iconIndex=[];
			this.dataProvider=null;
			generateNavigation();
			iconToDisplay();
			buttonsToDisable();
		}
        private function creationComplete(event:Object):void
        {
			iconToDisplay();
        	buttonsToDisable();
        }
		private static function getFunctionReferenceByFullPath(funcName:String):Function
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
        private function generateNavigation():void
		{
			if(menuXML == null) return;
			this.direction="horizontal";
			if(String(menuXML.@["direction"])!="") this.direction=String(menuXML.@["direction"])
			if(String(menuXML.@["id"])!="") this.id=String(menuXML.@["id"])
			if(String(menuXML.@["title"])!="") this.title=String(menuXML.@["title"])
			if(String(menuXML.@["type"])!="") this.type=String(menuXML.@["type"])
			if(String(menuXML.@["itemclick"])!="") this.menu_itemclicked=getFunctionReferenceByFullPath(String(menuXML.@["itemclick"]))
			this.dataProvider = linkObjects;
            this.horizontalCenter = 0;
            this.verticalCenter = 0;
			this.addEventListener(ItemClickEvent.ITEM_CLICK,menu_itemclickedMain);
            //this.selectedIndex=-1
        }
 		private function buttonsToDisable():void
		{
			for (var idx:int=0; idx < disableMenuIndex.length; idx++)
			{
				enableItem(disableMenuIndex[idx],false);
			}
		}
		private function iconToDisplay():void
		{
			for (var idx:int=0; idx < iconIndex.length; idx++)
			{
				var iArray:Array=String(iconIndex[idx]).split("::::");
				if(iArray.length>1)//add icon
				{
					attachIcon(iArray[0],iArray[1]);
				}
			}
		}
 		public function enableItem(idx:int,enable:Boolean):void
		{
			if(idx<0)
				return;
			this.enableLinkButton(idx, enable);
		}
		protected function callLaterenableItem(idx:int,enable:Boolean):void
		{
			if(idx<0)
				return;
			if(this.numElements>idx)
			{
				(this.getElementAt(idx) as LinkButton).enabled=enable;
			}
		}
		private function enableLinkButton(idx:int,enable:Boolean):void
		{
			if(idx<0)
				return;
			if(this.numElements>idx)
			{
				var aLinkButton:LinkButton=this.getElementAt(idx) as LinkButton;
				if(aLinkButton!=null)
				{
					aLinkButton.enabled=enable;
				}
				else
				{
					this.callLater(this.callLaterenableItem, [idx, enable]);
				}
			}
		}
		protected function callLaterAttachIcon(idx:int,iconPath:String):void
		{
			if(idx<0)
				return;
			var aLinkButton:LinkButton=this.getElementAt(idx) as LinkButton;
			if(aLinkButton!=null)
			{
				LudoUtils.setIconToButton(aLinkButton,iconPath);
			}
		}
 		private function attachIcon(idx:int,iconPath:String):void
		{
			if(idx<0)
				return;
			if(this.numElements>idx)
			{
				var aLinkButton:LinkButton=this.getElementAt(idx) as LinkButton;
				if(aLinkButton!=null)
				{
					LudoUtils.setIconToButton(aLinkButton,iconPath);
					//aLinkButton.setStyle('icon',getIcon(iconPath));
					//aLinkButton.setStyle('icon',setIcon(aLinkButton,iconPath));
				}
				else
				{
					this.callLater(this.callLaterAttachIcon, [idx, iconPath]);
				}
			}
		}
		public function getPageIDIfAny(idx:int):String
		{
			if(idx<0)
				return "";
			if(this.numElements>idx)
			{
				return this.dataProvider[idx]["pageid"];
			}
			return "";		
		}
		public function getItemObject(idx:int):Object
		{
			if(idx<0)
				return null;
			if(this.numElements>idx)
			{
				return this.dataProvider[idx];
			}
			return null;
		}
      	private function get linkObjects():Array
        {
        	var btnArray:Array=[];
        	var idx:int=0;
        	for each(var xml:XML in menuXML.children())
        	{
 				var linkButton:Object=new Object();
				var label:String=String(xml.@label);
				var view:Boolean=true;
				for each (var attribute:XML in xml.@*)
				{
					view=true;
					var atrName:String=String(attribute.name());
					switch (atrName)
					{
						case 'enabled':
							if (String(xml.@enabled) == "false")
							{
								disableMenuIndex.push(idx);
							}
							break;
						case 'permissionfor':
							view=LudoUtils.pageController.hasPermissionByActivities(String(xml.@permissionfor));
							break;
						case 'viewifquotein':
							view=LudoUtils.pageController.viewMenuIfQuoteIn(String(xml.@viewifquotein));
							break;
						case 'iconmap':
							//conIndex
							//LudoUtils.setIconToButton(linkButton,String(xml.@iconmap));
							iconIndex.push(idx+"::::"+String(xml.@iconmap));
							//linkButton[atrName]==ImageConnector.getImageByName(String(xml.@icon));
							break;
						default:
							linkButton[atrName]=String(xml.@[atrName]);
							break;
					}
					if(!view)
					{
						break;
					}
				}
				if(view)
				{
					generated=true;
					idx++;
					(label != "") ? linkButton.label=label : linkButton.label="Missing Label";
	       			btnArray.push(linkButton);
				}
        	}
        	return btnArray;
        }
	}
}