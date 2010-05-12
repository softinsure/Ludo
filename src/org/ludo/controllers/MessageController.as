package org.ludo.controllers
{
	import flash.events.Event;
	
	import mx.controls.Alert;
	
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.PopUp;
	
	public dynamic class MessageController
	{
		public function MessageController()
		{
		}
		public static function confirmYesNo(message:String,title:String,confirmHandler:Function,arg:Array=null):void 
		{
		// instantiate the Alert box
		if(arg!=null)
		{
			Alert.show(message,title,Alert.YES | Alert.NO,null,function(e:Event):void{confirmHandler.call(this,e,arg)});
		}
		else
		{
			Alert.show(message,title,Alert.YES | Alert.NO,null,function(e:Event):void{confirmHandler.call(this,e)});			
		}
     		//var alert:Alert = Alert.show(message,title, Alert.YES|Alert.NO,this, function(e){confirmHandler.call(this,e,arg)},null, Alert.NO);
		
		// modify the look of the Alert box
		/*
		alert.setStyle((”backgroundColor”, 0xffffff);
		alert.setStyle(”backgroundAlpha”, 0.50);
		alert.setStyle(”borderColor”, 0xffffff);
		alert.setStyle(”borderAlpha”, 0.75);
		alert.setStyle(”color”, 0×000000);
		*/
		}
		public static function popUpMessage(header:String,message:String,width:int=300,height:int=200):void
		{
			PopUp.showMessage(header,message,width,height);
			//LudoUtils.pageController.showPageErrorMsg(message);
		}
		public static function showPageErrorMsg(message:String):void
		{
			LudoUtils.pageController.showPageErrorMsg(message);
		}
		public static function hidePageErrorMsg():void
		{
			LudoUtils.pageController.hidePageErrorMsg();
		}
	}
}