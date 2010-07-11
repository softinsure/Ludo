package org.ludo.controllers
{
	import flash.display.DisplayObject;
	import flash.net.SharedObject;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.frest.utils.FrUtils;
	import org.ludo.components.mxml.LoginBox;
	import org.ludo.models.Session;
	import org.ludo.utils.LudoUtils;
	import org.ludo.views.PopupLogin;
	
	public class LoginController
	{
		private static var loginManager:LoginController;
		private var loginWindow:IFlexDisplayObject;
		public var loginbox:LoginBox;
		public var remember:Boolean=false;
		public static function getInstance():LoginController
        {
        	if (loginManager == null)
            {
                loginManager = new LoginController();
            }
            return loginManager;
        }
		public function LoginController()
		{
			if (loginManager != null)
			{
				throw new Error("Only one LoginManager instance may be instantiated.");
            }
		}
		public function showPopupLoginBox(parent:DisplayObject):void
		{
			// Create the TitleWindow container.
			loginWindow = PopUpManager.createPopUp(parent,PopupLogin,true);
	  	}
		public function showLoginStack(header:String="",message:String=""):void
		{
			// Create the TitleWindow container.
			/*
			loginbox.reset();
			try
			{
				LudoUtils.setCurrentState="start";
			}
			catch(e:Error)
			{
				showPopupLoginBoxApplication();
			}
			*/
			loginbox.reset();
			if(LudoUtils.navController.startBox!=null)
			{
				LudoUtils.navController.appstack.selectedChild=LudoUtils.navController.startBox;
				FrUtils.applicationUsed.currentState="start";
				LudoUtils.navController.startBox.visible=true;
				LudoUtils.navController.appstack.visible=true;
				//LudoUtils.applicationUsed.currentState="start";
			}
			else
			{
				showPopupLoginBoxApplication();
			}
			if(message.length>1)
			{
				MessageController.popUpMessage(header,message);
			}
			//loginWindow = PopUpManager.createPopUp(parent,login,true);
	  	}
		public function showPopupLoginBoxApplication():void
		{
			// Create the TitleWindow container.
			loginbox.reset();
			loginWindow = PopUpManager.createPopUp(LudoUtils.applicationUsed,PopupLogin,true);
	  	}
	  	public function closePopupLoginBox():void
        {
        	if(loginbox is TitleWindow)
        	{
        		PopUpManager.removePopUp(loginWindow);
        	}
        }
        public function doLogin(userid:String,password:String,rememberme:Boolean):void
        {
        	try
        	{
        		//create a new session
        		//clear from model controller
        		//assign a new session to controller
        		LudoUtils.modelController.currentSession=null;
        		LudoUtils.modelController.currentSession = new Session("curentSession");
        		LudoUtils.modelController.currentSession.login=userid;
        		LudoUtils.modelController.currentSession.password=password;
        		LudoUtils.modelController.currentSession.rememberme=rememberme;
				//LudoUtils.modelController.currentSession.afterCreate=loadMain;
				LudoUtils.modelController.currentSession.create();
        		//CairngormUtils.dispatchEvent(EventNames.CREATE_SESSION,{login:userid,password:password,remember:rememberMe});
        	}
            catch (error:Error)
            {
            	ErrorController.showErrorObject(error);
     		}
        }
		/*
		private function loadMain(event:Object):void
		{
			FrUtils.cairngormDispatchEvent(EventNames.LOAD_MAIN);
		}
		*/
        public function doLogOut():void
        {
        	try
        	{
        		LudoUtils.modelController.currentSession.destroy();
				LudoUtils.pageController.clearPage();
				LudoUtils.dataStore.cleanDataStore();
				//clean application
        		//CairngormUtils.dispatchEvent(EventNames.DELETE_SESSION);
        	}
            catch (error:Error)
            {
            	ErrorController.showErrorObject(error);
     		}
        }
        public function rememberedMe():Boolean
        {
 	        // put inside "data" property
	        var rememberSO:SharedObject=SharedObject.getLocal("loginData");
	        // if we have username and password saved
	        // we do auto-login
	        if (rememberSO.data.username != undefined && rememberSO.data.password != undefined)
	        {// calling the login service to check 
	            // the username and password
	            doLogin(rememberSO.data.username,rememberSO.data.password,true);
				remember=true;
	            return true;
	        }
	        else
	        {
				remember=false;
	        	return false;
	        }			
       	
        }
 		private function confirmResponse(event:CloseEvent):void {
			if(event.detail == Alert.YES)
			{
				doLogOut();
			}
		}
        public function doConfirmLogOut():void
        {
        	try
        	{
        		MessageController.confirmYesNo("There may be some unsaved changes on this page.\n\nLeave Anyway?","Confirmation",confirmResponse);
 			}
            catch (error:Error)
            {
            	ErrorController.showErrorObject(error);
     		}
        }
    }
}