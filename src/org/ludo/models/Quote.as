package org.ludo.models
{
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	
	import org.frest.Fr;
	import org.frest.collections.FrModelCollection;
	import org.ludo.objects.RiskPage;
	import org.ludo.utils.LudoUtils;

	[Resource(name="quotes")]
  	[Bindable]
  	public class Quote extends BaseModel
	{
		public var lob : String;
		public var policy_term:int=0;
		public var transaction_name:String;
		public var quote_type:String="NB";
		public var quote_status:String="Q";
		public var quoted_premium:Number=0.00;
		public var prorated_premium:Number=0.00;
		public var offset_premium:Number=0.00;
		public var quote_number:String="";
		public var payment_plan : String;
		public var down_payment_type : String;
		public var bill_type : String;
		public var min_down:Number=0.00;
		public var installment:Number=0.00;
		public var total_charge:Number=0.00;
		public var agency_fee:Number=0.00;
		public var policy_fee:Number=0.00;
		public var misc_fee:Number=0.00;
		public var misc_fee_reason : String;
		public var policy_id : int;
		//public var payment_plan:String;
		[Boolean]
		public var rated:Boolean;
		[Boolean]
		public var canbe_issued:Boolean;
		[Boolean]
		public var needs_rating:Boolean;
		[DateTime]
		[Ignored]
		public var updated_at:String=null;
		[DateTime]
		public var quote_effective_date : String;
		[DateTime]
		public var last_rated_at : String;
		[DateTime]
		public var policy_effective_date : String;
		[DateTime]
		public var policy_expiration_date : String;
		//[Ignored]
		[HasOne]
		//public var xmlstore:Xmlstore=new Xmlstore();
		public var xmlstore:Xmlstore;//=new Xmlstore();
		[Ignored]
		[BelongsTo]
		public var policy:Policy;
		//[HasOne]
		//public var payment:Payment;//=new Payment();
		[Ignored]
		public var changeDetail:Boolean=false;
/*		[Ignored]
		public var use_mode:String="V";*/
		[Ignored]
		public var risk_message:String="";
		[Ignored]
		public var risk_list:XMLList;
		[Ignored]
		public var change_list:XMLList;
		[Ignored]
		public function get currentActivity():String
		{
			if(quote_status=="E")
			{
				return "Endorsement";
			}
			else if(quote_status=="B")
			{
				return "Policy";
			}
			else if(quote_status=="R")
			{
				return "Renewal";
			}
			else
			{
				return "Quote";
			}
		}
		[Ignored]
		public function refreshRiskMessage():void
		{
			var rList:XML=<RiskPages/>;
			for each(var rObj:RiskPage in arrayRiskPages)
			{
				rList.appendChild(rObj.xmlNode.copy());
			}
			risk_list=rList.children();
			risk_message=rList.toXMLString();
			//risk_list=Fr.serializer.objectToXML(arrayRiskPages).children();
		}
		[Ignored]
		private var arrayRiskPages:Array=[];
		
		[Ignored]
		private var _requiredFieldsToBindEntered:Boolean=true;

		[HasMany]
		public var pageUpdatedInfo:FrModelCollection;//=new FrModelCollection();
		
		public function Quote(label:String="id")
		{
			doUnmarshall=false;
			super(label);
		}
		[Ignored]
		private function checkRequiredFiledsToBindEntered():void
		{
			arrayRiskPages=[];
			var reqToBindPages:XMLList=LudoUtils.pagesAndPropsController.getPagesByAttribute("requiredtobind","Y");
			for each( var xml:XML in reqToBindPages)
			{
				var hasInUI:Boolean=false;
				var reqPID:String=xml.@id.toString();
				for each (var model:PageUpdatedInfo in pageUpdatedInfo)
				{
					if(model.pageid==reqPID)
					{
						hasInUI=true;
						if(!model.required_fields_entered)
						{
							_requiredFieldsToBindEntered=false;
							var riskPage:RiskPage=new RiskPage();
							riskPage.pageid=reqPID;
							riskPage.description=xml.@description.toString()
							riskPage.unitnumner=String(model.unit_seq);
							riskPage.risk="Missing Information";
							arrayRiskPages.push(riskPage);
						}
					//	break;
					}
				}
				if(!hasInUI)
				{
					_requiredFieldsToBindEntered=false;
					var riskPage2:RiskPage=new RiskPage();
					riskPage2.pageid=reqPID;
					riskPage2.description=xml.@description.toString()
					riskPage2.risk="Missing Information";
					arrayRiskPages.push(riskPage2);
				}
			}
			refreshRiskMessage();
		}
		[Ignored]
		public function get requiredFiledsToBindEntered():Boolean
		{
			checkRequiredFiledsToBindEntered();
			return _requiredFieldsToBindEntered;
		}
		[Ignored]
		public function getUnitNumOfRequiredFiledsToBindEntered(pageid:String):Array
		{
			var idx:Array=[];
			for each(var rObj:RiskPage in arrayRiskPages)
			{
				if(rObj.pageid==pageid)
				{
					idx.push(rObj.unitnumner);
				}
			}
			return idx;
		}
		[Ignored]
		public function savePageUpdatedInfo(pageid:String,isunit:Boolean=false,unitindex:int=0,unitdelete:Boolean=false):void
		{
			var pageupdatedinfo:PageUpdatedInfo;
			if(isunit)
			{
				unitindex=unitindex+1;
			}
			for each (var model:PageUpdatedInfo in pageUpdatedInfo)
			{
				if(model.pageid==pageid && (model.unit_seq==unitindex || LudoUtils.isEmpty(String(model.unit_seq))))
				{
					pageupdatedinfo=model;
					break;
				}
			}
			if(pageupdatedinfo == null)
			{
				pageupdatedinfo = new PageUpdatedInfo("new");
				pageupdatedinfo.pageid=pageid;
				pageupdatedinfo.quote_id=this.id;
				pageUpdatedInfo.addModel(pageupdatedinfo);
			}
			//check for required prop
			if(LudoUtils.pagesAndPropsController.getPageProperties(pageid).requiredToBind && this.quote_status=="A")
			{
				pageupdatedinfo.required_fields_entered=true;
			}
			//pageupdatedinfo.required_fields_entered=true;
			pageupdatedinfo.changed=true;
			pageupdatedinfo.toBeDeleted=unitdelete;
			pageupdatedinfo.unit_seq=unitindex;
			pageupdatedinfo.belongsTo=this;
			pageupdatedinfo.changed=true;
			if(this.quote_status=="A")
			{
				checkRequiredFiledsToBindEntered();
			}
			if(this.quote_status=="E")//endorsement
			{
				changeDetail2();//LudoUtils.changeDetailController.allChanges.children();
			}
		}
		[Ignored]
		protected override function onFailure(event:Object):void
		{
			super.onFailure(event);
		}
		[Ignored]
		private function changeDetail2():void
		{
			//var asort:Sort=new Sort();
			//var field : SortField = new SortField("page_description",true,false,false);
			//asort.fields=[field];
			change_list=LudoUtils.changeDetailController.allChanges.children();
			//change_list.sort=asort;
			//change_list.refresh();
		}
		[Ignored]
		protected override function onSuccess(event:Object):void
		{
			doUnmarshall=false;
			showMessage=false;
			super.onSuccess(event);
			if(!error && !validationerror)
			{
				if(currentAction=='update')
				{
				}
				else
				{
					//unmarshal quote
					Fr.serializer.unmarshall(XML(event.result),this);
					LudoUtils.pageController.clearPage();
					//LudoUtils.dataStore.setSession("lob",this.lob);
					LudoUtils.modelController.currentSession.setSession("lob",this.lob);
					if(xmlstore!=null) xmlstore.belongsTo=this;
					if(currentAction=='create' || currentAction=='show'|| currentAction=='edit'|| currentAction=='clone'|| currentAction=='endorse')
					{
						LudoUtils.changeDetailController.resetChanges();
						if(currentAction=='show'|| currentAction=='clone'|| currentAction=='edit'|| currentAction=='endorse')
						{
							//may be a policy
							if(this.policy!=null)
							{
								LudoUtils.modelController.policyHeader=this.policy.policyHeader;
							}
							/*
							if(currentAction=="endorse")
							{
								this.offset_premium=this.quoted_premium;//keep current term amount for pro rata calculation
							}
							*/
							if(currentAction=="endorse" || quote_status=="E")
							{
								changeDetail=true;
								LudoUtils.changeDetailController.allChanges=this.xmlstore.change_detail;
							}
							if(quote_status=="E")
							{
								changeDetail2();
								//change_list=change_list;//LudoUtils.changeDetailController.allChanges.children();
							}
						}
						LudoUtils.containerController.loadContainer("quote",true);
					}
				}
			}
		}
		[Ignored]
		public function transaction(transactionName:String,lob:String):void
		{
			this.transaction_name=transactionName;
			this.lob=lob;
			setTerm();
		}
		[Ignored]
		public function bind():void
		{
			this.quote_status="B";
		}
		[Ignored]
		private function setTerm():void
		{
			if(!LudoUtils.isEmpty(transaction_name))
			{
				this.policy_term=XML(LudoUtils.dataStore.getFromXmlContainer("transactions").transaction.(@name == this.transaction_name)).policyterm;
			}
		}
	}
}