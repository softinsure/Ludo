package org.ludo.utils.base
{
	import org.ludo.validators.ServerErrors;

	public interface IPage
	{
		function get ID():String
		function get nextID():String
		function get previousID():String
		function get serverErrors():ServerErrors
		function get pageValidators():Array
		function get validatorContainer():Array
		function get pageValidatorsWithID():Array
		function set ID(id:String):void
		function set title (title:String):void
		function setFieldLabel (id:String,label:String):void
		function setRequiredFlag (id:String,required:Boolean):void
		function setValidationByID(id:String,validationString:String):void
		function setValidation(fieldtovalidate:*,validationString:String,id:String=""):void
		function getElmentByID(id:String):*
		function getFieldValueByID(id:String):String
		function addElmentByID(id:String,obj:*):void
		function enableByID(id:String,enabled:Boolean):void
		function displayByID(id:String,visible:Boolean):void
		function ediatableByID(id:String,editable:Boolean):void
		function setFieldValueByID(id:String,value:String):void
	}
}