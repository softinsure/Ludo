package org.ludo.validators
{
	import mx.validators.StringValidator;
	import mx.validators.ValidationResult;
	
	import org.common.utils.XXMLUtils;
	
	public class XmlValidator extends StringValidator
	{
		public function XmlValidator()
		{
			super();
		}
		override protected function doValidation(value:Object):Array
		{
			var results:Array = super.doValidation(value);
			// Return if there are errors
			// or if the required property is set to false and length is 0.
			if (results.length > 0)
				return results;
			if(!XXMLUtils.isXML(value))
			{
			/*	value=XML(value);
			}
			else
			{*/
				results.push(new ValidationResult(true, null, "XML_VALIDATION_ERROR","Invalid XML"));
			}
			return results;
		}
	}
}