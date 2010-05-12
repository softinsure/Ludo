package org.ludo.controllers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	
	import org.ludo.components.custom.DynaLinkBar;
	import org.ludo.models.BaseModel;
	import org.ludo.models.ErrorLog;
	import org.ludo.models.GroupPermission;
	import org.ludo.models.PaymentInfo;
	import org.ludo.models.Quote;
	import org.ludo.utils.CurrentPage;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.PopUp;
	import org.ludo.views.PopupMsgBox;
	
	import spark.components.ButtonBar;
	import spark.events.IndexChangeEvent;
	
	public class ActionController
	{
		//private static var callRaterFunction:Function;
		//private static var callAfterMakeApplicationFunction:Function;
		//private static var callAfterBindFunction:Function;
		//private static var callAfterProduceFunction:Function;
		/*
		public static function set setAfterBindFunction(func:Function):void
		{                                                                   
			callAfterBindFunction = func;
		}
		public static function set setAfterProduceFunction(func:Function):void
		{                                                                   
			callAfterProduceFunction = func;
		}
		public static function set setAfterMakeApplicationFunction(func:Function):void
		{                                                                   
			callAfterMakeApplicationFunction = func;
		}
		protected static function callAfterBind():void
		{
			if(callAfterBindFunction!=null)
			{
				callAfterBindFunction.call();
			}
		}
		protected static function callAfterProduce():void
		{
			if(callAfterProduceFunction!=null)
			{
				callAfterProduceFunction.call();
			}
		}
		protected static function callAfterMakeApplication():void
		{
			if(callAfterMakeApplicationFunction!=null)
			{
				callAfterMakeApplicationFunction.call();
			}
		}
		public static function set setMyRaterFunction(func:Function):void
		{                                                                   
			callRaterFunction = func;
		}
		*/
		protected static function callRater():void
		{
			LudoUtils.referencedMethods.callMethod("rate");
		}
		public static function topRight_itemclicked(event:ItemClickEvent):void
		{

			switch (String(event.item["action"]))
			{
				case 'signout':
					LudoUtils.loginController.doConfirmLogOut();
					break;
				case 'underconstruction':
					MessageController.popUpMessage("Under Construction","Under Construction!");
					return;
					break;
				default:
					MessageController.popUpMessage("No Action","No correct action specified!");
					break;
			}
		}
		public static function setPaymentPlan(defaultPlan:String=""):void
		{
			if(defaultPlan!="" && LudoUtils.modelController.quote.payment_plan=="")
			{
				LudoUtils.modelController.quote.payment_plan=defaultPlan;
			}
			var paymentinfo:PaymentInfo=LudoUtils.modelController.collections.getFromCollection("paymentschedule") as PaymentInfo;
			if(paymentinfo==null)
			{
				if(LudoUtils.modelController.quote.payment_plan!="")//has payment plan
				{
					LudoUtils.modelController.collections.addToCollection("paymentschedule",new PaymentInfo(LudoUtils.modelController.quote));
				}
			}
			else
			{
				paymentinfo.setSchedule();
			}
		}
		public static function paymentPlanSelected(event:ListEvent):void
		{
			LudoUtils.modelController.quote.payment_plan=event.target.selectedValue;
			LudoUtils.modelController.collections.addToCollection("paymentschedule",new PaymentInfo(LudoUtils.modelController.quote));
		}
		public static function paymentPlanSelection(event:ListEvent):void
		{
			LudoUtils.modelController.quote.payment_plan=event.itemRenderer.data["plan_code"];
			LudoUtils.modelController.collections.addToCollection("paymentschedule",new PaymentInfo(LudoUtils.modelController.quote));
		}
		public static function transQuoteLeft_itemclicked(event:ItemClickEvent):void
		{
			var menuClicked:DynaLinkBar=event.target as DynaLinkBar;
			menuClicked.container=event.item.container;
			menuClicked.currSelect=event.target.selectedIndex;
			if (menuClicked.lastSelect == menuClicked.currSelect)
			{
				return;
			}
			var action:String=String(event.item["action"])
			if (action == 'underconstruction')
			{
				MessageController.popUpMessage("Under Construction","Under Construction!");
				return;
			}
			switch (action)
			{
				case "screen"://navigation between page
					menuClicked.nextPage=String(event.item["pageid"]);
					if(!LudoUtils.pageController.confirmIfChanged(menuClicked.confirmBeforeChangePage))
					{
						menuClicked.changePage();
					}
					/*
					else
					{
						menuClicked.noChangePage();
					}
					*/
					break;
				default:
					menuClicked.lastSelect=menuClicked.currSelect
					break;
			}
		}
		public static function homeLeft_itemclicked(event:ItemClickEvent):void
		{
			var menuClicked:DynaLinkBar=event.target as DynaLinkBar;
			menuClicked.container=event.item.container;
			//var confirmchange:String=event.item.confirmchange;
			menuClicked.currSelect=event.target.selectedIndex;
			if (menuClicked.lastSelect == menuClicked.currSelect)
			{
				return;
			}
			var action:String=String(event.item["action"]);
			menuClicked.currentTransaction=String(event.item["transactiontouse"]);
			if(menuClicked.currentTransaction=="undefined")
			{
				menuClicked.currentTransaction="";
			}
			if (action == 'underconstruction')
			{
				MessageController.popUpMessage("Under Construction","Under Construction!");
				return;
			}
			switch (menuClicked.container)
			{
				//donot set transaction for quote
				//transaction will be set in quote box
				case 'quote':
					switch (action)
					{
						case 'new':
							var lob:String=String(event.item["lob"]);
							if (lob != "" && lob != 'undefined')
							{
								menuClicked.lastSelect=-1;
								LudoUtils.pageController.clearPage();
								LudoUtils.pageController.viewOnly=false;
								LudoUtils.dataStore.setSession("lob", lob);
								LudoUtils.modelController.getNewQuoteModel("currentQuote",menuClicked.currentTransaction,lob).create();
								return;
							}
							else
							{
								MessageController.popUpMessage("LOB","LOB not specified!");
								return;
							}
							break;
						default:
							MessageController.popUpMessage("No Action","No correct action specified!");
							break;
					}
					break;
				default:
					if(menuClicked.currentTransaction != "")
					{
						//set transaction
						LudoUtils.transController.setCurrentTransaction=menuClicked.currentTransaction;
					}
					if (menuClicked.container != "")
					{
						//LudoUtils.containerController
						LudoUtils.containerController.loadContainer(menuClicked.container);
					}
					return;
					break;
			}
			menuClicked.lastSelect=menuClicked.currSelect;
		}
		//action model
		public static function modelGridButtonBarClicked(event:ItemClickEvent,data:Object,param:Array):void
		{
			if(data is XML)//data row
			{
				if(param.length<=0)
				{
					throw new Error("Missing Model Class Path!");
				}
				//var definition:Class=getDefinitionByName(param[0].toString()) as Class;
				var model:BaseModel = LudoUtils.modelController.getModelToUpdateFromClassPath(param[0].toString(),int(String(data.id)));
				//var id:String=data.id;
				//model.id=int(String(data.id));
				model.afterShow=loadModelPage;
				//LudoUtils.modelController.addModelToUpdate(model);
				LudoUtils.pageController.viewOnly=true;
				//switch(event.label.toLowerCase())
				switch(String(event.item["action"]).toLowerCase())
				{
					case "view":
						model.show();
						break;
					case "edit":
						LudoUtils.pageController.viewOnly=false;
						model.show();
						//viewUser(id);
						break;
					case "finder":
					case "popup":
						PopUp.openPopupSearch("permission","adminsearch");
						break;
					case "copy":
						break;
				}
			}
		}
		public static function modelGridCheckBoxClicked(event:MouseEvent,data:Object,param:Array=null):void
		{
		}
		private static function loadModelPage(event:Object):void
		{
			LudoUtils.containerController.loadActivityDetail("pageholder",true);
			/*
			var object:PageHolder=LudoUtils.containerController.loadActivityDetail("pageholder",true) as PageHolder;
			if(object !=null)
			{
				object.loadPage();
			}
			*/
		}
		private static function getClickedEventObject(event:*):Object
		{
			var index:int=-1;
			var selectedObj:Object;
			if(event is IndexChangeEvent)
			{
				index=event["newIndex"]==-1?event["oldIndex"]:event["newIndex"];
				selectedObj=(event.currentTarget.dataProvider as IList).getItemAt(index) as Object;
			}
			else if (event.hasOwnProperty("item"))
			{
				selectedObj=event["item"] as Object;
			}
			return selectedObj;
		}
		public static function modelSearchHeaderButtonBarClicked(event:*):void
		{
			var selectedObj:Object=getClickedEventObject(event);
			if(selectedObj==null)
			{
				return;
			}
			switch(selectedObj.hasOwnProperty("action")?selectedObj.action:"noaction")
			{
				case "new":
					if(LudoUtils.isEmpty(String(selectedObj.modelclasspath)))
					{
						throw new Error("Missing Model Class Path!");
					}
					var model:BaseModel = LudoUtils.modelController.getModelToUpdateFromClassPath(String(selectedObj.modelclasspath));
					LudoUtils.pageController.viewOnly=false;//edit
					LudoUtils.containerController.loadActivityDetail("pageholder",true);
					break;
				case "loadcontainer":
					if(LudoUtils.isEmpty(String(selectedObj.container)))
					{
						throw new Error("Missing Container to load!");
					}
					LudoUtils.containerController.loadContainer(String(selectedObj.container));
					break;
				default:
					break;
			}
		}
		public static function modelControlBarClicked(event:*,param:Array=null):void
		{
			var selectedObj:Object=getClickedEventObject(event);
			if(selectedObj==null)
			{
				return;
			}
			var modelname:String=LudoUtils.transController.getProperty("modelname");
			if(modelname.length<=0)
			{
				throw new Error("Missing model name in transaction!");
			}
			var modelToUpdate:BaseModel=LudoUtils.modelController.getModelToUpdate(modelname) as BaseModel;
			switch(selectedObj.hasOwnProperty("action")?selectedObj.action:"noaction")
			{
				case "add":
				case "save":
					LudoUtils.pageController.saveModels(modelToUpdate);
					break;
				case "exit":
					//doExit();
					break;
				case "cancel":
					doCancel();
					//load userdadmin container
					LudoUtils.containerController.loadContainer(LudoUtils.transController.getProperty("container"));
					break;
				case "continueview":
					doContinueView();
					break;
				case "rate":
					doRate();
					break;
				case "continue":
					doContinue();
					break;

			}
		}
		public static function unitButtonBarClicked(event:ItemClickEvent,data:Object,param:Array):void
		{
			if(data is XML)
			{
				//read param
				var unitid:String="";
				if(param.length>0)
				{
					//first para is unit id
					unitid=param[0].toString();
					
				}
				else
				{
					MessageController.popUpMessage("Missing","Missing parameter array! Please add @methodparam.");
				}
				var pageid:String=String(event.currentTarget["pageid"]);
				if(pageid=="")
				{
					pageid=CurrentPage.ID;
				}
				LudoUtils.pageController.hidePageErrorMsg();
				switch(String(event.item["action"]).toLowerCase())
				//switch(event.label.toLowerCase())
				{
					case "viewxml":
						var popMsg:PopupMsgBox;
						popMsg=PopUp.openPopupOnMain(PopupMsgBox,true) as PopupMsgBox;
						popMsg.setPopupMessage("Unit Node",XMLList(data).toXMLString(),500,400);
						break;
					case "view":
					case "edit":
						LudoUtils.pageController.populateUnitGridPanel(pageid,unitid,XMLList(data));
						break;
					case "delete":
						LudoUtils.pageController.deleteUnitFromGrid(pageid,unitid);
						break;
				}
			}	
		}
		public static function pageControlBarClicked(event:*,param:Array=null):void
		{
			var selectedObj:Object=getClickedEventObject(event);
			if(selectedObj==null)
			{
				return;
			}
			var currentTrans:String="quote";
			if(!LudoUtils.isEmpty(String(selectedObj.pagetogo)))
			{
				LudoUtils.pageController.pageToGo=String(selectedObj.pagetogo).toLowerCase();
			}
			if(param!=null && param.length>0)
			{
				currentTrans=param[0].toString(); 
				
			}
			switch(currentTrans)
			{
				default:
					quoteAction(selectedObj.hasOwnProperty("action")?selectedObj.action:"noaction");
					break;
			}
		}
		/*
		public static function pageControlBarClicked(event:*,data:Object,param:Array=null):void
		{
			//read param
			
			var currentTrans:String="quote";
			//var pagetogo:String="";
			var action:String=event.item.action.toLowerCase();
			if(event.item.pagetogo!=null)
			{
				LudoUtils.pageController.pageToGo=String(event.item.pagetogo.toLowerCase());
			}
			if(param!=null && param.length>0)
			{
				currentTrans=param[0].toString();
				
			}
			switch(currentTrans)
			{
				default:
					quoteAction(action);
					break;
			}
			//LudoUtils.pageController.pageToGo=pagetogo;
		}
		*/
		protected static function quoteAction(action:String):void
		{
			switch(action)
			{
				case "add":
				case "save":
					doSaveQuote();
					break;
				case "cancel":
					doCancel();
					break;
				case "continueview":
					doContinueView();
					break;
				case "rate":
					doRate();
					break;
				case "application":
					doApplication();
					break;
				case "bind":
					doBind();
					break;
				case "produce":
					doProduce();
					break;
				case "continue":
					doContinue();
					break;
				case "current":
					doCurrent();
					break;
				case "nextpage":
					doNextPage();
					break;
				case "previouspage":
					doPrevPage();
					break;
				case "confirmendorsement":
					doConfirmEndorsement();
					break;
				default:
					callAfterMethod(action);
					break;
			}
		}
		protected static function getAfterMethod(methodkey:String):Function
		{
			return LudoUtils.referencedMethods.getMethod(methodkey);
		}
		protected static function callAfterMethod(methodkey:String):void
		{
			LudoUtils.referencedMethods.callMethod(methodkey);
		}
		protected static function doCancel() : void
		{
			LudoUtils.pageController.cancelSaveCurrentPage();
		}

		protected static function doSaveQuote() : void
		{
			LudoUtils.pageController.saveCurrentPage();
		}
		protected static function doSavePage(eventName:String,objectToSave:Object) : void
		{
			LudoUtils.pageController.saveCurrentPageByEventAndObject(eventName,objectToSave);
		}
		protected static function doApplication():void
		{
			LudoUtils.modelController.quote.quote_status="A";
			LudoUtils.modelController.quote.changed=true;
			LudoUtils.pageController.pageChanged=true;
			LudoUtils.pageController.saveCurrentPage(getAfterMethod("application"));
		}
		protected static function doBind():void
		{
			//do not bind here
			//just call me child function
			if(LudoUtils.modelController.quote.requiredFiledsToBindEntered)
			{
				callAfterMethod("bind");
				//callAfterBind();
			}
			else
			{
				LudoUtils.pageController.showPageErrorMsg("Policy cannot be issued because all required fileds are not entered!");
			}
		}
		protected static function doProduce():void
		{
			//do not produce here here
			//just call me child function
			callAfterMethod("produce");
			//callAfterProduceFunction();
		}
		protected static function doRate():void
		{
			LudoUtils.pageController.saveCurrentPage(callRater);
		}
		protected static function doConfirmEndorsement():void
		{
			LudoUtils.pageController.updateToDb=false;
			LudoUtils.pageController.saveCurrentPage(callAfterConfirmEndorsement);
		}
		protected static function callAfterConfirmEndorsement():void
		{
			LudoUtils.pageController.updateToDb=true;
			callAfterMethod("confirmendorsement")
		}
		protected static function doContinue():void
		{
			//Fr.crudTransactionQueue.actionAfterAllTransactions=nextPage;
			LudoUtils.pageController.saveCurrentPage(LudoUtils.pageController.nextPage);
			//if(!LudoUtils.pageController.saveCurrentPage())
			//{
				//Fr.crudTransactionQueue.clearModelQueue();
				//CurrentPage.ID=CurrentPage.nextID;//TransManager.getInstance().getNextPage(CurrentPage.ID);
				//LudoUtils.formBuilder.PaintPage();
				//LudoUtils.navController.leftMenu.selectItemByPageID(CurrentPage.ID);
			//}
		}		
		protected static function doNextPage():void
		{
			LudoUtils.pageController.nextPage();
		}		
		protected static function doPrevPage():void
		{
			LudoUtils.pageController.previousPage();
		}		
		protected static function doCurrent():void
		{
			LudoUtils.pageController.currentPageInFlow();
		}		
		protected static function doContinueView():void
		{
			LudoUtils.pageController.nextPage();
		}
		public static function workBoxButtonbarClicked(event:ItemClickEvent,data:Object):void
		{
			if(data is XML)//data row
			{
				var id:String=data.id;
					
				switch(String(event.item["action"]).toLowerCase())
				//switch(event.label.toLowerCase())
				{
					case "view":
						viewQuote(id);
						break;
					case "edit":
						viewQuote(id,false);
						break;
					case "copy":
						cloneQuote(id);
						break;
					case "viewerror":
						viewError(id);
						break;
				}
			}
		}
		public static function policySearchButtonbarClicked(event:ItemClickEvent,data:Object):void
		{
			if(data is XML)//data row
			{
				var id:String=data.id;
				
				switch(String(event.item["action"]).toLowerCase())
				//switch(event.label.toLowerCase())
				{
					case "view":
						viewQuote(id);
						break;
					case "endorse":
						endorsePolicy(id);
						break;
				}
			}
		}
		protected static function endorsePolicy(quoteid:String):void
		{
			LudoUtils.pageController.viewOnly=false;
			var quote:Quote=LudoUtils.modelController.getNewQuoteModel("endorsedQuote");
			quote.id=int(quoteid);
			quote.action("endorse");
			//CairngormUtils.dispatchEvent(EventNames.VIEW_QUOTE,quoteid);
		}
		protected static function cloneQuote(quoteid:String):void
		{
			LudoUtils.pageController.viewOnly=false;
			var quote:Quote=LudoUtils.modelController.getNewQuoteModel("clonedQuote");
			quote.id=int(quoteid);
			quote.action("clone");
			//CairngormUtils.dispatchEvent(EventNames.VIEW_QUOTE,quoteid);
		}
		protected static function viewQuote(quoteid:String,viewMode:Boolean=true):void
		{
			LudoUtils.pageController.viewOnly=viewMode;
			var quote:Quote=LudoUtils.modelController.getNewQuoteModel("currentQuote");
			//quote.use_mode=viewMode?"V":"E";
			quote.id=int(quoteid);
			if(!viewMode)
			{
				quote.action("edit");
			}
			else
			{
				quote.show();
			}
			//CairngormUtils.dispatchEvent(EventNames.VIEW_QUOTE,quoteid);
		}
		protected static function viewError(id:String):void
		{
			var errorLog:ErrorLog=new ErrorLog(id);
			errorLog.id=int(id);
			errorLog.show();
		}
		public static function popUpFinder(event:Event,searchid:String,searchxml:String,valuefrom:String="",valueto:String="",returnFromPopupClassPath:String=""):void
		{
			var vArrayFrom:Array=valuefrom.split("||");
			var vArrayTo:Array=valueto.split("||");
			if(vArrayFrom.length!=vArrayTo.length)
			{
				throw new Error("valuefrom and valueto mismatch!! Both should have same number of item.");
			}
			var valToDisplay:Array=[];
			for each (var vTo:String in vArrayTo)
			{
				var val:DisplayObject=CurrentPage.getElmentByID(vTo);
				if(val==null)
				{
					throw new Error(vTo+" is not a DisplayObject!");
				}
				valToDisplay.push(val);          
			}
			var aFunction:Function;
			if(returnFromPopupClassPath.length>0)
			{
				aFunction=LudoUtils.getFunctionReferenceByFullPath(returnFromPopupClassPath);
			}
			org.ludo.utils.PopUp.openPopupFinder(searchid,searchxml,vArrayFrom,valToDisplay,aFunction);
		}
		public static function setGroupActivity(event:MouseEvent,data:Object,param:Array=null):void
		{
			if(data is XML)//data row
			{
				var cBox:CheckBox=event.currentTarget as CheckBox;
				var selected:Boolean=cBox.selected;
				data.status=selected?"A":"I";
				//if both group and lob selected and activity chenged then save
				if(data.selected_group!="" && data.selected_lob!="")
				{
					//check permission
					if(LudoUtils.modelController.currentSession.hasPermission("ADM"))
					{
						if(data.status!=data.old_status)
						{
							var groupPermission:GroupPermission;
							//create activity objects
							groupPermission=LudoUtils.modelController.getModelToUpdate("grouppermission") as GroupPermission;
							if(groupPermission==null)
							{
								groupPermission=new GroupPermission(data.id);
							}
							groupPermission.id=data.id;
							groupPermission.group_code=data.selected_group;
							groupPermission.lob_code=data.selected_lob;
							groupPermission.status=data.status;
							groupPermission.activity_code=data.activity_code;
							groupPermission.changed=true;
							groupPermission.save();
						}
					}
					else
					{
						cBox.selected=!selected;
						MessageController.popUpMessage("Group Activity","You are not authorized to change permission.");
					}
				}
				else
				{
					cBox.selected=!selected;
					MessageController.popUpMessage("Group Activity","Please select both group and lob.");
				}
			}
		}
	}
}