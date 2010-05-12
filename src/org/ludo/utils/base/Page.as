package org.ludo.utils.base
{
	import org.ludo.validators.ServerErrors;

	public class Page implements IPage
	{
		private var pageid:String="nopage";
		private var nextid:String="";
		private var previd:String="";
		private var ttl:String="";
		
		public function Page()
		{
		}
		
		public function get ID():String
		{
			return pageid;
		}
		
		public function get nextID():String
		{
			return nextid;
		}
		
		public function get previousID():String
		{
			return previd;
		}
		
		public function get serverErrors():ServerErrors
		{
			return null;
		}
		
		public function get pageValidators():Array
		{
			return null;
		}
		
		public function get validatorContainer():Array
		{
			return null;
		}
		
		public function get pageValidatorsWithID():Array
		{
			return null;
		}
		
		public function set ID(id:String):void
		{
			this.pageid=id;
		}
		
		public function set title(title:String):void
		{
			this.ttl=title;
		}
		
		public function setFieldLabel(id:String, label:String):void
		{
		}
		
		public function setRequiredFlag(id:String, required:Boolean):void
		{
		}
		
		public function setValidationByID(id:String, validationString:String):void
		{
		}
		
		public function setValidation(fieldtovalidate:*, validationString:String, id:String=""):void
		{
		}
		
		public function getElmentByID(id:String):*
		{
			return null;
		}
		
		public function getFieldValueByID(id:String):String
		{
			return null;
		}
		
		public function addElmentByID(id:String, obj:*):void
		{
		}
		
		public function enableByID(id:String, enabled:Boolean):void
		{
		}
		
		public function displayByID(id:String, visible:Boolean):void
		{
		}
		
		public function ediatableByID(id:String, editable:Boolean):void
		{
		}
		
		public function setFieldValueByID(id:String, value:String):void
		{
		}
	}
}