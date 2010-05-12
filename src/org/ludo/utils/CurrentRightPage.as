package org.ludo.utils
{
	import org.ludo.layouts.PageHeaders;
	
	import mx.containers.FormItem;
	import mx.controls.Text;
	
	
	import org.ludo.validators.ServerErrors;
	import org.ludo.validators.CustomValidator;

	public dynamic class CurrentRightPage
	{
		public static function get ID():String
		{
			return LudoUtils.pageController.currentRightPageID;
		}
		public static function setValidationByID(id:String,validationString:String):void
		{
			LudoUtils.pageController.addValidationToPage(ID,getElmentByID(id),validationString,id);
			//setValidation(getElmentByID(id),validationString,id);
		}
		/*
		public static function get nextID():String
		{
			return LudoUtils.pageController.nextPageID;
		}
		public static function get previousID():String
		{
			return LudoUtils.pageController.previusPageID;
		}
		public static function get serverErrors():ServerErrors
		{
			return LudoUtils.pageController.pageServerErrors;
		}
		public static function get pageValidators():Array
		{
			return LudoUtils.dataStore.getFromValidatorContainer(ID)[0] as Array;
		}
		public static function get pageValidatorsWithID():Array
		{
			return LudoUtils.dataStore.getFromValidatorContainer(ID)[1] as Array;
		}
		*/
		public static function set ID(id:String):void
		{
			LudoUtils.pageController.currentRightPageID=id;
		}
		public static function set title (title:String):void
		{
			(getElmentByID(ID+"_title") as PageHeaders).headerTitle=title;
		}
		public static function setFieldLabel (id:String,label:String):void
		{
			(getElmentByID("lbl_"+id) as Text).text=label;
		}
		public static function setRequiredFlag (id:String,required:Boolean):void
		{
			(getElmentByID("parent_"+id) as FormItem).required=required;
		}
		public static function getElmentByID(id:String):*
		{
			if(id.length>0)
			{
				return LudoUtils.dataStore.getObjectMapContainer(ID)[id];
			}
			else
			{
				return null;
			}
		}
		public static function getFieldValueByID(id:String):String
		{
			return LudoUtils.getFieldValue(getElmentByID(id))
		}
		public static function addElmentByID(id:String,obj:*):void
		{
			if(id.length>0)
			{
				LudoUtils.dataStore.getObjectMapContainer(ID)[id]=obj;
			}
		}
		public static function enableByID(id:String,enabled:Boolean):void
		{
			getElmentByID(id)["enabled"]=enabled;
		}
		public static function displayByID(id:String,visible:Boolean):void
		{
			getElmentByID(id)["visible"]=visible;
		}
		public static function ediatableByID(id:String,editable:Boolean):void
		{
			getElmentByID(id)["editable"]=editable;
		}
		public static function setFieldValueByID(id:String,value:String):void
		{
			LudoUtils.setFieldValue(getElmentByID(id),value);
		}
	}
}