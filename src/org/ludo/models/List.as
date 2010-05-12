package org.ludo.models
{
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	import mx.managers.CursorManager;
	import mx.utils.ObjectUtil;
	
	import org.ludo.controllers.ErrorController;
	import org.ludo.utils.LudoUtils;
	
	[Resource(name="list")]
  	[Bindable]
	public class List extends BaseModel
	{
		public var query : String;
		[Ignored]
		public var control : IVisualElement;
		[Ignored]
		public var results : XML;
		[Ignored]
		public var rows : XMLList;
		[Ignored]
		public var selectone:Boolean=true;
		[Ignored]
		public function List(label:String="id")
		{
			super(label);
			doUnmarshall=false;
		}
		[Ignored]
		override protected function onSuccess(event:Object):void
		{
			super.onSuccess(event);
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
					this.setResults(resultXML);
				}
*/			}
			
		}
		[Ignored]
		protected override function onFailure(event:Object):void
		{
			CursorManager.removeBusyCursor();
			if(error)
			{
				ErrorController.logErrorTwo("List action failure at fault: " + ObjectUtil.toString(event),"Command","CreateRecordCommand");
				//PageManager.getInstance().showPageErrorMsg(message,"fault");
			}
		}
		[Ignored]
		private function setResults(results:XML) : void
		{
			this.results=results;
			this.rows=results..row;
			var optCol:ArrayCollection=new ArrayCollection();
			if(selectone)
			{
				var obj1:Object=new Object();
				obj1.label="Select One";
				obj1.data="";
				optCol.addItem(obj1);				
			}
			for each (var xml:XML in this.rows)
			{
				var obj:Object=new Object();
				obj.label=xml.Label;
				obj.data=xml.Data;
				optCol.addItem(obj);	
			}
			LudoUtils.setDataProvider(control,optCol);
		}
	}
}
