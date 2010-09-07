package org.ludo.models
{
	import org.ludo.controllers.ErrorController;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.PopUp;

	[Resource(name="error_logs")]
  	[Bindable]
	public class ErrorLog extends BaseModel
	{
		public var error_desc : String;
		public var error_name : String;
		public var error_source : String;
		public var error_type : String;
		public var quote_id : int;
		public function ErrorLog(label:String="id")
		{
			super(label);
			afterCreate=showError;
			afterShow=showError;
		}
		[Ignored]
		public override function create(onSuccess:Function=null,onFailure:Function=null):void
		{
			if(LudoUtils.modelController.currentSession!= null && LudoUtils.modelController.currentSession.loggedIn)
			{
				super.create();
			}
			else
			{
				ErrorController.showError(this);
			}
		}
		public function getMessage():String
		{
			return "Description:\n"+error_desc+"\nType:\n"+error_type+"\nSource:\n"+error_source;
		}
		private function showError(event:Object,model:Object):void
		{
			ErrorController.showError(this);
		}
	}
}