package org.ludo.utils
{
	import mx.containers.FormItem;
	import mx.controls.Text;
	
	import org.ludo.layouts.PageHeaders;
	import org.ludo.utils.base.Page;

	public class CurrentPage extends Page
	{
		public static function get ID():String
		{
			return LudoUtils.pageController.currentPageID;
		}
		/*
		public static function get pageAfterRate():String
		{
			return LudoUtils.pageController.pageAfterRate;
		}
		*/
		public static function get nextID():String
		{
			return LudoUtils.pageController.nextPageID;
		}
		public static function get previousID():String
		{
			return LudoUtils.pageController.previusPageID;
		}
		/*
		public static function get serverErrors():ServerErrors
		{
			return LudoUtils.pageController.pageServerErrors;
		}
		*/
		public static function get validatorContainer():Array
		{
			return LudoUtils.dataStore.getFromValidatorContainer(ID) as Array;
		}
		/*
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
			LudoUtils.pageController.currentPageID=id;
		}
		public static function set title (title:String):void
		{
			(getElmentByID(ID+"_title") as PageHeaders).label=title;
		}
		public static function setFieldLabel (id:String,label:String):void
		{
			(getElmentByID("lbl_"+id) as Text).text=label;
		}
		public static function setRequiredFlag (id:String,required:Boolean):void
		{
			(getElmentByID("parent_"+id) as FormItem).required=required;
		}
		public static function setValidationByID(id:String,validationString:String):void
		{
			LudoUtils.pageController.addValidationToPage(ID,getElmentByID(id),validationString,id);
			//setValidation(getElmentByID(id),validationString,id);
		}
		/*
		public static function setValidation(fieldtovalidate:*,validationString:String,id:String=""):void
		{
			CustomValidator.addValidatorsToPage(validatorContainer,fieldtovalidate,validationString,id);
		}
		*/
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
		/*
		public static function addElmentByID(id:String,obj:*):void
		{
			if(id.length>0)
			{
				LudoUtils.dataStore.getObjectMapContainer(ID)[id]=obj;
			}
		}
		*/
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