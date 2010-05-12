package org.ludo.validators {
    import mx.controls.TextInput;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    
    import org.ludo.utils.CurrentPage;

    public class PasswordConfirmationValidator
    extends Validator {
        /**
         * The password being compared to the confirmation.
         */
        public var passwordCtl:TextInput;
        public var passwordID:String;
        public var type:String="control";
        
        public function PasswordConfirmationValidator() {
            super();
        }
        
        override protected function doValidation(
            passwordConfirmation:Object):Array
        {
            //We call base class doValidation() to get the
            //required logic.
            var results:Array =
                super.doValidation(passwordConfirmation);
            
            // Compare password and passwordConfirmation fields.
            //check type
            //passwordCtl=type.toLowerCase()=="id"?(PageManager.getInstance().getObjByIDFromCurrentPageObjContainer(passwordID) as TextInput):passwordCtl;
            passwordCtl=type.toLowerCase()=="id"?(CurrentPage.getElmentByID(passwordID) as TextInput):passwordCtl;
            if (passwordCtl.text != passwordConfirmation) {
                results.push(
                    new ValidationResult(
                        true,
                        "password_confirmation",
                        "passwordDoesNotMatchConfirmation",
              "The password does not match the confirmation."));
            }            
            return results;
        }
    }
}