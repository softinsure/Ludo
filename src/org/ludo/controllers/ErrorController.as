package org.ludo.controllers
{
	import mx.controls.Alert;
	import mx.utils.ObjectUtil;
	
	import org.ludo.models.ErrorLog;
	import org.ludo.utils.LudoUtils;
	import org.ludo.utils.PopUp;

	public class ErrorController
	{
		public static function logError(error:Error,type:String="",source:String=""):void
		{
			//craete a new error
			LudoUtils.modelController.getNewErrorModel("currentError",ObjectUtil.toString(error),type,source+"\n"+error.getStackTrace(),error.name).create();
        }
		public static function logErrorTwo(
			errordesc:String,
			errortype:String="",
			errorsource : String = "" ,
			errorname : String = ""):void {
			//showErrorMeassage(errordesc);
			LudoUtils.modelController.getNewErrorModel("currentError",errordesc,errortype,errorsource,errorname).create();
        }
        public static function showError(errorlog:ErrorLog):void
        {
			MessageController.popUpMessage(errorlog.error_name,errorlog.getMessage(),400,500);
        	//PopUp.showMessage(errorlog.error_name,errorlog.getMessage());
        }
        public static function showErrorMeassage(message:String):void
        {
			MessageController.popUpMessage("An Error Occured",message,400,500);
		}
        public static function showErrorObject(error:Error):void
        {
			MessageController.popUpMessage(error.name,error.message,400,500);
			//PopUp.showMessage(error.name,error.message);
        }
    }
}