package org.ludo.models
{
	import mx.collections.ArrayCollection;
	import mx.events.ItemClickEvent;
	import mx.managers.CursorManager;
	import mx.utils.ObjectUtil;
	
	import org.ludo.controllers.ErrorController;
	
	[Resource(name="search")]
  	[Bindable]
	public class Search extends BaseModel
	{
		public var query : String;
		public var countquery : String;
		[Ignored]
		public var currentpage :int=1;
		[Ignored]
		public var rowlimit :int=10;
		[Ignored]
		public var rowcount :int=0;
		//public var offset :int=0;
		[Ignored]
		public var results : XML;
		[Ignored]
		public var rows : XMLList;
		[Ignored]
		private var navsize : int=5;
		[Ignored]
		private var navinit : int=1;
		[Ignored]
		public var pageinfo:String="";
		[Ignored]
		public var totalinfo:String="";
		[Ignored]
		public var keepNavigation:Boolean=true;
		
		[Ignored]
		public var navigation : ArrayCollection= new ArrayCollection();;
		public function Search(label:String="id")
		{
			super(label);
			doUnmarshall=false;
		}
		[Ignored]
		override protected function onSuccess(event:Object):void
		{
			super.onSuccess(event);
			showMessage=false;
			/*
			error=false;
			serverError=null;
			message="";
			var result : Object = event.result;
			if (result == "error")
			{
				error=true;
				message="There was an error. Please try again later!";
			}
			else if(result is XML)
			{
				var resultXML : XML = XML(result);
				if (resultXML.name().localName == "errors")
				{
					validationerror=true;
					serverError=resultXML;
				}
				else
				{
					this.setResults(resultXML);
				}
			}
			*/
			if(result is XML && result!=null)
			{
				this.setResults(XML(result));
/*				var resultXML : XML = XML(result);
				if (resultXML.name().localName == "errors")
				{
					validationerror=true;
					serverError=resultXML;
				}
				else
				{
					this.setResults(XML(result));
				}
*/			}
			CursorManager.removeBusyCursor();
		}
		[Ignored]
		protected override function onFailure(event:Object):void
		{
			CursorManager.removeBusyCursor();
			if(error)
			{
				ErrorController.logErrorTwo("Search action failure at fault: " + ObjectUtil.toString(event),"Command","CreateRecordCommand");
				//PageManager.getInstance().showPageErrorMsg(message,"fault");
			}
		}
		[Ignored]
		public function get currentOffset():int
		{
			return (currentpage-1)*rowlimit;
		}
		[Ignored]
		public function get totalpage():int
		{
			return Math.ceil(rowcount/rowlimit);
			//return rowcount<=0?0:rowcount%rowlimit==0?rowcount/rowlimit:rowcount/rowlimit+1;
		}
		[Ignored]
		private function setResults(results:XML) : void
		{
			this.results=results;
			this.rows=results..row;
			this.rowcount=results..rowcount;
			createNavigation();
		}
		[Ignored]
		public function resetNavVariables(event:ItemClickEvent) : void
		{
			this.currentpage=event.item.data;
			var lb : String = event.item.label.toString();
			if( lb.indexOf("<") > - 1 || lb.indexOf(">") > - 1 )
			{
				navinit=Math.floor((this.currentpage-1)/navsize)*navsize+1;
			}
		}
		[Ignored]
		public function resetSearchVariables():void
		{
			this.currentpage=1;
			this.navinit=1;
		}
		[Ignored]
		private function createNavigation(): void
		{
			if(!keepNavigation) return;
			navigation.removeAll();
			var pg:int=0;
			var lastpage:int=totalpage;

			if(navinit>1)//has last page
			{
				navigation.addItem({label : "<< First",data : 1});
				navigation.addItem({label : "< Previous" , data : navinit-1});
			}

			for( var i:int=0;i<navsize;i++)
			{
				pg=i+navinit;
				navigation.addItem({label:pg,data:pg});
				if(pg>=lastpage)//reached last page
				{
					break;
				}
			}
			if(pg<totalpage-1)//has last page
			{
				navigation.addItem({label : "Next >" , data : pg+1});
				navigation.addItem({label : "Last >>" , data:lastpage});
			}
			pageinfo = 'Page ' + currentpage.toString() + ' of ' + totalpage.toString();
			totalinfo = 'Total items ' + rowcount.toString();
		}
	}
}
