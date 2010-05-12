package org.ludo.models
{
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.CursorManager;
	
	import org.common.utils.XDateUtil;
	import org.frest.Fr;
	import org.frest.collections.DataContainer;
	import org.frest.utils.FrUtils;
	import org.ludo.controllers.EventNames;
	import org.ludo.controllers.MessageController;
	import org.ludo.utils.LudoUtils;

	[Resource(name="sessions")]
  	[Bindable]
	public class Session extends BaseModel
	{
		[Ignored]
		private var logged:Boolean=false;
		[Ignored]
		private var timer:Timer;
		private var rememberSO:SharedObject;
        public var login:String;
        public var password:String;
        public var remember_me:int=0;
		public var session_id:String;
		[ReadOnly]
		public var expired_at:String;
		//public var quote_id:String;
		//public var quote_used_mode:String;
		[Ignored]
		public var last_db_access_at : Date;//in minutes
		[ReadOnly]
		public var session_timeout : int;//in minutes
		[Ignored]
        public var rememberme:Boolean;		
    	[Ignored]
    	public var user:User;
		[Ignored]
    	public var agent:Agent;
		[Ignored]
    	public var agency:Agency;
		[Ignored]
		private var permissions:DataContainer;//=new FrModelCollection();
    	public function Session(label:String="id")
		{
			//doUnmarshall=false;
			super(label);
		}
		[Ignored]
		public function get loggedIn():Boolean
		{
			return logged;
		}
		[Ignored]
		private function setTimer(functionToCall:Function,delay:int=10000):void
		{
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER,functionToCall);
			timer.start();
		}
		[Ignored]
		public function stopTimer():void
		{
			if(timer!=null)
			{
				timer.stop();
			}
		}
		[Ignored]
		public function  ifSessionExpired(e:TimerEvent):void
		{
			if(XDateUtil.dateDiff("n",new Date(),last_db_access_at)>=session_timeout-5 && loggedIn)
			{
				timer.stop();
				MessageController.confirmYesNo("Last DB access at "+last_db_access_at+"\nSession time out "+session_timeout+" minutes\nYour DB session is about to expire and will expire at "+XDateUtil.dateAdd("n",session_timeout,last_db_access_at)+"!!! .\n\nDo you want to reset?","Confirmation",confirmIfReset);
			}
		}
		[Ignored]
		private function confirmIfReset(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				this.action("reset");
			}
			else
			{
				timer.start();
			}
		}
		[Ignored]
		public function hasPermission(activityCode:String):Boolean
		{
			var ret:Boolean=false;
			if(permissions.get(activityCode+"::ALL")!=null)
			{
				ret=true;
			}
			else if(permissions.get(activityCode+"::"+LudoUtils.dataStore.getSession("lob"))!=null)
			{
				ret=true;
			}
			return ret;
		}
		[Ignored]
		public override function create(onSuccess:Function=null,onFailure:Function=null):void
		{
			if(this.login!= null && this.password != null)
			{
				remember_me=0;
				if(rememberme)
				{
					remember_me=1;
				}
				//super.create(onSuccess,onFailure);
				super.create();
			}
			else
			{
				MessageController.popUpMessage("Validation Error","Please enter Valid Username and Password.");
			}
		}
		[Ignored]
		public override function update(onSuccess:Function=null,onFailure:Function=null):void
		{
			cannotUse();
		}
		[Ignored]
		public override function show(onSuccess:Function=null,onFailure:Function=null):void
		//public override function show():void
		{
			cannotUse();
		}
		[Ignored]
		protected override function onFailure(event:Object):void
		{
			super.onFailure(event);
			LudoUtils.loginController.showLoginStack();
			CursorManager.removeBusyCursor();
			if(currentAction=="destroy")
			{
				MessageController.popUpMessage("Validation Error","Sign Out Failed.");
			}
			else
			{
				MessageController.popUpMessage("Validation Error","login Failed.");
			}
		}
		[Ignored]
		protected override function onSuccess(event:Object):void
		{
			CursorManager.removeBusyCursor();
			doUnmarshall=false;
			showMessage=false;
			super.onSuccess(event);
			//var result : Object = event.result;
			rememberSO = SharedObject.getLocal("loginData");
			if(currentAction=="release")
			{
				
			}
			else if(currentAction=="reset")
			{
				if(result == "sessionreset")
				{
					MessageController.popUpMessage("Reset Session","Your DB session has been reset successfully!");
				}
				timer.start();
			}
			else if(currentAction=="destroy")
			{
				rememberSO.clear();
	            LudoUtils.loginController.showLoginStack();
				LudoUtils.cleanObjects();
			}
			else
			{
				// getting data from shared object
	            // if the object named "loginData" and
	            // saved localy doesn't exists it is 
	            // created without data
	            // if it exists the data is recovered and
	            // put inside "data" property
	            rememberSO = SharedObject.getLocal("loginData");
	            //var navMgr : NavManager = NavManager.getInstance();
				if (event.result == "badlogin")
				{
					LudoUtils.loginController.showLoginStack();
					MessageController.popUpMessage("Validation Error","login Failed.");
					rememberSO.clear();
				}
				else
				{
					if(rememberme)
					{
						// if we selected remember password
		                // we save data as we may login 
		                // without checking the checkbox in the
		                // first screen but we want to select it
		                // after login
		                rememberSO.data.username = login;
		                rememberSO.data.password = password;
		                rememberSO.flush();
		                rememberSO.close();
		                                
	    			}
	    			else
	    			{
	    				rememberSO.clear();
	    			}
	    			logged=true;
	    			//close  login box
	    			LudoUtils.loginController.closePopupLoginBox();
					//Alert.show("here");
					//Alert.show(event.result);
					//Alert.show(XML(event.result..session));
					Fr.serializer.unmarshall(XML(event.result..session),this);
					setTimer(ifSessionExpired,10000);
					
					//FrUtils.setSessionTimer(this.ifSessionExpired);
					this.user=new User("sessionUser");

					//unmarshal quote
					Fr.serializer.unmarshall(XML(event.result..user),this.user);
					this.agent=new Agent("sessionAgent");
					Fr.serializer.unmarshall(XML(event.result..agent),this.agent);
					this.agency=new Agency("sessionAgency");
					Fr.serializer.unmarshall(XML(event.result..agency),this.agency);
					//LudoUtils.modelController.user=this.user;
					//permissions
					permissions = new DataContainer();
					var pxml:XML=XML(event.result..permissions);
					if(pxml!=null)
					{
						for each (var xml:XML in pxml.children())
						{
							if(xml.hasOwnProperty("activity_code") && xml.hasOwnProperty("lob_code"))
							{
								//assign permission
								permissions.put(xml.activity_code+"::"+xml.lob_code,"Y");
							}
						}
					}
					FrUtils.cairngormDispatchEvent(EventNames.LOAD_MAIN);
				}
			}
		}
	}
}