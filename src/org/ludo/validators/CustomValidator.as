package org.ludo.validators
{
	import flash.events.EventDispatcher;
	
	import mx.validators.DateValidator;
	import mx.validators.EmailValidator;
	import mx.validators.NumberValidator;
	import mx.validators.PhoneNumberValidator;
	import mx.validators.RegExpValidator;
	import mx.validators.SocialSecurityValidator;
	import mx.validators.StringValidator;
	import mx.validators.Validator;
	import mx.validators.ZipCodeValidator;

	public class CustomValidator
	{
		/*
		public function generator()
		{
		}
		*/
		public static function addValidatorsToPage(validatorArray:Array,fieldtovalidate:*,stringToParse:String,fieldId:String=""):void
		{
			if(stringToParse.length>0)
			{
				//var validatorArray:Array=CurrentPage.validatorContainer;
				for each(var items:String in stringToParse.split("^"))
				{
					var vArray:Array=items.split("|");
					var validator:Validator=null;
					var type:String=vArray[0].toString();
					var server:Boolean=false;

					if(fieldId!="")
					{
						if((validatorArray[1] as Array)[fieldId+"::"+type] is Validator)
						{
							validator=(validatorArray[1] as Array)[fieldId+"::"+type] as Validator;
						}
					}
					if(validator==null)
					{
						switch(type.toLowerCase())
						{
							case 'string':
								validator=new StringValidator();
								break;
							case 'number':
								validator=new NumberValidator();
								break;
							case 'phone':
								validator=new PhoneNumberValidator();
								break;
							case 'zipcode':
								validator=new ZipCodeValidator();
								break;
							case 'ssn':
								validator=new SocialSecurityValidator();
							break;
							case 'email':
								validator=new EmailValidator();
								break;
							case 'regexp':
								validator=new RegExpValidator();
								break;
							case 'radiolist':
								validator=new RadioButtonGroupValidator();
								break;
							case 'date':
								validator=new DateValidator();
								break;
							case 'servererror':
								validator=new ServerErrorValidator();
								//validator.source=fieldtovalidate;
								//validator["serverErrors"]=CurrentPage.serverErrors;
								server=true;
								break;
							case 'passwordconfirmation':
								validator=new PasswordConfirmationValidator();
								validator["type"]="id";						
								break;
							default:
								validator=new Validator();
								break;
						}
						//if(server==false)
						//{
							validator["property"]=getProperty(fieldtovalidate);
							validator.source=fieldtovalidate;
						//}
						validator.trigger= new EventDispatcher();
						if(validatorArray.length==3)
						{
							if(server)
							{
								(validatorArray[2] as Array).push(validator);
							}
							else
							{
								(validatorArray[0] as Array).push(validator);
							}
							if(fieldId!="")
							{
								(validatorArray[1] as Array)[fieldId+"::"+type]=validator;
							}
						}
					}
					setProperties(validator,vArray[1]);
				}
			}
		}
		public static function resetAllValidators(validatorArray:Array):void
		{
			for each (var v:Validator in validatorArray)
			{
			    v.source.errorString="";
			}
		}
		public static function getProperty(formitem:*):String
		{
			var retval:String="text";
			if(formitem!=null && formitem.hasOwnProperty('className'))
			{
				switch(formitem['className'].toString())
				{
					case 'CCRadioList':
						retval="value";
						break;
					case 'CComboBox':
					case 'ComboBox':
					case 'CDropDownList':
					case 'DropDownList':
						retval="selectedValue";
						break;
					default:
						break
				}
			}
			return retval;			
		}
		private static function setProperties(validator:Validator,properties:String):void
		{
			if(validator!=null && properties.length>0)
			{
				var reqd:Boolean=false;
				for each(var prop:String in properties.split(";"))
				{
					var vProp:Array=prop.split("=");
					if(vProp.length==2)
					{
						switch(vProp[0].toString())
						{
							//exceptions in case
							//this will grow in course of time
							case 'exception':
								//write exception logic here
							break;
							case 'property':
								//write exception logic here
							break;
							case 'required':
							if(vProp[1]=="true")
							{
								reqd=true;
							}
								//write exception logic here
							break;
							default:
								validator[vProp[0]]=vProp[1];
							break;
						}
					}
				}
				validator.required=reqd;			
			}
		}

	}
}