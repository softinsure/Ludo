package org.ludo.validators
{
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;
	import mx.validators.StringValidator;
	public class RadioButtonGroupValidator extends StringValidator
	{
		private var _radioButtonGroupInitialized : Boolean = false;
		public function RadioButtonGroupValidator()
		{
			super();
		}

		override protected function doValidation(value : Object) : Array
		{
			if ( !_radioButtonGroupInitialized && (source is RadioButtonGroup || listener is RadioButtonGroup))
			{
				removeListenerHandler();
				addListenerHandler();
			}

			return super.doValidation(value);
		}

		override protected function get actualListeners() : Array
		{
			var results : Array = super.actualListeners;
			if (results == null || results.length < 1)
			{
				return results;
			}

			var sourceElem : Object = results[0];
			if (sourceElem && sourceElem is RadioButtonGroup)
			{
				var numRadioButtons : int = RadioButtonGroup(sourceElem).numRadioButtons;
				for (var i : int = 0; i < numRadioButtons; i++)
				{
					var rb : RadioButton = RadioButtonGroup(sourceElem).getRadioButtonAt(i);
					results.push(rb);
					rb.validationSubField = null;
				}

				if (numRadioButtons > 0)
				{
					_radioButtonGroupInitialized = true;
				}
			}

			return results;
		}
	}
}
