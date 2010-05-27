package org.ludo.controllers
{
	import flash.display.DisplayObject;
	
	import mx.containers.Box;
	import mx.containers.FormItem;
	import mx.controls.Alert;
	import mx.core.IVisualElement;
	import mx.events.CloseEvent;
	import mx.validators.Validator;
	
	import org.common.utils.XArrayUtil;
	import org.frest.Fr;
	import org.frest.collections.DataContainer;
	import org.frest.models.FrModel;
	import org.frest.utils.FrUtils;
	import org.ludo.components.custom.CoverageInput;
	import org.ludo.layouts.ActionBar;
	import org.ludo.layouts.DataEntryVBox;
	import org.ludo.layouts.PageMsgBox;
	import org.ludo.models.Group;
	import org.ludo.models.Policy;
	import org.ludo.models.PolicyHeader;
	import org.ludo.objects.DataMap;
	import org.ludo.objects.PageProperties;
	import org.ludo.objects.XmlMap;
	import org.ludo.utils.CurrentPage;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.PopUp;
	import org.ludo.utils.XMLMapper;
	import org.ludo.validators.CustomValidator;
	import org.ludo.validators.ServerErrors;
	import org.ludo.views.UnitEditGrid;
	
	import spark.components.Group;
	
	public class PageController
	{
		//propertiesdoSaveAllCoverages
		//private var ifQuote:Boolean=false;
		private var currentpageid:String="default";
		//private var pageinprocess:String="default";
		public var currentRightPageID:String="";
		public var pageToGo:String="";
		//public var nextPage:String="default";
		//public var previousPage:String="default";
		private var propsOfPageInProcess:PageProperties;
		//public var pageChanged:Boolean=false;
		public var pageClean:Boolean=false;
		public var changeDetail:Boolean=false;
		public var pageChanged:Boolean=false;
		public var updateToDb:Boolean=true;
		public var pageValidated:Boolean=true;
		public var pageExit:Boolean=true;
		public var pageLoaded:Boolean=false;
		//private var pageMsgAdded:Boolean=false;
		
		public var dataEntryBox:spark.components.Group;
		public var dataEntryRightBox:spark.components.Group;
		public var dataEntryInnerBox:DataEntryVBox;
		public var dataEntryRightInnerBox:DataEntryVBox;
		public var pageMessageBox:PageMsgBox = new PageMsgBox();
		
		
		//public var policyCoverageCtlArray:Array=[];
        //
        //Singleton stuff
        //
		private static var pagesAndPropsController:PagesAndPropertiesController=PagesAndPropertiesController.getInstance();
		private static var pagebarContainer:DataContainer = new	DataContainer();
		private static var ctlToRefshContainer:DataContainer = new	DataContainer();
		private static var paintedPageContainer:DataContainer = new	DataContainer();
		private static var pageManager:PageController;
        private var funcToCallAfterConfirm:Function;
		private var funcToCallAfterConfirmArg:Array;
        
        private static const VALIDATION_MSG:String="Please correct the validation errors highlighted on the form."  
		private static const SUCCESS_MSG:String="Page has been saved successfully."  
		private static const NOCHANGE_MSG:String="There is nothing to save in this page."  

 		//private var pagereadonly:Boolean=false;
		//private var raterependant:Boolean=false;
		private var viewonly:Boolean=true;
		//private var viewmode:String="E";
		private var currentServerErrors:ServerErrors;
		
		private var valueChangedFlagInModel:Array=[];
		//private var pageAndProperties:XML;
		private var savedUnitIndex:int=0;
		private var hasUnit:Boolean=false;

		public function initializePage():void
		{
			//ifQuote=LudoUtils.containerController.loadedContainerName=="quote";
			pagesAndPropsController.setCutrrentPageAndProperties(viewOnly);
			if(ifQuote)
			{
				changeDetail=LudoUtils.modelController.quote.changeDetail;
			}
		}
		public function get ifQuote():Boolean
		{
			return LudoUtils.containerController.loadedContainerName=="quote";
		}
		public function get viewOnly():Boolean
		{
			return viewonly;
		}
		public function set viewOnly(value:Boolean):void
		{
			viewonly=value;
			//viewmode=(value)?"V":"E";
		}
		/*
		public function get viewMode():String
        {
			return viewmode;
        }
       	public function set viewMode(value:String):void
        {
			viewmode=value;
        }
		*/
		public function ifReadOnly(pageid:String):Boolean
        {
			try
			{
				return pagesAndPropsController.getPageProperties(pageid).readOnly;
			}
			catch (e:Error)
			{
				ErrorController.logError(e,pageid,"ifReadOnly");
				throw e;
			}
			return true;
        }
		/*
		public function pageToBuild(pageid:String):void
		{
			propsOfPageInProcess=pagesAndPropsController.getPageProperties(pageid);
		}
		*/
		/*
		public function set pageViewOnly(value:Boolean):void
        {
        	if(value)
        	{
        		viewmode="V";
        	}
        	else
        	{
        		viewmode="E";
        	}
			pagereadonly=value;
        }
		*/
		/*
		public function viewControl(fieldProp:XML):Boolean
		{
			var ret:Boolean=true;
			if(fieldProp.hasOwnProperty('@viewmode'))
			{
				ret=viewByViewMode(currentPageID,fieldProp.@viewmode)
			}
			if(ret)//check by quote status
			{
				if(fieldProp.hasOwnProperty('@viewifquotein'))
				{
					ret=checkIfQuoteIn(fieldProp.@viewifquotein)
				}
			}
			return ret;
		}
		*/
		private function setNeedsRatingIfRateDependantOnChange(pageid:String):void
		{
			if(LudoUtils.containerController.loadedContainerName=="quote")
			{
				if(pagesAndPropsController.getPageProperties(pageid).rateDependant)
				{
					LudoUtils.modelController.quote.needs_rating=true;
				}
			}
		}
		public function viewPageControl(pageid:String,fieldProp:XML):Boolean
		{
			var ret:Boolean=true;
			if(fieldProp.hasOwnProperty('@permissionfor'))
			{
				ret=hasPermissionByNode(fieldProp);
			}
			if(ret)//check by view mode
			{
				if(fieldProp.hasOwnProperty('@viewmode'))
				{
					ret=viewByViewMode(pageid,fieldProp.@viewmode)
				}
			}
			if(ret)//check by quote status
			{
				if(fieldProp.hasOwnProperty('@viewifquotein'))
				{
					ret=checkIfQuoteIn(pageid,fieldProp.@viewifquotein)
				}
			}
			return ret;
		}
		public function paintPanel(pageid:String,paintIfQuoteIn:String=""):Boolean
		{
			return checkIfQuoteIn(pageid,paintIfQuoteIn);
		}
		public function viewPageIfQuoteIn(viewifquotein:String=""):Boolean
		{
			return viewIfQuoteIn(viewifquotein);
		}
		public function viewMenuIfQuoteIn(viewifquotein:String=""):Boolean
		{
			return viewIfQuoteIn(viewifquotein);
		}
		/*
		public function ifReadOnlyPanel(readOnlyIfQuoteIn:String=""):Boolean
		{
			return readOnlyIfQuoteIn(readOnlyIfQuoteIn);
		}
		*/
		public function redrawPage(pageid:String,redraw:String="false", redrawIfQuoteIn:String=""):Boolean
		{
			if(redraw=="true")
			{
				return true;
			}
			return redrawIfQuoteIn==""?false:checkIfQuoteIn(pageid,redrawIfQuoteIn);
		}
		public function requiredField(pageid:String,fieldProp:XML):Boolean
		{
			var ret:Boolean=false;
			if(String(fieldProp.@requiredflag)=="true")
			{
				return true;
			}
			if(fieldProp.hasOwnProperty('@requiredifquotein'))
			{
				ret=checkIfQuoteIn(pageid,fieldProp.@requiredifquotein)
			}
			return ret;
		}
		private function viewByViewMode(pageid:String,vmode:String=""):Boolean
		{
			if(vmode=="")
			{
				return false;
			}
			if(vmode==pagesAndPropsController.getPageProperties(pageid).processMode)
			{
				return true;
			}
			return false;
		}
		public function readOnlyIfQuoteIn(checkIfQuoteIn:String=""):Boolean
		{
			if(!ifQuote)
			{
				return false;
			}
			if(checkIfQuoteIn=="")
			{
				return false;
			}
			var qstatus:String=LudoUtils.modelController.quote.quote_status;
			if(qstatus=="E")
			{
				qstatus="Q";
			}
			for each(var mode:String in checkIfQuoteIn.split(','))
			{
				if(qstatus==mode)
				{
					return true;
				}
				else if(mode=='E')//Endorsement
				{
					if(LudoUtils.modelController.quote.quote_status=="E")
					{
						return true;
					}
				}
			}
			return false;
		}
		private function viewIfQuoteIn(checkIfQuoteIn:String=""):Boolean
		{
			if(!ifQuote)
			{
				return true;
			}
			if(checkIfQuoteIn=="")
			{
				return true;
			}
			var qstatus:String=LudoUtils.modelController.quote.quote_status;
			if(qstatus=="E")
			{
				qstatus="Q";
			}
			for each(var mode:String in checkIfQuoteIn.split(','))
			{
				if(qstatus==mode)
				{
					return true;
				}
				else if(mode=='E')//Endorsement
				{
					if(LudoUtils.modelController.quote.quote_status=="E")
					{
						return true;
					}
				}
				else if(mode=='!E')//not in endorsement
				{
					if(LudoUtils.modelController.quote.quote_status=="E")
					{
						return false;
					}
				}
			}
			return false;
		}
		private function checkIfQuoteIn(pageid:String,checkIfQuoteIn:String=""):Boolean
		{
			if(!ifQuote)
			{
				return true;
			}
			if(checkIfQuoteIn=="")
			{
				return true;
			}
			var qstatus:String=LudoUtils.modelController.quote.quote_status;
			if(qstatus=="E")
			{
				qstatus="Q";
			}
			for each(var mode:String in checkIfQuoteIn.split(','))
			{
				if(qstatus==mode)
				{
					return true;
				}
				else if(mode=='E')//Endorsement
				{
					if(LudoUtils.modelController.quote.quote_status=="E")
					{
						return true;
					}
				}
				else if(mode=='!E')//not in endorsement
				{
					if(LudoUtils.modelController.quote.quote_status!="E")
					{
						return true;
					}
				}
				else if(mode=='R')//rated
				{
					if(!this.ifReadOnly(pageid) && LudoUtils.modelController.quote.rated)
					{
						return true;
					}
				}
				else if(mode=='RQ')//rated and in quote mode
				{
					if(!this.ifReadOnly(pageid) && LudoUtils.modelController.quote.rated && qstatus=="Q")
					{
						return true;
					}
				}
				else if(mode=='RA')//rated and in application mode
				{
					if(!this.ifReadOnly(pageid) && LudoUtils.modelController.quote.rated && qstatus=="A")
					{
						return true;
					}
				}
			}
			return false;
		}
		public function hasPermissionByNode(element:XML):Boolean
		{
			if(element.hasOwnProperty('@permissionfor'))
			{
				return hasPermissionByActivities(element.@permissionfor);
			}
			return false;
		}
		public function hasPermissionByActivities(activities:String):Boolean
		{
			if(activities=="")
			{
				return true;
			}
			for each(var mode:String in activities.split(','))
			{
				if(LudoUtils.modelController.currentSession.hasPermission(mode))
				{
					return true;
				}
			}
			return false;
		}
		public function set currentPageID(value:String):void
		{
			LudoUtils.transController.currentPageIDInFlow=value;
			currentpageid=value;
		}
		public function get currentPageID():String
		{
			return currentpageid;
		}
		public function get nextPageID():String
        {
			if(pageToGo!="")
			{
				return pageToGo;
			}
			return LudoUtils.transController.nextPageIDInFlow;
			/*
			if(LudoUtils.transController.hasApplicationFlow)
			{
				//return applicationFlow.get(curPage).next as String;
				return LudoUtils.transController.pageFlow[currentPageID].next as String;
            }
            else
            {
				throw new Error("Application Flow definition is missing in Transaction.XML.");
            }
			*/
        }
		/*
        public function get pageAfterRate():String
        {
			return LudoUtils.transController.pageAfterRate;
        }
		*/
        public function get hasRightPage():Boolean
        {
			return LudoUtils.transController.hasRightPage;
        }
        public function get rightDefaultPage():String
        {
			return LudoUtils.transController.rightDefaultPage;
        }
		/*
        public function get nextRightPageID():String
        {
			if(LudoUtils.transController.hasApplicationFlow)
			{
				//return applicationFlow.get(curPage).next as String;
				return LudoUtils.transController.pageFlow[currentRightPageID].next as String;
            }
            else
            {
				throw new Error("Application Flow definition is missing in Transaction.XML.");
            }
        }
		*/
        public function get previusPageID():String
        {
			if(pageToGo!="")
			{
				return pageToGo;
			}
			return LudoUtils.transController.previousPageIDInFlow;
        }
        public function get previusRightPageID():String
        {
			if(LudoUtils.transController.hasApplicationFlow)
			{
				//return applicationFlow.get(curPage).next as String;
				return LudoUtils.transController.pageFlow[currentRightPageID].previous as String;
            }
            else
            {
				throw new Error("Application Flow definition is missing in Transaction.XML.");
            }
        }        
        public static function getInstance():PageController
        {
            if (pageManager == null)
            {
                pageManager = new PageController();
            }
            return pageManager;
        }
        public function PageController()
		{
			if (pageManager != null)
			{
                throw new Error("Only one PageManager instance may be instantiated.");
            }
        }
        public function setServerErrors(error:XML):void
        {
        	currentServerErrors=new ServerErrors(error);
        }
        public function get pageServerErrors():ServerErrors
        {
        	return currentServerErrors;
        }
        public function showActionBar():void
        {
        	(pagebarContainer.get(this.currentPageID) as ActionBar).visible=true;
        	//actionPanel.visible=true;
        }
        public function hideActionBar():void
        {
        	(pagebarContainer.get(this.currentPageID) as ActionBar).visible=false;
        	//actionPanel.visible=false;
        }
        public function set setActionBar(bar:ActionBar):void
        {
        	//actionPanel=bar;
        	pagebarContainer.put(this.currentPageID,bar);
        }
		public function set paintedPage(pageid:String):void
		{
			paintedPageContainer.put(pageid,"Y");
		}
		public function ifPainted(pageid:String):Boolean
		{
			return paintedPageContainer.contains(pageid);
		}
		public function redrawAllPages():void
		{
			paintedPageContainer.empty();
			currentRightPageID="";//reset blank to refresh right page
		}
        public function addToControlToRefreshContainer(pageid:String,ctls:Array):void
        {
        	//actionPanel=bar;
        	ctlToRefshContainer.put(pageid,ctls);
        }
		public function getFromControlToRefreshContainer(pageid:String) : Array
		{
			return ctlToRefshContainer.get(pageid);
		}
		
		/*
        public function addToControlToRIghtRefreshContainer(ctls:Array):void
        {
        	//actionPanel=bar;
        	ctlToRefshContainer.put(this.currentRightPageID,ctls);
        }
		public function getFromControlToRightRefreshContainer() : Array
		{
			return ctlToRefshContainer.get(this.currentRightPageID);
		}
		*/
	    public function resetPage():void
		{
			pageClean=false;
			pageChanged=false;
			pageExit=true;
		}
		public function resetPageID():void
		{
			currentRightPageID="";
			currentPageID=LudoUtils.transController.defaultScreen;			
		}
		public function pageContainer(pageid:String):Array
		{
			return LudoUtils.dataStore.getFromPageContainer(pageid)
		}
		/*
		public function currentRightPageContainer():Array
		{
			return LudoUtils.dataStore.getFromPageContainer(this.currentRightPageID)
		}
		*/
		public function emptyPageContainer(pageid:String):void
		{
			LudoUtils.dataStore.addToPageContainer(pageid,null);
			LudoUtils.dataStore.addToDataMapContainer(pageid,null);
			LudoUtils.dataStore.addToXmlMapContainer(pageid,null);
			LudoUtils.dataStore.addToInitFuncContainer(pageid,null);
			LudoUtils.dataStore.addToValidatorContainer(pageid,null);
			LudoUtils.dataStore.addToCoverageContainer(pageid,null);
			LudoUtils.dataStore.addToObjectMapContainer(pageid,null);
			//LudoUtils.dataStore.addToPageContainer(pageid,null);
			LudoUtils.dataStore.addToCoverageContainer(pageid,null);
			//LudoUtils.dataStore.addToPageContainer(pageid,null);
			ctlToRefshContainer.put(pageid,null);
		}		
		public function emptyRightPageContainer():void
		{
			emptyPageContainer(this.currentRightPageID)
			emptyRightEntryBox();
		}		
		public function emptyCurrentPageContainer():void
		{
			/*
			LudoUtils.dataStore.addToPageContainer(this.currentPageID,null);
			LudoUtils.dataStore.addToDataMapContainer(this.currentPageID,null);
			LudoUtils.dataStore.addToXmlMapContainer(this.currentPageID,null);
			LudoUtils.dataStore.addToInitFuncContainer(this.currentPageID,null);
			LudoUtils.dataStore.addToValidatorContainer(this.currentPageID,null);
			LudoUtils.dataStore.addToCoverageContainer(this.currentPageID,null);
			LudoUtils.dataStore.addToObjectMapContainer(this.currentPageID,null);
			//LudoUtils.dataStore.addToPageContainer(this.currentPageID,null);
			LudoUtils.dataStore.addToCoverageContainer(this.currentPageID,null);
			//LudoUtils.dataStore.addToPageContainer(this.currentPageID,null);
			ctlToRefshContainer.put(this.currentPageID,null);
			//this.dataEntryBox.removeAllChildren();
			*/
			emptyPageContainer(this.currentPageID)
			emptyEntryBox();
		}
		public function set setEntryBox(entryBox:spark.components.Group):void
		{                                                                   
         	this.dataEntryBox = entryBox;
     	}
     	public function emptyEntryBox():void
		{
			if(this.dataEntryBox!=null)
			{
				/*
				if(this.dataEntryRightInnerBox!=null)
				{
					this.dataEntryRightInnerBox.removeAllChildren();
				}
				if(this.dataEntryInnerBox!=null)
				{
					//this.dataEntryInnerBox.removeAllChildren();
				}
				*/
				//this.dataEntryBox.removeAllChildren();
				this.dataEntryBox.removeAllElements();
					//pageMsgAdded=false;
			}
		}
    	public function emptyRightEntryBox():void
		{
			if(this.dataEntryRightBox!=null)
			{
				if(this.dataEntryRightInnerBox!=null)
				{
					//this.dataEntryRightInnerBox.removeAllChildren();
				}
				this.dataEntryRightBox.removeAllElements();
				//dataEntryRightBox.removeAllChildren();
			}
		}
		public function addToRightPage(child:IVisualElement):void
		{
			//this.dataEntryRightBox.addChild(child);
			this.dataEntryRightBox.addElement(child);
		}
		public function removeFromRightPage(child:IVisualElement):void
		{
			//this.dataEntryRightBox.removeChild(child);
			this.dataEntryRightBox.removeElement(child);
		}
		public function addToCurrentPage(child:IVisualElement):void
		{
			//this.dataEntryBox.addChild(child);
			this.dataEntryBox.addElement(child);
		}
		public function removeFromCurrentPage(child:IVisualElement):void
		{
			//this.dataEntryBox.removeChild(child);
			this.dataEntryBox.removeElement(child);
		}
		/**********update function************/
		public function checkIfDataChangedInPage():Boolean
		{
			if(checkIfDataChanged(this.currentPageID))
			{
				return true;
			}
			else
			{
				return checkIfDataChanged(this.currentRightPageID)
			}
			/*
			if(checkIfDataChangedInModel()) return true;
			if(checkIfControlDataChangedInXmlMapContainer()) return true;
			//get all the unit id
			var units:Array=LudoUtils.dataStore.getFromPageContainer(this.currentPageID)[1] as Array;//
			if(units!=null)
			{
				for each(var unit:String in units)
				{
					if(checkIfDataChangedInUnitGridPanel(unit)) return true;
				}
			}
			return false;
			*/
		}
		private function checkIfCoverageValueChanged(pageid:String):Boolean
		{
			var coverageCtlArray:Array=LudoUtils.dataStore.getFromCoverageContainer(pageid);
			if(coverageCtlArray!=null && coverageCtlArray.length>0)
			{
				for each (var coverageinput:CoverageInput in coverageCtlArray)
				{
					if(coverageinput.anyValueChanged())
					{
						return true;
					}
				}
			}
			return false;
		}
		private function checkIfDataChanged(pageid:String):Boolean
		{
			if(checkIfDataChangedInModel(pageid)) return true;
			if(checkIfControlDataChangedInXmlMapContainer(pageid)) return true;
			if(checkIfCoverageValueChanged(pageid)) return true;
			var pageAarray:Array=LudoUtils.dataStore.getFromPageContainer(pageid) as Array;
			if(pageAarray!=null)
			{
				//get all the unit id
				var units:Array=pageAarray[1] as Array;//
				if(units!=null)
				{
					for each(var unit:String in units)
					{
						if(checkIfDataChangedInUnitGridPanel(pageid,unit)) return true;
					}
				}
			}
			return false;
		}
		public function checkIfDataChangedInRightPage():Boolean
		{
			return checkIfDataChanged(this.currentRightPageID);
		}

		private function resetToValueBeforeSaved(action:String="default"):void
		{
			resetModelDataFromValueBeforeSaved(this.currentPageID);
			resetModelDataFromValueBeforeSaved(this.currentRightPageID);
			resetControlInXmlMapContainerFromValueBeforeSaved(this.currentPageID);
			resetControlInXmlMapContainerFromValueBeforeSaved(this.currentRightPageID);
			resetCoverageValue(this.currentPageID);
			resetCoverageValue(this.currentRightPageID);
			resetUnitInCurrentPage(action);
			resetPage();
		}
		public function nextPage():void
		{
			this.currentPageID=this.nextPageID;//TransManager.getInstance().getNextPage(CurrentPage.ID);
			pageToGo="";//reset
			LudoUtils.formBuilder.PaintPage();
			LudoUtils.navController.leftMenu.selectItemByPageID(this.currentPageID);
		}
		public function previousPage():void
		{
			this.currentPageID=this.previusPageID;//TransManager.getInstance().getNextPage(CurrentPage.ID);
			pageToGo="";//reset
			LudoUtils.formBuilder.PaintPage();
			LudoUtils.navController.leftMenu.selectItemByPageID(this.currentPageID);
		}
		public function currentPageInFlow():void
		{
			this.currentPageID=LudoUtils.transController.currentPageIDInFlow;//TransManager.getInstance().getNextPage(CurrentPage.ID);
			pageToGo="";//reset
			LudoUtils.formBuilder.PaintPage();
			LudoUtils.navController.leftMenu.selectItemByPageID(this.currentPageID);
		}
		public function nextPageAfterRate():void
		{
			var pafterrate:String="pageafterrate";
			if(changeDetail) pafterrate="pageafterrate_e";
			this.currentPageID=LudoUtils.transController.pageidByName(pafterrate);
			//this.currentPageID=this.pageAfterRate;//TransManager.getInstance().getNextPage(CurrentPage.ID);
			LudoUtils.formBuilder.PaintPage();
			LudoUtils.navController.leftMenu.selectItemByPageID(this.currentPageID);
			
		}
		public function nextPageAfterRateInEndorsement():void
		{
			this.currentPageID=LudoUtils.transController.pageidByName("pageafterrate");
			LudoUtils.formBuilder.PaintPage();
			//LudoUtils.navController.leftMenu.selectItemByPageID(this.currentPageID);
		}
		public function nextPageAfterIssue():void
		{
			this.currentPageID=LudoUtils.transController.pageidByName("pageafterissue");
			LudoUtils.formBuilder.PaintPage();
			//LudoUtils.navController.leftMenu.selectItemByPageID(this.currentPageID);
		}
		public function redirectToPage(pageid:String):void
		{
			pageToGo=pageid;
			nextPage();
		}
		public function nextPageOnEndorsement():void
		{
			this.currentPageID=LudoUtils.transController.pageidByName("changedetailpage");
			LudoUtils.formBuilder.PaintPage();
			//LudoUtils.navController.leftMenu.selectItemByPageID(this.currentPageID);
		}
		public function saveCurrentPage(afterSave:Function=null):Boolean
		{
			if(validatePage())
			{
				savedUnitIndex=0;
				hasUnit=false;
				savePageByID(currentPageID);
				savePageByID(currentRightPageID);
				if(this.pageChanged)
				{
					if(!updateToDb)
					{
						if(afterSave!=null)
						{
							afterSave.call(this);
						}
					}
					else
					{
						Fr.crudTransactionQueue.actionAfterAllTransactions=afterSave;
						//changedetail
						if(changeDetail)
						{
							//if(afterSave!=null)
							//{
								//send to change detail page on change
								Fr.crudTransactionQueue.actionAfterAllTransactions=nextPageOnEndorsement;
							//}
							LudoUtils.modelController.quote.xmlstore.change_detail=LudoUtils.changeDetailController.allChanges;
						}
						updateQuoteToDB();
					}
				}
				else if(afterSave!=null)
				{
					afterSave.call(this);
				}
				else
				{
					showPageMessage(NOCHANGE_MSG,"nochange");
				}
				resetPage();
				return true;
			}
			else
			{
				return false;
			}
		}
		public function printPageFormItemsValue(pageid:String):String
		{
			var itemValue:String="";
			var _dataarray:Array=LudoUtils.dataStore.getFromDataMapContainer(pageid);
			if(_dataarray!=null)
			{
				if(_dataarray.length>0)
				{
					for each (var map:DataMap in _dataarray)
					{
						if(map.fieldaction=="save" || LudoUtils.isEmpty(map.fieldaction))//update model
						{
							if(map.fieldmap.indexOf(".")>0)//datamapping path seperated by '.' like quote.lob
							{
								//if data changed
								var val:String=LudoUtils.getFieldValue(map.displayObject);
								var valBeforeSave:String=LudoUtils.getFieldValueBeforeSave(map.displayObject);	
								itemValue=itemValue+"Field ID: "+map.displayObject.name+" - Value Now: "+val+" - Value Before: "+valBeforeSave+ "\n";
							}
						}
					}
				}
			}
			return itemValue;
		}
		private function savePageByID(pageid:String):void
		{
			valueChangedFlagInModel=[];
			saveModelDataFromCurrentPage(pageid);
			saveAcordXmlFromCurrentPage(pageid);
			//if any policy lavel coverage
			saveCoverages(pageid);
			//get all the unit id
			var pageAarray:Array=LudoUtils.dataStore.getFromPageContainer(pageid) as Array;
			if(pageAarray!=null)
			{
				var units:Array=pageAarray[1] as Array;//
				if(units!=null)
				{
					for each(var unit:String in units)
					{
						saveUnitGridPanel(pageid,unit);
					}
				}
			}
			if(pageChanged)
			{
				setNeedsRatingIfRateDependantOnChange(pageid);
			}
		}
		public function saveModels(model:FrModel,afterSave:Function=null):Boolean
		{
			if(validatePage())
			{
				savedUnitIndex=0;
				hasUnit=false;
				savePageByID(currentPageID);
				savePageByID(currentRightPageID);
				
				if(this.pageChanged)
				{
					saveModelsToDB(model);
				}
				else if(afterSave!=null)
				{
					afterSave.call(this);
				}
				else
				{
					showPageMessage(NOCHANGE_MSG,"nochange");
				}
				resetPage();
				return true;
			}
			else
			{
				return false;
			}
		}
/*
		public function saveModels(model:FrModel):Boolean
		{
			if(validatePage())
			{
				saveModelDataFromCurrentPage();
				saveAcordXmlFromCurrentPage();
				//get all the unit id
				var units:Array=LudoUtils.dataStore.getFromPageContainer(this.currentPageID)[1] as Array;//
				if(units!=null)
				{
					for each(var unit:String in units)
					{
						saveUnitGridPanel(unit);
					}
				}
				saveModelsToDB(model);
				return true;
			}
			else
			{
				return false;
			}
		}
*/
		public function saveCurrentPageByEventAndObject(eventName:String,objectToSave:Object,afterSave:Function=null):Boolean
		{
			if(validatePage())
			{
				savedUnitIndex=0;
				hasUnit=false;
				savePageByID(currentPageID);
				savePageByID(currentRightPageID);
				if(this.pageChanged)//save quote to db
				{
					Fr.crudTransactionQueue.actionAfterAllTransactions=afterSave;
					updatePageToDB(eventName,objectToSave);
					return true;
				}
				else if(afterSave!=null)
				{
					afterSave.call(this);
				}
				else
				{
					showPageMessage(NOCHANGE_MSG,"nochange");
				}
				resetPage();
				return true;
			}
			else
			{
				return false;
			}
		}

/*		public function saveCurrentPageByEventAndObject(eventName:String,objectToSave:Object):Boolean
		{
			if(validatePage())
			{
				saveModelDataFromCurrentPage();
				saveAcordXmlFromCurrentPage();
				//get all the unit id
				var units:Array=LudoUtils.dataStore.getFromPageContainer(this.currentPageID)[1] as Array;//
				if(units!=null)
				{
					for each(var unit:String in units)
					{
						saveUnitGridPanel(unit);
					}
				}
				updatePageToDB(eventName,objectToSave);
				return true;
			}
			else
			{
				return false;
			}
		}
	*/
		public function addElmentByID(pageid:String,id:String,obj:*):void
		{
			if(id.length>0)
			{
				LudoUtils.dataStore.getObjectMapContainer(pageid)[id]=obj;
			}
		}
		private function validatorContainer(pageid:String):Array
		{
			return LudoUtils.dataStore.getFromValidatorContainer(pageid) as Array;
		}
		public function addValidationToPage(pageid:String,fieldtovalidate:*,validationString:String,id:String=""):void
		{
			CustomValidator.addValidatorsToPage(validatorContainer(pageid),fieldtovalidate,validationString,id);
		}
		public function pageValidators(pageid:String):Array
		{
			var vContaier:Array=validatorContainer(pageid);
			if(vContaier==null)
			{
				return [];
			}
			else
			{
				var pVal:Array=vContaier[0] as Array;
				return pVal==null?[]:pVal;
			}
			//return LudoUtils.dataStore.getFromValidatorContainer(pageid)[0] as Array;
		}
		public function serverValidators(pageid:String):Array
		{
			var vContaier:Array=validatorContainer(pageid);
			if(vContaier==null)
			{
				return [];
			}
			else
			{
				var sVal:Array=vContaier[2] as Array;
				return sVal==null?[]:sVal;
			}
			//return LudoUtils.dataStore.getFromValidatorContainer(pageid)[2] as Array;
		}
		public function cancelSaveCurrentPage():void
		{
			resetToValueBeforeSaved("cancel");
			hidePageErrorMsg();
			resetAllValidators(pageValidators(currentPageID));
			resetAllValidators(serverValidators(currentPageID));
			resetAllValidators(pageValidators(currentRightPageID));
			resetAllValidators(serverValidators(currentRightPageID));
			currentServerErrors=null;
		}
		public function resetAllValidators(validatorArray:Array):void
		{
			for each (var v:Validator in validatorArray)
			{
				if(v.source!=null)
				{
					v.source.errorString="";
				}
				else if(v.listener!=null)
				{
					v.listener.errorString="";
				}
			}
			//this.currentServerErrors=null;
		}
		private static function enableAllValidators(validatorArray:Array):void
		{
			for each (var v:Validator in validatorArray)
			{
				var obj:DisplayObject=(v.source==null?v.listener:v.source) as DisplayObject;
				v.enabled=obj.visible==true?LudoUtils.enabled(obj):false;
			}
		}
		public function resetUnitInCurrentPage(resetafter:String="default"):void
		{
			resetUnitInPage(this.currentPageID,resetafter);
			resetUnitInPage(this.currentRightPageID,resetafter);
			/*
			var units:Array=LudoUtils.dataStore.getFromPageContainer(this.currentPageID)[1] as Array;//
			if(units!=null)
			{
				for each(var unit:String in units)
				{
					resetUnitGridPanel(unit,resetafter);
				}
			}
			*/
		}
 		public function resetUnitInPage(pageid:String,resetafter:String="default"):void
		{
			var pageAarray:Array=LudoUtils.dataStore.getFromPageContainer(pageid) as Array;
			if(pageAarray!=null)
			{
				var units:Array=pageAarray[1] as Array;//
				if(units!=null)
				{
					for each(var unit:String in units)
					{
						resetUnitGridPanel(pageid,unit,resetafter);
					}
				}
			}
		}
        private function resetModelDataFromValueBeforeSaved(pageid:String):void {
        	var _dataarray:Array=LudoUtils.dataStore.getFromDataMapContainer(pageid);
        	if(_dataarray!=null && _dataarray.length>0)
        	{
        		for each (var map:DataMap in _dataarray)
				{
    				if(map.fieldaction=="save" || LudoUtils.isEmpty(map.fieldaction))//update model
    				{
    					if(map.fieldmap.indexOf(".")>0)//datamapping path seperated by '.' like quote.lob
    					{
    						LudoUtils.setFieldValue(map.displayObject,LudoUtils.getFieldValueBeforeSave(map.displayObject))
    					}
    				}
        		}
         	}
        }
        private function saveModelDataFromCurrentPage(pageid:String):void {
        	var _dataarray:Array=LudoUtils.dataStore.getFromDataMapContainer(pageid);
        	if(_dataarray!=null)
        	{
	        	if(_dataarray.length>0)
	        	{
	        		for each (var map:DataMap in _dataarray)
					{
	    				if(map.fieldaction=="save" || LudoUtils.isEmpty(map.fieldaction))//update model
	    				{
	    					if(map.fieldmap.indexOf(".")>0)//datamapping path seperated by '.' like quote.lob
	    					{
	    						//if data changed
								var val:String=LudoUtils.getFieldValue(map.displayObject);
								var valBeforeSave:String=LudoUtils.getFieldValueBeforeSave(map.displayObject);
								if(val!=valBeforeSave)
	        					{
									valueChangedFlagInModel[map.displayObject]="Y";
	        						var modelArray:Array=map.fieldmap.split(".");//datamapping path seperated by '.' like quote.lob
	        						//var val:String=Common.getFieldValue(_maparray[0]);
	        						if(modelArray.length>1)
	        						{
										LudoUtils.setValueToModel(LudoUtils.modelController.collections,map.fieldmap,val,true);
		    							//LudoUtils.modelController.collections[modelArray[0]][modelArray[1]]=val;
		    							//change the value before saved to the latest value
		    							LudoUtils.setFieldValueBeforeSave(map.displayObject,val);
										addToChangeDetail(String(map.displayObject["id"]),pageid,valBeforeSave==""?"A":"M","",map.description,"model",valBeforeSave,val,map.fieldmap);
										pageChanged=true;
	        						}
	        					}
		        			}
	    				}
	        		}
	        	}
        	}
        }
		public function addToChangeDetail(controlid:String,pageid:String,action:String,unitnumber:String,description:String,type:String,valueBeforeChange:String,valueAfterChange:String,datamap:String):void
		{
			if(changeDetail)
			{
				LudoUtils.changeDetailController.addDetail(controlid,pageid,action==""?(valueBeforeChange==""?"A":"M"):action,unitnumber,description,type,valueBeforeChange,valueAfterChange,datamap);
			}			
		}
        private function checkIfDataChangedInModel(pageid:String):Boolean {
        	var _dataarray:Array=LudoUtils.dataStore.getFromDataMapContainer(pageid);
        	if(_dataarray!=null && _dataarray.length>0)
        	{
        		for each (var map:DataMap in _dataarray)
				{
    				if(map.fieldaction=="save" || LudoUtils.isEmpty(map.fieldaction))//update model
    				{
    					return LudoUtils.getFieldValue(map.displayObject)!=LudoUtils.getFieldValueBeforeSave(map.displayObject);
    				}
        		}
        	}
        	return false;
        }
 		private function resetCoverageValue(pageid:String):void
		{
			var coverageCtlArray:Array=LudoUtils.dataStore.getFromCoverageContainer(pageid);
			if(coverageCtlArray!=null && coverageCtlArray.length>0)
			{
				for each (var coverageinput:CoverageInput in coverageCtlArray)
				{
					coverageinput.resetCoverageValue()
				}
			}
		}
       private function resetControlInXmlMapContainerFromValueBeforeSaved(pageid:String):void {
        	//xmlMapArray.push([displayobject,xmlMap,xmlnode,fieldAction])
        	var _dataarray:Array=LudoUtils.dataStore.getFromXmlMapContainer(pageid);
        	if(_dataarray!=null && _dataarray.length>0)
        	{
        		for(var i:int=0;i<_dataarray.length;i++)
        		{
        			var xmlmap:XmlMap = _dataarray[i];
        			if(xmlmap!=null)
        			{
        				if(xmlmap.fieldaction=="save" || xmlmap.fieldaction=="")//update model
        				{
        					LudoUtils.setFieldValue(xmlmap.displayObject,LudoUtils.getFieldValueBeforeSave(xmlmap.displayObject));
        				}			
        			}
        		}
        	}
        }
 		private function saveCoverages(pageid:String):void
		{
			var coverageCtlArray:Array=LudoUtils.dataStore.getFromCoverageContainer(pageid);
			if(coverageCtlArray!=null && coverageCtlArray.length>0)
			{
				for each (var coverageinput:CoverageInput in coverageCtlArray)
				{
					if(coverageinput.doSaveCoverageNode())
					{
						pageChanged=true;
						LudoUtils.modelController.quote.xmlstore.changed=true;
					}
				}
			}
		}
       private function saveAcordXmlFromCurrentPage(pageid:String):void {
        	//xmlMapArray.push([displayobject,xmlMap,xmlnode,fieldAction])
        	var _dataarray:Array=LudoUtils.dataStore.getFromXmlMapContainer(pageid);
        	if(_dataarray!=null)
        	{
	        	if(_dataarray.length>0)
	        	{
	        		for(var i:int=0;i<_dataarray.length;i++)
	        		{
	        			var xmlmap:XmlMap = _dataarray[i];
	        			if(xmlmap!=null)
	        			{
	        				if(xmlmap.fieldaction=="save" || xmlmap.fieldaction=="")//update model
	        				{
	         					//if data changed
	        					var val:String=LudoUtils.getFieldValue(xmlmap.displayObject);
								var valBeforeSave:String="";
								if(valueChangedFlagInModel[xmlmap.displayObject]!="Y")
								{
									valBeforeSave=LudoUtils.getFieldValueBeforeSave(xmlmap.displayObject);
								}
								if(val==valBeforeSave)
								{
									//try fromxmlnode
									valBeforeSave=LudoUtils.getNodeValue(xmlmap.node);
								}	
								if(val!=valBeforeSave)
	        					{
	        						//var val:String = Common.getFieldValue(xmlmap[0]);
			        				if(xmlmap.node==null)
		        					{
		        						//create empty node
		        						xmlmap.node=LudoUtils.modelController.xmlMapper.createXmlNodeByPathAtRoot(xmlmap.fieldmap,xmlmap.findByChildTag);
		        					}
	        						if(xmlmap.node is XML)
	        						{
	        							LudoUtils.setFieldValueToNode(xmlmap.node,val);
	        							//change the value before saved to the latest value
	        							LudoUtils.setFieldValueBeforeSave(xmlmap.displayObject,val);
	        							pageChanged=true;
										LudoUtils.modelController.quote.xmlstore.changed=true;
										addToChangeDetail(String(xmlmap.displayObject["id"]),pageid,"","",xmlmap.description,"xml",valBeforeSave,val,xmlmap.fieldmap);
	        						}
	        					}
	        				}			
	        			}
	        		}
	        	}
        	}
        }
 
         private function checkIfControlDataChangedInXmlMapContainer(pageid:String):Boolean {
        	//xmlMapArray.push([displayobject,xmlMap,xmlnode,fieldAction])
        	var _dataarray:Array=LudoUtils.dataStore.getFromXmlMapContainer(pageid);
        	if(_dataarray!=null && _dataarray.length>0)
        	{
        		for(var i:int=0;i<_dataarray.length;i++)
        		{
        			var xmlmap:XmlMap = _dataarray[i];
        			if(xmlmap!=null)
        			{
        				if(xmlmap.fieldaction=="save" || xmlmap.fieldaction=="")//update model
        				{
        					if(LudoUtils.getFieldValue(xmlmap.displayObject)!=LudoUtils.getFieldValueBeforeSave(xmlmap.displayObject))
        					{
        						return true;
        					}
        				}			
        			}
        		}
        	}
        	return false;
        }

        private function saveUnitGridPanel(pageid:String,unitid:String):void {
        	if(unitid!="")
        	{
        		var _unitaray:Array=LudoUtils.dataStore.getFromUnitXmlMapContainer(pageid+"_"+unitid);
        		if(_unitaray!=null)
        		{
        			var unitPanel:UnitEditGrid=_unitaray[0] as UnitEditGrid;
        			if(unitPanel!=null && unitPanel.saveunit)
        			{
        				if(unitPanel.currentFieldMapping!=null)
        				{
        					var nodetosave:XML=unitPanel.getNodeToSave();
        					for(var i:int=0;i<unitPanel.currentFieldMapping.length;i++)
			        		{
			        			var xmlmap:Array = unitPanel.currentFieldMapping[i];
			        			if(xmlmap.length>1)
			        			{
			        				//xmlMapArray.push([displayobject,xmlMap,fieldAction])
			        				var unitMapArray:XmlMap=xmlmap[0];
			        				if(unitMapArray!=null)
			        				{
				        				if(unitMapArray.fieldaction=="save" || unitMapArray.fieldaction=="")//update unit
				        				{
				        					var val:String=LudoUtils.getFieldValue(unitMapArray.displayObject);
											var valBeforeSave:String=LudoUtils.getFieldValueBeforeSave(unitMapArray.displayObject);
											/*
											if(unitMapArray.fieldtype=='hidden')
											{
												val=unitMapArray.defaultvalue;//default for hidden if not set
												valBeforeSave="";
											}
											*/
											if(val==valBeforeSave)
											{
												//try fromxmlnode
												valBeforeSave=LudoUtils.getNodeValue(xmlmap[1]);
											}	
					        				if(val!=valBeforeSave)
				        					{
				        						if(xmlmap[1]==null)
					        					{
					        						xmlmap[1]=XMLMapper.createXmlNodeByPath(nodetosave,unitMapArray.fieldmap,unitMapArray.findByChildTag);
					        					}
												if(xmlmap[1] is XML)
					        					{
									        		LudoUtils.setFieldValueToNode(xmlmap[1],val);
				        							//change the value before saved to the latest value
				        							LudoUtils.setFieldValueBeforeSave(unitMapArray.displayObject,val);
				        							pageChanged=true;
													LudoUtils.modelController.quote.xmlstore.changed=true;
													addToChangeDetail(String(unitMapArray.displayObject["id"]),pageid,"",unitPanel.currentIdetifier,unitMapArray.description,"unit",valBeforeSave,val,unitPanel.unitMap+unitMapArray.fieldmap);
					        					}				        					
				        					}
				        				}
				        			}
	        					}
			        		}
			        		//save coverage info
			        		if(unitPanel.doSaveAllCoverages())
			        		{
			        			pageChanged=true;
								LudoUtils.modelController.quote.xmlstore.changed=true;
			        		}
							if(pageChanged)
							{
								savedUnitIndex=unitPanel.currentIndex;
							}
							hasUnit=true;
			        		unitPanel.resetUnit();
		        		}
		        	}
        		}
        	}
        } 
        
        private function resetUnitGridPanel(pageid:String,unitid:String,resetafter:String="default"):void {
        	if(unitid!="")
        	{
        		var _unitaray:Array=LudoUtils.dataStore.getFromUnitXmlMapContainer(pageid+"_"+unitid);
        		if(_unitaray!=null)
        		{
        			var unitPanel:UnitEditGrid=_unitaray[0] as UnitEditGrid;
        			if(unitPanel!=null)
        			{
		        		unitPanel.resetUnit(resetafter);
		        	}
        		}
        	}
        } 
        private function checkIfDataChangedInUnitGridPanel(pageid:String,unitid:String):Boolean {
        	if(unitid!="")
        	{
        		var _unitaray:Array=LudoUtils.dataStore.getFromUnitXmlMapContainer(pageid+"_"+unitid);
        		if(_unitaray!=null)
        		{
        			var unitPanel:UnitEditGrid=_unitaray[0] as UnitEditGrid;
        			if(unitPanel!=null)
        			{
        				if(unitPanel.currentFieldMapping!=null)
        				{
        					//var nodetosave:XML=unitPanel.getNodeToSave();
        					for(var i:int=0;i<unitPanel.currentFieldMapping.length;i++)
			        		{
			        			var xmlmap:Array = unitPanel.currentFieldMapping[i];
			        			if(xmlmap.length>1)
			        			{
			        				var unitMapArray:XmlMap=xmlmap[0];
			        				if(unitMapArray!=null)
			        				{
				        				if(unitMapArray.fieldaction=="save" || unitMapArray.fieldaction=="")//update unit
				        				{
				        					if(LudoUtils.getFieldValue(unitMapArray.displayObject)!=LudoUtils.getFieldValueBeforeSave(unitMapArray.displayObject))
				        					{
				        						return true;
				        					}
				        				}
				        			}
	        					}
			        		}
		        		}
		        		//check if coverage value changed
		        		return unitPanel.checkIfCoverageValueChanged();
	        		}
        		}
        	}
        	return false;
        } 

		/************end update functions*******************/		
		/***********unid grid function*/
 
        public function populateUnitGridPanel(pageid:String,unitid:String,unitnode:XMLList):void {
        	if(unitnode!=null)
        	{
        		var _unitaray:Array=LudoUtils.dataStore.getFromUnitXmlMapContainer(pageid+"_"+unitid);
        		if(_unitaray!=null)
        		{
        			var unitPanel:UnitEditGrid=_unitaray[0] as UnitEditGrid;
        			if(unitPanel!=null)
        			{
        				unitPanel.populateEditPanel();
	        		}
        		}
        	}
        } 

        public function confirmIfChanged(funcToCallAfterConfirm:Function,arg:Array=null):Boolean 
        {
			this.funcToCallAfterConfirm=funcToCallAfterConfirm;
			this.funcToCallAfterConfirmArg=arg;
     		if(checkIfDataChangedInPage())
     		{
     			MessageController.confirmYesNo("There are unsaved changes on this page.\n\nLeave Anyway?","Confirmation",confirmIfChangedResponse);
     			return true;
     		}
     		else
     		{
     			resetToValueBeforeSaved();
     			return false;
     		}
     	}
      	private function confirmIfChangedResponse(event:CloseEvent):void {
			if (event.detail == Alert.YES)
			{
				resetToValueBeforeSaved();
			}
			if(funcToCallAfterConfirmArg!=null)
			{
				funcToCallAfterConfirm.call(this,event,funcToCallAfterConfirmArg);
			}
			else
			{
				funcToCallAfterConfirm.call(this,event);
			}
		}
     	public function confirmSave():void {

     		if(checkIfDataChangedInPage())
     		{
     			MessageController.confirmYesNo("Do you want to save the current page information?","Confirmation",confirmSaveResponse);
     		}
     		else
     		{
     			resetToValueBeforeSaved();
     		}
     	}
        
     	private function confirmSaveResponse(event:CloseEvent):void {
			if (event.detail == Alert.YES)
			{
				saveCurrentPage();
			}
			else
			{
				resetToValueBeforeSaved();
			}
		}
		public function deleteUnitFromGrid(pageid:String,unitid:String):void {
     		var _unitaray:Array=LudoUtils.dataStore.getFromUnitXmlMapContainer(pageid+"_"+unitid);
    		if(_unitaray!=null)
    		{
    			var unitPanel:UnitEditGrid=_unitaray[0] as UnitEditGrid;
    			if(unitPanel!=null)
    			{
    				unitPanel.deleteUnit();
				}
    		}
        } 
		/***********end unid grid function*/
		public function clearPage():void
		{
			//empty all quote related containers
			LudoUtils.dataStore.emptyPageContainer();
			LudoUtils.dataStore.emptyXmlMapContainer();
			LudoUtils.dataStore.emptyDataMapContainer();
			LudoUtils.dataStore.emptyUnitXmlMapContainer();
			LudoUtils.dataStore.emptyValidatorContainer();
			LudoUtils.dataStore.emptyInitFuncContainer();
			LudoUtils.dataStore.emptyObjectMapContainer();
			LudoUtils.dataStore.emptyCoverageContainer();
			ctlToRefshContainer.empty();
			pagebarContainer.empty();
			emptyEntryBox();
			emptyRightEntryBox();
			changeDetail=false;
		}
		public function updateQuoteToDB(unitindex:int=0,unitdelete:Boolean=false):void
		{
			if(this.pageChanged)//save quote to db
			{
				updateTransMenuXML();
				if(!updateToDb) return;
				LudoUtils.modelController.quote.changed=true;
				if(unitdelete)
				{
					LudoUtils.modelController.quote.savePageUpdatedInfo(currentPageID,true,unitindex,unitdelete);
				}
				else
				{
					LudoUtils.modelController.quote.savePageUpdatedInfo(currentPageID,hasUnit,savedUnitIndex);
				}
				LudoUtils.modelController.quote.update();				
				//CairngormUtils.dispatchEvent(EventNames.UPDATE_QUOTE ,[modelController.quote,true]);
				//CairngormUtils.dispatchEvent(EventNames.UPDATE_QUOTE ,[modelController.quote,modelController.xmlstore,true]);
			}
			else
			{
				showPageMessage(NOCHANGE_MSG,"nochange");
			}
		}
		public function updatePolicyToDB(policy:Policy,action:String="create"):void
		{
			if(this.pageChanged)//save policy to db
			{
				updateTransMenuXML();
				if(!updateToDb) return;
				LudoUtils.modelController.quote.changed=true;
				LudoUtils.modelController.quote.savePageUpdatedInfo(currentPageID,hasUnit,savedUnitIndex);
				action=="create"?policy.create():policy.update();				
			}
			else
			{
				showPageMessage(NOCHANGE_MSG,"nochange");
			}
		}
		public function updatePolicyHeaderToDB(policyHeader:PolicyHeader,action:String="create"):void
		{
			if(this.pageChanged)//save policy to db
			{
				updateTransMenuXML();
				if(!updateToDb) return;
				LudoUtils.modelController.quote.changed=true;
				LudoUtils.modelController.quote.savePageUpdatedInfo(currentPageID,hasUnit,savedUnitIndex);
				action=="create"?policyHeader.create():policyHeader.update();				
			}
			else
			{
				showPageMessage(NOCHANGE_MSG,"nochange");
			}
		}
		public function updateTransMenuXML():void
		{
			if(LudoUtils.containerController.leftNavContainer.transMenu)
			{
				LudoUtils.navController.leftMenu.enableItemByPageID(currentPageID);
				LudoUtils.navController.leftMenu.enableItemByPageID(CurrentPage.nextID);
				//update menu xml
				LudoUtils.modelController.quote.xmlstore.menu_xml=LudoUtils.navController.leftMenu.menuXML;
			}
		}
		public function updatePageToDB(eventName:String,objectToSave:Object):void
		{
			if(this.pageChanged)//save quote to db
			{
				//enable next page menu
				//navMgr.enableTransLeftManuItem(LudoUtils.transController.getNextPage(this.currentPageID));
				//update current page menu
				//navMgr.updateTransLeftMenuXml();
				updateTransMenuXML();			
				if(!updateToDb) return;
				FrUtils.cairngormDispatchEvent(eventName,objectToSave);
			}
			else
			{
				showPageMessage(NOCHANGE_MSG,"nochange");
			}
			//resetPage();
		}
		public function saveModelsToDB(model:FrModel):void
		{
			if(this.pageChanged)//save quote to db
			{
				//enable next page menu
				//navMgr.enableTransLeftManuItem(LudoUtils.transController.getNextPage(this.currentPageID));
				//update current page menu
				updateTransMenuXML();
				if(!updateToDb) return;
				//navMgr.updateTransLeftManuXml();
				model.changed=true;
				if(model.id==0)
				{
					model.create();
				}
				else
				{
					model.update();
				}
			}
			else
			{
				showPageMessage(NOCHANGE_MSG,"nochange");
			}
			resetPage();
		}
		/*
		public function loadPage():void
		{
			//load quote if quoteBox in initiated
			
			if(LudoUtils.navController.pageHolder!=null)
			{
				LudoUtils.navController.pageHolder.loadPage();
				pageLoaded=true;
			}
		}
		*/
		private function validatePage():Boolean {
			hidePageErrorMsg();
			//var vArray:Array=pageValidators;
			var vArray:Array=XArrayUtil.concat(pageValidators(currentPageID),pageValidators(currentRightPageID));
			//enable if visible
			enableAllValidators(vArray);
			var results:Array = Validator.validateAll(vArray);
			var msg:String="";
			if (results.length >0)
			{
				for each (var err:* in results) 
				{
					var errField:String = FormItem(err.currentTarget.source.parent).label
					msg=msg+errField + ": " + err.message+"\n";
				}
				showValidationMsg(msg);
				return false;
			}
			else
			{
				return true;
			}
		}
		public function validateServerError(error:XML):Boolean
		{
			setServerErrors(error);
			hidePageErrorMsg();
			var vArray:Array=XArrayUtil.concat(serverValidators(currentPageID),serverValidators(currentRightPageID));
			//var vArray:Array=serverValidators;
			//enable if visible
			enableAllValidators(vArray);
			var msg:String="";
			var results:Array = Validator.validateAll(vArray);
			currentServerErrors=null;
			if (results.length >0) {
				for each (var err:* in results) 
				{
					var errField:String = FormItem(err.currentTarget.source.parent).label
					msg=msg+errField + ": " + err.message+"\n";
				}
				showValidationMsg(msg);
				return false;
			}
			else
			{
				return true;
			}
		}
		public function showPageMessage(message:String,type:String):void
		{
			if(dataEntryBox!=null)
			{
				pageMessageBox.setMessage(message,type);
				if(this.dataEntryInnerBox!=null)
				{
					dataEntryInnerBox.addElementAt(pageMessageBox,1);
				}
				//pageMsgAdded=true;
			}
			else
			{
				MessageController.popUpMessage(type,message);
			}
		}
		public function showValidationMsg(msg:String):void
		{
			showPageMessage(VALIDATION_MSG,"validation");
			//MessageController.popUpMessage("Validation Error",msg,350,300);
		}
		public function showSuccessMsg():void
		{
			showPageMessage(SUCCESS_MSG,"success");
		}
		public function showPageErrorMsg(message:String):void
		{
			showPageMessage(message,"error");
		}
		public function hidePageErrorMsg():void
		{
			if(this.dataEntryInnerBox!=null)
			{
				if(dataEntryInnerBox.contains(pageMessageBox))
				{
					dataEntryInnerBox.removeElement(pageMessageBox);
				}
			}
		}
	}
}