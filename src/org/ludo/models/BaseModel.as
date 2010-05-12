package org.ludo.models
{
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectUtil;
	
	import org.frest.Fr;
	import org.frest.models.FrModel;
	import org.ludo.controllers.ErrorController;
	import org.ludo.utils.LudoUtils;

	public class BaseModel extends FrModel
	{
		public function BaseModel(label:String="id")
		{
			super(label);
		}
		[Ignored]
		protected override function onSuccess(event:Object):void
		{
			setLastDBAccessAt();
			super.onSuccess(event);
			if(sessionexpired)
			{
				LudoUtils.modelController.currentSession.stopTimer();
				LudoUtils.loginController.showLoginStack("Session Expired","Your session has been expired!\nPlease log in.");
				return;
			}
			else if(loggedout)
			{
				LudoUtils.modelController.currentSession.stopTimer();
				LudoUtils.loginController.showLoginStack("Sign Out","Your have signed out successfully.");
				return;
			}
			else if(error)
			{
				if(message.length>0)
				{
					LudoUtils.pageController.showPageErrorMsg(message);
				}
				return;
			}
			else if(validationerror)
			{
				LudoUtils.pageController.validateServerError(serverError);
				return;
			}
			else if(currentAction=='create' || currentAction=='update' || currentAction=='directupdate')
			{
				if(!Fr.crudTransactionQueue.hasAnyTransaction && showMessage)
				{
					LudoUtils.pageController.showSuccessMsg();
				}
			}
			afterOnSuccess(event);
		}
		[Ignored]
		private function parseSessionData():void
		{
			//get the session data
			for each(var items:String in session_data.split("^"))
			{
				var sArray:Array=items.split("::");
				if(sArray.length==2)
				{
					//parse data
					if(LudoUtils.modelController.currentSession.hasOwnProperty(sArray[0]))
					{
						LudoUtils.modelController.currentSession[sArray[0]]=sArray[1];
					}
				}
			}
		}
		[Ignored]
		private function setLastDBAccessAt():void
		{
			LudoUtils.modelController.currentSession.last_db_access_at=new Date();
		}
		[Ignored]
		private function afterOnSuccess(event:Object):void
		{
			switch(currentAction.toLowerCase())//do a lowercase
        	{
        		case "show":
					afterShow.call(this,event);
					break;
        		case "update":
					afterUpdate.call(this,event);
       			break;
        		case "destroy":
					afterDestroy.call(this,event);
        			break;
        		case "create":
					afterCreate.call(this,event);
				case "clone":
					afterClone.call(this,event);
        			break;
				default:
					afterAction.call(this,event);
					break;
        	}
		}
		[Ignored]
		public var afterShow:Function = function (event:Object):void{};
		[Ignored]
		public var afterCreate:Function = function (event:Object):void{};
		[Ignored]
		public var afterUpdate:Function = function (event:Object):void{};
		[Ignored]
		public var afterDestroy:Function = function (event:Object):void{};
		[Ignored]
		public var afterClone:Function = function (event:Object):void{};
		[Ignored]
		public var afterAction:Function = function (event:Object):void{};
		[Ignored]
		protected override function onFailure(event:Object):void
		{
			setLastDBAccessAt();
			super.onFailure(event);
			if(error)
			{
				ErrorController.logErrorTwo(getQualifiedClassName(this)+" action failure at fault: " + ObjectUtil.toString(event),"Command","CreateRecordCommand");
				//LudoUtils.pageController.showPageErrorMsg(message,"fault");
			}
		}
	}
}