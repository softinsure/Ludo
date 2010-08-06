package org.ludo.utils
{
	import flash.display.DisplayObject;
	
	import mx.managers.PopUpManager;
	
	import org.ludo.components.mxml.PopupSearch;
	import org.ludo.sparks.components.mxml.PopupFinder;
	import org.ludo.views.PopupMsgBox;
	import org.ludo.views.SearchBox;
	
	public class PopUp
	{
		/*
		public function Popup()
		{
		}
		*/
		public static function openPopup(parent:DisplayObject,popup:Class,model:Boolean):*
		{
			return PopUpManager.createPopUp(parent,popup,true);
       	}
 		public static function showMessage(header:String,message:String,width:int=300,height:int=200):void
		{
			var popMsg:PopupMsgBox;
			popMsg=openPopupOnMain(PopupMsgBox,true) as PopupMsgBox;
			popMsg.setPopupMessage(header,message,width,height);
       	}
		public static function openPopupOnMain(popup:Class,model:Boolean):*
		{
			return PopUpManager.createPopUp(LudoUtils.applicationUsed,popup,true);
       	}
		public static function openPopupFinder(searchid:String,searchxml:String,valuefrom:Array=null,valueto:Array=null,returnFromPopup:Function=null):void
		{
			var popSearch:PopupFinder=new PopupFinder();
			popSearch.initiateSearch(searchid,searchxml,valuefrom,valueto,returnFromPopup);
			PopUpManager.addPopUp(popSearch,LudoUtils.applicationUsed,true);
		}
		public static function openPopupSearch(searchid:String,searchxml:String):void
		{
			var popSearch:PopupSearch=new PopupSearch();
			popSearch.initiateSearch(searchid,searchxml);
			PopUpManager.addPopUp(popSearch,LudoUtils.applicationUsed,true);
		}
	}
}