package org.ludo.controllers
{
	import org.ludo.utils.CurrentPage;
	import org.ludo.utils.LudoUtils;

	public class TransController
	{
        private static var transManager:TransController;
        private var sid:String="screen";
		private var rsid:String="rightscreen";
		private static var applicationFlow:Array;
		//private static var previous:DataContainer;
		private var transInfo:XML;
		private var currentpaageidinflow:String="default";
		private var curTrans:String="";
		public var hasApplicationFlow:Boolean=false;;
       	public var hasRightPage:Boolean=false;;
       	public var rightDefaultPage:String="rightdefault";
		public var transactionChanged:Boolean=true;
		public static function getInstance():TransController
        {
            if (transManager == null)
            {
                transManager = new TransController();
                //applicationFlow = new DataContainer();
                //previous = new DataContainer();                
            }
            return transManager;
        }
        public function TransController()
		{
			if (transManager != null)
			{
                throw new Error("Only one TransManager instance may be instantiated.");
            }
        }
        public function get screenid():String
        {
        	return sid;
        }
		private function get ifQuote():Boolean
		{
			return LudoUtils.containerController.loadedContainerName=="quote";
		}
        public function get rightScreenid():String
        {
        	return rsid;
        }
        public function get currentTransaction():String
        {
        	return curTrans;
        }
        public function get pageFlow():Array
        {
        	return applicationFlow;
        }
		public function get nextPageIDInFlow():String
		{
			if(hasApplicationFlow)
			{
				return applicationFlow[currentpaageidinflow].next as String;
			}
			else
			{
				throw new Error("Application Flow definition is missing in Transaction.XML.");
			}
		}
		public function get previousPageIDInFlow():String
		{
			if(hasApplicationFlow)
			{
				return applicationFlow[currentpaageidinflow].previous as String;
			}
			else
			{
				throw new Error("Application Flow definition is missing in Transaction.XML.");
			}
		}
		public function set currentPageIDInFlow(value:String):void
		{
			if(hasInPageFlow(value))
			{
				currentpaageidinflow=value;
			}
		}
		public function get currentPageIDInFlow():String
		{
			return currentpaageidinflow;
		}
		public function get hasTransaction():Boolean
		{
			return transInfo!=null?true:false;
		}
        public function hasInPageFlow(pageid:String):Boolean
        {
			if(hasApplicationFlow)
			{
        		return applicationFlow[pageid]!=null;
			}
			else
			{
				return false;
			}
        }
       public function set setCurrentTransaction(transName:String):void
        {
			if(curTrans==transName && transInfo!=null)
			{
			   transactionChanged=false;
			   return
			}
		   	transactionChanged=true;
        	curTrans=transName;
        	hasApplicationFlow=true;
        	applicationFlow=[];
        	transInfo=XML(LudoUtils.dataStore.getFromXmlContainer("transactions").transaction.(@name == transName));
        	if(transInfo!=null)
        	{
				var appflow:String="";
				if(transInfo.hasOwnProperty("applicationflow"))
				{
					appflow="applicationflow";
				}
				if(ifQuote && LudoUtils.modelController.quote.quote_status=="E")//endorsement
				{
					if(transInfo.hasOwnProperty("applicationflow_e"))
					{
						appflow="applicationflow_e";
					}
				}
				if(appflow!="")
        		{
	        		//var appFlow:Array=transInfo.applicationflow.split(",");
					var appFlow:Array=transInfo[appflow].split(",");
					if(appFlow.length>0)
	        		{
	        			hasApplicationFlow=true;
	        		}
	        		for(var i:int=0;i<appFlow.length;i++)
	        		{
	        			var obj:Object = new Object();
	        			if(i==0)
	        			{
	        				obj.previous=appFlow[appFlow.length-1];
	        			}
	        			else
	        			{
	        				obj.previous=appFlow[i-1];
	        			}
	        			obj.current=appFlow[i];
	         			if(i==appFlow.length-1)
	        			{
	        				obj.next=appFlow[0];
	        			}
	        			else
	        			{
	        				obj.next=appFlow[i+1];
	        			}       		
	        			//applicationFlow.put(appFlow[i],obj);
	        			applicationFlow[appFlow[i]]=obj;       		
	        		}
        		}
        		if(transInfo.hasOwnProperty("screenid"))
        		{
        			sid=transInfo.screenid;
        		}
        		else
        		{
        			sid="screen";
        		}
        		if(transInfo.hasOwnProperty("rightscreenid"))
        		{
        			rsid=transInfo.rightscreenid;
        		}
        		else
        		{
        			rsid="rightscreen";
        		}
        		if(transInfo.hasOwnProperty("rightpage"))
        		{
        			if(transInfo["rightpage"].toString()=="true")
        			{
        				hasRightPage=true;
        				rightDefaultPage=String(transInfo.rightpage.@default);
        				
        			}
        			else
        			{
        				hasRightPage=true;
        				rightDefaultPage="rightdefault";
        		
        			}
        		}
        		else
        		{
        			hasRightPage=false;
        			rightDefaultPage="rightdefault";
        		}
        	}
        }
        public function get defaultTopMenuIndex():int
        {
        	if(transInfo.hasOwnProperty("defaulttopmenuindex"))
			{
				return transInfo["defaulttopmenuindex"].toString();
			}
			else
			{
				return 0;
			}
        }        
        public function get defaultLeftMenuIndex():int
        {
        	if(transInfo.hasOwnProperty("defaultleftmenuindex"))
			{
				return transInfo["defaultleftmenuindex"].toString();
			}
			else
			{
				return 0;
			}
       }
       public function get defaultactivitymenuindex():int
        {
        	if(transInfo.hasOwnProperty("defaultactivitymenuindex"))
			{
				return transInfo["defaultactivitymenuindex"].toString();
			}
			else
			{
				return 0;
			}
       }
       public function get container():String
        {
        	if(transInfo.hasOwnProperty("container"))
			{
				return transInfo["container"].toString();
			}
			else
			{
				return "pageholder";
			}
       }
        public function get activityMenuID():String
        {
        	if(transInfo.hasOwnProperty("activitymenuid"))
			{
				return transInfo["activitymenuid"].toString();
			}
			else
			{
				return "";
			}
       }
         public function get fieldsetid():String
        {
        	if(transInfo.hasOwnProperty("fieldsetid"))
			{
				return transInfo["fieldsetid"].toString();
			}
			else
			{
				return "fieldsets";
			}
       }
       public function get defaultScreen():String
       {
        	if(transInfo.hasOwnProperty("defaultscreen"))
			{
				return transInfo["defaultscreen"].toString();
			}
			else
			{
				return "default";
			}
       }
       public function get pageAfterRate():String
       {
        	if(transInfo.hasOwnProperty("pageafterrate"))
			{
				return transInfo["pageafterrate"].toString();
			}
			else
			{
				return CurrentPage.nextID;
			}
       }       
	   public function pageidByName(which:String):String
	   {
		   if(transInfo.hasOwnProperty(which))
		   {
			   return transInfo[which].toString();
		   }
		   else
		   {
			   return CurrentPage.nextID;
		   }
	   }       
	   /*
       public function getNextPage(curPage:String):String
        {
			if(applicationFlow != null)
			{
				//return applicationFlow.get(curPage).next as String;
				return applicationFlow[curPage].next as String;
            }
            else
            {
				throw new Error("Application Flow definition is missing in Transaction.XML.");
            }
        }
        public function getPreviousPage(curPage:String):String
        {
			if (applicationFlow != null)
			{
			    //return applicationFlow.get(curPage).previous as String;
			    return applicationFlow[curPage].previous as String;
            }
            else
            {
				throw new Error("Application Flow definition is missing in Transaction.XML.");
            }
        }
        */
        /*
        public function get getCurrentTransaction():XML
        {
        	return transInfo;
        }
        */
        public function getProperty(prop:String):*
        {
        	return transInfo[prop.toLowerCase()];
        }
  	}
}